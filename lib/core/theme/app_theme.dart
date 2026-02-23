import 'package:flutter/material.dart';
import 'package:imani/core/constants/app_colors.dart';

class AppTheme {
  // ثيم مخصص للغة العربية (Tajawal)
  static ThemeData get lightThemeArabic {
    return ThemeData(
      fontFamily: 'Tajawal', // الخط الافتراضي للتطبيق في العربية
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      textTheme: _arabicTextTheme, // تعريف TextTheme منفصل
    );
  }

  // ثيم مخصص للغة الإنجليزية (Roboto)
  static ThemeData get lightThemeEnglish {
    return ThemeData(
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      textTheme: _englishTextTheme,
    );
  }

  // TextTheme للعربية (Tajawal)
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

  // TextTheme للإنجليزية (Roboto)
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