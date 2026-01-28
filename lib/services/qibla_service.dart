// lib/services/qibla_service.dart
import 'dart:math';

class QiblaService {
  // Kaaba coordinates (Masjid al-Haram)
  static const double kaabaLat = 21.4225;
  static const double kaabaLon = 39.8262;

  /// Returns Qibla bearing in degrees clockwise from TRUE North (0..360)
  static double bearingFrom(double lat, double lon) {
    final phi1 = _degToRad(lat);
    final phi2 = _degToRad(kaabaLat);
    final deltaLambda = _degToRad(kaabaLon - lon);

    final y = sin(deltaLambda) * cos(phi2);
    final x = cos(phi1) * sin(phi2) - sin(phi1) * cos(phi2) * cos(deltaLambda);

    final theta = atan2(y, x); // radians
    final bearing = (_radToDeg(theta) + 360) % 360;
    return bearing;
  }

  static double _degToRad(double deg) => deg * pi / 180.0;
  static double _radToDeg(double rad) => rad * 180.0 / pi;
}
