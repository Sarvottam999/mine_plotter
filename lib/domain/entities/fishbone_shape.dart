// lib/domain/entities/fishbone_shape.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:myapp/core/enum/fishbone_type.dart';
import 'package:myapp/core/enum/shape_type.dart';
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
    if (points.length != 2) return [];

    List<Polyline> polylines = [];
    final startPoint = points[0];
    final endPoint = points[1];

    // Add main horizontal line
    polylines.add(Polyline(
      points: [startPoint, endPoint],
      strokeWidth: config.mainLineWidth,
      color: config.mainLineColor,
    ));

    // Calculate bearing between points
    double startLat = startPoint.latitude * pi / 180;
    double startLon = startPoint.longitude * pi / 180;
    double endLat = endPoint.latitude * pi / 180;
    double endLon = endPoint.longitude * pi / 180;
    
    double bearing = atan2(
      sin(endLon - startLon) * cos(endLat),
      cos(startLat) * sin(endLat) - sin(startLat) * cos(endLat) * cos(endLon - startLon)
    );

    double totalDistance = calculateDistance();
    
    // Validate the configuration
    if (config.startFromMeters >= totalDistance || 
        config.endBeforeMeters >= totalDistance ||
        config.startFromMeters + config.endBeforeMeters >= totalDistance) {
      return [Polyline(
        points: [startPoint, endPoint],
        strokeWidth: config.mainLineWidth,
        color: config.mainLineColor,
      )];
    }

    // Calculate available distance for vertical lines
    double availableDistance = totalDistance - (config.startFromMeters + config.endBeforeMeters);
    
    // Calculate number of vertical lines that will fit
    int numberOfLines = (availableDistance / config.lineSpacing).floor();
    
    // Generate vertical lines
    for (int i = 0; i < numberOfLines; i++) {
      // Calculate distance from start for this vertical line
      double distanceFromStart = config.startFromMeters + (i * config.lineSpacing);
      
      // Make sure we don't exceed the end point
      if (distanceFromStart >= (totalDistance - config.endBeforeMeters)) {
        break;
      }
      
      // Calculate position along the main line
      double fraction = distanceFromStart / totalDistance;
      
      // Interpolate position
      double lat = startPoint.latitude + (endPoint.latitude - startPoint.latitude) * fraction;
      double lon = startPoint.longitude + (endPoint.longitude - startPoint.longitude) * fraction;
      
      // Calculate vertical line length
      double verticalLatDelta = metersToDegreesLatitude(config.verticalLineLength);
      double verticalLonDelta = metersToDegreesLongitude(config.verticalLineLength, lat);
      
      // Calculate perpendicular bearing
      double perpBearing = bearing + (pi / 2);
      LatLng mainLinePoint = LatLng(lat, lon);
      LatLng verticalEnd;
      


      // ---------------------------------
        // Alternate between up and down
      if (i % 2 == 0) {
        // Right side vertical (up)
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
        // Left side vertical (down)
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
      // ---------------------------------
      // Alternate between up and down
      // if (i % 2 == 0) {
      //   verticalEnd = LatLng(
      //     lat + verticalLatDelta * cos(perpBearing),
      //     lon + verticalLonDelta * sin(perpBearing)
      //   );
      // } else {
      //   verticalEnd = LatLng(
      //     lat - verticalLatDelta * cos(perpBearing),
      //     lon - verticalLonDelta * sin(perpBearing)
      //   );
      // }

      // Add vertical line
      // polylines.add(Polyline(
      //   points: [mainLinePoint, verticalEnd],
      //   strokeWidth: config.verticalLineWidth,
      //   color: config.verticalLineColor,
      // ));
    }

    return polylines;
  }

  @override
  Map<String, dynamic> getDetails() {
    if (points.isEmpty) return {'type': fishboneTitle[fishboneType]};
    
    var details = {
      'type':fishboneType,
      'start': '${points[0].latitude.toStringAsFixed(6)}, ${points[0].longitude.toStringAsFixed(6)}',
    };

    if (points.length > 1) {
      details['end'] = '${points[1].latitude.toStringAsFixed(6)}, ${points[1].longitude.toStringAsFixed(6)}';
      details['distance'] = '${(calculateDistance() / 1000).toStringAsFixed(2)} km';
      
      // Calculate number of markers
      double totalDistance = calculateDistance();
      double availableDistance = totalDistance - (config.startFromMeters + config.endBeforeMeters);
      int numberOfLines = (availableDistance / config.lineSpacing).floor();
      details['markers'] = '$numberOfLines markers';
      details['start_offset'] = '${config.startFromMeters.toStringAsFixed(1)}m';
      details['end_offset'] = '${config.endBeforeMeters.toStringAsFixed(1)}m';
    }

    return details;
  }
}