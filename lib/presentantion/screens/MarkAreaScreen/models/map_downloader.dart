import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'dart:convert';

import 'package:myapp/presentantion/screens/MarkAreaScreen/models/storage_hanndler.dart';

class TileBounds {
  final int minX;
  final int maxX;
  final int minY;
  final int maxY;

  TileBounds({
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
  });
}

// class MapDownloader {
//   final String id;
//   final String tileUrl;
//   final int minZoom;
//   final int maxZoom;
//   final LatLng northEast;
//   final LatLng southWest;
//   final String mapName;

//   MapDownloader({
//     required this.id,
//     required this.tileUrl,
//     required this.minZoom,
//     required this.maxZoom,
//     required this.northEast,
//     required this.southWest,
//     required this.mapName,
//   });
class MapDownloader {
  final String id;
  final String tileUrl;
  final int minZoom;
  final int maxZoom;
  final LatLng northEast;
  final LatLng southWest;
  final String mapName;
  final String mapType; // "standard" or "satellite"
  bool isCancelled = false; 

  MapDownloader({
    required this.id,
    required this.tileUrl,
    required this.minZoom,
    required this.maxZoom,
    required this.northEast,
    required this.southWest,
    required this.mapName,
    required this.mapType,
  });

  void cancelDownload() {
    isCancelled = true;
  }



  Future<void> downloadTiles(Function(double) onProgress) async {
    final mapDirPath = await StorageHandler.createMapDirectory(id);
    int totalTiles = 0;
    int downloadedTiles = 0;

    // Calculate total tiles
    for (int z = minZoom; z <= maxZoom; z++) {
      final bounds = _getTileBounds(z);
      for (int x = bounds.minX; x <= bounds.maxX; x++) {
        for (int y = bounds.minY; y <= bounds.maxY; y++) {
          totalTiles++;
        }
      }
    }

    // Download tiles
    for (int z = minZoom; z <= maxZoom; z++) {
      final bounds = _getTileBounds(z);
      final zoomDir = Directory('$mapDirPath/$z');
      if (!await zoomDir.exists()) {
        await zoomDir.create();
      }

      for (int x = bounds.minX; x <= bounds.maxX; x++) {
        final xDir = Directory('${zoomDir.path}/$x');
        if (!await xDir.exists()) {
          await xDir.create();
        }

        for (int y = bounds.minY; y <= bounds.maxY; y++) {
          if (isCancelled) return; 
          
          final tileFile = File('${xDir.path}/$y.png');
          
          if (!await tileFile.exists()) {
            String url = tileUrl
                .replaceAll('{z}', z.toString())
                .replaceAll('{x}', x.toString())
                .replaceAll('{y}', y.toString());
                
            if (url.contains('{s}')) {
              final subdomains = ['a', 'b', 'c'];
              final randomSubdomain = subdomains[DateTime.now().millisecondsSinceEpoch % subdomains.length];
              url = url.replaceAll('{s}', randomSubdomain);
            }

            try {
              final response = await http.get(Uri.parse(url));
              if (response.statusCode == 200) {
                await tileFile.writeAsBytes(response.bodyBytes);
              }
            } catch (e) {
              print('Error downloading tile: $e');
            }
          }
          
          downloadedTiles++;
          onProgress(downloadedTiles / totalTiles);
        }
      }
    }

    // Save metadata
    final metadataFile = File('$mapDirPath/metadata.json');
    final metadata = {
      'id' :id,
      'name': mapName,
      'minZoom': minZoom,
      'maxZoom': maxZoom,
      'northEast': {'lat': northEast.latitude, 'lng': northEast.longitude},
      'southWest': {'lat': southWest.latitude, 'lng': southWest.longitude},
      'downloadDate': DateTime.now().toIso8601String(),
      'mapType': mapType, // Store the type of map downloaded

    };
    await metadataFile.writeAsString(jsonEncode(metadata));
  }

  TileBounds _getTileBounds(int zoom) {
    Point<int> northEastPoint = _latLonToTile(northEast.latitude, northEast.longitude, zoom);
    Point<int> southWestPoint = _latLonToTile(southWest.latitude, southWest.longitude, zoom);

    return TileBounds(
      minX: southWestPoint.x,
      maxX: northEastPoint.x,
      minY: northEastPoint.y,
      maxY: southWestPoint.y
    );
  }

  Point<int> _latLonToTile(double lat, double lon, int zoom) {
    final x = ((lon + 180) / 360 * pow(2, zoom)).floor();
    final y = ((1 - log(tan(lat * pi / 180) + 1 / cos(lat * pi / 180)) / pi) / 2 * pow(2, zoom)).floor();
    return Point(x, y);
  }
}