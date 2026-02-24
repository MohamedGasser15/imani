import 'dart:ui' show Locale; // مهم عشان نعرف نوع Locale
import 'package:flutter/material.dart';
import 'package:imani/features/home/presentation/widgets/header_widget.dart';
import 'package:imani/features/home/presentation/widgets/last_read_card.dart';
import 'package:imani/features/home/presentation/widgets/daily_activity_card.dart';
import 'package:imani/core/constants/app_colors.dart';
import 'package:imani/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  final void Function(Locale)? onLocaleChange; // الباراميتر الجديد (اختياري)

  const HomeScreen({super.key, this.onLocaleChange}); // نضيفه هنا

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderWidget(),
            const LastReadCard(),
            const SizedBox(height: 16),
            // const DailyActivityCard(),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: AppColors.textLight,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: t.home),
          BottomNavigationBarItem(icon: const Icon(Icons.explore), label: t.discover),
          BottomNavigationBarItem(icon: const Icon(Icons.menu_book), label: t.quran),
          BottomNavigationBarItem(icon: const Icon(Icons.access_time), label: t.prayer),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: t.settings),
        ],
      ),
    );
  }
}