import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imani/core/models/quran_models.dart';
import 'package:imani/core/providers/settings_provider.dart';
import 'package:imani/features/quran/providers/quran_provider.dart';

class QuranPageViewScreen extends StatefulWidget {
  const QuranPageViewScreen({super.key});

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

  @override
  void initState() {
    super.initState();
    final quranProvider = Provider.of<QuranProvider>(context, listen: false);
    _currentPage = quranProvider.lastReadPage;
    _pageController = PageController(initialPage: _currentPage - 1);
    _updatePageInfoFromPageNumber(_currentPage);
    _tabController = TabController(length: 4, vsync: this);

    // تحميل الصفحات المجاورة بعد البناء مباشرة
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
      // إذا لم تكن الصفحة محملة، ننتظر تحميلها
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
    // تحميل 5 صفحات قبل وبعد
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
            // رأس الفهرس
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
            // تبويبات
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
                  Tab(
                      text: 'المرجعيات',
                      icon: Icon(Icons.bookmark_border_rounded)),
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
                    _buildPlaceholderTab('الأجزاء - قريباً'),
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

  Widget _buildIndexTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
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
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: surahNames.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 0.5, thickness: 0.5, color: Color(0xFFEEEEEE)),
            itemBuilder: (context, index) {
              final surahNumber = index + 1;
              final surahName = surahNames[surahNumber]!;
              final bool isSelected = surahName == "العلق";
              return Container(
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
                            'رقمها ${_toArabicNumber(surahNumber)}  ـ  آياتها ${_toArabicNumber(19)}  ـ  مكية',
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
                          _toArabicNumber(590 + index),
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
              );
            },
          ),
        ),
      ],
    );
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
                      // الصفحة لم تصل بعد، نبدأ تحميلها
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
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
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
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
}

// ==================== QuranPageWidget (بدون تغيير يذكر) ====================

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
  final TransformationController _transformationController =
      TransformationController();
  bool _isZoomed = false;

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
    final settings = Provider.of<SettingsProvider>(context);
    final firstAyah = widget.ayahs.first;

    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 1.0,
      maxScale: 4.0,
      panEnabled: _isZoomed,
      scaleEnabled: true,
      child: Container(
        color: const Color(0xFFF5EBDD),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isStartOfSurah(firstAyah))
              _buildSurahTitle(_getSurahName(firstAyah.surahNumber)),
            if (_isStartOfSurah(firstAyah) && firstAyah.surahNumber != 9)
              _buildBasmala(settings.quranFontSize),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: RichText(
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.rtl,
                  text: TextSpan(
                    children: _buildAyahSpans(widget.ayahs, settings.quranFontSize),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahTitle(String surahName) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/surah_frame.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 8,
            child: Text(
              'سورة $surahName',
              style: const TextStyle(
                fontFamily: 'UthmanicHafs',
                fontSize: 24,
                color: Color(0xFF8B5E3C),
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

      // تنظيف النص (كما في الكود الأصلي)
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

      if (ayah.numberInSurah == 1 && ayah.surahNumber != 9) {
        cleanedText = _removeBasmalaSmart(cleanedText);
      }

      spans.add(
        TextSpan(
          text: cleanedText,
          style: TextStyle(
            fontFamily: 'UthmanicHafs',
            fontSize: ayahFontSize,
            height: 1.5,
            color: Colors.black,
          ),
        ),
      );

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: AyahNumberWidget(
            number: ayah.numberInSurah,
            fontSize: ayahFontSize * 0.8,
          ),
        ),
      );

      spans.add(const TextSpan(text: " "));
    }
    return spans;
  }

  String _removeBasmalaSmart(String text) {
    String normalizeForCompare(String s) {
      return s
          .replaceAll(RegExp(r'[\u0610-\u061A\u064B-\u065F\u0670]'), '')
          .replaceAll('ٱ', 'ا')
          .replaceAll('إ', 'ا')
          .replaceAll('أ', 'ا')
          .replaceAll('آ', 'ا');
    }

    String normalizedText = normalizeForCompare(text);
    const normalizedBasmala = 'بسم الله الرحمن الرحيم';

    if (normalizedText.startsWith(normalizedBasmala)) {
      int basmalaLength = 0;
      for (int i = 1; i <= text.length; i++) {
        String prefix = text.substring(0, i);
        String normalizedPrefix = normalizeForCompare(prefix);
        if (normalizedBasmala.startsWith(normalizedPrefix)) {
          basmalaLength = i;
        } else {
          break;
        }
      }
      if (basmalaLength > 0) {
        return text.substring(basmalaLength).trimLeft();
      }
    }
    return text;
  }

  String _getSurahName(int surahNumber) {
    // يمكن جلبها من القائمة العامة أو استخدام خريطة محلية مختصرة
    const surahNames = {
      1: 'الفاتحة',
      2: 'البقرة',
      3: 'آل عمران',
      // ... يمكن إكمال القائمة حسب الحاجة
    };
    return surahNames[surahNumber] ?? 'سورة';
  }

  bool _isStartOfSurah(Ayah ayah) {
    return ayah.numberInSurah == 1;
  }
}

// ==================== AyahNumberWidget (بدون تغيير) ====================

class AyahNumberWidget extends StatelessWidget {
  final int number;
  final double fontSize;

  const AyahNumberWidget({super.key, required this.number, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        _toArabicNumber(number),
        style: TextStyle(
          fontFamily: 'UthmanicHafs',
          fontSize: fontSize,
          color: const Color(0xFF8B5E3C),
        ),
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