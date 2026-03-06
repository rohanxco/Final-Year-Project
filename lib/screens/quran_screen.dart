import 'package:flutter/material.dart';
import '../services/quran_service.dart';
import 'surah_detail_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  late Future<List<dynamic>> _surahsFuture;

  @override
  void initState() {
    super.initState();
    _surahsFuture = QuranService.loadSurahs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Qur'an")),
      body: FutureBuilder<List<dynamic>>(
        future: _surahsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "❌ Failed to load Qur'an JSON\n\n${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final surahs = snapshot.data ?? const [];

          return ListView.separated(
            itemCount: surahs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final s = (surahs[index] as Map).cast<String, dynamic>();

              final number = (s['number'] ?? '').toString();
              final englishName = (s['englishName'] ?? '').toString();
              final arabicName = (s['name'] ?? '').toString();

              final ayahs = (s['ayahs'] as List?) ?? const [];
              final ayahCount = ayahs.length;

              return ListTile(
                title: Text("$number. $englishName"),
                subtitle: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    "$arabicName  •  Ayaat: $ayahCount",
                    style: const TextStyle(fontFamily: 'AmiriQuran'),
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SurahDetailScreen(surah: s),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
