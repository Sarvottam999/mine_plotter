import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:myapp/core/enum/fishbone_type.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/domain/entities/circle_shape.dart';
import 'package:myapp/domain/entities/fishbone_shape.dart';
import 'package:myapp/domain/entities/line_shape.dart';
import 'package:myapp/domain/entities/square_shape.dart';

abstract class Shape {
  List<LatLng> points;
  ShapeType type;
  
  Shape({
    required this.points,
    required this.type,
  });

  double calculateDistance();
  Map<String, dynamic> getDetails(BuildContext context);
  List<Polyline> getPolylines();

  // **Convert Shape to JSON**
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(), // Convert enum to string
      'points': points.map((p) => {'lat': p.latitude, 'lng': p.longitude}).toList(),
    };
  }

  // **Convert JSON to Shape Object (Factory Constructor)**
  factory Shape.fromJson(Map<String, dynamic> json) {
    List<LatLng> points = (json['points'] as List)
        .map((p) => LatLng(p['lat'], p['lng']))
        .toList();

    ShapeType shapeType = ShapeType.values.firstWhere(
      (e) => e.toString() == json['type'],
      orElse: () => ShapeType.none,
    );

    switch (shapeType) {
      case ShapeType.line:
        return LineShape(points: points);
      case ShapeType.square:
        return SquareShape(points: points);
      case ShapeType.circle:
        return CircleShape(points: points);
      case ShapeType.fishbone:
        return FishboneShape(points: points, fishboneType: FishboneType.strip_anti_personal);
      default:
        throw Exception("Unknown shape type");
    }
  }
}
