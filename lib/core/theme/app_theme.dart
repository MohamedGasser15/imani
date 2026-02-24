import 'package:flutter/material.dart';
import 'package:imani/core/constants/app_colors.dart';

class AppTheme {
  // ---- الثيم الفاتح للعربية ----
  static ThemeData lightThemeArabic() {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Tajawal',
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.lightSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.lightBackground,
      ),
      textTheme: _arabicTextTheme,
    );
  }

  // ---- الثيم الفاتح للإنجليزية ----
  static ThemeData lightThemeEnglish() {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.lightSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.lightBackground,
      ),
      textTheme: _englishTextTheme,
    );
  }

  // ---- الثيم الداكن للعربية ----
  static ThemeData darkThemeArabic() {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Tajawal',
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.darkSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkText,
      ),
      textTheme: _arabicTextTheme.apply(
        bodyColor: AppColors.darkText,
        displayColor: AppColors.darkText,
      ),
    );
  }

  // ---- الثيم الداكن للإنجليزية ----
  static ThemeData darkThemeEnglish() {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.darkSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkText,
      ),
      textTheme: _englishTextTheme.apply(
        bodyColor: AppColors.darkText,
        displayColor: AppColors.darkText,
      ),
    );
  }

  // ---- دوال مساعدة لاختيار الثيم بناءً على اللغة والوضع ----
  static ThemeData getTheme({required String languageCode, required Brightness brightness}) {
    if (brightness == Brightness.light) {
      return languageCode == 'ar' ? lightThemeArabic() : lightThemeEnglish();
    } else {
      return languageCode == 'ar' ? darkThemeArabic() : darkThemeEnglish();
    }
  }

  // TextTheme للعربية (كما هي)
  static const TextTheme _arabicTextTheme = TextTheme(
    displayLarge: TextStyle(fontFamily: 'Tajawal', fontSize: 32, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontFamily: 'Tajawal', fontSize: 28, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(fontFamily: 'Tajawal', fontSize: 24, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontFamily: 'Tajawal', fontSize: 20, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontFamily: 'Tajawal', fontSize: 16),
    bodyMedium: TextStyle(fontFamily: 'Tajawal', fontSize: 14),
    labelLarge: TextStyle(fontFamily: 'Tajawal', fontSize: 14, fontWeight: FontWeight.w500),
  );

  // TextTheme للإنجليزية (كما هي)
  static const TextTheme _englishTextTheme = TextTheme(
    displayLarge: TextStyle(fontFamily: 'Roboto', fontSize: 32, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontFamily: 'Roboto', fontSize: 28, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(fontFamily: 'Roboto', fontSize: 24, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontFamily: 'Roboto', fontSize: 20, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontFamily: 'Roboto', fontSize: 16),
    bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 14),
    labelLarge: TextStyle(fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.w500),
  );
}