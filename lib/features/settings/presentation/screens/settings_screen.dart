import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imani/core/providers/settings_provider.dart';
import 'package:imani/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final settings = Provider.of<SettingsProvider>(context);
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isLight ? Colors.transparent : null,
        foregroundColor: isLight ? primaryColor : null,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            // قسم المظهر
            _buildSectionHeader(context, t.appearance, Icons.palette),
            const SizedBox(height: 12),
            _buildThemeSelector(context, settings, t),
            const SizedBox(height: 30),

            // قسم اللغة
            _buildSectionHeader(context, t.language, Icons.language),
            const SizedBox(height: 12),
            _buildLanguageSelector(context, settings, t),
            const SizedBox(height: 30),

            // قسم الساعة
            _buildSectionHeader(context, t.timeFormat, Icons.access_time),
            const SizedBox(height: 12),
            _buildTimeFormatSelector(context, settings, t),
            const SizedBox(height: 30),

            // قسم الإشعارات
            _buildSectionHeader(context, t.notifications, Icons.notifications),
            const SizedBox(height: 12),
            _buildNotificationSettings(context, settings, t),
            const SizedBox(height: 30),

            // قسم القرآن
            _buildSectionHeader(context, t.quranSettings, Icons.menu_book),
            const SizedBox(height: 12),
            _buildQuranSettings(context, settings, t),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: primaryColor, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSelector(BuildContext context, SettingsProvider settings, AppLocalizations t) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          RadioListTile<ThemeMode>(
            title: Text(t.system),
            value: ThemeMode.system,
            groupValue: settings.themeMode,
            onChanged: (value) => settings.setThemeMode(value!),
            activeColor: primaryColor,
            secondary: Icon(Icons.brightness_auto, color: primaryColor),
          ),
          RadioListTile<ThemeMode>(
            title: Text(t.light),
            value: ThemeMode.light,
            groupValue: settings.themeMode,
            onChanged: (value) => settings.setThemeMode(value!),
            activeColor: primaryColor,
            secondary: Icon(Icons.brightness_5, color: primaryColor),
          ),
          RadioListTile<ThemeMode>(
            title: Text(t.dark),
            value: ThemeMode.dark,
            groupValue: settings.themeMode,
            onChanged: (value) => settings.setThemeMode(value!),
            activeColor: primaryColor,
            secondary: Icon(Icons.brightness_2, color: primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, SettingsProvider settings, AppLocalizations t) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          RadioListTile<Locale>(
            title: Text(t.arabic),
            value: const Locale('ar'),
            groupValue: settings.locale,
            onChanged: (value) => settings.setLocale(value!),
            activeColor: primaryColor,
            secondary: const Icon(Icons.flag), // يمكن استبدالها بصورة علم
          ),
          RadioListTile<Locale>(
            title: Text(t.english),
            value: const Locale('en'),
            groupValue: settings.locale,
            onChanged: (value) => settings.setLocale(value!),
            activeColor: primaryColor,
            secondary: const Icon(Icons.flag),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFormatSelector(BuildContext context, SettingsProvider settings, AppLocalizations t) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          RadioListTile<TimeFormat>(
            title: Text(t.twelveHour),
            value: TimeFormat.twelveHour,
            groupValue: settings.timeFormat,
            onChanged: (value) => settings.setTimeFormat(value!),
            activeColor: primaryColor,
            secondary: const Icon(Icons.access_time),
          ),
          RadioListTile<TimeFormat>(
            title: Text(t.twentyFourHour),
            value: TimeFormat.twentyFourHour,
            groupValue: settings.timeFormat,
            onChanged: (value) => settings.setTimeFormat(value!),
            activeColor: primaryColor,
            secondary: const Icon(Icons.twenty_four_mp),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings(BuildContext context, SettingsProvider settings, AppLocalizations t) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SwitchListTile(
        title: Text(t.adhanSound),
        value: settings.isAdhanEnabled,
        onChanged: settings.setAdhanEnabled,
        secondary: const Icon(Icons.volume_up),
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildQuranSettings(BuildContext context, SettingsProvider settings, AppLocalizations t) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.fontSize, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: settings.quranFontSize,
                  min: 14,
                  max: 32,
                  divisions: 9,
                  label: settings.quranFontSize.round().toString(),
                  onChanged: (value) => settings.setQuranFontSize(value),
                  activeColor: primaryColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '${settings.quranFontSize.round()}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}