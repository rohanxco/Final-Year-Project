// lib/screens/prayer_times_screen.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/location_service.dart';
import '../services/location_storage.dart';
import '../services/prayer_times_service.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  bool _loading = true;
  String? _error;

  String? _locationLabel;
  String? _nextPrayerLabel;
  Map<String, String> _times = const {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // 1) Try manual location first (if you saved one)
      final manual = await LocationStorage.loadManualLocation();

      double? lat = manual?.latitude;
      double? lon = manual?.longitude;

      if (manual != null) {
        _locationLabel = manual.displayName;
      }

      // 2) If manual has no coords, use GPS coords
      if (lat == null || lon == null) {
        final status = await LocationService.getStatus();
        if (status == LocationStatus.servicesOff) {
          throw Exception('Location services are off. Turn them on or set a manual location.');
        }
        if (status == LocationStatus.denied) {
          final req = await LocationService.requestPermission();
          if (req != LocationStatus.ready) {
            throw Exception('Location permission not granted.');
          }
        }
        if (status == LocationStatus.deniedForever) {
          throw Exception('Location permission is permanently denied. Enable it in system settings.');
        }

        final Position pos = await LocationService.getCurrentPosition();
        lat = pos.latitude;
        lon = pos.longitude;

        _locationLabel ??= 'Current Location';
      }

      final times = PrayerTimesService.getTodayPrayerTimes(
        latitude: lat,
        longitude: lon,
      );

      final nextLabel = PrayerTimesService.getNextPrayerLabel(
        latitude: lat,
        longitude: lon,
      );

      if (!mounted) return;
      setState(() {
        _times = times;
        _nextPrayerLabel = nextLabel;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Prayer Times"),
        actions: [
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _ErrorView(message: _error!, onRetry: _load)
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (_locationLabel != null)
                      Text(
                        _locationLabel!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    const SizedBox(height: 8),
                    if (_nextPrayerLabel != null)
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.schedule),
                          title: const Text('Next prayer'),
                          trailing: Text(_nextPrayerLabel!),
                        ),
                      ),
                    const SizedBox(height: 8),
                    ..._times.entries.map(
                      (e) => Card(
                        child: ListTile(
                          title: Text(e.key),
                          trailing: Text(e.value),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 44),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
