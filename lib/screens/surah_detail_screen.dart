import 'package:flutter/material.dart';

class SurahDetailScreen extends StatefulWidget {
  final Map<String, dynamic> surah;

  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  static final RegExp _bismillahPrefix = RegExp(
    r'^\s*بِسْمِ\s+ٱللَّهِ\s+ٱلرَّحْمَٰنِ\s+ٱلرَّحِيمِ\s*',
  );

  static const String _bismillahHeader =
      'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ';

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

  String _stripLeadingBismillahIfNeeded({
    required int surahNumber,
    required int ayahIndex,
    required String text,
  }) {
    final shouldStrip =
        (surahNumber != 1 && surahNumber != 9 && ayahIndex == 0);

    if (!shouldStrip) return text;

    final stripped = text.replaceFirst(_bismillahPrefix, '').trim();
    return stripped.isEmpty ? text : stripped;
  }

  String _cleanQuranText(String text) {
    return text.replaceAll(RegExp(r'[\u06D6-\u06ED۝؞﴿﴾]'), '').trim();
  }

  bool _isSajdahAyah(dynamic sajdaValue) {
    if (sajdaValue == null || sajdaValue == false) return false;
    if (sajdaValue == true) return true;

    if (sajdaValue is Map) {
      return sajdaValue['recommended'] == true ||
          sajdaValue['obligatory'] == true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.surah;

    final surahNumber = int.tryParse((s['number'] ?? '').toString()) ?? 0;
    final englishName = (s['englishName'] ?? '').toString();
    final arabicName = (s['name'] ?? '').toString();

    final ayahs = (s['ayahs'] as List?)?.cast<Map>() ?? const [];

    final showBismillahHeader = surahNumber != 1 && surahNumber != 9;

    return Scaffold(
      appBar: AppBar(title: Text("$surahNumber. $englishName")),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          if (arabicName.isNotEmpty)
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                arabicName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'UthmanicHafs',
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  height: 1.6,
                ),
              ),
            ),
          const SizedBox(height: 12),
          if (showBismillahHeader)
            Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: const Text(
                  _bismillahHeader,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'UthmanicHafs',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.8,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 14),
          for (int i = 0; i < ayahs.length; i++) ...[
            _AyahRow(
              ayahNumber: _toArabicIndic(
                int.tryParse(
                      (ayahs[i]['numberInSurah'] ?? (i + 1)).toString(),
                    ) ??
                    (i + 1),
              ),
              arabicText: _cleanQuranText(
                _stripLeadingBismillahIfNeeded(
                  surahNumber: surahNumber,
                  ayahIndex: i,
                  text: (ayahs[i]['text'] ?? '').toString(),
                ),
              ),
              isSajdah: _isSajdahAyah(ayahs[i]['sajda']),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _AyahRow extends StatelessWidget {
  final String arabicText;
  final String ayahNumber;
  final bool isSajdah;

  const _AyahRow({
    required this.arabicText,
    required this.ayahNumber,
    required this.isSajdah,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: arabicText,
                    style: const TextStyle(
                      fontFamily: 'UthmanicHafs',
                      fontSize: 22,
                      height: 3.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '  ﴿$ayahNumber﴾',
                        style: const TextStyle(
                          fontFamily: 'UthmanicHafs',
                          fontSize: 22,
                          height: 2.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),

                      if (isSajdah)
                        const TextSpan(
                          text: ' ۩ ',
                          style: TextStyle(
                            fontFamily: 'UthmanicHafs',
                            fontSize: 22,
                          ),
                        ),

                      if (isSajdah)
                        const TextSpan(
                          text: '{SIJDAH AYAH}',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 16,
                            color: Color.fromARGB(255, 2, 72, 40),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Divider(
          height: 1,
          thickness: 1,
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.20),
        ),
      ],
    );
  }
}
