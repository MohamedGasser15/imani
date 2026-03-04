import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imani/core/models/quran_models.dart';
import 'package:imani/core/providers/settings_provider.dart';
import 'package:imani/features/quran/providers/quran_provider.dart';

class QuranPageViewScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  const QuranPageViewScreen({super.key, this.onBackPressed});

  @override
  State<QuranPageViewScreen> createState() => _QuranPageViewScreenState();
}

class _QuranPageViewScreenState extends State<QuranPageViewScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 1;
  final ValueNotifier<bool> _isZoomedNotifier = ValueNotifier<bool>(false);
  String _currentSurahName = '';
  int _currentJuz = 1;

  late TabController _tabController;

  // قائمة أسماء السور (كاملة)
  final Map<int, String> surahNames = {
    1: 'الفاتحة',
    2: 'البقرة',
    3: 'آل عمران',
    4: 'النساء',
    5: 'المائدة',
    6: 'الأنعام',
    7: 'الأعراف',
    8: 'الأنفال',
    9: 'التوبة',
    10: 'يونس',
    11: 'هود',
    12: 'يوسف',
    13: 'الرعد',
    14: 'إبراهيم',
    15: 'الحجر',
    16: 'النحل',
    17: 'الإسراء',
    18: 'الكهف',
    19: 'مريم',
    20: 'طه',
    21: 'الأنبياء',
    22: 'الحج',
    23: 'المؤمنون',
    24: 'النور',
    25: 'الفرقان',
    26: 'الشعراء',
    27: 'النمل',
    28: 'القصص',
    29: 'العنكبوت',
    30: 'الروم',
    31: 'لقمان',
    32: 'السجدة',
    33: 'الأحزاب',
    34: 'سبأ',
    35: 'فاطر',
    36: 'يس',
    37: 'الصافات',
    38: 'ص',
    39: 'الزمر',
    40: 'غافر',
    41: 'فصلت',
    42: 'الشورى',
    43: 'الزخرف',
    44: 'الدخان',
    45: 'الجاثية',
    46: 'الأحقاف',
    47: 'محمد',
    48: 'الفتح',
    49: 'الحجرات',
    50: 'ق',
    51: 'الذاريات',
    52: 'الطور',
    53: 'النجم',
    54: 'القمر',
    55: 'الرحمن',
    56: 'الواقعة',
    57: 'الحديد',
    58: 'المجادلة',
    59: 'الحشر',
    60: 'الممتحنة',
    61: 'الصف',
    62: 'الجمعة',
    63: 'المنافقون',
    64: 'التغابن',
    65: 'الطلاق',
    66: 'التحريم',
    67: 'الملك',
    68: 'القلم',
    69: 'الحاقة',
    70: 'المعارج',
    71: 'نوح',
    72: 'الجن',
    73: 'المزمل',
    74: 'المدثر',
    75: 'القيامة',
    76: 'الإنسان',
    77: 'المرسلات',
    78: 'النبأ',
    79: 'النازعات',
    80: 'عبس',
    81: 'التكوير',
    82: 'الانفطار',
    83: 'المطففين',
    84: 'الانشقاق',
    85: 'البروج',
    86: 'الطارق',
    87: 'الأعلى',
    88: 'الغاشية',
    89: 'الفجر',
    90: 'البلد',
    91: 'الشمس',
    92: 'الليل',
    93: 'الضحى',
    94: 'الشرح',
    95: 'التين',
    96: 'العلق',
    97: 'القدر',
    98: 'البينة',
    99: 'الزلزلة',
    100: 'العاديات',
    101: 'القارعة',
    102: 'التكاثر',
    103: 'العصر',
    104: 'الهمزة',
    105: 'الفيل',
    106: 'قريش',
    107: 'الماعون',
    108: 'الكوثر',
    109: 'الكافرون',
    110: 'النصر',
    111: 'المسد',
    112: 'الإخلاص',
    113: 'الفلق',
    114: 'الناس',
  };

  // صفحات بدايات السور (وفقًا للمصحف المجمع)
  final Map<int, int> surahStartPage = {
    1: 1, 2: 2, 3: 50, 4: 77, 5: 106, 6: 128, 7: 151, 8: 177, 9: 187, 10: 208,
    11: 221, 12: 235, 13: 249, 14: 255, 15: 262, 16: 267, 17: 282, 18: 293, 19: 305,
    20: 312, 21: 322, 22: 332, 23: 342, 24: 350, 25: 359, 26: 367, 27: 377, 28: 385,
    29: 396, 30: 404, 31: 411, 32: 415, 33: 418, 34: 428, 35: 434, 36: 440, 37: 446,
    38: 453, 39: 458, 40: 467, 41: 477, 42: 484, 43: 492, 44: 499, 45: 506, 46: 512,
    47: 518, 48: 523, 49: 528, 50: 532, 51: 537, 52: 542, 53: 547, 54: 552, 55: 556,
    56: 560, 57: 565, 58: 571, 59: 576, 60: 580, 61: 584, 62: 587, 63: 590, 64: 593,
    65: 596, 66: 599, 67: 602, 68: 605, 69: 608, 70: 611, 71: 614, 72: 617, 73: 620,
    74: 623, 75: 626, 76: 629, 77: 632, 78: 635, 79: 638, 80: 641, 81: 644, 82: 647,
    83: 650, 84: 653, 85: 656, 86: 659, 87: 662, 88: 665, 89: 668, 90: 671, 91: 674,
    92: 677, 93: 680, 94: 683, 95: 686, 96: 689, 97: 692, 98: 695, 99: 698, 100: 701,
    101: 704, 102: 707, 103: 710, 104: 713, 105: 716, 106: 719, 107: 722, 108: 725,
    109: 728, 110: 731, 111: 734, 112: 737, 113: 740, 114: 743,
  };

  // صفحات بدايات الأجزاء
  final Map<int, int> juzStartPage = {
    1: 1, 2: 22, 3: 42, 4: 62, 5: 82, 6: 102, 7: 121, 8: 141, 9: 161, 10: 181,
    11: 201, 12: 221, 13: 241, 14: 261, 15: 281, 16: 301, 17: 321, 18: 341, 19: 361,
    20: 381, 21: 401, 22: 421, 23: 441, 24: 461, 25: 481, 26: 501, 27: 521, 28: 541,
    29: 561, 30: 581,
  };

  @override
  void initState() {
    super.initState();
    final quranProvider = Provider.of<QuranProvider>(context, listen: false);
    _currentPage = quranProvider.lastReadPage;
    _pageController = PageController(initialPage: _currentPage - 1);
    _updatePageInfoFromPageNumber(_currentPage);
    _tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadAdjacentPages(_currentPage);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _isZoomedNotifier.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onZoomStateChanged(bool isZoomed) {
    _isZoomedNotifier.value = isZoomed;
  }

  Future<void> _updatePageInfoFromPageNumber(int pageNumber) async {
    final quranProvider = Provider.of<QuranProvider>(context, listen: false);
    final ayahs = quranProvider.getCachedPage(pageNumber);
    if (ayahs != null && ayahs.isNotEmpty) {
      setState(() {
        _currentSurahName = _getSurahName(ayahs.first.surahNumber);
        _currentJuz = ayahs.first.juz;
      });
    } else {
      await quranProvider.loadPage(pageNumber);
      final loadedAyahs = quranProvider.getCachedPage(pageNumber);
      if (loadedAyahs != null && loadedAyahs.isNotEmpty) {
        setState(() {
          _currentSurahName = _getSurahName(loadedAyahs.first.surahNumber);
          _currentJuz = loadedAyahs.first.juz;
        });
      }
    }
  }

  void _preloadAdjacentPages(int currentPage) {
    final quranProvider = Provider.of<QuranProvider>(context, listen: false);
    for (int i = 1; i <= 5; i++) {
      if (currentPage + i <= quranProvider.totalPages) {
        quranProvider.loadPage(currentPage + i);
      }
      if (currentPage - i >= 1) {
        quranProvider.loadPage(currentPage - i);
      }
    }
  }

  void _showIndexBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textDirection: TextDirection.rtl,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.chevron_left_rounded,
                          color: Color(0xFF424242),
                          size: 22,
                        ),
                      ),
                    ),
                    const Text(
                      'فهرس',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B5E3C),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF8B5E3C),
                labelColor: const Color(0xFF8B5E3C),
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'الفهرس', icon: Icon(Icons.list_rounded)),
                  Tab(text: 'الأجزاء', icon: Icon(Icons.grid_view_rounded)),
                  Tab(text: 'الملاحظات', icon: Icon(Icons.edit_note_rounded)),
                  Tab(text: 'المرجعيات', icon: Icon(Icons.bookmark_border_rounded)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildIndexTab(),
                    _buildJuzTab(),
                    _buildPlaceholderTab('الملاحظات - قريباً'),
                    _buildPlaceholderTab('المرجعيات - قريباً'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة لبناء تبويب الفهرس مع البحث والتفاعل
  Widget _buildIndexTab() {
    final searchController = TextEditingController();
    final ValueNotifier<String> searchQuery = ValueNotifier<String>('');

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: searchController,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: 'بحث في أسماء السور',
              suffixIcon: const Icon(Icons.search, color: Colors.black87),
              filled: true,
              fillColor: const Color(0xFFF9F9F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              searchQuery.value = value;
            },
          ),
        ),
        Expanded(
          child: ValueListenableBuilder<String>(
            valueListenable: searchQuery,
            builder: (context, query, child) {
              final filteredSurahs = surahNames.entries.where((entry) {
                return entry.value.contains(query);
              }).toList();

              return ListView.separated(
                itemCount: filteredSurahs.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 0.5, thickness: 0.5, color: Color(0xFFEEEEEE)),
                itemBuilder: (context, index) {
                  final surahNumber = filteredSurahs[index].key;
                  final surahName = filteredSurahs[index].value;
                  final bool isSelected = surahName == _currentSurahName;

                  return GestureDetector(
                    onTap: () => _goToSurahPage(surahNumber),
                    child: Container(
                      color: isSelected ? const Color(0xFFF3EADA) : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  surahName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontFamily: 'UthmanicHafs',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'رقمها ${_toArabicNumber(surahNumber)}  ـ  آياتها ${_toArabicNumber(_getSurahAyahCount(surahNumber))}',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF8B5E3C) : const Color(0xFFF2F2F2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                _toArabicNumber(surahStartPage[surahNumber] ?? 1),
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // دالة لبناء تبويب الأجزاء
  Widget _buildJuzTab() {
    final searchController = TextEditingController();
    final ValueNotifier<String> searchQuery = ValueNotifier<String>('');

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: searchController,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: 'بحث في الأجزاء',
              suffixIcon: const Icon(Icons.search, color: Colors.black87),
              filled: true,
              fillColor: const Color(0xFFF9F9F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              searchQuery.value = value;
            },
          ),
        ),
        Expanded(
          child: ValueListenableBuilder<String>(
            valueListenable: searchQuery,
            builder: (context, query, child) {
              final allJuzs = List.generate(30, (index) => index + 1);
              final filteredJuzs = allJuzs.where((juz) {
                return 'الجزء ${_toArabicNumber(juz)}'.contains(query);
              }).toList();

              return ListView.separated(
                itemCount: filteredJuzs.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 0.5, thickness: 0.5, color: Color(0xFFEEEEEE)),
                itemBuilder: (context, index) {
                  final juzNumber = filteredJuzs[index];
                  final bool isSelected = juzNumber == _currentJuz;

                  return GestureDetector(
                    onTap: () => _goToJuzPage(juzNumber),
                    child: Container(
                      color: isSelected ? const Color(0xFFF3EADA) : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Text(
                              'الجزء ${_toArabicNumber(juzNumber)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87,
                                fontFamily: 'UthmanicHafs',
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF8B5E3C) : const Color(0xFFF2F2F2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                'صفحة ${_toArabicNumber(juzStartPage[juzNumber]!)}',
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // الانتقال إلى صفحة السورة
  void _goToSurahPage(int surahNumber) {
    final targetPage = surahStartPage[surahNumber] ?? 1;
    Navigator.pop(context); // إغلاق الـ BottomSheet
    _pageController.animateToPage(
      targetPage - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    // تحديث المعلومات
    _updatePageInfoFromPageNumber(targetPage);
    Provider.of<QuranProvider>(context, listen: false).goToPage(targetPage);
  }

  // الانتقال إلى صفحة الجزء
  void _goToJuzPage(int juzNumber) {
    final targetPage = juzStartPage[juzNumber] ?? 1;
    Navigator.pop(context); // إغلاق الـ BottomSheet
    _pageController.animateToPage(
      targetPage - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    // تحديث المعلومات
    _updatePageInfoFromPageNumber(targetPage);
    Provider.of<QuranProvider>(context, listen: false).goToPage(targetPage);
  }

  Widget _buildPlaceholderTab(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
          color: Color(0xFF8B5E3C),
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quranProvider = Provider.of<QuranProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5EBDD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EBDD),
        elevation: 0,
        titleSpacing: 0,
        title: _buildHeader(),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ValueListenableBuilder<bool>(
          valueListenable: _isZoomedNotifier,
          builder: (context, isZoomed, child) {
            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              physics: isZoomed
                  ? const NeverScrollableScrollPhysics()
                  : const PageScrollPhysics(),
              itemCount: quranProvider.totalPages,
              onPageChanged: (index) async {
                final newPage = index + 1;
                setState(() {
                  _currentPage = newPage;
                });
                await quranProvider.goToPage(newPage);
                await _updatePageInfoFromPageNumber(newPage);
                _preloadAdjacentPages(newPage);
              },
              itemBuilder: (context, index) {
                final pageNumber = index + 1;
                return Selector<QuranProvider, List<Ayah>?>(
                  selector: (_, provider) => provider.getCachedPage(pageNumber),
                  builder: (context, ayahs, child) {
                    if (ayahs != null) {
                      return QuranPageWidget(
                        pageNumber: pageNumber,
                        ayahs: ayahs,
                        onZoomStateChanged: _onZoomStateChanged,
                      );
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        quranProvider.loadPage(pageNumber);
                      });
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EBDD),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // الزر الأيمن (رقم الجزء) - ينفذ onBackPressed
          GestureDetector(
            onTap: () {
              if (widget.onBackPressed != null) {
                widget.onBackPressed!(); // العودة إلى home tab
              } else {
                Navigator.pop(context); // السلوك الافتراضي
              }
            },
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8D9C5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.bookmark_border,
                    color: Color(0xFF8B5E3C),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'الجزء ${_toArabicNumber(_currentJuz)}',
                  style: const TextStyle(
                    fontFamily: 'UthmanicHafs',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8B5E3C),
                  ),
                ),
              ],
            ),
          ),
          // الزر الأوسط (الفهرس)
          GestureDetector(
            onTap: _showIndexBottomSheet,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8D9C5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.grid_view,
                color: Color(0xFF8B5E3C),
                size: 22,
              ),
            ),
          ),
          // الزر الأيسر (اسم السورة) - ينفذ onBackPressed أيضاً
          GestureDetector(
            onTap: () {
              if (widget.onBackPressed != null) {
                widget.onBackPressed!(); // العودة إلى home tab
              } else {
                Navigator.pop(context); // السلوك الافتراضي
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE8D9C5),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF8B5E3C),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _currentSurahName,
                    style: const TextStyle(
                      fontFamily: 'UthmanicHafs',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B5E3C),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _toArabicNumber(int number) {
    const westernToEastern = {
      '0': '٠',
      '1': '١',
      '2': '٢',
      '3': '٣',
      '4': '٤',
      '5': '٥',
      '6': '٦',
      '7': '٧',
      '8': '٨',
      '9': '٩',
    };
    return number
        .toString()
        .split('')
        .map((e) => westernToEastern[e] ?? e)
        .join('');
  }

  String _getSurahName(int surahNumber) {
    return surahNames[surahNumber] ?? 'سورة';
  }

  int _getSurahAyahCount(int surahNumber) {
    // يمكن استبدال هذه القيم بالأعداد الحقيقية
    const surahAyahCount = {
      1: 7, 2: 286, 3: 200, 4: 176, 5: 120, 6: 165, 7: 206, 8: 75, 9: 129, 10: 109,
      11: 123, 12: 111, 13: 43, 14: 52, 15: 99, 16: 128, 17: 111, 18: 110, 19: 98,
      20: 135, 21: 112, 22: 78, 23: 118, 24: 64, 25: 77, 26: 227, 27: 93, 28: 88,
      29: 69, 30: 60, 31: 34, 32: 30, 33: 73, 34: 54, 35: 45, 36: 83, 37: 182, 38: 88,
      39: 75, 40: 85, 41: 54, 42: 53, 43: 89, 44: 59, 45: 37, 46: 35, 47: 38, 48: 29,
      49: 18, 50: 45, 51: 60, 52: 49, 53: 62, 54: 55, 55: 78, 56: 96, 57: 29, 58: 22,
      59: 24, 60: 13, 61: 14, 62: 11, 63: 11, 64: 18, 65: 12, 66: 12, 67: 30, 68: 52,
      69: 52, 70: 44, 71: 28, 72: 28, 73: 20, 74: 56, 75: 40, 76: 31, 77: 50, 78: 40,
      79: 46, 80: 42, 81: 29, 82: 19, 83: 36, 84: 25, 85: 22, 86: 17, 87: 19, 88: 26,
      89: 30, 90: 20, 91: 15, 92: 21, 93: 11, 94: 8, 95: 8, 96: 19, 97: 5, 98: 8,
      99: 8, 100: 11, 101: 11, 102: 8, 103: 3, 104: 9, 105: 5, 106: 4, 107: 7, 108: 3,
      109: 6, 110: 3, 111: 5, 112: 4, 113: 5, 114: 6,
    };
    return surahAyahCount[surahNumber] ?? 0;
  }
}

// ==================== QuranPageWidget المعدل (مع التحقق من البيانات الفارغة) ====================

class QuranPageWidget extends StatefulWidget {
  final int pageNumber;
  final List<Ayah> ayahs;
  final Function(bool) onZoomStateChanged;

  const QuranPageWidget({
    super.key,
    required this.pageNumber,
    required this.ayahs,
    required this.onZoomStateChanged,
  });

  @override
  State<QuranPageWidget> createState() => _QuranPageWidgetState();
}

class _QuranPageWidgetState extends State<QuranPageWidget> {
  final TransformationController _transformationController = TransformationController();
  bool _isZoomed = false;

  // الحد الأقصى لحجم الخط (لمنع التكبير المفرط في الصفحات القصيرة)
  static const double _maxFontSize = 40.0;
  // الحد الأدنى لحجم الخط
  static const double _minFontSize = 12.0;

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onTransformationChanged);
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformationChanged);
    _transformationController.dispose();
    super.dispose();
  }

  void _onTransformationChanged() {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    final zoomed = scale > 1.05;
    if (_isZoomed != zoomed) {
      setState(() {
        _isZoomed = zoomed;
      });
      widget.onZoomStateChanged(zoomed);
    }
  }

  @override
  Widget build(BuildContext context) {
    // التحقق من وجود آيات
    if (widget.ayahs.isEmpty) {
      // محاولة إعادة تحميل الصفحة إذا كانت فارغة
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<QuranProvider>(context, listen: false).loadPage(widget.pageNumber);
      });
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('جاري تحميل الصفحة...'),
          ],
        ),
      );
    }

    final settings = Provider.of<SettingsProvider>(context);
    final firstAyah = widget.ayahs.first;
    final isStartOfSurah = _isStartOfSurah(firstAyah);
    final showBasmala = isStartOfSurah && firstAyah.surahNumber != 9;

    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 1.0,
      maxScale: 4.0,
      panEnabled: _isZoomed,
      scaleEnabled: true,
      child: Container(
        color: const Color(0xFFF5EBDD),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // عنوان السورة (إذا كانت بداية سورة)
            if (isStartOfSurah)
              _buildSurahTitle(_getSurahName(firstAyah.surahNumber)),

            // البسملة (إذا كانت بداية سورة وليست سورة التوبة)
            if (showBasmala)
              _buildBasmala(settings.quranFontSize),

            // منطقة النص الرئيسية (تتمدد لتملأ المساحة المتبقية)
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // المساحة المتاحة للنص (الارتفاع)
                  final double availableHeight = constraints.maxHeight;
                  // العرض المتاح (مع طرح الـ padding الأفقي)
                  final double maxWidth = constraints.maxWidth;

                  // حساب حجم الخط المثالي لهذه الصفحة بناءً على المساحة المتاحة
                  final double optimalFontSize = _getOptimalFontSize(
                    ayahs: widget.ayahs,
                    availableHeight: availableHeight,
                    maxWidth: maxWidth,
                    baseFontSize: settings.quranFontSize,
                  );

                  // نضع النص في حاوية بارتفاع محدد = المساحة المتاحة
                  return SizedBox(
                    height: availableHeight,
                    child: _buildRichText(optimalFontSize),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // بناء النص باستخدام حجم الخط المحسوب (مع WidgetSpan)
  Widget _buildRichText(double fontSize) {
    return RichText(
      textAlign: TextAlign.justify,
      textDirection: TextDirection.rtl,
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'UthmanicHafs',
          fontSize: fontSize,
          height: 1.3,
          color: Colors.black,
        ),
        children: _buildAyahSpans(widget.ayahs, fontSize),
      ),
    );
  }



  double _getOptimalFontSize({
    required List<Ayah> ayahs,
    required double availableHeight,
    required double maxWidth,
    required double baseFontSize,
  }) {
    double minFont = _minFontSize;
    double maxFont = _maxFontSize;
    double targetFont = baseFontSize.clamp(minFont, maxFont);

    if (ayahs.isEmpty) return minFont;

    for (int i = 0; i < 15; i++) {
      final plainSpans = _buildPlainTextSpans(ayahs, targetFont);
      final textSpan = TextSpan(style: plainSpans.first.style, children: plainSpans);

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.justify,
        maxLines: null,
      );

      textPainter.layout(maxWidth: maxWidth);
      final textHeight = textPainter.height;

      if (textHeight > availableHeight + 1.0) {
        maxFont = targetFont;
        targetFont = (minFont + maxFont) / 2;
      } else if (textHeight < availableHeight - 1.0) {
        minFont = targetFont;
        targetFont = (minFont + maxFont) / 2;
      } else {
        break; // تطابق ضمن التسامح
      }

      if ((maxFont - minFont) < 0.2) break; // دقة كافية
    }

    return targetFont.clamp(_minFontSize, _maxFontSize);
  }

  List<TextSpan> _buildPlainTextSpans(List<Ayah> ayahs, double fontSize) {
    List<TextSpan> spans = [];
    final double ayahFontSize = fontSize * 1.3;

    for (var ayah in ayahs) {
      String originalText = ayah.text;

      String withoutMarker = originalText.replaceAll(RegExp(r'\u06DD'), '');
      String cleanedText = withoutMarker.replaceAllMapped(
        RegExp(r'[\u0660-\u0669\u06F0-\u06F9]'),
        (match) => '',
      );

      cleanedText = cleanedText.replaceAllMapped(
        RegExp(
          r'[\u0600\u0601\u0602\u0603\u0604\u0605\u0606\u0607\u0608\u0609\u060A\u060B\u060C\u060D\u060E' +
              r'\u060F\u0610\u0611\u0612\u0613\u0614\u0615\u0616\u0617\u0618\u0619\u061A\u061B\u061C\u061D' +
              r'\u061E\u061F\u0620\u063B-\u063F\u0658-\u065F\u066A-\u066F\u0672-\u06FF]',
        ),
        (match) => '',
      );

      cleanedText = cleanedText.replaceAllMapped(
        RegExp(r'[\u0600-\u06FF]'),
        (match) => match[0]!,
      );
      cleanedText = cleanedText.replaceAll(' ', '\u200A\u200A\u200A');

      if (ayah.numberInSurah == 1 && ayah.surahNumber != 9) {
        cleanedText = _removeBasmalaSmart(cleanedText);
      }

      spans.add(
        TextSpan(
          text: cleanedText,
          style: TextStyle(
            fontFamily: 'UthmanicHafs',
            fontSize: ayahFontSize,
            height: 1.3,
            color: Colors.black,
            letterSpacing: 0.0,
          ),
        ),
      );

      spans.add(
        TextSpan(
          text: ' ﴿${_toArabicNumber(ayah.numberInSurah)}﴾ ',
          style: TextStyle(
            fontFamily: 'UthmanicHafs',
            fontSize: ayahFontSize,
            color: const Color(0xFF8B5E3C),
          ),
        ),
      );
    }
    return spans;
  }

Widget _buildSurahTitle(String surahName) {
  return SizedBox(
    width: double.infinity, // عرض الشاشة كاملاً
    child: Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/surah_frame.png',
          width: double.infinity,
          fit: BoxFit.cover, // يغطي العرض بالكامل
        ),
        Positioned(
          bottom: 8,
          child: Text(
            'سورة $surahName',
            style: const TextStyle(
              fontFamily: 'UthmanicHafs',
              fontSize: 24,
              color: Colors.black, // ✅ اللون الأسود الآن
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildBasmala(double baseFontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'UthmanicHafs',
          fontSize: baseFontSize * 1.2,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          height: 1.4,
        ),
      ),
    );
  }

  List<InlineSpan> _buildAyahSpans(List<Ayah> ayahs, double fontSize) {
    List<InlineSpan> spans = [];
    final double ayahFontSize = fontSize * 1.3;

    for (var ayah in ayahs) {
      String originalText = ayah.text;

      String withoutMarker = originalText.replaceAll(RegExp(r'\u06DD'), '');
      String cleanedText = withoutMarker.replaceAllMapped(
        RegExp(r'[\u0660-\u0669\u06F0-\u06F9]'),
        (match) => '',
      );

      cleanedText = cleanedText.replaceAllMapped(
        RegExp(
          r'[\u0600\u0601\u0602\u0603\u0604\u0605\u0606\u0607\u0608\u0609\u060A\u060B\u060C\u060D\u060E' +
              r'\u060F\u0610\u0611\u0612\u0613\u0614\u0615\u0616\u0617\u0618\u0619\u061A\u061B\u061C\u061D' +
              r'\u061E\u061F\u0620\u063B-\u063F\u0658-\u065F\u066A-\u066F\u0672-\u06FF]',
        ),
        (match) => '',
      );

      cleanedText = cleanedText.replaceAllMapped(
        RegExp(r'[\u0600-\u06FF]'),
        (match) => match[0]!,
      );
      cleanedText = cleanedText.replaceAll(' ', '\u200A\u200A\u200A');
      if (ayah.numberInSurah == 1 && ayah.surahNumber != 9) {
        cleanedText = _removeBasmalaSmart(cleanedText);
      }

      spans.add(
        TextSpan(
          text: cleanedText,
          style: TextStyle(
            fontFamily: 'UthmanicHafs',
            fontSize: ayahFontSize,
            height: 1.3,
            color: Colors.black,
            letterSpacing: 0.0,
          ),
        ),
      );

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: AyahNumberWidget(
              number: ayah.numberInSurah,
              fontSize: ayahFontSize * 1.0,
            ),
          ),
        ),
      );

      spans.add(WidgetSpan(child: SizedBox(width: 1)));
    }
    return spans;
  }
String _removeBasmalaSmart(String text) {
  final basmalaPattern = RegExp(
    r'^\s*بِ?سْمِ?\s*ٱ?للَّهِ?\s*ٱ?لرَّحْمَٰ?نِ?\s*ٱ?لرَّحِيمِ?',
    unicode: true,
  );

  return text.replaceFirst(basmalaPattern, '').trimLeft();
}
String _getSurahName(int surahNumber) {
  const surahNames = {
    1: 'الفاتحة',
    2: 'البقرة',
    3: 'آل عمران',
    4: 'النساء',
    5: 'المائدة',
    6: 'الأنعام',
    7: 'الأعراف',
    8: 'الأنفال',
    9: 'التوبة',
    10: 'يونس',
    11: 'هود',
    12: 'يوسف',
    13: 'الرعد',
    14: 'إبراهيم',
    15: 'الحجر',
    16: 'النحل',
    17: 'الإسراء',
    18: 'الكهف',
    19: 'مريم',
    20: 'طه',
    21: 'الأنبياء',
    22: 'الحج',
    23: 'المؤمنون',
    24: 'النور',
    25: 'الفرقان',
    26: 'الشعراء',
    27: 'النمل',
    28: 'القصص',
    29: 'العنكبوت',
    30: 'الروم',
    31: 'لقمان',
    32: 'السجدة',
    33: 'الأحزاب',
    34: 'سبأ',
    35: 'فاطر',
    36: 'يس',
    37: 'الصافات',
    38: 'ص',
    39: 'الزمر',
    40: 'غافر',
    41: 'فصلت',
    42: 'الشورى',
    43: 'الزخرف',
    44: 'الدخان',
    45: 'الجاثية',
    46: 'الأحقاف',
    47: 'محمد',
    48: 'الفتح',
    49: 'الحجرات',
    50: 'ق',
    51: 'الذاريات',
    52: 'الطور',
    53: 'النجم',
    54: 'القمر',
    55: 'الرحمن',
    56: 'الواقعة',
    57: 'الحديد',
    58: 'المجادلة',
    59: 'الحشر',
    60: 'الممتحنة',
    61: 'الصف',
    62: 'الجمعة',
    63: 'المنافقون',
    64: 'التغابن',
    65: 'الطلاق',
    66: 'التحريم',
    67: 'الملك',
    68: 'القلم',
    69: 'الحاقة',
    70: 'المعارج',
    71: 'نوح',
    72: 'الجن',
    73: 'المزمل',
    74: 'المدثر',
    75: 'القيامة',
    76: 'الإنسان',
    77: 'المرسلات',
    78: 'النبأ',
    79: 'النازعات',
    80: 'عبس',
    81: 'التكوير',
    82: 'الانفطار',
    83: 'المطففين',
    84: 'الانشقاق',
    85: 'البروج',
    86: 'الطارق',
    87: 'الأعلى',
    88: 'الغاشية',
    89: 'الفجر',
    90: 'البلد',
    91: 'الشمس',
    92: 'الليل',
    93: 'الضحى',
    94: 'الشرح',
    95: 'التين',
    96: 'العلق',
    97: 'القدر',
    98: 'البينة',
    99: 'الزلزلة',
    100: 'العاديات',
    101: 'القارعة',
    102: 'التكاثر',
    103: 'العصر',
    104: 'الهمزة',
    105: 'الفيل',
    106: 'قريش',
    107: 'الماعون',
    108: 'الكوثر',
    109: 'الكافرون',
    110: 'النصر',
    111: 'المسد',
    112: 'الإخلاص',
    113: 'الفلق',
    114: 'الناس',
  };
  return surahNames[surahNumber] ?? 'سورة';
}

  bool _isStartOfSurah(Ayah ayah) {
    return ayah.numberInSurah == 1;
  }

  // دالة تحويل الأرقام إلى عربية
  String _toArabicNumber(int number) {
    const westernToEastern = {
      '0': '٠',
      '1': '١',
      '2': '٢',
      '3': '٣',
      '4': '٤',
      '5': '٥',
      '6': '٦',
      '7': '٧',
      '8': '٨',
      '9': '٩',
    };
    return number
        .toString()
        .split('')
        .map((e) => westernToEastern[e] ?? e)
        .join('');
  }
}

// ==================== AyahNumberWidget (بدون تغيير) ====================

class AyahNumberWidget extends StatelessWidget {
  final int number;
  final double fontSize;

  const AyahNumberWidget({super.key, required this.number, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      _toArabicNumber(number),
      style: TextStyle(
        fontFamily: 'UthmanicHafs',
        fontSize: fontSize,
        color: const Color(0xFF8B5E3C),
      ),
    );
  }

  String _toArabicNumber(int number) {
    const westernToEastern = {
      '0': '٠',
      '1': '١',
      '2': '٢',
      '3': '٣',
      '4': '٤',
      '5': '٥',
      '6': '٦',
      '7': '٧',
      '8': '٨',
      '9': '٩',
    };
    return number
        .toString()
        .split('')
        .map((e) => westernToEastern[e] ?? e)
        .join('');
  }
}
