import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:imani/core/theme/app_theme.dart';
import 'package:imani/features/splash/presentation/splash_screen.dart';
import 'package:imani/l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('ar');

  void _setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'إيماني',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(
        languageCode: _locale.languageCode,
        brightness: Brightness.light,
      ),
      darkTheme: AppTheme.getTheme(
        languageCode: _locale.languageCode,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      locale: _locale,
      home: SplashScreen(onLocaleChange: _setLocale),
    );
  }
}