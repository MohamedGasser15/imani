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

class _QuranPageViewScreenState extends State<QuranPageViewScreen> {
  late PageController _pageController;
  int _currentPage = 1;
  final ValueNotifier<bool> _isZoomedNotifier = ValueNotifier<bool>(false);
  String _currentSurahName = '';
  int _currentJuz = 1;

  @override
  void initState() {
    super.initState();
    final quranProvider = Provider.of<QuranProvider>(context, listen: false);
    _currentPage = quranProvider.lastReadPage;
    _pageController = PageController(initialPage: _currentPage - 1);
    _updatePageInfoFromCurrentPage(quranProvider);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _isZoomedNotifier.dispose();
    super.dispose();
  }

  void _onZoomStateChanged(bool isZoomed) {
    _isZoomedNotifier.value = isZoomed;
  }

  void _updatePageInfoFromCurrentPage(QuranProvider provider) {
    if (provider.currentPageAyahs != null && provider.currentPageAyahs!.isNotEmpty) {
      setState(() {
        _currentSurahName = _getSurahName(provider.currentPageAyahs!.first.surahNumber);
        _currentJuz = provider.currentPageAyahs!.first.juz;
      });
    }
  }

  Future<void> _updatePageInfo(int pageNumber) async {
    final quranProvider = Provider.of<QuranProvider>(context, listen: false);
    if (quranProvider.currentPageAyahs != null && quranProvider.currentPageAyahs!.isNotEmpty) {
      setState(() {
        _currentSurahName = _getSurahName(quranProvider.currentPageAyahs!.first.surahNumber);
        _currentJuz = quranProvider.currentPageAyahs!.first.juz;
      });
    }
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
                _updatePageInfo(newPage);
              },
              itemBuilder: (context, index) {
                final pageNumber = index + 1;
                // إذا كانت هذه هي الصفحة الحالية، استخدم currentPageAyahs
                if (pageNumber == quranProvider.lastReadPage) {
                  if (quranProvider.isLoadingPage) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (quranProvider.currentPageAyahs == null || quranProvider.currentPageAyahs!.isEmpty) {
                    return const Center(child: Text('لا توجد آيات'));
                  }
                  return QuranPageWidget(
                    pageNumber: pageNumber,
                    ayahs: quranProvider.currentPageAyahs!,
                    onZoomStateChanged: _onZoomStateChanged,
                  );
                } else {
                  // للصفحات الأخرى، استخدم FutureBuilder
                  return FutureBuilder<List<Ayah>>(
                    future: quranProvider.getPage(pageNumber),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('لا توجد آيات'));
                      }
                      return QuranPageWidget(
                        pageNumber: pageNumber,
                        ayahs: snapshot.data!,
                        onZoomStateChanged: _onZoomStateChanged,
                      );
                    },
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      color: const Color(0xFFF5EBDD),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.bookmark_border, color: Color(0xFF8B5E3C), size: 24),
              const SizedBox(width: 4),
              Text(
                'الجزء ${_toArabicNumber(_currentJuz)}',
                style: const TextStyle(
                  fontFamily: 'UthmanicHafs',
                  fontSize: 18,
                  color: Color(0xFF8B5E3C),
                ),
              ),
            ],
          ),
          const Icon(Icons.grid_view, color: Color(0xFF8B5E3C), size: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8D9C5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_back_ios, color: Color(0xFF8B5E3C), size: 16),
                const SizedBox(width: 4),
                Text(
                  _currentSurahName,
                  style: const TextStyle(
                    fontFamily: 'UthmanicHafs',
                    fontSize: 16,
                    color: Color(0xFF8B5E3C),
                  ),
                ),
              ],
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
    const surahNames = {
      1: 'الفاتحة',
      2: 'البقرة',
      3: 'آل عمران',
      // ... أضف باقي السور
    };
    return surahNames[surahNumber] ?? 'سورة';
  }
}

// ==================== QuranPageWidget ====================

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
            // عنوان السورة إذا كانت بداية سورة
            if (_isStartOfSurah(firstAyah))
              _buildSurahTitle(_getSurahName(firstAyah.surahNumber)),

            // البسملة (فقط للآية الأولى وليست سورة التوبة)
            if (_isStartOfSurah(firstAyah) && firstAyah.surahNumber != 9)
              _buildBasmala(settings.quranFontSize),

            const SizedBox(height: 16),

            // نص الآيات
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

  // دالة بناء عنوان السورة (كما هي)
Widget _buildSurahTitle(String surahName) {
  final width = MediaQuery.of(context).size.width;

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 15),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/surah_frame.png',
          width: width,
          fit: BoxFit.fitWidth,
        ),
        Positioned(
          bottom: width * 0.02,
          child:  Text(
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

  // ✅ دالة جديدة لبناء البسملة
  Widget _buildBasmala(double baseFontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'UthmanicHafs',
          fontSize: baseFontSize * 1.2, // أكبر قليلاً من حجم الآيات
          fontWeight: FontWeight.bold,
          color: const Color(0xFF8B5E3C),
          height: 1.4,
        ),
      ),
    );
  }

  // دالة بناء الـ Spans (مع دالة إزالة البسملة الذكية)
  List<InlineSpan> _buildAyahSpans(List<Ayah> ayahs, double fontSize) {
    List<InlineSpan> spans = [];
    final double ayahFontSize = fontSize * 1.3;

    for (var ayah in ayahs) {
      String originalText = ayah.text;
      
      // تنظيف النص من الرموز الخاصة (كما كانت)
      String withoutMarker = originalText.replaceAll(RegExp(r'\u06DD'), '');
      String cleanedText = withoutMarker.replaceAllMapped(
        RegExp(r'[\u0660-\u0669\u06F0-\u06F9]'),
        (match) => '',
      );

      cleanedText = cleanedText.replaceAllMapped(
        RegExp(
          r'[\u0600\u0601\u0602\u0603\u0604\u0605\u0606\u0607\u0608\u0609\u060A\u060B\u060C\u060D\u060E' +
          r'\u060F\u0610\u0611\u0612\u0613\u0614\u0615\u0616\u0617\u0618\u0619\u061A\u061B\u061C\u061D' +
          r'\u061E\u061F\u0620\u063B-\u063F\u0658-\u065F\u066A-\u066F\u0672-\u06FF]'
        ),
        (match) => '',
      );

      cleanedText = cleanedText.replaceAllMapped(
        RegExp(r'[\u0600-\u06FF]'),
        (match) => match[0]!,
      );

      // إزالة البسملة من الآية الأولى فقط (باستخدام الدالة الذكية)
      if (ayah.numberInSurah == 1 && ayah.surahNumber != 9) {
        cleanedText = _removeBasmalaSmart(cleanedText);
      }

      // إضافة النص
      spans.add(
        TextSpan(
          text: cleanedText,
          style: TextStyle(
            fontFamily: 'UthmanicHafs',
            fontSize: ayahFontSize,
            height: 1.4,
            color: Colors.black,
          ),
        ),
      );

      // رقم الآية
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

  // دالة إزالة البسملة الذكية (اللي اشتغلنا عليها)
  String _removeBasmalaSmart(String text) {
    String normalizeForCompare(String s) {
      return s.replaceAll(RegExp(r'[\u0610-\u061A\u064B-\u065F\u0670]'), '')
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

  // دوال مساعدة (موجودة بالفعل)
  String _getSurahName(int surahNumber) {
    const surahNames = {
      1: 'الفاتحة',
      2: 'البقرة',
      3: 'آل عمران',
      // ... أكمل القائمة
    };
    return surahNames[surahNumber] ?? 'سورة';
  }

  bool _isStartOfSurah(Ayah ayah) {
    return ayah.numberInSurah == 1;
  }
}
// ==================== AyahNumberWidget ====================

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