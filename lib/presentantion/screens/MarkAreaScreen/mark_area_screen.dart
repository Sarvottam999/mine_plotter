import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/molecules/Buttons/icon_button.dart';
import 'package:myapp/presentantion/providers/dowanload_provider.dart';
import 'package:myapp/presentantion/screens/MarkAreaScreen/models/downloaded_map.dart';
import 'package:provider/provider.dart';

class MapSelectorScreen extends StatelessWidget {
  const MapSelectorScreen({super.key});

  void _showDownloadDialog(BuildContext context) {
    final provider = Provider.of<MapProvider>(context, listen: false);
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Download Map'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Map Name',
                hintText: 'Enter a name for this map',
              ),
            ),
            SizedBox(height: 16),
            Text('Area: ${provider.calculateArea().toStringAsFixed(2)} km²'),
            Text(
                'Zoom Levels: ${provider.zoomRange.start.round()} - ${provider.zoomRange.end.round()}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
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
                  provider.zoomRange.end.round());

              Navigator.pop(context); // Close dialog
              //  Navigator.pop(context);  // Close map selector
            },
            child: Text('Download'),
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
              child: MapSelector(),
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
                  provider.selectedPoints.length >= 3
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

class MapSelector extends StatelessWidget {
    final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
        final provider = Provider.of<MapProvider>(context, listen: false);

    return 
    
    Consumer<MapProvider>(
      builder: (context, provider, child) => FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(51.5, -0.09),
          initialZoom: 13.0,
          onTap: provider.addPoint,
           onMapEvent: (event) {
             provider.setZoomLevel(event.camera.zoom); 
        },
        ),
        children: [
          // TileLayer(
          //   urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          //   subdomains: ['a', 'b', 'c'],
          // ),
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
    );
  }
}
