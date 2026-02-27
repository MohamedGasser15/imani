import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:imani/core/models/quran_models.dart';
import 'package:imani/core/services/quran_database.dart';

class QuranRepository {
  final QuranDatabase _db = QuranDatabase();
  static const int _totalPages = 604;
  static const int _backgroundBatchSize = 5; // عدد الصفحات المحملة في الخلفية لكل دفعة
  static const Duration _delayBetweenBackgroundRequests = Duration(milliseconds: 300);

  bool _isBackgroundLoading = false;
  bool _cancelBackgroundLoading = false;

  /// جلب صفحة معينة: تحقق من قاعدة البيانات أولاً، إذا لم توجد يتم جلبها من API فورًا (وتخزينها)
  Future<List<Ayah>> getPage(int pageNumber) async {
    // حاول جلب الصفحة من قاعدة البيانات
    final localAyahs = await _db.getAyahsByPage(pageNumber);
    if (localAyahs.isNotEmpty) {
      return localAyahs;
    }

    // إذا لم توجد، قم بجلبها من API
    try {
      final ayahs = await _fetchPageAndStore(pageNumber);
      return ayahs;
    } catch (e) {
      print('فشل جلب الصفحة $pageNumber من API: $e');
      return [];
    }
  }

  /// دالة داخلية لجلب صفحة من API وتخزينها في قاعدة البيانات
  Future<List<Ayah>> _fetchPageAndStore(int pageNumber) async {
    final response = await http.get(
      Uri.parse('https://api.alquran.cloud/v1/page/$pageNumber/quran-uthmani'),
    );

    if (response.statusCode != 200) {
      throw Exception('فشل تحميل الصفحة $pageNumber: ${response.statusCode}');
    }

    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    if (jsonData['code'] != 200) {
      throw Exception('خطأ في استجابة API للصفحة $pageNumber: ${jsonData['status']}');
    }

    final pageData = jsonData['data'];
    final List<dynamic> ayahsJson = pageData['ayahs'] as List;

    final List<Ayah> fetchedAyahs = [];
    final Map<int, Surah> surahsToAdd = {};

    for (var ayahJson in ayahsJson) {
      final int surahNumber = ayahJson['surah']['number'] as int;

      final ayah = Ayah(
        number: ayahJson['number'] as int,
        text: ayahJson['text'] as String,
        numberInSurah: ayahJson['numberInSurah'] as int,
        juz: ayahJson['juz'] as int,
        page: pageNumber,
        surahNumber: surahNumber,
      );
      fetchedAyahs.add(ayah);

      if (!surahsToAdd.containsKey(surahNumber)) {
        final surahJson = ayahJson['surah'];
        surahsToAdd[surahNumber] = Surah(
          number: surahNumber,
          name: surahJson['name'] as String,
          englishName: surahJson['englishName'] as String,
          englishNameTranslation: surahJson['englishNameTranslation'] as String,
          revelationType: surahJson['revelationType'] as String,
          numberOfAyahs: surahJson['numberOfAyahs'] as int,
          ayahs: [],
        );
      }
    }

    // إدراج السور الجديدة (إذا لم تكن موجودة)
    for (var surah in surahsToAdd.values) {
      final existing = await _db.getSurahIfExists(surah.number);
      if (existing == null) {
        await _db.insertSurah(surah);
      }
    }

    // إدراج الآيات
    await _db.insertAyahs(fetchedAyahs);

    return fetchedAyahs;
  }

  /// بدء تحميل باقي الصفحات في الخلفية
  void startBackgroundLoading(int currentPage) {
    if (_isBackgroundLoading) return;
    _isBackgroundLoading = true;
    _cancelBackgroundLoading = false;

    Future(() => _backgroundLoadPages(currentPage));
  }

  /// إيقاف التحميل في الخلفية (إذا لزم الأمر)
  void stopBackgroundLoading() {
    _cancelBackgroundLoading = true;
  }

  /// التحميل الفعلي في الخلفية
  Future<void> _backgroundLoadPages(int startPage) async {
    final Set<int> pagesToLoad = {};

    // الصفحات التالية (حتى 30)
    for (int i = 1; i <= 30; i++) {
      if (startPage + i <= _totalPages) pagesToLoad.add(startPage + i);
    }
    // الصفحات السابقة (حتى 30)
    for (int i = 1; i <= 30; i++) {
      if (startPage - i >= 1) pagesToLoad.add(startPage - i);
    }

    final pagesList = pagesToLoad.toList()..sort();
    for (int i = 0; i < pagesList.length; i += _backgroundBatchSize) {
      if (_cancelBackgroundLoading) break;

      final batch = pagesList.skip(i).take(_backgroundBatchSize).toList();
      final List<Future> futures = [];

      for (int page in batch) {
        futures.add(Future(() async {
          final localAyahs = await _db.getAyahsByPage(page);
          if (localAyahs.isEmpty) {
            try {
              await _fetchPageAndStore(page);
              print('✅ تم تحميل الصفحة $page في الخلفية');
            } catch (e) {
              print('❌ فشل تحميل الصفحة $page في الخلفية: $e');
            }
          }
          await Future.delayed(_delayBetweenBackgroundRequests);
        }));
      }

      await Future.wait(futures);
    }

    _isBackgroundLoading = false;
    print('🏁 انتهى التحميل الخلفي للصفحات المحيطة');
  }

  // دوال مساعدة
  Future<Surah?> getSurahIfExists(int surahNumber) => _db.getSurahIfExists(surahNumber);
  Future<List<Surah>> getSurahs() => _db.getSurahs();
  Future<List<Ayah>> getAyahs(int surahNumber) => _db.getAyahsForSurah(surahNumber);
  Future<List<Ayah>> getAllAyahs() => _db.getAllAyahs();

  Future<void> reloadData() async {
    await _db.clearAllData();
  }
}