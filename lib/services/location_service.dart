// lib/services/location_service.dart
import 'package:geolocator/geolocator.dart';

enum LocationStatus { ready, servicesOff, denied, deniedForever }

class LocationService {
  static Future<LocationStatus> getStatus() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return LocationStatus.servicesOff;

    final perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) return LocationStatus.denied;
    if (perm == LocationPermission.deniedForever) return LocationStatus.deniedForever;

    return LocationStatus.ready;
  }

  static Future<LocationStatus> requestPermission() async {
    final perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.denied) return LocationStatus.denied;
    if (perm == LocationPermission.deniedForever) return LocationStatus.deniedForever;
    return LocationStatus.ready;
  }

  static Future<Position> getCurrentPosition() {
    // Newer geolocator versions prefer LocationSettings,
    // but this still works; you can upgrade later.
    // ignore: deprecated_member_use
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
