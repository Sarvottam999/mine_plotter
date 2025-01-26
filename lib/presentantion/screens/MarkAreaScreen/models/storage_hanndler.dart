import 'dart:io';

import 'package:path_provider/path_provider.dart';

class StorageHandler {
  static Future<String> createMapDirectory(String mapName) async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) throw Exception('External storage not available');

    final baseMapDir = Directory('${directory.path}/offline_maps');
    if (!await baseMapDir.exists()) {
      await baseMapDir.create(recursive: true);
    }

    final mapDir = Directory('${baseMapDir.path}/$mapName');
    if (!await mapDir.exists()) {
      await mapDir.create(recursive: true);
    }

    return mapDir.path;
  }
}
