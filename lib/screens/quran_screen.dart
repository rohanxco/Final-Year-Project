import 'package:flutter/material.dart';
import '../services/quran_service.dart';

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

          final surahs = snapshot.data ?? [];
          if (surahs.isEmpty) {
            return const Center(child: Text("⚠️ Loaded, but surahs list is empty."));
          }

          return ListView.separated(
            itemCount: surahs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final s = surahs[index] as Map<String, dynamic>;
              final number = (s['number'] ?? '').toString();
              final englishName = (s['englishName'] ?? 'Unknown').toString();
              final translation = (s['englishNameTranslation'] ?? '').toString();
              final ayahs = (s['ayahs'] as List?)?.length ?? 0;

              return ListTile(
                title: Text("$number. $englishName"),
                subtitle: Text(translation),
                trailing: Text("$ayahs"),
              );
            },
          );
        },
      ),
    );
  }
}
