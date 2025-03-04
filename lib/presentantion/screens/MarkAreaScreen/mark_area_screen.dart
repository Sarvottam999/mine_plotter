 
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/molecules/Buttons/icon_button.dart';
import 'package:myapp/molecules/Buttons/outline_filled_button.dart';
import 'package:myapp/presentantion/providers/dowanload_provider.dart';
import 'package:myapp/presentantion/screens/MarkAreaScreen/models/downloaded_map.dart';
import 'package:myapp/presentantion/widgets/map_layers.dart';
import 'package:myapp/utils/contant.dart';
import 'package:provider/provider.dart';

class MapSelectorScreen extends StatefulWidget {
  const MapSelectorScreen({super.key});

  @override
  State<MapSelectorScreen> createState() => _MapSelectorScreenState();
}

class _MapSelectorScreenState extends State<MapSelectorScreen> {

    String selectedMapType = "standard"; // Default

    onSelect(String type){
       setState(() {
                  selectedMapType = type;
                });
  }

  void _showDownloadDialog(BuildContext context) {
    final provider = Provider.of<MapProvider>(context, listen: false);
    TextEditingController nameController = TextEditingController();
  
      


    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Download Map'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hoverColor: my_orange,
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Map Name',
                  hintText: 'Enter a name for this map',
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: my_orange, width: 2.0),
                  ),
                )),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedMapType,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  selectedMapType = newValue;
                }
              },
              items: [
                DropdownMenuItem(
                    value: "standard", child: Text("Standard Map")),
                DropdownMenuItem(
                    value: "satellite", child: Text("Satellite Map")),
              ],
            ),
            SizedBox(height: 16),
            Text('Area: ${provider.calculateArea().toStringAsFixed(2)} km²'),
            Text(
                'Zoom Levels: ${provider.zoomRange.start.round()} - ${provider.zoomRange.end.round()}'),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          NButtonOutline(
            color: my_orange,
            label: 'Download',

            onPressed: () {
              final mapName = nameController.text.isNotEmpty
                  ? nameController.text
                  : 'Map_${DateTime.now().millisecondsSinceEpoch}';

              final bounds = LatLngBounds.fromPoints(provider.selectedPoints);
              final map = DownloadedMap(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: mapName,
                northEast: bounds.northEast,
                southWest: bounds.southWest,
                date: DateTime.now().toString(),
                tiles: 0,
                areaSqKm: provider.calculateArea(),
              );

              provider.downloadMap(map, provider.zoomRange.start.round(),
                  provider.zoomRange.end.round(), selectedMapType);

              Navigator.pop(context);
            },
            // child: Text('Download'),
          ),
        ],
      ),
    );

    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: MapSelector( selectedMapType: selectedMapType, onChange: onSelect,),
            ),
            Positioned(
              bottom: 10,
              left: 16,
              right: 16,
              child: _buildZoomSlider(),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: NIconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            sideBaar(context),
 
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
                    'Zoom: ${provider.currentZoomLevel.toStringAsFixed(1)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

              // Positioned(
              // bottom: 10,
              // right: 10,
              // child: LayerSelector(onLayerChanged: (value) {
              //   setState(() {
              //     currentMapLayer = value;
              //   });
              // })),
            // Container(
          ],
        ),
      ),
    );
  }

  Positioned sideBaar(BuildContext context) {
    return Positioned(
        top: 0,
        left: 10,
        bottom: 0,
        child: Center(
          child: Consumer<MapProvider>(
              builder: (context, provider, child) =>
                  provider.selectedPoints.length >= 1
                      ? Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 5),
                            child: Column(
                              spacing: 4,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                NIconButton(
                                  icon: Icon(Icons.download),
                                  onPressed: () => _showDownloadDialog(context),
                                ),
                                NIconButton(
                                  icon: Icon(Icons.undo),
                                  onPressed: () => provider.removeLastPoint(),
                                ),

                                NIconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => provider.clearPoints(),
                                ),

                                //  Consumer<MapProvider>(
                                //     builder: (context, provider, child) => provider.selectedPoints.length >= 3
                                //         ? NIconButton(
                                //              icon: Icon(Icons.download),
                                //             onPressed: () => _showDownloadDialog(context),
                                //           )
                                //         : SizedBox(),
                                //   )
                              ],
                            ),
                          ),
                        )
                      : SizedBox()),
        ));
  }
}

Widget _buildZoomSlider() {
  return Consumer<MapProvider>(
    builder: (context, provider, child) => Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Zoom Levels: ${provider.zoomRange.start.round()} - ${provider.zoomRange.end.round()}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RangeSlider(
              values: provider.zoomRange,
              min: 1,
              max: 19,
              activeColor: Colors.black,
              inactiveColor: Colors.grey,
              divisions: 18,
              labels: RangeLabels(
                provider.zoomRange.start.round().toString(),
                provider.zoomRange.end.round().toString(),
              ),
              onChanged: provider.setZoomRange,
            ),
            Text(
              'Selected Area: ${provider.calculateArea().toStringAsFixed(2)} km²',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}

class MapSelector extends StatefulWidget {
    final String selectedMapType;

     final void Function(String value) onChange;

    const MapSelector({Key? key, required this.selectedMapType, required this.onChange }) : super(key: key);

  @override
  State<MapSelector> createState() => _MapSelectorState();
}

 

class _MapSelectorState extends State<MapSelector> {
  // MapLayer currentMapLayer = maplayersData[0];
  // String selectedMapType = "standard";

  // void _changeMapType(String mapType) {
  //   setState(() {
  //     selectedMapType = mapType;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<MapProvider>(
          builder: (context, provider, child) => FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(51.5, -0.09),
              initialZoom: 19.0,
              maxZoom: 19,
              
              onTap: provider.addPoint,
              onMapEvent: (event) {
                provider.setZoomLevel(event.camera.zoom);
              },
            ),
            children: [
              TileLayer(
                // minZoom: 19,
                
                 
                urlTemplate: widget.selectedMapType == "satellite"
                    ? "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}"
                    : "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              PolygonLayer(
                polygons: [
                  if (provider.selectedPoints.length >= 3)
                    Polygon(
                      points: provider.selectedPoints,
                      color: Colors.blue.withOpacity(0.3),
                      borderColor: Colors.blue,
                      borderStrokeWidth: 2,
                    ),
                ],
              ),
              DragMarkers(markers: provider.polyEditor.edit()),
            ],
          ),
        ),
        Positioned(
          top: 50,
          right: 10,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            color: Colors.white,
            ),
            child: DropdownButton<String>(
              underline: SizedBox(),
              dropdownColor: Colors.white,

              value: widget.selectedMapType,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  widget.onChange(newValue);
                }
              },
              items: [
                DropdownMenuItem(value: "standard", child: Text("Standard Map")),
                DropdownMenuItem(value: "satellite", child: Text("Satellite Map")),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
