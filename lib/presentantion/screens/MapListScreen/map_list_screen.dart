import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/error_widgets/no_content_view.dart';
import 'package:myapp/presentantion/providers/dowanload_provider.dart';
import 'package:myapp/presentantion/screens/MarkAreaScreen/mark_area_screen.dart';
import 'package:myapp/presentantion/screens/MarkAreaScreen/models/downloaded_map.dart';
import 'package:myapp/presentantion/screens/map_preview_screen.dart';
import 'package:myapp/presentantion/screens/map_screen/utils.dart';
import 'package:myapp/presentantion/widgets/download_button.dart';
import 'package:myapp/presentantion/widgets/location_card2.dart';
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
        final screen_size = MediaQuery.of(context).size;
        final double screenWidth = screen_size.width;

    final isTablet = screenWidth > 600;
        int crossAxisCount = screenWidth > 600 ? 2 : 2; // 3 columns for tablets, 2 for mobile


    return Scaffold(
      backgroundColor: Colors.white,
    
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

                // ====================  list =============================
                 Container(
                  height: screen_size.height * 0.7,
                   child: mapProvider.downloadedMaps.length == 0 ? 
                   Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: AspectRatio(
                              aspectRatio: 16 / 9,
                        child: Image.asset(
                          'assets/nothing_found.png',
                          width: double.infinity,
                        ),
                      ),
                    ),
                  )
                   
                   
                   : GridView.builder(
                   
                    
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                           crossAxisCount: crossAxisCount,
                           crossAxisSpacing: 10,
                           mainAxisSpacing: 10,
                           childAspectRatio:4.8/6, // Adjust aspect ratio if needed
                                ),
                                padding: const EdgeInsets.all(10),
                                itemCount: mapProvider.downloadedMaps.length,
                                itemBuilder: (context, index) {
                           return MapListItem(map: mapProvider.downloadedMaps[index], index: index,);
                                },
                              ),
                 ),
              // SizedBox(
              //   height: screenSize.height * 0.7,
              //   width: screenSize.width,
              //   child: mapProvider.downloadedMaps.length > 0
              //       ? ListView.builder(
              //           itemCount: mapProvider.downloadedMaps.length,
              //           itemBuilder: (context, index) =>
              //               MapListItem(index: index),
              //         )
              //       : EmptyNotificationsScreen(),
              // ),
              Padding(
                padding: const EdgeInsets.only(bottom: 28.0),
                child: NDownloadButton(
                  width: 300,
                  hideShadowa: true,
                  label: 'DOWNLOAD MAPS',
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
              ),
            ],
          );
        },
      ),
      // floatingActionButton:
    );
  }
}

class MapListItem extends StatelessWidget {
  final DownloadedMap map;
  final int index;

  MapListItem({required this.map, required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) {
        // final map = mapProvider.downloadedMaps[index];
        print('====================> ${map.id}');
        // return Listcard(map: map);
        return FutureBuilder(
            future: getPreviewImage(map.id),
            builder: (context, snapshot) {
              print(map.date);

              return Container(
                margin: EdgeInsets.symmetric(vertical: 5.h),
                child: LocationCard(
                  onMapSelect: () {
                    print('clicked ...............');
                    context.read<MapProvider>().setPreviewMap(map.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapPreviewScreen(
                          map: map,
                        ),
                      ),
                    );

                    // Provider.of<MapProvider>(context, listen: false).deleteMap(index);
                  },
                  onPressed: () {
                    Provider.of<MapProvider>(context, listen: false)
                        .deleteMap(index);
                  },
                  fileImage: snapshot.hasData ? snapshot.data! : null,
                  // imageUrl: snapshot.hasData ? null : 'https://via.placeholder.com/200', // Placeholder for fallback
                  name: map.name,
                  time: formatDateTime(map.date),
                  northEast:
                      ' Lat : ${map.northEast.latitude.toStringAsFixed(2)} | Lag : ${map.northEast.longitude.toStringAsFixed(2)}',
                  southWest:
                      'Lat : ${map.northEast.latitude.toStringAsFixed(2)} | Lag : ${map.northEast.longitude.toStringAsFixed(2)}',
                  areaSqKm: '${map.areaSqKm.toStringAsFixed(2)} km²',
                  // latitude: '37.7749° N',
                ),
              );
            });
      },
    );
  }
}
