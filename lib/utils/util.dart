import 'dart:io';
import 'dart:math';

import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/presentantion/screens/MarkAreaScreen/models/downloaded_map.dart';
import 'package:path_provider/path_provider.dart';

String formatDateTime(String isoDate) {
  try {
    // Parse the ISO 8601 string
    DateTime dateTime = DateTime.parse(isoDate);

    // Format the date and time
    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    return formattedDate;
  } catch (e) {
    // Return an error message if parsing fails
    return 'Invalid date format';
  }
}

 


Future<File> getPreviewImage(String mapName) async {
  final directory = await getExternalStorageDirectory();
  final mapDir = Directory('${directory!.path}/offline_maps/$mapName');

  File? previewFile;
  await for (var entity in mapDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.png')) {
      previewFile = entity;
      break;
    }
  }

  return previewFile ??
      File('${directory.path}/offline_maps/$mapName/15/0/0.png');
}



// Helper method to calculate distance from point to line segment
  double distanceToLineSegment(LatLng p, LatLng start, LatLng end) {
    const Distance distance = Distance();

    // Convert to meters
    double l2 = distance.as(LengthUnit.Meter, start, end);
    l2 = l2 * l2; // squared length of the line segment

    if (l2 == 0) {
      // Line segment is actually a point
      return distance.as(LengthUnit.Meter, p, start);
    }

    // Consider the line extending the segment, parameterized as start + t (end - start)
    // We find projection of point p onto the line
    double t = ((p.longitude - start.longitude) *
                (end.longitude - start.longitude) +
            (p.latitude - start.latitude) * (end.latitude - start.latitude)) /
        l2;

    if (t < 0) {
      // Beyond the start of the segment
      return distance.as(LengthUnit.Meter, p, start);
    }
    if (t > 1) {
      // Beyond the end of the segment
      return distance.as(LengthUnit.Meter, p, end);
    }

    // Projection falls on the segment
    LatLng projection = LatLng(
        start.latitude + t * (end.latitude - start.latitude),
        start.longitude + t * (end.longitude - start.longitude));

    return distance.as(LengthUnit.Meter, p, projection);
  }


  void goToMapArea(DownloadedMap map,MapController mapController) {
      final centerLat = (map.northEast.latitude + map.southWest.latitude) / 2;
      final centerLng = (map.northEast.longitude + map.southWest.longitude) / 2;
      final center = LatLng(centerLat, centerLng);

      // Calculate zoom level to fit bounds
      final latZoom =
          getZoomLevel(map.northEast.latitude - map.southWest.latitude);
      final lngZoom =
          getZoomLevel(map.northEast.longitude - map.southWest.longitude);
      final zoom = min(latZoom, lngZoom);

      mapController.move(center, zoom);
    }


    double getZoomLevel(double delta) {
      return log(360 / delta) / ln2;
    }


   double calculateDistanceInMeters(LatLng start,LatLng end ) {
    // if (points.length != 2) return 0;
    return const Distance().as(
      LengthUnit.Meter,
      start,
      end,
    );
  }

  double truncateToFourDecimalPlaces(double largeNumber) {
  return (largeNumber * 10000).truncateToDouble() / 10000;
}
