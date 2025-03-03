import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/molecules/Buttons/back_button.dart';
import 'package:myapp/presentantion/providers/dowanload_provider.dart';
import 'package:myapp/presentantion/screens/MarkAreaScreen/models/downloaded_map.dart';
import 'package:myapp/services/safe_file_tile_provider.dart';
import 'package:myapp/utils/util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class MapPreviewScreen extends StatefulWidget {
  final DownloadedMap map;
  const MapPreviewScreen({super.key, required this.map});

  @override
  State<MapPreviewScreen> createState() => _MapPreviewScreenState();
}

class _MapPreviewScreenState extends State<MapPreviewScreen> {
  final MapController mapController = MapController();

  // Existing properties
  double zoomLevel = 0;

  void setZoomLevel(double zoom) {
    setState(() {
      // zoomLevel = zoom;
    });
  }
 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Ensure the MapController is used only after the widget is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      goToMapArea(widget.map, mapController);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  onMapEvent: (event) {
                    setZoomLevel(
                        event.camera.zoom); // Update zoom level in provider
                  },

                  //  initialCenter: LatLng(
                  //    (widget.map.northEast.latitude + widget.map.southWest.latitude) / 2,
                  //    (widget.map.northEast.longitude + widget.map.southWest.longitude) / 2,
                  //  ),
                ),
                children: [
                  Consumer<MapProvider>(
                      builder: (context, provider, _) => TileLayer(
                            urlTemplate: provider.previewMapPath,
                            tileProvider: SafeFileTileProvider(),
                           )

                    
                      ),
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Consumer<MapProvider>(
                  builder: (context, provider, child) => Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Zoom: ${mapController.camera.zoom.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 10,
                left: 10,
                child: NBackButton(onPressed: (){
                  Navigator.pop(context);

                })),
              





            ],
          ),
        ),
      );
}
