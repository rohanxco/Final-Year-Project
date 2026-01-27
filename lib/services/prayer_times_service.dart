// lib/services/prayer_times_service.dart
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

class PrayerTimesService {
  /// Returns today's prayer times as Map: {"Fajr": "05:12", ...}
  static Map<String, String> getTodayPrayerTimes({
    required double latitude,
    required double longitude,
    CalculationMethod method = CalculationMethod.muslim_world_league,
    Madhab madhab = Madhab.shafi,
  }) {
    final coords = Coordinates(latitude, longitude);
    final params = method.getParameters()..madhab = madhab;

    final pt = PrayerTimes.today(coords, params);

    final fmt = DateFormat('HH:mm');
    return <String, String>{
      'Fajr': fmt.format(pt.fajr),
      'Sunrise': fmt.format(pt.sunrise),
      'Dhuhr': fmt.format(pt.dhuhr),
      'Asr': fmt.format(pt.asr),
      'Maghrib': fmt.format(pt.maghrib),
      'Isha': fmt.format(pt.isha),
    };
  }

  /// Returns the next prayer name + time.
  static ({String name, DateTime time}) getNextPrayer({
    required double latitude,
    required double longitude,
    CalculationMethod method = CalculationMethod.muslim_world_league,
    Madhab madhab = Madhab.shafi,
  }) {
    final coords = Coordinates(latitude, longitude);
    final params = method.getParameters()..madhab = madhab;

    final pt = PrayerTimes.today(coords, params);

    final next = pt.nextPrayer();
    final time = _timeForPrayer(pt, next);

    return (name: _label(next), time: time);
  }

  static String getNextPrayerLabel({
    required double latitude,
    required double longitude,
    CalculationMethod method = CalculationMethod.muslim_world_league,
    Madhab madhab = Madhab.shafi,
  }) {
    final next = getNextPrayer(
      latitude: latitude,
      longitude: longitude,
      method: method,
      madhab: madhab,
    );

    final fmt = DateFormat('HH:mm');
    return '${next.name} • ${fmt.format(next.time)}';
  }

  static DateTime _timeForPrayer(PrayerTimes pt, Prayer p) {
    switch (p) {
      case Prayer.fajr:
        return pt.fajr;
      case Prayer.sunrise:
        return pt.sunrise;
      case Prayer.dhuhr:
        return pt.dhuhr;
      case Prayer.asr:
        return pt.asr;
      case Prayer.maghrib:
        return pt.maghrib;
      case Prayer.isha:
        return pt.isha;
      case Prayer.none:
        // If none, just return Isha as fallback (rare edge case)
        return pt.isha;
    }
  }

  static String _label(Prayer p) {
    switch (p) {
      case Prayer.fajr:
        return 'Fajr';
      case Prayer.sunrise:
        return 'Sunrise';
      case Prayer.dhuhr:
        return 'Dhuhr';
      case Prayer.asr:
        return 'Asr';
      case Prayer.maghrib:
        return 'Maghrib';
      case Prayer.isha:
        return 'Isha';
      case Prayer.none:
        return 'None';
    }
  }
}
