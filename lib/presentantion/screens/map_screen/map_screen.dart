import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/molecules/Buttons/icon_button.dart';
import 'package:myapp/presentantion/providers/dowanload_provider.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
import 'package:myapp/presentantion/screens/SettingScreen/setting_screen.dart';
import 'package:myapp/presentantion/screens/map_screen/utils.dart';
import 'package:myapp/presentantion/widgets/compass_button.dart';
import 'package:myapp/presentantion/widgets/coordinate_search_bar.dart';
import 'package:myapp/presentantion/widgets/current_location_marke.dart';
import 'package:myapp/presentantion/widgets/draggable_coordinate_shower.dart';
import 'package:myapp/presentantion/widgets/map_layers.dart';
import 'package:myapp/presentantion/widgets/map_tile_selector.dart';
import 'package:myapp/presentantion/widgets/selection_button.dart';
import 'package:myapp/presentantion/widgets/shape_details_panel.dart';
import 'package:myapp/presentantion/widgets/shape_editor.dart';
import 'package:myapp/presentantion/widgets/showEditInfo.dart';
import 'package:myapp/services/safe_file_tile_provider.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  MapLayer currentMapLayer = maplayersData[0];

  OptsButtonType? _currentSelectedButton;

  late PolyEditor _polyEditor;

  double zoom_level = 0;

  @override
  void initState() {
    super.initState();
    _polyEditor = PolyEditor(
        points: context.read<DrawingProvider>().markers,
        pointIcon: const Icon(Icons.adjust, color: Colors.red),
        pointIconSize: const Size(30, 30),
        callbackRefresh: (point) {});
  }

  @override
  void dispose() {
    _mapController.dispose(); // Clean up when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    _polyEditor = PolyEditor(
        points: context.watch<DrawingProvider>().markers,
        pointIcon: const Icon(Icons.adjust, color: Colors.red),
        pointIconSize: const Size(30, 30),
        callbackRefresh: (point) {
          // print("#############    ${point}");
        });

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                onMapEvent: (event) {
                  setState(() {
                    zoom_level = event.camera.zoom;
                  }); // Update zoom level in provider
                },
                onTap: (_, point) {
                  final provider =
                      Provider.of<DrawingProvider>(context, listen: false);
                  if (provider.currentShape == ShapeType.point) {
                    provider.addMarker(point);
                  } else if (provider.currentShape != ShapeType.none) {
                    provider.addPoint(point);
                  } else {
                    Positioned(
                      bottom: 1,
                      right: 0,
                      left: 0,
                      child: Text(""),
                    );
                  }
                },
                onPointerHover: (event, point) {
                  final provider = context.read<DrawingProvider>();
                  if (provider.currentShape != ShapeType.none) {
                    provider.updateCursor(point);
                  }
                },
              ),
              children: [
                Consumer<MapProvider>(
                    builder: (context, provider, _) => TileLayer(
                          urlTemplate:
                              provider.currentTilePath ?? currentMapLayer.url,
                          tileProvider: provider.currentTilePath != null
                              ? SafeFileTileProvider()
                              : NetworkTileProvider(),
                          subdomains: provider.currentTilePath != null
                              ? []
                              : currentMapLayer.subdomains ?? [],
                          errorImage:
                              const AssetImage('assets/placeholder_tile.png'),
                        )),

                Consumer<DrawingProvider>(
                  builder: (context, provider, _) {
                    return PolylineLayer(
                      polylines: [
                        ...provider.shapes.expand((shape) {
                          var polylines = shape.getPolylines();
                          if (shape == provider.selectedShape) {
                            polylines = polylines
                                .map((polyline) => Polyline(
                                      points: polyline.points,
                                      strokeWidth: polyline.strokeWidth + 2,
                                      color: Colors.yellow,
                                    ))
                                .toList();
                          }
                          return polylines;
                        }),
                        if (provider.currentPoints.isNotEmpty &&
                            provider.isAddingMarker)
                          Polyline(
                            points: provider.currentPoints,
                            strokeWidth: 10.0,
                            color: Colors.red,
                          ),
                      ],
                    );
                  },
                ),

                Align(
                  alignment: Alignment.center,
                  child: const ShapeEditor(),
                ),


              

                Consumer<DrawingProvider>(builder: (context, provider, _) {
                  _polyEditor = PolyEditor(
                      points: provider.markers,
                      pointIcon: const Icon(Icons.adjust, color: Colors.red),
                      pointIconSize: const Size(30, 30),
                      callbackRefresh: (point) {}

                      // setState(() {
                      //   // selectedPoints = selectedPoints;
                      // }),

                      );
                  return DragMarkers(markers: _polyEditor.edit());
                }),

                //             DraggableCoordinateMarker(
                //   mapController: _mapController,
                // ),
                DraggableCoordinateMarker(),

//  DragMarkers(
//                 alignment: Alignment.topCenter,

//                       markers: [
//                           DragMarker(
//         // key: GlobalKey<DragMarkerWidgetState>(),
//         point: const LatLng(45.535, -122.675),
//         size: const Size.square(50),
//         offset: const Offset(0, -20),
//         builder: (_, __, ___) => const Icon(
//           Icons.location_on,
//           size: 50,
//           color: Color.fromRGBO(96, 125, 139, 1),
//         ),
//       ),

//                       ],
//                     ),
              ]),

          //    Positioned(
          // top: MediaQuery.of(context).size.height*0.2,
          // left: 0,
          // right: 0,
          // child: Center(
          //   child:  ShowEditInfo())),

          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 0,
            right: 0,
            child: Center(
              child: CoordinateSearch(
                mapController: _mapController,
              ),
            ),
          ),
          Positioned(
            top: screenSize.height * 0.13,
            right: 10,
            child: CompassButton(
              mapController: _mapController,
              onPressed: () {
                // Handle compass button click if needed
              },
            ),
          ),

          // -------------------  right bottom button --------------

          Positioned(
            bottom: screenSize.height * 0.3,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 6,
              children: [
                SelectionButton(
                  mapController: _mapController,
                ),

                Center(
                  child: CurrentLocationLayer(
                    mapController: _mapController,
                    onLocationMarked: (location) {
                      final provider =
                          Provider.of<DrawingProvider>(context, listen: false);
                      provider.addMarker(location);
                    },
                  ),
                ),
                // **************   new  *****************
                Center(
                  child: Container(
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
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: SidePanelbuttonIcon.entries.map((entry) {
                          OptsButtonType button = entry.key;
                          // Widget label = entry.value;
                          return NIconButton(
                            backgroundColor: _currentSelectedButton == entry.key
                                ? Colors.black
                                : Colors.white,
                            icon: Icon(entry.value,
                                color: _currentSelectedButton == entry.key
                                    ? Colors.white
                                    : Colors.black),
                            onPressed: () {
                              if (button == OptsButtonType.setting) {
                                setState(() {
                                  _currentSelectedButton = OptsButtonType.none;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SettingsPage()),
                                );
                              }

                              // } else {
                              setState(() {
                                _currentSelectedButton =
                                    (_currentSelectedButton == button)
                                        ? OptsButtonType.none
                                        : button;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

// ###############################################################################

          // *****************  content s *********************
          if (_currentSelectedButton == OptsButtonType.mapElementDetailed)
            Positioned(
              right: sidePaneSize,
              top: screenSize.height * 0.15,
              bottom: screenSize.height * 0.2,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: ShapeDetailsPanel(
                  mapController: _mapController,
                  // onPressed: () {
                  //   setState(() {
                  //     _isPanelVisible = !_isPanelVisible;
                  //   });
                  // },
                ),
              ),
            ),

          // dowaloaded layers
          // if (_isDownnloadedLayerVisible) // Add condition here
          // if (_currentSelectedButton == OptsButtonType.downloadedMaps)
          //   Positioned(
          //     right: sidePaneSize,
          //     top: screenSize.height * 0.15,
          //     bottom: screenSize.height * 0.2,
          //     child: AnimatedSize(
          //       duration: const Duration(milliseconds: 300),
          //       child: MapTileSelector(
          //         mapController: _mapController,
          //         // mapController: _mapController,
          //         // onPressed: () {
          //         //   setState(() {
          //         //     _isPanelVisible = !_isPanelVisible;
          //         //   });
          //         // },
          //       ),
          //     ),
          //   ),

// ###############################################################################

          //  layer selector =========================
          Positioned(
              bottom: 10,
              right: 10,
              child: LayerSelector(
                  mapController: _mapController,
                  onLayerChanged: (value) {
                    setState(() {
                      currentMapLayer = value;
                    });
                  })),

          // ====================  undo/redo button ==============
          Positioned(bottom: 10, left: 10, child: undoButtons()),

          // ?============== zoom level ==================
          Positioned(
            bottom: 10,
            // right: 0,
            left: 120,
            child: Container(
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
              child: Row(
                spacing: 5,
                children: [
                  Icon(
                    Icons.open_in_full,
                    size: 18,
                  ),
                  Text(
                    'Zoom: ${zoom_level.toStringAsFixed(1)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget undoButtons() {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<DrawingProvider>(
            builder: (context, provider, _) => IconButton(
              icon: const Icon(
                Icons.redo,
                size: 18,
              ),
              onPressed: provider.canRedo ? provider.redo : null,
              tooltip: 'Redo',
            ),
          ),
          Consumer<DrawingProvider>(
            builder: (context, provider, _) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.undo,
                    size: 18,
                  ),
                  onPressed: provider.canUndo ? provider.undo : null,
                  tooltip: 'Undo',
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
