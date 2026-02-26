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
    _updatePageInfo(_currentPage);
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

  Future<void> _updatePageInfo(int pageNumber) async {
    final quranProvider = Provider.of<QuranProvider>(context, listen: false);
    final ayahs = await quranProvider.getPage(pageNumber);
    if (ayahs.isNotEmpty) {
      setState(() {
        _currentSurahName = _getSurahName(ayahs.first.surahNumber);
        _currentJuz = ayahs.first.juz;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final quranProvider = Provider.of<QuranProvider>(context);
    final totalPages = quranProvider.totalPages;

    if (totalPages == 0) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
              itemCount: totalPages,
              onPageChanged: (index) {
                final newPage = index + 1;
                setState(() {
                  _currentPage = newPage;
                });
                quranProvider.saveLastPage(newPage);
                _updatePageInfo(newPage);
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
                    return QuranPageWidget(
                      pageNumber: pageNumber,
                      ayahs: ayahs,
                      onZoomStateChanged: _onZoomStateChanged,
                    );
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
    // استبدل هذه القائمة بأسماء السور الكاملة
    const surahNames = {
      1: 'الفاتحة',
      2: 'البقرة',
      3: 'آل عمران',
      // ... أضف باقي السور
    };
    return surahNames[surahNumber] ?? 'سورة';
  }
}

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
            // اسم السورة (إذا كانت بداية سورة)
            if (_isStartOfSurah(firstAyah))
              _buildSurahTitle(_getSurahName(firstAyah.surahNumber)),
            if (_isStartOfSurah(firstAyah)) ...[
              const SizedBox(height: 8),
              // عرض أول آية كعنوان مميز
              Text(
                firstAyah.text.replaceAll(RegExp(r'[\u0600-\u06FF\s]'), ''),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'UthmanicHafs',
                  fontSize: settings.quranFontSize * 1.2,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8B5E3C),
                  height: 2.0,
                ),
              ),
              const SizedBox(height: 16),
            ],
            // الآيات
            Expanded(
              child: SingleChildScrollView(
                physics: _isZoomed ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8D9C5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'سورة $surahName',
            style: const TextStyle(
              fontFamily: 'UthmanicHafs',
              fontSize: 28,
              color: Color(0xFF8B5E3C),
            ),
          ),
        ],
      ),
    );
  }

  List<InlineSpan> _buildAyahSpans(List<Ayah> ayahs, double fontSize) {
    List<InlineSpan> spans = [];
    final double ayahFontSize = fontSize * 1.5;

    for (var ayah in ayahs) {
      String withoutMarker = ayah.text.replaceAll(RegExp(r'\u06DD'), '');
      String ayahText = ayah.text;
      String cleanedText = withoutMarker.replaceAllMapped(
        RegExp(r'[\u0660-\u0669\u06F0-\u06F9]'),
        (match) => '',
      );

      cleanedText = cleanedText.replaceAllMapped(
        RegExp(
          r'[\u0600\u0601\u0602\u0603\u0604\u0605\u0606\u0607\u0608\u0609\u060A\u060B\u060C\u060D\u060E' +
          r'\u060F\u0610\u0611\u0612\u0613\u0614\u0615\u0616\u0617\u0618\u0619\u061A\u061B\u061C\u061D' +
          r'\u061E\u061F\u0620\u063B\u063C\u063D\u063E\u063F\u0658\u0659\u065A\u065B\u065C\u065D\u065F' +
          r'\u066A\u066B\u066C\u066D\u066F\u0672\u0673\u0674\u0675\u0676\u0677\u0678\u0679\u067A\u067B' +
          r'\u067C\u067D\u067E\u067F\u0680\u0681\u0682\u0683\u0684\u0685\u0686\u0687\u0688\u0689\u068A' +
          r'\u068B\u068C\u068D\u068E\u068F\u0690\u0691\u0692\u0693\u0694\u0695\u0696\u0697\u0698\u0699' +
          r'\u069A\u069B\u069C\u069D\u069E\u069F\u06A0\u06A1\u06A2\u06A3\u06A4\u06A5\u06A6\u06A7\u06A8' +
          r'\u06A9\u06AA\u06AB\u06AC\u06AD\u06AE\u06AF\u06B0\u06B1\u06B2\u06B3\u06B4\u06B5\u06B6\u06B7' +
          r'\u06B8\u06B9\u06BA\u06BB\u06BC\u06BD\u06BE\u06BF\u06C0\u06C1\u06C2\u06C3\u06C4\u06C5\u06C6' +
          r'\u06C7\u06C8\u06C9\u06CA\u06CB\u06CC\u06CD\u06CE\u06CF\u06D0\u06D1\u06D2\u06D3\u06D4\u06D5' +
          r'\u06DF\u06E3\u06EB\u06EE\u06EF\u06F0\u06F1\u06F2\u06F3\u06F4\u06F5\u06F6\u06F7\u06F8\u06F9' +
          r'\u06FA\u06FB\u06FC\u06FD\u06FE\u06FF]'
        ),
        (match) => '',
      );

      ayahText = ayahText.replaceAll(RegExp(r'\u06DD'), '');
      
      if (ayah.numberInSurah == 1 && ayah.surahNumber != 9) {
        ayahText = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ' + ayahText;
      }
      
      spans.add(
        TextSpan(
          text: "$cleanedText",
          style: TextStyle(
            fontFamily: 'UthmanicHafs',
            fontSize: ayahFontSize,
            height: 2.0,
            color: Colors.black,
          ),
        ),
      );

      // إضافة رقم الآية بدون أقواس
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: AyahNumberWidget(
            number: ayah.numberInSurah,
            fontSize: ayahFontSize * 0.8,
          ),
        ),
      );
print("API TEXT => ${ayah.text}");
      spans.add(const TextSpan(text: " "));
    }

    return spans;
  }

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

// عنصر رقم الآية بدون دائرة وبدون أقواس
class AyahNumberWidget extends StatelessWidget {
  final int number;
  final double fontSize;

  const AyahNumberWidget({super.key, required this.number, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        _toArabicNumber(number), // بدون أقواس
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