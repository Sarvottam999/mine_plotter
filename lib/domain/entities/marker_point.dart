// lib/domain/entities/marker_point.dart
import 'package:latlong2/latlong.dart';

class MarkerPoint {
  final LatLng position;
  final String name;
  final String details;

  MarkerPoint({
    required this.position,
    required this.name,
    String? details,
  }) : details = details ?? 'Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}';
}