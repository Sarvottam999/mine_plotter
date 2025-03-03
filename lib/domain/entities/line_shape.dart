// import 'package:helloworld/core/enums/shape_type.dart';
// import 'package:helloworld/domain/entities/shape.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/domain/entities/shape.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:myapp/presentantion/providers/coordinate_provider.dart';
import 'package:myapp/utils/indian_grid_converter.dart';
import 'package:myapp/utils/util.dart';
import 'package:provider/provider.dart';

class LineShape extends Shape {
  LineShape({required List<LatLng> points})
      : super(points: points, type: ShapeType.line);

  @override
  double calculateDistance() {
    if (points.length != 2) return 0;
    return const Distance().as(
      LengthUnit.Kilometer,
      points[0],
      points[1],
    );
  }

 

  // @override
  // Map<String, dynamic> getDetails(BuildContext context) {

  //   if (points.isEmpty) return {'type': 'Line'};
    
  //       final provider = context.read<CoordinateProvider>();

  //   var details = {
  //     'type': 'Line',
          
  //   };
  //     details['start_wgs84'] = '${points[0].latitude.toStringAsFixed(6)}, ${points[0].longitude.toStringAsFixed(6)}';

    
  //  if (provider.showIndianGrid) {
  //     final startGridCoords = IndianGridConverter.latLongToGrid(
  //       provider.selectedZone,
  //       points[0].latitude,
  //       points[0].longitude,
  //     );
      
  //     if (startGridCoords != null) {
  //       details['start_grid'] = 'E: ${startGridCoords.easting.toStringAsFixed(3)}m, N: ${startGridCoords.northing.toStringAsFixed(3)}m';
  //     }
  //   }

  //   if (points.length > 1) {
  //     details['end'] =
  //         '${points[1].latitude.toStringAsFixed(6)}, ${points[1].longitude.toStringAsFixed(6)}';
  //          // Add Zone IIB coordinates for end point
  //         if (provider.showIndianGrid) {
  //       final endGridCoords = IndianGridConverter.latLongToGrid(
  //         provider.selectedZone,
  //         points[1].latitude,
  //         points[1].longitude,
  //       );
        
  //       if (endGridCoords != null) {
  //         details['end_grid'] = 'E: ${endGridCoords.easting.toStringAsFixed(3)} m, N: ${endGridCoords.northing.toStringAsFixed(3)} m';
  //       }
  //     }

  //     details['distance'] = '${calculateDistanceInMeters(points[0], points[1]).toStringAsFixed(2)} m (${calculateDistance().toStringAsFixed(2)} km)';
  //   } else if (points.length == 1) {
  //     details['current_length'] = '${const Distance().as(
  //           LengthUnit.Kilometer,
  //           points[0],
  //           points.last,
  //         ).toStringAsFixed(2)} km';
  //   }

  //   return details;
  // }

    @override
  Map<String, dynamic> getDetails(BuildContext context) {
    if (points.isEmpty) return {'type': 'Line'};
    
    final provider = context.read<CoordinateProvider>();

    var details = {
      'type': 'Line',
    };

    details['start_wgs84'] =
        '${points[0].latitude.toStringAsFixed(6)}, ${points[0].longitude.toStringAsFixed(6)}';

    if (provider.showIndianGrid) {
      final startGridCoords = IndianGridConverter.latLongToGrid(
        provider.selectedZone,
        points[0].latitude,
        points[0].longitude,
      );

      if (startGridCoords != null) {
        details['start_grid'] =
            'E: ${startGridCoords.easting.toStringAsFixed(3)}m, N: ${startGridCoords.northing.toStringAsFixed(3)}m';
      }
    }

    if (points.length > 1) {
      LatLng end_point = points[points.length -1];
      details['end'] =
          '${end_point.latitude.toStringAsFixed(6)}, ${end_point.longitude.toStringAsFixed(6)}';

      if (provider.showIndianGrid) {
        final endGridCoords = IndianGridConverter.latLongToGrid(
          provider.selectedZone,
          end_point.latitude,
          end_point.longitude,
        );

        if (endGridCoords != null) {
          details['end_grid'] =
              'E: ${endGridCoords.easting.toStringAsFixed(3)} m, N: ${endGridCoords.northing.toStringAsFixed(3)} m';
        }
      }

      details['distance'] =
          '${calculateDistanceInMeters(points[0], end_point).toStringAsFixed(2)} m (${calculateDistance().toStringAsFixed(2)} km)';

      // Calculate bearing
      final bearing = const Distance().bearing(points[0], end_point);
      details['bearing'] = '${bearing.toStringAsFixed(2)}°';
    }

    return details;
  }


  @override
List<Polyline> getPolylines() {
  return [
    Polyline(
      points: points, // or points for line, getSquarePoints() for square, etc.
      strokeWidth: 2.0,
      // color: Colors.blue,
    ),
  ];
}
 

}
