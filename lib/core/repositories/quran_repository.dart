import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:imani/core/models/quran_models.dart';
import 'package:imani/core/services/quran_database.dart';

class QuranRepository {
  final QuranDatabase _db = QuranDatabase();

  Future<void> preloadQuran() async {
    if (await _db.isDataLoaded()) return;

    final response = await http.get(
      Uri.parse('https://api.alquran.cloud/v1/quran/quran-uthmani'),
    );

    if (response.statusCode != 200) {
      throw Exception('فشل تحميل القرآن: ${response.statusCode}');
    }

    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final List<Surah> surahs = await compute(_parseQuranJson, jsonData);

    await _db.insertFullQuran(surahs);
  }

  Future<List<Surah>> getSurahs() => _db.getSurahs();
  Future<List<Ayah>> getAyahs(int surahNumber) => _db.getAyahsForSurah(surahNumber);
  Future<List<Ayah>> getAllAyahs() => _db.getAllAyahs();
  Future<List<Ayah>> getAyahsByPage(int page) => _db.getAyahsByPage(page);

  Future<void> reloadData() async {
    await _db.insertFullQuran([]); // مسح
    await preloadQuran();
  }
}

List<Surah> _parseQuranJson(Map<String, dynamic> jsonData) {
  final List<dynamic> surahsJson = jsonData['data']['surahs'];
  return surahsJson.map((sJson) => Surah.fromJson(sJson)).toList();
}