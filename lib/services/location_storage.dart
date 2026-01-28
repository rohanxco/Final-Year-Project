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

  /// Backwards-compatible alias (in case other files call it)
  static Future<LocationSelection?> getManualLocation() async {
    return loadManualLocation();
  }

  /// Used by Qibla/Prayer screens: returns saved manual location if it has coords.
  static Future<LocationSelection?> getSavedLocation() async {
    final loc = await loadManualLocation();
    if (loc == null) return null;
    if (loc.latitude == null || loc.longitude == null) return null;
    return loc;
  }
}
