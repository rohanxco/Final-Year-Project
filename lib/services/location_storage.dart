// lib/services/location_storage.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_selection.dart';

class LocationStorage {
  static const _kManualLocation = 'manual_location';

  static Future<void> saveManualLocation(LocationSelection loc) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kManualLocation, jsonEncode(loc.toJson()));
  }

  static Future<LocationSelection?> loadManualLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kManualLocation);
    if (raw == null || raw.trim().isEmpty) return null;

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return LocationSelection.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearManualLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kManualLocation);
  }
}
