import 'package:flutter/material.dart';

class SurahDetailScreen extends StatelessWidget {
  final Map<String, dynamic> surah;
  const SurahDetailScreen({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    final englishName = (surah['englishName'] ?? 'Unknown').toString();
    final number = (surah['number'] ?? '').toString();

    final ayahsRaw = surah['ayahs'];
    final ayahs = (ayahsRaw is List) ? ayahsRaw : const [];

    return Scaffold(
      appBar: AppBar(title: Text("$number. $englishName")),
      body: ayahs.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "No ayahs found.\nayahs type: ${ayahsRaw.runtimeType}\nkeys: ${surah.keys.toList()}",
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: ayahs.length,
              separatorBuilder: (_, __) => const Divider(height: 16),
              itemBuilder: (context, index) {
                final a = (ayahs[index] is Map)
                    ? Map<String, dynamic>.from(ayahs[index] as Map)
                    : <String, dynamic>{};

                final text = (a['text'] ?? '').toString();
                final numInSurah = (a['numberInSurah'] ?? (index + 1))
                    .toString();

                return Text("$numInSurah) $text");
              },
            ),
    );
  }
}
