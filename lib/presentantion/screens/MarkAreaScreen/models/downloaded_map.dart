import 'package:latlong2/latlong.dart';

class DownloadedMap {
    final String id;  // Add ID field

  final String name;
  final LatLng northEast;
  final LatLng southWest;
  final String date;
  final int tiles;
  final double areaSqKm;
    final String displayName; // For UI display


  DownloadedMap({
        // String id,  // Optional since we'll generate if not provided

    required this.name,
    required this.northEast,
    required this.southWest,
    required this.date,
    required this.tiles,
    required this.areaSqKm,
        required this. id,
    String? displayName,
// 
  }) :   
    this.displayName = displayName ?? name;



  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'northEast': {'lat': northEast.latitude, 'lng': northEast.longitude},
    'southWest': {'lat': southWest.latitude, 'lng': southWest.longitude},
    'date': date,
    'tiles': tiles,
    'areaSqKm': areaSqKm,
  };

  factory DownloadedMap.fromJson(Map<String, dynamic> json) {
    return DownloadedMap(
            id: json['id'],
      name: json['name'],
      northEast: LatLng(json['northEast']['lat'], json['northEast']['lng']),
      southWest: LatLng(json['southWest']['lat'], json['southWest']['lng']),
      date: json['date'],
      tiles: json['tiles'],
      areaSqKm: json['areaSqKm'],
    );
  }
}