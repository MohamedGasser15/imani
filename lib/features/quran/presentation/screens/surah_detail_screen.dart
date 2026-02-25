import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Adjust imports according to your project structure
import 'package:imani/core/models/quran_models.dart';
import 'package:imani/core/providers/settings_provider.dart';
import 'package:imani/features/quran/providers/quran_provider.dart';

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;
  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  late Future<List<Ayah>> _ayahsFuture;

  // Color palette
  static const Color bgColor = Color(0xFFF5EBDD); // main background
  static const Color darkBeige = Color(0xFFE8D9C5); // header/footer background
  static const Color brownGold = Color(0xFF8B5E3C); // text and icons
  static const Color goldBorder = Color(0xFFB8860B); // ayah circle border

  @override
  void initState() {
    super.initState();
    final quranProvider = Provider.of<QuranProvider>(context, listen: false);
    _ayahsFuture = quranProvider.getAyahsForSurah(widget.surah.number);
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: bgColor,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: CustomScrollView(
          slivers: [
            // ----- Custom Header (SliverToBoxAdapter) -----
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 8),
                color: bgColor, // no separate app bar background
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left: Bookmark + "الجزء ٣٠"
                    Row(
                      children: [
                        Icon(Icons.bookmark_border, color: brownGold, size: 24),
                        const SizedBox(width: 4),
                        Text(
                          'الجزء ٣٠',
                          style: TextStyle(
                            fontFamily: 'UthmanicHafs',
                            fontSize: 18,
                            color: brownGold,
                          ),
                        ),
                      ],
                    ),
                    // Center: Grid icon
                    Icon(Icons.grid_view, color: brownGold, size: 24),
                    // Right: Back button with surah name
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: darkBeige,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back_ios, color: brownGold, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            widget.surah.name, // e.g., "الانشقاق"
                            style: TextStyle(
                              fontFamily: 'UthmanicHafs',
                              fontSize: 16,
                              color: brownGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ----- Surah Title with Ornaments -----
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: darkBeige,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Left ornament SVG
                    // SvgPicture.asset(
                    //   'assets/svgs/ornament_left.svg',
                    //   width: 40,
                    //   colorFilter: const ColorFilter.mode(goldBorder, BlendMode.srcIn),
                    // ),
                    // Surah name
                    Text(
                      'سورة ${widget.surah.name}',
                      style: const TextStyle(
                        fontFamily: 'UthmanicHafs',
                        fontSize: 28,
                        color: brownGold,
                      ),
                    ),
                    // Right ornament SVG
                    // SvgPicture.asset(
                    //   'assets/svgs/ornament_right.svg',
                    //   width: 40,
                    //   colorFilter: const ColorFilter.mode(goldBorder, BlendMode.srcIn),
                    // ),
                  ],
                ),
              ),
            ),

            // ----- Basmala (if not Surah Tawbah) -----
            if (widget.surah.number != 9)
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  child: const Text(
                    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'UthmanicHafs',
                      fontSize: 32,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

            // ----- Ayah List (SliverList) -----
            FutureBuilder<List<Ayah>>(
              future: _ayahsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(child: Text('خطأ: ${snapshot.error}')),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('لا توجد آيات')),
                  );
                }

                final ayahs = snapshot.data!;
                return SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    child: FutureBuilder<List<Ayah>>(
      future: _ayahsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final ayahs = snapshot.data!;

        return RichText(
          textAlign: TextAlign.justify,
          textDirection: TextDirection.rtl,
          text: TextSpan(
            children: _buildAyahSpans(
              ayahs,
              settings.quranFontSize,
            ),
          ),
        );
      },
    ),
  ),
);
              },
            ),

            // ----- Footer (Page & Hizb info) -----
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: darkBeige,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Page number (example ٥٨٩)
                    Text(
                      _toArabicNumber(589),
                      style: const TextStyle(
                        fontFamily: 'UthmanicHafs',
                        fontSize: 20,
                        color: brownGold,
                      ),
                    ),
                    // Hizb info with arrow
                    Row(
                      children: [
                        Text(
                          '٣/٤ الحزب ٥٩',
                          style: const TextStyle(
                            fontFamily: 'UthmanicHafs',
                            fontSize: 18,
                            color: brownGold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios, color: brownGold, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
List<InlineSpan> _buildAyahSpans(List<Ayah> ayahs, double fontSize) {
  List<InlineSpan> spans = [];

  for (var ayah in ayahs) {
    // 1. إزالة أيقونة رأس الآية (U+06DD)
    String withoutMarker = ayah.text.replaceAll(RegExp(r'\u06DD'), '');
    
    // 2. إزالة الأرقام العربية بكافة أشكالها
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

    spans.add(
      TextSpan(
        text: "$cleanedText ",
        style: TextStyle(
          fontFamily: 'UthmanicHafs',
          fontSize: fontSize,
          height: 2.0,
          color: Colors.black,
        ),
      ),
    );

    spans.add(
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: AyahNumberWidget(
          number: ayah.numberInSurah,
          fontSize: fontSize * 1.0, // كبرنا الرقم ليكون بنفس حجم الخط
        ),
      ),
    );

    spans.add(const TextSpan(text: " "));
  }

  return spans;
}

  /// Builds a single ayah with its number in an ornamental circle.
  Widget _buildAyahItem(Ayah ayah, double fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: RichText(
        textAlign: TextAlign.justify,
        textDirection: TextDirection.rtl,
        text: TextSpan(
          children: [
            // Ayah text
            TextSpan(
              text: '${ayah.text} ',
              style: TextStyle(
                fontFamily: 'UthmanicHafs',
                fontSize: fontSize,
                height: 2.0,
                color: Colors.black,
              ),
            ),
            // Ornamental ayah number
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: AyahNumberWidget(
                number: ayah.numberInSurah,
                fontSize: fontSize * 0.7,
              ),
            ),
            const TextSpan(text: ' '), // small gap
          ],
        ),
      ),
    );
  }

  /// Convert Western digits to Eastern Arabic numerals
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

/// Custom widget for the ayah number inside an ornamental gold circle.
class AyahNumberWidget extends StatelessWidget {
  final int number;
  final double fontSize;

  const AyahNumberWidget({super.key, required this.number, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fontSize * 2.2, // size relative to text
      height: fontSize * 2.2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ornamental frame (SVG)
          // SvgPicture.asset(
          //   'assets/svgs/ayah_number_frame.svg',
          //   width: fontSize * 2.2,
          //   height: fontSize * 2.2,
          //   colorFilter: const ColorFilter.mode(
          //     Color(0xFFB8860B), // gold border tint (if SVG uses strokes)
          //     BlendMode.srcIn,
          //   ),
          // ),
          // Number
          Text(
            _toArabicNumber(number),
            style: TextStyle(
              fontFamily: 'UthmanicHafs',
              fontSize: fontSize,
              color: const Color(0xFF8B5E3C), // brown
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
}