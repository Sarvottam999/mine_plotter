import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class SafeFileTileProvider extends TileProvider {
   @override
 ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
   try {
     final basePath = options.urlTemplate!;
     final tilePath = '$basePath/${coordinates.z}/${coordinates.x}/${coordinates.y}.png'
         .replaceAll(' ', '_')
         .replaceAll(',', '_');

     
     final file = File(tilePath);
     if (!file.existsSync()) {
       print('Tile not found: $tilePath');
       return const AssetImage('assets/placeholder_tile.png');
     }
     
     return FileImage(file);
   } catch (e) {
     print('Error loading tile: $e');
     return const AssetImage('assets/placeholder_tile.png');
   }
 }
//  @override
//  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
//    try {
//      String path = options.urlTemplate!
//          .replaceAll('{z}', coordinates.z.toString())
//          .replaceAll('{x}', coordinates.x.toString())
//          .replaceAll('{y}', coordinates.y.toString());
     
//      // Handle spaces and special characters in path
//      path = Uri.encodeFull(path);
     
//      final file = File(path);
//      if (!file.existsSync()) {
//        print('Tile not found: $path');
//        // Return a placeholder or empty tile
//        return const AssetImage('assets/placeholder_tile.png');
//      }
     
//      return FileImage(file);
//    } catch (e) {
//      print('Error loading tile: $e');
//      return const AssetImage('assets/placeholder_tile.png');
//    }
//  }
}

// // Usage in TileLayer:
// TileLayer(
//  urlTemplate: provider.currentTilePath ?? currentMapLayer.url,
//  tileProvider: provider.currentTilePath != null 
//    ? SafeFileTileProvider() 
//    : NetworkTileProvider(),
//  subdomains: provider.currentTilePath != null ? [] : currentMapLayer.subdomains,
//  errorImage: const AssetImage('assets/placeholder_tile.png'),
// )