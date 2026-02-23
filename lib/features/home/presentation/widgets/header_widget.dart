import 'package:flutter/material.dart';
import 'package:imani/core/constants/app_colors.dart';
import 'package:imani/features/home/presentation/widgets/prayer_item.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, AppColors.secondary],
              ),
            ),
          ),
          // صورة المسجد (اختياري)
          Positioned.fill(
            child: Opacity(
              opacity: 0.12,
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
                            const Text(
                              '14:01',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '☉ Ashr in 01:08:59',
                              style: TextStyle(
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
                                color: AppColors.darkPrimary,
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
                        PrayerItem(name: 'Subuh', time: '04:37', icon: Icons.wb_twilight, isActive: false),
                        PrayerItem(name: 'Fajr', time: '05:50', icon: Icons.wb_sunny, isActive: false),
                        PrayerItem(name: 'Dzuhur', time: '12:05', icon: Icons.wb_sunny, isActive: false),
                        PrayerItem(name: 'Ashr', time: '15:10', icon: Icons.wb_cloudy, isActive: true),
                        PrayerItem(name: 'Maghrib', time: '18:13', icon: Icons.nightlight, isActive: false),
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