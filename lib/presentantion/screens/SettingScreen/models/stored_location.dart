class StoredLocation {
  final int? id;
  final String name;
  final double? latitude;
  final double? longitude;
  final String? zone;
  final double? easting;
  final double? northing;
  final bool isWGS84;

  StoredLocation({
    this.id,
    required this.name,
    this.latitude,
    this.longitude,
    this.zone,
    this.easting,
    this.northing,
    required this.isWGS84,
  });

  StoredLocation copyWith({
    int? id,
    String? name,
    double? latitude,
    double? longitude,
    String? zone,
    double? easting,
    double? northing,
    bool? isWGS84,
  }) {
    return StoredLocation(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      zone: zone ?? this.zone,
      easting: easting ?? this.easting,
      northing: northing ?? this.northing,
      isWGS84: isWGS84 ?? this.isWGS84,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'zone': zone,
      'easting': easting,
      'northing': northing,
      'isWGS84': isWGS84 ? 1 : 0,
    };
  }

  factory StoredLocation.fromMap(Map<String, dynamic> map) {
    return StoredLocation(
      id: map['id'],
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      zone: map['zone'],
      easting: map['easting'],
      northing: map['northing'],
      isWGS84: map['isWGS84'] == 1,
    );
  }
}