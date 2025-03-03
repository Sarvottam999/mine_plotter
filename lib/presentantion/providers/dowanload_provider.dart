import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/presentantion/screens/MarkAreaScreen/models/downloaded_map.dart';
import 'package:myapp/presentantion/screens/MarkAreaScreen/models/map_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapProvider extends ChangeNotifier {
 
  List<DownloadedMap> downloadedMaps = [];
  bool isDownloading = false;
  double currentProgress = 0;
  String currentStatus = '';
  MapDownloader? currentDownloader;  


    double currentZoomLevel = 13.0;


    List<LatLng> selectedPoints = [];
  late PolyEditor polyEditor;
  RangeValues zoomRange = RangeValues(10, 15);
  void setZoomLevel(double zoom) {
    currentZoomLevel = zoom;
    notifyListeners();
  }

  // ============== preview screen stae ==============
  String? previewMapPath;

void setPreviewMap(String? id)  async{

    final directory = await getExternalStorageDirectory();
    previewMapPath = '${directory!.path}/offline_maps/${id}';
    
  notifyListeners();
}

  // ==========================
  String? currentTilePath;


Future<void> loadOfflineMap(DownloadedMap? map) async {
  if (map == null) {
    currentTilePath = null;

  } else {

    final directory = await getExternalStorageDirectory();
    currentTilePath = '${directory!.path}/offline_maps/${map.id}';

  }
  notifyListeners();
}
 
  Future<void> loadMaps() async {
 final directory = await getExternalStorageDirectory();
 final baseMapDir = Directory('${directory!.path}/offline_maps');
 
 if (!await baseMapDir.exists()) {
   return;
 }

 List<DownloadedMap> maps = [];
 await for (var entity in baseMapDir.list()) {
   if (entity is Directory) {
     final metadataFile = File('${entity.path}/metadata.json');
     if (await metadataFile.exists()) {
       final metadata = jsonDecode(await metadataFile.readAsString());
       maps.add(DownloadedMap(
        id:metadata['id'] ?? 0 ,
         name: metadata['name'],
         northEast: LatLng(metadata['northEast']['lat'], metadata['northEast']['lng']),
         southWest: LatLng(metadata['southWest']['lat'], metadata['southWest']['lng']),
         date: metadata['downloadDate'],
         tiles: metadata['tileCount'] ?? 0,
         areaSqKm: _calculateArea(
           LatLng(metadata['northEast']['lat'], metadata['northEast']['lng']),
           LatLng(metadata['southWest']['lat'], metadata['southWest']['lng']),
         ),
       ));
     }
   }
 }
 
 downloadedMaps = maps;
 notifyListeners();
}
Future<void> deleteMap(int index) async {
 final map = downloadedMaps[index];
 final directory = await getExternalStorageDirectory();
 final mapDir = Directory('${directory!.path}/offline_maps/${map.id}');
 
 await mapDir.delete(recursive: true);  
 downloadedMaps.removeAt(index);        
 notifyListeners();                     
 await loadMaps();                     
}



double _calculateArea(LatLng ne, LatLng sw) {
 final width = (ne.longitude - sw.longitude).abs() * 111.32;
 final height = (ne.latitude - sw.latitude).abs() * 111.32;
 return width * height;
}
    MapProvider() {
    loadMaps(); // Loads existing maps from storage

    polyEditor = PolyEditor(
      points: selectedPoints,
      pointIcon: const Icon(Icons.my_location_sharp, color: Colors.black),
      intermediateIcon: const Icon(Icons.lens, color: Colors.blue),
      intermediateIconSize: const Size(20, 20),
      pointIconSize: const Size(30, 30),
      callbackRefresh: (_) => notifyListeners(),
    );
  }

  void addPoint(TapPosition tapPosition, LatLng point) {
    selectedPoints.add(point);
    notifyListeners();
  }
  void deletePoint(int index) {
  if (index >= 0 && index < selectedPoints.length) {
    selectedPoints.removeAt(index);
    notifyListeners();
  }
}

void clearPoints() {
  selectedPoints.clear();
  notifyListeners();
}
void removeLastPoint() {
  selectedPoints.removeLast();
  notifyListeners();
}

  void setZoomRange(RangeValues values) {
    zoomRange = values;
    notifyListeners();
  }
double calculateArea() {
 if (selectedPoints.length < 3) return 0;
 
 double area = 0;
 for (int i = 0; i < selectedPoints.length; i++) {
   int j = (i + 1) % selectedPoints.length;
   area += selectedPoints[i].longitude * selectedPoints[j].latitude;
   area -= selectedPoints[j].longitude * selectedPoints[i].latitude;
 }
 
 // Convert to approximate km² using haversine formula
 area = area.abs() * 111.32 * 111.32 / 2;
 return area;
}
  

  Future<void> downloadMap(DownloadedMap map, int minZoom, int maxZoom, String mapType) async {
    isDownloading = true;

  String tileUrl;
  if (mapType == "satellite") {
    tileUrl = 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
  } else {
    tileUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  }


      currentDownloader = MapDownloader(
      id: map.id,
      tileUrl: tileUrl,
      minZoom: minZoom,
      maxZoom: maxZoom,
      northEast: map.northEast,
      southWest: map.southWest,
      mapName: map.name,
          mapType: mapType,

    );

    try {
      await currentDownloader?.downloadTiles((progress) {
        print("downloadMap --> ${currentDownloader!.isCancelled} ");
      if (currentDownloader!.isCancelled) return; // Stop if cancelled

        currentProgress = progress;
        currentStatus = 'Downloading tiles...';
        notifyListeners();
      });

      if (!currentDownloader!.isCancelled) {
        downloadedMaps.add(map);
        currentStatus = 'Download completed!';
        await _saveMaps();
      }

      isDownloading = false;


      notifyListeners();
    } catch (e) {
      isDownloading = false;
      currentStatus = 'Error: $e';
      notifyListeners();
    }
    notifyListeners();

  }

  // Future<void> deleteMap(int index) async {
  //   final map = downloadedMaps[index];
  //   final directory = await getExternalStorageDirectory();
  //   final mapDir = Directory('${directory!.path}/offline_maps/${map.name}');
    
  //   await mapDir.delete(recursive: true);
  //   downloadedMaps.removeAt(index);
  //   await _saveMaps();
  //   notifyListeners();
  // }

  Future<void> _saveMaps() async {
    final prefs = await SharedPreferences.getInstance();
    final mapsJson = downloadedMaps.map((map) => jsonEncode(map.toJson())).toList();
    await prefs.setStringList('downloaded_maps', mapsJson);
  }

   void cancelDownload() {
    if (isDownloading && currentDownloader != null) {
      currentDownloader!.cancelDownload();
      isDownloading = false;
      currentStatus = 'Download cancelled!';
      notifyListeners();
    }
  }
}