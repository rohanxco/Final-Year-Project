import 'dart:convert';
import 'package:http/http.dart' as http;

class MosquePlace {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? googleMapsUri;

  MosquePlace({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.googleMapsUri,
  });

  factory MosquePlace.fromJson(Map<String, dynamic> json) {
    final displayName = (json['displayName'] as Map?) ?? const {};
    final location = (json['location'] as Map?) ?? const {};

    return MosquePlace(
      name: (displayName['text'] ?? 'Unknown Mosque').toString(),
      address: (json['formattedAddress'] ?? 'No address').toString(),
      latitude: ((location['latitude'] ?? 0) as num).toDouble(),
      longitude: ((location['longitude'] ?? 0) as num).toDouble(),
      googleMapsUri: json['googleMapsUri']?.toString(),
    );
  }
}

class MosqueService {
  static const String _apiKey = String.fromEnvironment('GOOGLE_PLACES_API_KEY');

  static Future<List<MosquePlace>> searchNearbyMosques({
    required double latitude,
    required double longitude,
    double radiusMeters = 5000,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'Google Places API key missing. Run Flutter with --dart-define=GOOGLE_PLACES_API_KEY=YOUR_KEY',
      );
    }

    final uri = Uri.parse(
      'https://places.googleapis.com/v1/places:searchNearby',
    );

    final body = {
      'includedTypes': ['mosque'],
      'maxResultCount': 20,
      'locationRestriction': {
        'circle': {
          'center': {'latitude': latitude, 'longitude': longitude},
          'radius': radiusMeters,
        },
      },
    };

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': _apiKey,
        'X-Goog-FieldMask':
            'places.displayName,places.formattedAddress,places.location,places.googleMapsUri',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Places API failed (${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final places = (data['places'] as List?) ?? const [];

    return places
        .map((e) => MosquePlace.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
