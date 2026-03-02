import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imani/core/models/quran_models.dart';
import 'package:imani/core/repositories/quran_repository.dart';

class QuranProvider extends ChangeNotifier {
  final QuranRepository _repository = QuranRepository();

  int _lastReadPage = 1;
  bool _isLoadingPage = false;
  String? _error;
  final int _totalPages = 604;

  // Cache للصفحات في الذاكرة
  final Map<int, List<Ayah>> _pageCache = {};

  int get lastReadPage => _lastReadPage;
  bool get isLoadingPage => _isLoadingPage;
  String? get error => _error;
  int get totalPages => _totalPages;

  QuranProvider() {
    _init();
  }

  Future<void> initialize() async {
    if (_pageCache.containsKey(_lastReadPage)) return;
    await _init();
  }

  Future<void> _init() async {
    await _loadLastPage();
    await loadPage(_lastReadPage);
    _repository.startBackgroundLoading(_lastReadPage);
  }

  Future<void> _loadLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    _lastReadPage = prefs.getInt('lastReadPage') ?? 1;
  }

  Future<void> saveLastPage(int page) async {
    if (page == _lastReadPage) return;
    _lastReadPage = page;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastReadPage', page);
  }

  /// الحصول على صفحة من الكاش (إن وجدت)
  List<Ayah>? getCachedPage(int pageNumber) {
    return _pageCache[pageNumber];
  }

  /// تحميل صفحة وتخزينها في الكاش
  Future<void> loadPage(int pageNumber) async {
    if (pageNumber < 1 || pageNumber > _totalPages) return;
    if (_pageCache.containsKey(pageNumber)) return; // موجودة بالفعل

    _isLoadingPage = true;
    _error = null;
    notifyListeners();

    try {
      final ayahs = await _repository.getPage(pageNumber);
      _pageCache[pageNumber] = ayahs;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingPage = false;
      notifyListeners(); // يُعلم فقط أن صفحة معينة اكتمل تحميلها
    }
  }

  /// الانتقال إلى صفحة محددة
  Future<void> goToPage(int pageNumber) async {
    if (pageNumber < 1 || pageNumber > _totalPages) return;
    if (pageNumber == _lastReadPage) return;

    await saveLastPage(pageNumber);
    await loadPage(pageNumber);
    _repository.startBackgroundLoading(pageNumber);
    notifyListeners(); // لتحديث الصفحة الحالية في الـ Header
  }

  // دوال إضافية
  Future<List<Ayah>> getPage(int pageNumber) {
    return _repository.getPage(pageNumber);
  }

  Future<List<Ayah>> getAyahsForSurah(int surahNumber) {
    return _repository.getAyahs(surahNumber);
  }

  Future<List<Surah>> getSurahs() => _repository.getSurahs();

  @override
  void dispose() {
    _repository.stopBackgroundLoading();
    super.dispose();
  }
}