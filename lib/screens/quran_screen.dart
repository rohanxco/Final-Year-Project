import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'surah_detail_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _surahs = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final raw = await rootBundle.loadString('assets/quran/quran.json');
      final jsonMap = json.decode(raw) as Map<String, dynamic>;
      final data = jsonMap['data'] as Map<String, dynamic>;
      final surahs = (data['surahs'] as List).cast<Map>();

      setState(() {
        _surahs = surahs.map((e) => Map<String, dynamic>.from(e)).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Qur'an")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Qur'an")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Text("Failed to load Quran JSON:\n$_error"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Qur'an")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _surahs.length,
        // ignore: unnecessary_underscores
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final s = _surahs[index];
          final number = (s['number'] ?? '').toString();
          final englishName = (s['englishName'] ?? '').toString();
          final arabicName = (s['name'] ?? '').toString();
          final ayahCount = (s['ayahs'] is List)
              ? (s['ayahs'] as List).length
              : 0;

          return ListTile(
            title: Text("$number. $englishName"),
            subtitle: Text("$arabicName • Ayaat: $ayahCount"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Debug proof (optional)
              // ignore: avoid_print
              print("✅ TAP WORKS on $englishName");

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SurahDetailScreen(surah: s)),
              );
            },
          );
        },
      ),
    );
  }
}
