import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imani/core/models/quran_models.dart';
import 'package:imani/core/repositories/quran_repository.dart';

class QuranProvider extends ChangeNotifier {
  final QuranRepository _repository = QuranRepository();

  int _lastReadPage = 1;
  List<Ayah>? _currentPageAyahs;
  bool _isLoadingPage = false;
  String? _error;
  final int _totalPages = 604; // عدد صفحات المصحف ثابت

  // Getters
  int get lastReadPage => _lastReadPage;
  List<Ayah>? get currentPageAyahs => _currentPageAyahs;
  bool get isLoadingPage => _isLoadingPage;
  String? get error => _error;
  int get totalPages => _totalPages;

  QuranProvider() {
    _init();
  }

  // دالة تهيئة عامة (تُستدعى من SplashScreen)
  Future<void> initialize() async {
    // إذا كانت الصفحة الحالية محملة بالفعل، لا تفعل شيئاً
    if (_currentPageAyahs != null) return;
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

  Future<void> loadPage(int pageNumber) async {
    if (pageNumber < 1 || pageNumber > _totalPages) return;

    _isLoadingPage = true;
    _error = null;
    notifyListeners();

    try {
      _currentPageAyahs = await _repository.getPage(pageNumber);
      if (pageNumber != _lastReadPage) {
        await saveLastPage(pageNumber);
      }
    } catch (e) {
      _error = e.toString();
      _currentPageAyahs = null;
    } finally {
      _isLoadingPage = false;
      notifyListeners();
    }
  }

  Future<void> goToPage(int pageNumber) async {
    if (pageNumber < 1 || pageNumber > _totalPages) return;
    await loadPage(pageNumber);
    _repository.startBackgroundLoading(pageNumber);
  }

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