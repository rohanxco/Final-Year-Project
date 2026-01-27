// lib/models/location_selection.dart
class LocationSelection {
  final String city;
  final String? country;
  final double? latitude;
  final double? longitude;

  const LocationSelection({
    required this.city,
    this.country,
    this.latitude,
    this.longitude,
  });

  bool get hasCoords => latitude != null && longitude != null;

  String get displayName {
    final c = (country == null || country!.trim().isEmpty) ? '' : ', ${country!.trim()}';
    return '${city.trim()}$c';
  }

  Map<String, dynamic> toJson() => {
        'city': city,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
      };

  static LocationSelection fromJson(Map<String, dynamic> json) => LocationSelection(
        city: (json['city'] ?? '').toString(),
        country: json['country']?.toString(),
        latitude: (json['latitude'] is num) ? (json['latitude'] as num).toDouble() : null,
        longitude: (json['longitude'] is num) ? (json['longitude'] as num).toDouble() : null,
      );
}
