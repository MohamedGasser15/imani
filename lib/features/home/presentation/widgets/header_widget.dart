import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:imani/core/constants/app_colors.dart';
import 'package:imani/core/providers/settings_provider.dart';
import 'package:imani/features/home/presentation/widgets/prayer_item.dart';
import 'package:imani/features/settings/presentation/screens/settings_screen.dart';
import 'package:imani/l10n/app_localizations.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  String _formatTime(DateTime time, TimeFormat format) {
    if (format == TimeFormat.twelveHour) {
      return DateFormat('h:mm a').format(time);
    } else {
      return DateFormat('HH:mm').format(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final t = AppLocalizations.of(context)!;
    final settings = Provider.of<SettingsProvider>(context);
    final now = DateTime.now();
    final formattedTime = _formatTime(now, settings.timeFormat);
    final timeUntilNextPrayer = "01:08:59"; // مؤقت، سيتم تحديثه لاحقاً

    // اختيار ألوان التدرج حسب الوضع
    final List<Color> gradientColors = isLight
        ? [AppColors.primary, AppColors.secondary]
        : [AppColors.darkPrimary, AppColors.primary.withOpacity(0.7)];

    // خفض شفافية صورة الخلفية في الوضع الليلي
    final double imageOpacity = isLight ? 0.12 : 0.08;

    return Container(
      height: 340,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // الخلفية المتدرجة
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
              ),
            ),
          ),
          // صورة المسجد (خلفية زخرفية)
          Positioned.fill(
            child: Opacity(
              opacity: imageOpacity,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/images/test1.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
            ),
          ),
          // المحتوى
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            Text(
                              formattedTime,
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '☉ Ashr in $timeUntilNextPrayer',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // أيقونة الإعدادات فوق التاريخ
                            IconButton(
                              icon: const Icon(Icons.settings, color: Colors.white, size: 28),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                                );
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '10 Ramadhan 1446 H',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isLight
                                    ? AppColors.darkPrimary
                                    : AppColors.darkPrimary.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '☉ Sumedang, West Ja...',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // صف مواقيت الصلاة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PrayerItem(name: t.subuh, time: '04:37', icon: Icons.wb_twilight, isActive: false),
                        PrayerItem(name: t.fajr, time: '05:50', icon: Icons.wb_sunny, isActive: false),
                        PrayerItem(name: t.dzuhur, time: '12:05', icon: Icons.wb_sunny, isActive: false),
                        PrayerItem(name: t.ashr, time: '15:10', icon: Icons.wb_cloudy, isActive: true),
                        PrayerItem(name: t.maghrib, time: '18:13', icon: Icons.nightlight, isActive: false),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}