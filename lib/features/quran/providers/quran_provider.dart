import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imani/core/models/quran_models.dart';
import 'package:imani/core/repositories/quran_repository.dart';

class QuranProvider extends ChangeNotifier {
  final QuranRepository _repository = QuranRepository();

  List<Surah> _surahs = [];
  bool _isLoading = false;
  String? _error;
  double _progress = 0.0;

  Map<int, List<Ayah>> _pagesMap = {};
  int _totalPages = 0;
  int _lastReadPage = 1;

  List<Surah> get surahs => _surahs;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get progress => _progress;
  Map<int, List<Ayah>> get pagesMap => _pagesMap;
  int get totalPages => _totalPages;
  int get lastReadPage => _lastReadPage;

  QuranProvider() {
    _loadLastPage();
    loadSurahs();
  }

  Future<void> _loadLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    _lastReadPage = prefs.getInt('lastReadPage') ?? 1;
    notifyListeners();
  }

  Future<void> saveLastPage(int page) async {
    if (page == _lastReadPage) return;
    _lastReadPage = page;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastReadPage', page);
    notifyListeners();
  }

  Future<void> loadSurahs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _surahs = await _repository.getSurahs();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> buildPagesMap() async {
    try {
      final allAyahs = await _repository.getAllAyahs();
      _pagesMap = {};
      for (var ayah in allAyahs) {
        if (!_pagesMap.containsKey(ayah.page)) {
          _pagesMap[ayah.page] = [];
        }
        _pagesMap[ayah.page]!.add(ayah);
      }
      _totalPages = _pagesMap.length;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<List<Ayah>> getPage(int pageNumber) async {
    try {
      return await _repository.getAyahsByPage(pageNumber);
    } catch (e) {
      _error = e.toString();
      return [];
    }
  }

  Future<void> preload() async {
    _isLoading = true;
    _progress = 0.1;
    notifyListeners();

    try {
      await _repository.preloadQuran();
      _progress = 0.9;
      notifyListeners();
      await loadSurahs();
      await buildPagesMap();
      _progress = 1.0;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
Future<List<Ayah>> getAllAyahs() => _repository.getAllAyahs();
  Future<List<Ayah>> getAyahsForSurah(int surahNumber) {
    return _repository.getAyahs(surahNumber);
  }
}