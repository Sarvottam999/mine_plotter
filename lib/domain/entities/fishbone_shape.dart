// lib/domain/entities/fishbone_shape.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map_dragmarker/src/drag_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:myapp/core/enum/fishbone_type.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/presentantion/providers/coordinate_provider.dart';
import 'package:myapp/utils/indian_grid_converter.dart';
import 'package:myapp/utils/util.dart';
import 'package:provider/provider.dart';
import './shape.dart';

class FishboneConfiguration {
  final double verticalLineLength;
  final double lineSpacing;
  final double startFromMeters;  // Start drawing verticals after these meters
  final double endBeforeMeters;  // Stop drawing verticals at these meters
  final Color mainLineColor;
  final Color verticalLineColor;
  final double mainLineWidth;
  final double verticalLineWidth;
    final bool hideLeftVerticals;    // New parameter
  final bool hideRightVerticals;   // New parameter


  const FishboneConfiguration({
    required this.verticalLineLength,
    required this.lineSpacing,
    required this.startFromMeters,
    required this.endBeforeMeters,
    this.mainLineColor = Colors.blue,
    this.verticalLineColor = Colors.red,
    this.mainLineWidth = 4.0,
    this.verticalLineWidth = 3.0,
        this.hideLeftVerticals = false,  // Default show all
    this.hideRightVerticals = false, // Default show all

  });

  static FishboneConfiguration getConfig(FishboneType type) {
    switch (type) {
      case FishboneType.strip_anti_personal:
        return FishboneConfiguration(
          verticalLineLength: 4.0,  // 2m each side
          lineSpacing: 1.0,         // 1m between lines
          startFromMeters: 3.0,    // Start after 10m
          endBeforeMeters: 3.0,    // End 10m before end
          mainLineColor: Colors.red,
          verticalLineColor: Colors.red,
        );
     
      case FishboneType.strip_anti_tank:
        return FishboneConfiguration(
          verticalLineLength: 8.0, // 6m each side
          lineSpacing: 3.0,        // 12m between lines
          startFromMeters: 6.0,    // Start after 20m
          endBeforeMeters: 6.0,    // End 20m before end
          mainLineColor: Colors.green,
          verticalLineColor: Colors.green,
        );
         case FishboneType.strip_anti_fragmentation:
        return FishboneConfiguration(
          verticalLineLength: 12, 
          lineSpacing:12.0,         // 3m between lines
          startFromMeters: 9.0,    // Start after 9m
          endBeforeMeters: 9.0,    // End 15m before end
          mainLineColor: Colors.blue,
          verticalLineColor: Colors.blue,
          hideRightVerticals: true
        );
      case FishboneType.row_singlerow_anti_personal:
      default:
        return FishboneConfiguration(
          verticalLineLength: 10.0,
          lineSpacing: 3.0,
          startFromMeters: 10.0,
          endBeforeMeters: 10.0,
          mainLineColor: Colors.blue,
          verticalLineColor: Colors.red,
        );
    }
  }
}

class FishboneShape extends Shape {
  final FishboneType fishboneType;
  late final FishboneConfiguration config;

  FishboneShape({
    required List<LatLng> points,
    this.fishboneType = FishboneType.strip_anti_personal,
  }) : super(points: points, type: ShapeType.fishbone) {
    config = FishboneConfiguration.getConfig(fishboneType);
  }

  // Utility function to convert meters to degrees longitude
  static double metersToDegreesLongitude(double meters, double latitude) {
    const double earthRadius = 6371000;
    return (meters / (earthRadius * cos(latitude * pi / 180))) * (180 / pi);
  }

  // Utility function to convert meters to degrees latitude
  static double metersToDegreesLatitude(double meters) {
    const double earthRadius = 6371000;
    return (meters / earthRadius) * (180 / pi);
  }

  @override
  double calculateDistance() {
    if (points.length != 2) return 0;
    
    const double earthRadius = 6371000; // Earth's radius in meters
    
    double lat1 = points[0].latitude * pi / 180;
    double lat2 = points[1].latitude * pi / 180;
    double dLat = (points[1].latitude - points[0].latitude) * pi / 180;
    double dLon = (points[1].longitude - points[0].longitude) * pi / 180;

    double a = sin(dLat/2) * sin(dLat/2) +
        cos(lat1) * cos(lat2) *
        sin(dLon/2) * sin(dLon/2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    
    return earthRadius * c;
  }

   @override
List<Polyline> getPolylines() {
  if (points.length < 2) {
    print("Not enough points to draw fishbone.");
    return [];
  }

  List<Polyline> polylines = [];

  // Draw the main polyline through all points
  polylines.add(Polyline(
    points: points,
    strokeWidth: config.mainLineWidth,
    color: config.mainLineColor,
  ));

  // Loop through each segment
  for (int j = 0; j < points.length - 1; j++) {
    final startPoint = points[j];
    final endPoint = points[j + 1];

    double segmentDistance = calculateDistanceInMeters(startPoint, endPoint);
    
    if (segmentDistance == 0) continue;

    // Calculate bearing between segment points
    double startLat = startPoint.latitude * pi / 180;
    double startLon = startPoint.longitude * pi / 180;
    double endLat = endPoint.latitude * pi / 180;
    double endLon = endPoint.longitude * pi / 180;

    double bearing = atan2(
      sin(endLon - startLon) * cos(endLat),
      cos(startLat) * sin(endLat) - sin(startLat) * cos(endLat) * cos(endLon - startLon)
    );

    double availableDistance = segmentDistance - (config.startFromMeters + config.endBeforeMeters);
    if (availableDistance <= 0) continue;

    int numberOfLines = (availableDistance / config.lineSpacing).floor();

    for (int i = 0; i < numberOfLines; i++) {
      double distanceFromStart = config.startFromMeters + (i * config.lineSpacing);
      
      if (distanceFromStart >= (segmentDistance - config.endBeforeMeters)) break;

      double fraction = distanceFromStart / segmentDistance;

      double lat = startPoint.latitude + (endPoint.latitude - startPoint.latitude) * fraction;
      double lon = startPoint.longitude + (endPoint.longitude - startPoint.longitude) * fraction;

      double verticalLatDelta = metersToDegreesLatitude(config.verticalLineLength);
      double verticalLonDelta = metersToDegreesLongitude(config.verticalLineLength, lat);

      double perpBearing = bearing + (pi / 2);
      LatLng mainLinePoint = LatLng(lat, lon);
      LatLng verticalEnd;

      if (i % 2 == 0) {
        if (!config.hideRightVerticals) {
          verticalEnd = LatLng(
            lat + verticalLatDelta * cos(perpBearing),
            lon + verticalLonDelta * sin(perpBearing)
          );
          polylines.add(Polyline(
            points: [mainLinePoint, verticalEnd],
            strokeWidth: config.verticalLineWidth,
            color: config.verticalLineColor,
          ));
        }
      } else {
        if (!config.hideLeftVerticals) {
          verticalEnd = LatLng(
            lat - verticalLatDelta * cos(perpBearing),
            lon - verticalLonDelta * sin(perpBearing)
          );
          polylines.add(Polyline(
            points: [mainLinePoint, verticalEnd],
            strokeWidth: config.verticalLineWidth,
            color: config.verticalLineColor,
          ));
        }
      }
    }
  }

  return polylines;
}
 

  @override
  Map<String, dynamic> getDetails(BuildContext context) {
    if (points.isEmpty) return {'type': fishboneTitle[fishboneType]};
        final provider = context.read<CoordinateProvider>();

    
    var details = {
      'type':fishboneTitle[fishboneType],
      'start': '${points[0].latitude.toStringAsFixed(6)}, ${points[0].longitude.toStringAsFixed(6)}',
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
      details['end'] = '${points[1].latitude.toStringAsFixed(6)}, ${points[1].longitude.toStringAsFixed(6)}';

        if (provider.showIndianGrid) {
        final endGridCoords = IndianGridConverter.latLongToGrid(
          provider.selectedZone,
          points[1].latitude,
          points[1].longitude,
        );
        
        if (endGridCoords != null) {
          details['end_grid'] = 'E: ${endGridCoords.easting.toStringAsFixed(3)}m, N: ${endGridCoords.northing.toStringAsFixed(3)}m';
        }
      }
      // details['distance'] = '${(calculateDistance() / 1000).toStringAsFixed(2)} km';
      details['distance'] = '${calculateDistanceInMeters(points[0], points[1]).toStringAsFixed(2)}m (${(calculateDistance() / 1000).toStringAsFixed(2)}km)';

      
      double totalDistance = calculateDistance();
      double availableDistance = totalDistance - (config.startFromMeters + config.endBeforeMeters);
      int numberOfLines = (availableDistance / config.lineSpacing).floor();
      details['markers'] = '$numberOfLines markers';
      details['start_offset'] = '${config.startFromMeters.toStringAsFixed(1)}m';
      details['end_offset'] = '${config.endBeforeMeters.toStringAsFixed(1)}m';
    }

    return details;
  }

  @override
  List<DragMarker> getPoints() {
    // TODO: implement getPoints
    throw UnimplementedError();
  }
}