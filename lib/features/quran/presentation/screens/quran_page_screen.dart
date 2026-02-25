import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imani/core/providers/settings_provider.dart';
import 'package:imani/features/quran/providers/quran_provider.dart';
import 'package:imani/core/models/quran_models.dart';

class QuranPageScreen extends StatefulWidget {
  const QuranPageScreen({super.key});

  @override
  State<QuranPageScreen> createState() => _QuranPageScreenState();
}

class _QuranPageScreenState extends State<QuranPageScreen> {
  late PageController _pageController;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    final quranProvider = Provider.of<QuranProvider>(context, listen: false);
    _currentPage = quranProvider.lastReadPage;
    _pageController = PageController(initialPage: _currentPage - 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quranProvider = Provider.of<QuranProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final totalPages = quranProvider.totalPages;

    if (totalPages == 0) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('القرآن الكريم'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemCount: totalPages,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index + 1;
                });
                quranProvider.saveLastPage(_currentPage);
              },
              itemBuilder: (context, index) {
                final pageNumber = index + 1;
                return FutureBuilder<List<Ayah>>(
                  future: quranProvider.getPage(pageNumber),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('لا توجد آيات'));
                    }
                    final ayahs = snapshot.data!;
                    return _buildPage(ayahs, settings.quranFontSize);
                  },
                );
              },
            ),
          ),
          // شريط الصفحات السفلي
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Theme.of(context).cardColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    if (_currentPage > 1) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
                Text(
                  'الصفحة $_currentPage من $totalPages',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    if (_currentPage < totalPages) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(List<Ayah> ayahs, double fontSize) {
    return Container(
      color: const Color(0xFFFFF8E7), // خلفية ذهبية فاتحة جداً
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.end,
            runAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: ayahs.map((ayah) {
              return _buildAyahWithNumber(ayah, fontSize);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildAyahWithNumber(Ayah ayah, double fontSize) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        // رقم الآية في دائرة
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: CircleAvatar(
            radius: fontSize * 0.5,
            backgroundColor: const Color(0xFFD4AF37).withOpacity(0.2), // ذهبي خفيف
            child: Text(
              '${ayah.numberInSurah}',
              style: TextStyle(
                fontSize: fontSize * 0.5,
                fontFamily: 'Tajawal',
                color: const Color(0xFFB8860B), // ذهبي غامق
              ),
            ),
          ),
        ),
        // نص الآية
        Flexible(
          child: Text(
            ayah.text,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: 'Scheherazade',
              fontSize: fontSize,
              height: 1.8,
            ),
          ),
        ),
      ],
    );
  }
}