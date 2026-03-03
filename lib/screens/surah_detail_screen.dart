import 'package:flutter/material.dart';

class SurahDetailScreen extends StatefulWidget {
  final Map<String, dynamic> surah;
  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final ScrollController _controller = ScrollController();
  bool _showToTop = false;

  static const String _bismillah = 'بِسْمِ ٱللَّٰهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final shouldShow = _controller.offset > 450;
      if (shouldShow != _showToTop) {
        setState(() => _showToTop = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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

  bool _isBismillahExact(String text) {
    // normalize spaces
    final a = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    final b = _bismillah.replaceAll(RegExp(r'\s+'), ' ').trim();
    return a == b;
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.surah;
    final number = (s['number'] ?? '').toString();
    final englishName = (s['englishName'] ?? '').toString();
    final arabicName = (s['name'] ?? '').toString();

    final ayahs = (s['ayahs'] as List?)?.cast<Map>() ?? const [];
    final surahNumber = int.tryParse(number) ?? 0;

    // ✅ Bismillah header logic (except Surah 9)
    final showBismillahHeader = surahNumber != 9;

    // Many datasets include Bismillah as ayah[0] for most surahs.
    // For production feel:
    // - For surahs other than 1, if ayah1 == Bismillah, we show header and SKIP that ayah from list.
    // - For Al-Fatiha (1), we DO NOT skip because it’s commonly treated as ayah 1 in many prints.
    int startIndex = 0;
    if (showBismillahHeader && surahNumber != 1 && ayahs.isNotEmpty) {
      final firstText = (ayahs.first['text'] ?? '').toString();
      if (_isBismillahExact(firstText)) startIndex = 1;
    }

    return Scaffold(
      appBar: AppBar(title: Text("$number. $englishName")),
      floatingActionButton: _showToTop
          ? FloatingActionButton(
              onPressed: () {
                _controller.animateTo(
                  0,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOut,
                );
              },
              child: const Icon(Icons.keyboard_arrow_up),
            )
          : null,
      body: ListView(
        controller: _controller,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          if (arabicName.isNotEmpty)
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                arabicName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  height: 1.6,
                ),
              ),
            ),
          const SizedBox(height: 10),

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
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withOpacity(0.6),
                ),
                child: Text(
                  _bismillah,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    height: 1.9,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 14),

          for (int i = startIndex; i < ayahs.length; i++) ...[
            _AyahRow(
              ayahNumber: i + 1, // keep original ayah number index-based
              arabicIndic: _toArabicIndic(i + 1),
              text: (ayahs[i]['text'] ?? '').toString(),
            ),
            const Divider(height: 18),
          ],
        ],
      ),
    );
  }
}

class _AyahRow extends StatelessWidget {
  final int ayahNumber;
  final String arabicIndic;
  final String text;

  const _AyahRow({
    required this.ayahNumber,
    required this.arabicIndic,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) return const SizedBox.shrink();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Ayah number circle badge
          Container(
            width: 34,
            height: 34,
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.35),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              arabicIndic,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          // ✅ Better Arabic spacing
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 22,
                height: 2.05,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
