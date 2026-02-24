import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TimeFormat { twelveHour, twentyFourHour }

class SettingsProvider extends ChangeNotifier {
  // الإعدادات الافتراضية
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('ar'); // هيتغير بعد قراءة الجهاز
  TimeFormat _timeFormat = TimeFormat.twelveHour;
  bool _isAdhanEnabled = true;
  double _quranFontSize = 20.0;

  // Getters
  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  TimeFormat get timeFormat => _timeFormat;
  bool get isAdhanEnabled => _isAdhanEnabled;
  double get quranFontSize => _quranFontSize;

  SettingsProvider() {
    _loadSettings();
  }

  // تحميل الإعدادات المحفوظة
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 0];
    
    // قراءة اللغة المحفوظة، وإذا لم توجد نستخدم لغة الجهاز
    String languageCode = prefs.getString('languageCode') ?? 
                          WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    // دعم العربي والإنجليزي فقط
    if (languageCode != 'ar' && languageCode != 'en') {
      languageCode = 'en'; // افتراضي
    }
    _locale = Locale(languageCode);
    
    _timeFormat = TimeFormat.values[prefs.getInt('timeFormat') ?? 0];
    _isAdhanEnabled = prefs.getBool('isAdhanEnabled') ?? true;
    _quranFontSize = prefs.getDouble('quranFontSize') ?? 20.0;
    notifyListeners();
  }

  // حفظ الإعدادات عند التغيير
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    notifyListeners();
  }

  Future<void> setTimeFormat(TimeFormat format) async {
    if (_timeFormat == format) return;
    _timeFormat = format;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timeFormat', format.index);
    notifyListeners();
  }

  Future<void> setAdhanEnabled(bool enabled) async {
    _isAdhanEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAdhanEnabled', enabled);
    notifyListeners();
  }

  Future<void> setQuranFontSize(double size) async {
    _quranFontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('quranFontSize', size);
    notifyListeners();
  }
}