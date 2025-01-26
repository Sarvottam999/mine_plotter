import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/presentantion/providers/dowanload_provider.dart';
import 'package:myapp/presentantion/screens/MarkAreaScreen/mark_area_screen.dart';
import 'package:myapp/presentantion/screens/MarkAreaScreen/models/downloaded_map.dart';
import 'package:myapp/presentantion/widgets/download_button.dart';
import 'package:myapp/presentantion/widgets/location_card.dart';
import 'package:myapp/utils/util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class MapListScreen extends StatefulWidget {
  @override
  State<MapListScreen> createState() => _MapListScreenState();
}

class _MapListScreenState extends State<MapListScreen> {
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text('Offline Maps'),
      // ),
      body: Consumer<MapProvider>(
        builder: (context, mapProvider, child) {
          return Column(
            children: [
              if (mapProvider.isDownloading)
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                          value: mapProvider.currentProgress),
                      Text(mapProvider.currentStatus),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: mapProvider.downloadedMaps.length,
                  itemBuilder: (context, index) => MapListItem(index: index),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: NDownloadButton(
            label: 'Download More',
            primaryColor: Colors.black,
            secondaryColor: Colors.white,
            onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MapSelectorScreen(),
              ));
          
             },
          ),
     
    );
  }
}

class MapListItem extends StatelessWidget {
  final int index;

  MapListItem({required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) {
        final map = mapProvider.downloadedMaps[index];
        // return Listcard(map: map);
        return FutureBuilder(
          future: getPreviewImage(map.name),
          builder: (context, snapshot) {
            print(map.date);

            
            return Container(
              margin: EdgeInsets.symmetric(vertical: 5.h),
              child: LocationCard(
                onPressed: () {
               Provider.of<MapProvider>(context, listen: false).deleteMap(index);

                  
                },
                fileImage: snapshot.hasData ? snapshot.data! : null,
                // imageUrl: snapshot.hasData ? null : 'https://via.placeholder.com/200', // Placeholder for fallback
                  name: map.name,
                  time: formatDateTime(map.date),
                  northEast:' Lat : ${map.northEast.latitude.toStringAsFixed(2)} | Lag : ${map.northEast.longitude.toStringAsFixed(2)}' ,
                  southWest:'Lat : ${map.northEast.latitude.toStringAsFixed(2)} | Lag : ${map.northEast.longitude.toStringAsFixed(2)}' ,
                  areaSqKm: '${map.areaSqKm} km²',
                  // latitude: '37.7749° N',
                ),
            );
          }
        ); 
      },
    );
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
