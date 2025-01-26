import 'package:latlong2/latlong.dart';

class DownloadedMap {
  final String name;
  final LatLng northEast;
  final LatLng southWest;
  final String date;
  final int tiles;
  final double areaSqKm;

  DownloadedMap({
    required this.name,
    required this.northEast,
    required this.southWest,
    required this.date,
    required this.tiles,
    required this.areaSqKm,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'northEast': {'lat': northEast.latitude, 'lng': northEast.longitude},
    'southWest': {'lat': southWest.latitude, 'lng': southWest.longitude},
    'date': date,
    'tiles': tiles,
    'areaSqKm': areaSqKm,
  };

  factory DownloadedMap.fromJson(Map<String, dynamic> json) {
    return DownloadedMap(
      name: json['name'],
      northEast: LatLng(json['northEast']['lat'], json['northEast']['lng']),
      southWest: LatLng(json['southWest']['lat'], json['southWest']['lng']),
      date: json['date'],
      tiles: json['tiles'],
      areaSqKm: json['areaSqKm'],
    );
  }
}