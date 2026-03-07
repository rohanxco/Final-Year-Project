import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/mosque_service.dart';

class MosqueFinderScreen extends StatefulWidget {
  const MosqueFinderScreen({super.key});

  @override
  State<MosqueFinderScreen> createState() => _MosqueFinderScreenState();
}

class _MosqueFinderScreenState extends State<MosqueFinderScreen> {
  bool _loading = true;
  String? _error;
  List<MosquePlace> _mosques = [];
  Position? _position;

  @override
  void initState() {
    super.initState();
    _loadMosques();
  }

  Future<void> _loadMosques() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permission permanently denied. Enable it in settings.',
        );
      }

      final position = await Geolocator.getCurrentPosition();
      final mosques = await MosqueService.searchNearbyMosques(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (!mounted) return;

      setState(() {
        _position = position;
        _mosques = mosques;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    }
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  Future<void> _openInMaps(MosquePlace mosque) async {
    final fallback = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${mosque.latitude},${mosque.longitude}',
    );

    final uri = mosque.googleMapsUri != null
        ? Uri.parse(mosque.googleMapsUri!)
        : fallback;

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open maps.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mosque Finder')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_error!, textAlign: TextAlign.center),
              ),
            )
          : _mosques.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No nearby mosques found.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadMosques,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _mosques.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final mosque = _mosques[index];

                  double? distanceMeters;
                  if (_position != null) {
                    distanceMeters = Geolocator.distanceBetween(
                      _position!.latitude,
                      _position!.longitude,
                      mosque.latitude,
                      mosque.longitude,
                    );
                  }

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.mosque_outlined),
                      title: Text(mosque.name),
                      subtitle: Text(
                        distanceMeters != null
                            ? '${mosque.address}\n${_formatDistance(distanceMeters)} away'
                            : mosque.address,
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: const Icon(Icons.directions),
                        onPressed: () => _openInMaps(mosque),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
