import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:imani/core/providers/settings_provider.dart';
import 'package:imani/core/theme/app_theme.dart';
import 'package:imani/features/splash/presentation/splash_screen.dart';
import 'package:imani/l10n/app_localizations.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return MaterialApp(
      title: 'إيماني',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(
        languageCode: settings.locale.languageCode,
        brightness: Brightness.light,
      ),
      darkTheme: AppTheme.getTheme(
        languageCode: settings.locale.languageCode,
        brightness: Brightness.dark,
      ),
      themeMode: settings.themeMode,
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
      locale: settings.locale,
      home: const SplashScreen(),
    );
  }
}