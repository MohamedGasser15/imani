import 'package:flutter/material.dart';
import 'package:imani/features/home/presentation/widgets/header_widget.dart';
import 'package:imani/features/home/presentation/widgets/last_read_card.dart';
import 'package:imani/features/home/presentation/widgets/categories_section.dart';
import 'package:imani/features/quran/presentation/screens/quran_page_screen.dart'; // استيراد الشاشة الجديدة
import 'package:imani/features/quran/presentation/screens/QuranPageViewScreen.dart';
import 'package:imani/features/quran/presentation/screens/surah_list_screen.dart';
import 'package:imani/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    const HomeTab(),
    const DiscoverTab(),
    const QuranTab(), // هذا التبويب يستخدم QuranPageScreen
    const PrayerTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
     // داخل HomeScreen، في build:
bottomNavigationBar: _selectedIndex == 2 
    ? null // إخفاء الشريط في تبويب القرآن
    : BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: t.home),
          BottomNavigationBarItem(icon: const Icon(Icons.explore), label: t.discover),
          BottomNavigationBarItem(icon: const Icon(Icons.menu_book), label: t.quran),
          BottomNavigationBarItem(icon: const Icon(Icons.access_time), label: t.prayer),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: t.profile),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWidget(),
          LastReadCard(),
          CategoriesSection(),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

class DiscoverTab extends StatelessWidget {
  const DiscoverTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('قريباً...'));
  }
}

// داخل class QuranTab في home_screen.dart
class QuranTab extends StatelessWidget {
  const QuranTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const QuranPageViewScreen(); // استبدال SurahListScreen
  }
}
class PrayerTab extends StatelessWidget {
  const PrayerTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('قريباً...'));
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('قريباً...'));
  }
}