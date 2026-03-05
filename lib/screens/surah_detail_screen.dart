import 'dart:math' as math;
import 'package:flutter/material.dart';

class SurahDetailScreen extends StatefulWidget {
  final Map<String, dynamic> surah;
  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  static const String _bismillah = 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ';

  // Prefix matcher for your dataset:
  static final RegExp _bismillahPrefix = RegExp(
    r'^\s*بِسْمِ\s+ٱللَّهِ\s+ٱلرَّحْمَٰنِ\s+ٱلرَّحِيمِ\s*',
  );

  final PageController _pageController = PageController();
  int _pageIndex = 0;

  // Pagination cache
  List<List<_AyahPiece>> _pages = [];
  double _lastWidth = -1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _toArabicIndic(int n) {
    const map = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    final s = n.toString();
    final buf = StringBuffer();
    for (final ch in s.split('')) {
      final d = int.tryParse(ch);
      buf.write(d == null ? ch : map[d]);
    }
    return buf.toString();
  }

  bool _hasSajda(dynamic a) {
    // Supports different JSON shapes:
    // - "sajda": true
    // - "sajda": {"recommended": true} or {"obligatory": true}
    final v = (a is Map) ? a['sajda'] : null;
    if (v is bool) return v;
    if (v is Map) {
      final rec = v['recommended'];
      final obl = v['obligatory'];
      return (rec == true) || (obl == true);
    }
    return false;
  }

  String _stripLeadingBismillahIfNeeded({
    required int surahNumber,
    required int ayahIndex,
    required String text,
  }) {
    // Your rule:
    // - Surah 1: NO header, keep ayah1 bismillah intact
    // - Surah 9: NO header, no stripping
    // - Others: YES header, strip bismillah from ayah 1 only
    final shouldStrip =
        (surahNumber != 1 && surahNumber != 9 && ayahIndex == 0);
    if (!shouldStrip) return text;

    final stripped = text.replaceFirst(_bismillahPrefix, '').trim();
    return stripped.isEmpty ? text : stripped;
  }

  List<_AyahPiece> _buildAyahPieces({
    required int surahNumber,
    required List<Map> ayahs,
  }) {
    final pieces = <_AyahPiece>[];
    for (int i = 0; i < ayahs.length; i++) {
      final a = Map<String, dynamic>.from(ayahs[i]);
      final raw = (a['text'] ?? '').toString();

      final display = _stripLeadingBismillahIfNeeded(
        surahNumber: surahNumber,
        ayahIndex: i,
        text: raw,
      );

      final numInSurah =
          int.tryParse((a['numberInSurah'] ?? (i + 1)).toString()) ?? (i + 1);

      pieces.add(
        _AyahPiece(
          text: display,
          ayahNumberInSurah: numInSurah,
          hasSajda: _hasSajda(a),
        ),
      );
    }
    return pieces;
  }

  /// Paginate into pages of EXACTLY up to 20 lines using TextPainter measurement.
  List<List<_AyahPiece>> _paginate20Lines({
    required List<_AyahPiece> pieces,
    required double maxWidth,
    required TextStyle textStyle,
    required int maxLinesPerPage,
  }) {
    final pages = <List<_AyahPiece>>[];

    final current = <_AyahPiece>[];
    final spans = <InlineSpan>[];

    bool fitsWith(List<InlineSpan> trySpans) {
      final tp = TextPainter(
        text: TextSpan(children: trySpans),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center, // Mushaf feel
        maxLines: maxLinesPerPage,
        ellipsis: null,
      )..layout(maxWidth: maxWidth);

      // if text exceeds maxLines, painter will overflow vertically.
      return !tp.didExceedMaxLines;
    }

    void commitPage() {
      if (current.isNotEmpty) {
        pages.add(List<_AyahPiece>.from(current));
        current.clear();
        spans.clear();
      }
    }

    for (final p in pieces) {
      // Build the ayah as rich span:
      final ayahSpan = _ayahInlineSpan(
        p,
        textStyle: textStyle,
        numberText: _toArabicIndic(p.ayahNumberInSurah),
      );

      final trySpans = <InlineSpan>[
        ...spans,
        ayahSpan,
        const TextSpan(text: '  '),
      ];

      if (spans.isEmpty) {
        spans.add(ayahSpan);
        spans.add(const TextSpan(text: '  '));
        current.add(p);
        continue;
      }

      if (fitsWith(trySpans)) {
        spans.add(ayahSpan);
        spans.add(const TextSpan(text: '  '));
        current.add(p);
      } else {
        // Start new page
        commitPage();

        spans.add(ayahSpan);
        spans.add(const TextSpan(text: '  '));
        current.add(p);
      }
    }

    commitPage();
    return pages;
  }

  InlineSpan _ayahInlineSpan(
    _AyahPiece p, {
    required TextStyle textStyle,
    required String numberText,
  }) {
    // Mushaf-like: ayah text + sajda marker + medallion number.
    return TextSpan(
      children: [
        TextSpan(text: p.text, style: textStyle),
        if (p.hasSajda)
          TextSpan(
            text: ' ۩ ',
            style: textStyle.copyWith(fontSize: textStyle.fontSize! * 0.9),
          )
        else
          const TextSpan(text: '  '),

        // Medallion as a widget span
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.surah;
    final surahNumber = int.tryParse((s['number'] ?? '').toString()) ?? 0;

    final englishName = (s['englishName'] ?? '').toString();
    final arabicName = (s['name'] ?? '').toString();

    final ayahs = (s['ayahs'] as List?)?.cast<Map>() ?? const [];

    // Header rules:
    // - Surah 1: NO header
    // - Surah 9: NO header
    // - All others: YES header
    final showBismillahHeader = surahNumber != 1 && surahNumber != 9;

    // Main mushaf style (you already registered AmiriQuran in FontManifest)
    final mushafStyle = const TextStyle(
      fontFamily: 'AmiriQuran',
      fontSize: 26,
      height: 2.15, // very important for correct shaping / mushaf spacing
      fontWeight: FontWeight.w400,
    );

    final pieces = _buildAyahPieces(surahNumber: surahNumber, ayahs: ayahs);

    return Scaffold(
      appBar: AppBar(
        title: Text('$surahNumber. $englishName'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Inner area width (inside frame padding)
          final pageWidth = math.min(constraints.maxWidth, 900.0);
          final innerWidth = pageWidth - 120; // matches padding below

          // Build pages only when width changes (web resize safe)
          if (_lastWidth != innerWidth) {
            _lastWidth = innerWidth;
            _pages = _paginate20Lines(
              pieces: pieces,
              maxWidth: innerWidth,
              textStyle: mushafStyle,
              maxLinesPerPage: 20,
            );
            _pageIndex = 0;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_pageController.hasClients) {
                _pageController.jumpToPage(0);
              }
              if (mounted) setState(() {});
            });
          }

          return Center(
            child: SizedBox(
              width: pageWidth,
              child: Stack(
                children: [
                  // Mushaf frame background
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/mushaf_frame.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  // Content inside the frame
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(60, 70, 60, 70),
                      child: Column(
                        children: [
                          // Surah title ornament
                          _SurahHeader(
                            arabicName: arabicName,
                            showBismillahHeader: showBismillahHeader,
                            bismillah: _bismillah,
                          ),

                          const SizedBox(height: 14),

                          // Pages
                          Expanded(
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: _pages.isEmpty ? 1 : _pages.length,
                                onPageChanged: (i) =>
                                    setState(() => _pageIndex = i),
                                itemBuilder: (context, i) {
                                  if (_pages.isEmpty) {
                                    return const Center(
                                      child: Text('No ayahs found.'),
                                    );
                                  }

                                  // Render the page as a single RichText so it behaves like Mushaf lines.
                                  final pagePieces = _pages[i];
                                  final spans = <InlineSpan>[];
                                  for (final p in pagePieces) {
                                    spans.add(
                                      _ayahInlineSpan(
                                        p,
                                        textStyle: mushafStyle,
                                        numberText: _toArabicIndic(
                                          p.ayahNumberInSurah,
                                        ),
                                      ),
                                    );
                                    spans.add(const TextSpan(text: '  '));
                                  }

                                  return SingleChildScrollView(
                                    // Allow a tiny scroll if needed, but ideally pagination fits.
                                    physics: const BouncingScrollPhysics(),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      text: TextSpan(
                                        style: mushafStyle,
                                        children: spans,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Page number
                          Text(
                            'صفحة ${_toArabicIndic(_pageIndex + 1)} / ${_toArabicIndic(math.max(_pages.length, 1))}',
                            style: const TextStyle(
                              fontFamily: 'AmiriQuran',
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SurahHeader extends StatelessWidget {
  final String arabicName;
  final bool showBismillahHeader;
  final String bismillah;

  const _SurahHeader({
    required this.arabicName,
    required this.showBismillahHeader,
    required this.bismillah,
  });

  @override
  Widget build(BuildContext context) {
    final ornamentExists = true; // set false if you don’t add the asset

    return Column(
      children: [
        if (ornamentExists)
          SizedBox(
            height: 42,
            child: Image.asset(
              'assets/images/surah_ornament.png',
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) {
                // If ornament not found, fallback to text title.
                return const SizedBox.shrink();
              },
            ),
          ),

        Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            arabicName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'AmiriQuran',
              fontSize: 30,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        if (showBismillahHeader) ...[
          const SizedBox(height: 10),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              bismillah,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'AmiriQuran',
                fontSize: 24,
                height: 2.1,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ignore: unused_element
class _AyahMedallion extends StatelessWidget {
  final String numberText;
  const _AyahMedallion({required this.numberText});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MedallionPainter(
        // ignore: deprecated_member_use
        stroke: Theme.of(context).colorScheme.outline.withOpacity(0.45),
        // ignore: deprecated_member_use
        fill: Theme.of(context).colorScheme.surface.withOpacity(0.75),
      ),
      child: SizedBox(
        width: 34,
        height: 34,
        child: Center(
          child: Text(
            numberText,
            style: const TextStyle(
              fontFamily: 'AmiriQuran',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

class _MedallionPainter extends CustomPainter {
  final Color stroke;
  final Color fill;
  _MedallionPainter({required this.stroke, required this.fill});

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.shortestSide / 2;

    final fillPaint = Paint()..color = fill;
    final strokePaint = Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    // Outer circle
    canvas.drawCircle(Offset(r, r), r - 1, fillPaint);
    canvas.drawCircle(Offset(r, r), r - 1, strokePaint);

    // Inner decorative ring
    canvas.drawCircle(Offset(r, r), r - 6, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _MedallionPainter oldDelegate) =>
      oldDelegate.stroke != stroke || oldDelegate.fill != fill;
}

class _AyahPiece {
  final String text;
  final int ayahNumberInSurah;
  final bool hasSajda;

  _AyahPiece({
    required this.text,
    required this.ayahNumberInSurah,
    required this.hasSajda,
  });
}
