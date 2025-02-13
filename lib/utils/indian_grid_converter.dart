// lib/utils/indian_grid_converter.dart

import 'package:proj4dart/proj4dart.dart';
import 'package:latlong2/latlong.dart';

class IndianGridConverter {
  static Map<String, String> zoneDefinitions = {
    'Zone_0': '+proj=lcc +lat_1=39.5 +lat_0=39.5 +lon_0=68 +k_0=0.99846154 +x_0=2153866.4 +y_0=2368292.9 +a=6377276.345 +b=6356075.413140 +units=m +no_defs',
    'Zone_IA': '+proj=lcc +lat_1=32.5 +lat_0=32.5 +lon_0=68 +k_0=0.99878641 +x_0=2743196.4 +y_0=914398.8 +a=6377276.345 +b=6356075.413140 +units=m +no_defs',
    'Zone_IIA': '+proj=lcc +lat_1=26 +lat_0=26 +lon_0=74 +k_0=0.99878641 +x_0=2743196.4 +y_0=914398.8 +a=6377276.345 +b=6356075.413140 +units=m +no_defs',
    'Zone_IIB': '+proj=lcc +lat_1=26 +lat_0=26 +lon_0=90 +k_0=0.99878641 +x_0=2743196.4 +y_0=914398.8 +a=6377276.345 +b=6356075.413140 +units=m +no_defs',
    'Zone_IIIA': '+proj=lcc +lat_1=19 +lat_0=19 +lon_0=80 +k_0=0.99878641 +x_0=2743196.4 +y_0=914398.8 +a=6377276.345 +b=6356075.413140 +units=m +no_defs',
    'Zone_IVA': '+proj=lcc +lat_1=12 +lat_0=12 +lon_0=80 +k_0=0.99878641 +x_0=2743196.4 +y_0=914398.8 +a=6377276.345 +b=6356075.413140 +units=m +no_defs',
  };

  // Convert from Lat/Long to Grid coordinates
  static ({double easting, double northing})? latLongToGrid(
    String zoneName,
    double latitude,
    double longitude,
  ) {
    try {
      final projString = zoneDefinitions[zoneName];
      if (projString == null) return null;

      final zoneProj = Projection.add(zoneName, projString);
      final wgs84 = Projection.get('EPSG:4326')!;

      final sourcePoint = Point(x: longitude, y: latitude);
      final result = wgs84.transform(zoneProj, sourcePoint);

      return (easting: result.x, northing: result.y);
    } catch (e) {
      print('Error converting lat/long to grid: $e');
      return null;
    }
  }

  // Convert from Grid coordinates to Lat/Long
  static LatLng? gridToLatLong(
    String zoneName,
    double easting,
    double northing,
  ) {
    try {
      final projString = zoneDefinitions[zoneName];
      if (projString == null) return null;

      final zoneProj = Projection.add(zoneName, projString);
      final wgs84 = Projection.get('EPSG:4326')!;

      final sourcePoint = Point(x: easting, y: northing);
      final result = zoneProj.transform(wgs84, sourcePoint);

      return LatLng(result.y, result.x);
    } catch (e) {
      print('Error converting grid to lat/long: $e');
      return null;
    }
  }

  // Get zone names for UI display
  static List<String> get zoneNames => zoneDefinitions.keys.toList();

  // Get readable zone name
  static String getReadableZoneName(String zoneName) {
    return zoneName.replaceAll('_', ' ');
  }
}