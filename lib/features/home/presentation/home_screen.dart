import 'package:flutter/material.dart';
import 'package:imani/features/home/presentation/widgets/categories_section.dart';
import 'package:imani/features/home/presentation/widgets/category_buttons.dart';
import 'package:imani/features/home/presentation/widgets/header_widget.dart';
import 'package:imani/features/home/presentation/widgets/last_read_card.dart';
import 'package:imani/core/constants/app_colors.dart';
import 'package:imani/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // صفحات التاب (الآن 5 صفحات: الرئيسية، استكشاف، القرآن، الصلاة، الملف الشخصي)
  final List<Widget> _pages = const [
    HomeContent(),
    DiscoverScreenPlaceholder(),
    QuranScreenPlaceholder(),
    PrayerScreenPlaceholder(),
    ProfileScreenPlaceholder(), // الصفحة الخامسة هي البروفايل
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: AppColors.textLight,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
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

// المحتوى الرئيسي للصفحة الرئيسية
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    // داخل HomeContent في build
return SingleChildScrollView(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      HeaderWidget(),
      LastReadCard(),
      CategoriesSection(), // هنا القسم الجديد
      SizedBox(height: 30),
    ],
  ),
);
  }
}

// صفحات مؤقتة للتبويبات الأخرى
class DiscoverScreenPlaceholder extends StatelessWidget {
  const DiscoverScreenPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Discover Page'));
  }
}

class QuranScreenPlaceholder extends StatelessWidget {
  const QuranScreenPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Quran Page'));
  }
}

class PrayerScreenPlaceholder extends StatelessWidget {
  const PrayerScreenPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Prayer Page'));
  }
}

// صفحة الملف الشخصي (مؤقتة)
class ProfileScreenPlaceholder extends StatelessWidget {
  const ProfileScreenPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile Page'));
  }
}