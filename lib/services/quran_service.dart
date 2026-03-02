import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class QuranService {
  static Future<List<dynamic>> loadSurahs() async {
    final raw = await rootBundle.loadString('assets/quran/quran.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;

    final data = decoded['data'] as Map<String, dynamic>;
    final surahs = data['surahs'] as List<dynamic>;
    return surahs;
  }
}
