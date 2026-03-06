import 'dart:convert';
import 'package:flutter/services.dart';

class QuranService {
  static Future<List<dynamic>> loadSurahs() async {
    final jsonStr = await rootBundle.loadString('assets/quran/quran.json');
    final data = json.decode(jsonStr);

    final surahs = data['data']?['surahs'];
    if (surahs is List) return surahs;

    throw Exception("Invalid Quran JSON structure: data.surahs not found");
  }
}
