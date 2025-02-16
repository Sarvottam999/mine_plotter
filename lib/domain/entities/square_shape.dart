// import 'package:helloworld/core/enums/shape_type.dart';
// import 'package:helloworld/domain/entities/shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_dragmarker/src/drag_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/domain/entities/shape.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:myapp/presentantion/providers/coordinate_provider.dart';
import 'package:myapp/utils/indian_grid_converter.dart';
import 'package:provider/provider.dart';

class SquareShape extends Shape {
  SquareShape({required List<LatLng> points})
      : super(points: points, type: ShapeType.square);

  @override
  double calculateDistance() {
    if (points.length != 2) return 0;
    return const Distance().as(
      LengthUnit.Kilometer,
      points[0],
      points[1],
    );
  }

  List<LatLng> getSquarePoints() {
    if (points.length != 2) return [];

    final dx = points[1].longitude - points[0].longitude;
    final dy = points[1].latitude - points[0].latitude;

    return [
      points[0],
      LatLng(points[0].latitude, points[1].longitude),
      points[1],
      LatLng(points[1].latitude, points[0].longitude),
      points[0],
    ];
  }

  @override
  Map<String, dynamic> getDetails(BuildContext context) {
    if (points.isEmpty) return {'type': 'Square'};
        final provider = context.read<CoordinateProvider>();


    var details = {
      'type': 'Square',
      'start':
          '${points[0].latitude.toStringAsFixed(6)}, ${points[0].longitude.toStringAsFixed(6)}',
    };
    if (provider.showIndianGrid) {
      final startGridCoords = IndianGridConverter.latLongToGrid(
        provider.selectedZone,
        points[0].latitude,
        points[0].longitude,
      );
      
      if (startGridCoords != null) {
        details['start_grid'] = 'E: ${startGridCoords.easting.toStringAsFixed(3)} m, N: ${startGridCoords.northing.toStringAsFixed(3)} m';
      }
    }


    if (points.length > 1) {
      details['end'] =
          '${points[1].latitude.toStringAsFixed(6)}, ${points[1].longitude.toStringAsFixed(6)}';
           
              if (provider.showIndianGrid) {
        final endGridCoords = IndianGridConverter.latLongToGrid(
          provider.selectedZone,
          points[1].latitude,
          points[1].longitude,
        );
        
        if (endGridCoords != null) {
          details['end_grid'] = 'E: ${endGridCoords.easting.toStringAsFixed(3)} m, N: ${endGridCoords.northing.toStringAsFixed(3)} m';
        }
      }






      details['side_length'] = '${calculateDistance().toStringAsFixed(2)} km';
      details['area'] =
          '${(calculateDistance() * calculateDistance()).toStringAsFixed(2)} km²';
    } else if (points.length == 1) {
      var currentDistance = const Distance().as(
        LengthUnit.Kilometer,
        points[0],
        points.last,
      );
      details['current_side'] = '${currentDistance.toStringAsFixed(2)} km';
      details['current_area'] =
          '${(currentDistance * currentDistance).toStringAsFixed(2)} km²';
    }

    return details;
  }

  @override
List<Polyline> getPolylines() {
  return [
    Polyline(
      points: getSquarePoints(), // or points for line, getSquarePoints() for square, etc.
      strokeWidth: 2.0,
      color: Colors.blue,
    ),
  ];
}

  @override
  List<DragMarker> getPoints() {
    // TODO: implement getPoints
    throw UnimplementedError();
  }
}
