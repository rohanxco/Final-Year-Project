import 'dart:math';

class QiblaService {
  // Kaaba coordinates
  static const double _kaabaLat = 21.422487;
  static const double _kaabaLon = 39.826206;

  /// Returns bearing in degrees from North (0..360)
  static double bearingToKaaba({
    required double latitude,
    required double longitude,
  }) {
    final lat1 = _degToRad(latitude);
    final lon1 = _degToRad(longitude);
    final lat2 = _degToRad(_kaabaLat);
    final lon2 = _degToRad(_kaabaLon);

    final dLon = lon2 - lon1;

    final y = sin(dLon) * cos(lat2);
    final x =
        cos(lat1) * sin(lat2) -
        sin(lat1) * cos(lat2) * cos(dLon);

    var brng = atan2(y, x);
    brng = _radToDeg(brng);

    // normalize 0..360
    brng = (brng + 360) % 360;

    return brng;
  }

  static double _degToRad(double d) => d * (pi / 180.0);
  static double _radToDeg(double r) => r * (180.0 / pi);
}
