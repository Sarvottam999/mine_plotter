import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
// import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/core/enum/fishbone_type.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/database/location_database.dart';
import 'package:myapp/domain/entities/circle_shape.dart';
import 'package:myapp/domain/entities/fishbone_shape.dart';
import 'package:myapp/domain/entities/shape.dart';
import 'package:myapp/domain/entities/square_shape.dart';
import 'package:myapp/molecules/Buttons/icon_button.dart';
import 'package:myapp/presentantion/providers/dowanload_provider.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
import 'package:myapp/presentantion/screens/SettingScreen/setting_screen.dart';
import 'package:myapp/presentantion/screens/map_screen/utils.dart';
import 'package:myapp/presentantion/widgets/ShowMyLocationButton.dart';
import 'package:myapp/presentantion/widgets/coordinate_popup.dart';
import 'package:myapp/presentantion/widgets/coordinate_search_bar.dart';
import 'package:myapp/presentantion/widgets/current_location_marke.dart';
import 'package:myapp/presentantion/widgets/current_location_marker.dart';
import 'package:myapp/presentantion/widgets/draggable_coordinate_shower.dart';
import 'package:myapp/presentantion/widgets/drawing_button.dart';
import 'package:myapp/presentantion/widgets/floating_toolbar.dart';
import 'package:myapp/presentantion/widgets/map_layers.dart';
import 'package:myapp/presentantion/widgets/map_tile_selector.dart';
import 'package:myapp/presentantion/widgets/search_location.dart';
import 'package:myapp/presentantion/widgets/selection_button.dart';
import 'package:myapp/presentantion/widgets/shape_details_panel.dart';
import 'package:myapp/presentantion/widgets/shape_editor.dart';
import 'package:myapp/services/safe_file_tile_provider.dart';
import 'package:myapp/utils/util.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  bool _isMapReady = false;
  bool _isPanelVisible = false;
  bool _isSearchBarVisible = false;
  bool _isDownnloadedLayerVisible = true;
  MapLayer currentMapLayer = maplayersData[0];

  // -----------------------  new   --------------------------
  OptsButtonType? _currentSelectedButton; // Tracks which button is selected

  late PolyEditor _polyEditor;
  // List<LatLng> selectedMarkerPoints = [];

  // final PopupController _popupLayerController = PopupController();

  void _handleShapeSelection(DrawingProvider provider, LatLng clickPoint) {
    Shape? selectedShape;
    double minDistance = 100; // threshold in meters

    // Check each shape
    for (var shape in provider.shapes) {
      // Get all polylines for this shape
      List<Polyline> polylines = shape.getPolylines();

      // Check each polyline in the shape
      for (var polyline in polylines) {
        // Check each segment in the polyline
        for (int i = 0; i < polyline.points.length - 1; i++) {
          LatLng start = polyline.points[i];
          LatLng end = polyline.points[i + 1];

          // Calculate distance from click to line segment
          double distance = distanceToLineSegment(clickPoint, start, end);

          if (distance < minDistance) {
            minDistance = distance;
            selectedShape = shape;
          }
        }
      }
    }

    // If we found a shape close enough to the click
    if (selectedShape != null) {
      // Toggle selection if clicking the same shape

      provider.selectShape(
          selectedShape == provider.selectedShape ? null : selectedShape);
    } else {
      // Deselect if clicked away from shapes
      provider.selectShape(null);
    }
  }

  @override
  void initState() {
    super.initState();
    _polyEditor = PolyEditor(
        points: context.read<DrawingProvider>().markers,
        pointIcon: const Icon(Icons.adjust, color: Colors.red),
        pointIconSize: const Size(30, 30),
        callbackRefresh: (point) {
          print("*********************${point}");
        }

        // setState(() {
        //   print("###########");
        //   // selectedPoints = selectedPoints;
        // }),

        );
    // _mapController = MapController();
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
          print("*********************${point}");
        }

        // setState(() {
        //   print("###########");
        //   // selectedPoints = selectedPoints;
        // }),

        );

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                onTap: (_, point) {
                  // final provider = context.watch<DrawingProvider>();
                  final provider =
                      Provider.of<DrawingProvider>(context, listen: false);
                  if (provider.currentShape == ShapeType.point) {
                    provider.addMarker(point);
                    // print('addedd dddddddddddddddddddddd ${provider.markers}');
                    // setState(() {
                    // selectedMarkerPoints.add(point);
                    // });
                  }
                  // else if (provider.isSelectionMode) {
                  //   // _handleShapeSelection(provider, point);

                  //   // sadcdcas

                  // }
                  else if (provider.currentShape != ShapeType.none) {
                    provider.addPoint(point);
                  } else {
                    print("clicked.......");
                    Positioned(
                      bottom: 1,
                      right: 0,
                      left: 0,
                      child: Text(""),
                    );
                  }
                },
                // onTap: (_, point) {
                //   final provider = context.read<DrawingProvider>();
                //   if (provider.currentShape != ShapeType.none) {
                //     provider.addPoint(point);
                //   }
                // },
                onPointerHover: (event, point) {
                  print("event==========>${event}");

                  final provider = context.read<DrawingProvider>();
                  if (provider.currentShape != ShapeType.none) {
                    provider.updateCursor(point);
                  }

                  print("point==========>${point}");
                },
                onMapReady: () {
                  print("=============     called   =========");
                  setState(() {
                    _isMapReady = true;
                  });
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
                              : currentMapLayer.subdomains,
                          errorImage:
                              const AssetImage('assets/placeholder_tile.png'),
                        )

                    // TileLayer(
                    //   urlTemplate:
                    //       provider.currentTilePath ?? currentMapLayer.url,
                    //   tileProvider: provider.currentTilePath != null
                    //       ? FileTileProvider()
                    //       : NetworkTileProvider(),
                    //   subdomains: provider.currentTilePath != null
                    //       ? []
                    //       : currentMapLayer.subdomains,
                    // ),
                    ),

                //           // TileLayer(
                //   urlTemplate: currentMapLayer.url,
                //   // 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                //   subdomains: currentMapLayer.subdomains,
                // ),
                Consumer<DrawingProvider>(
                  builder: (context, provider, _) {
                    return PolylineLayer(
                      polylines: [
                        ...provider.shapes.expand((shape) {
                          var polylines = shape.getPolylines();
                          // Highlight selected shape
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



                // Popup Layer
                //       PopupMarkerLayer(
                //         options: PopupMarkerLayerOptions(
                //           popupController: _popupLayerController,
                //            markers: _polyEditor.edit().map((dragMarker) {
                //   return Marker(
                //     point: dragMarker.point,
                //     width: 30,
                //     height: 30,
                //     child: GestureDetector(
                //       onTap: () {
                //         print('---------------');
                //         _popupLayerController.togglePopup(Marker(point: dragMarker.point, child: Icon(Icons.access_time_filled_sharp)));
                //       },
                //       child: const Icon(Icons.location_on, color: Colors.red, size: 30),
                //     ),
                //   );
                // }).toList(),
                //  popupDisplayOptions: PopupDisplayOptions(
                //           builder: (BuildContext context, Marker marker) {
                //               // ExamplePopup(marker),
                //             LatLng position = (marker.point as LatLng); // Extract LatLng
                //             print('position=========');
                //             return Card(
                //               child: Padding(
                //                 padding: const EdgeInsets.all(8.0),
                //                 child: Text(
                //                   "Lat: ${position.latitude.toStringAsFixed(5)}\nLng: ${position.longitude.toStringAsFixed(5)}",
                //                   style: TextStyle(fontSize: 14),
                //                 ),
                //               ),
                //             );
                //           },
                //         ),
                //         )),

                // DragMarkers(markers: _polyEditor.edit()),
                Consumer<DrawingProvider>(builder: (context, provider, _) {
                  print(
                      "===============provider.markers ======${provider.markers}");
                  _polyEditor = PolyEditor(
                      points: provider.markers,
                      pointIcon: const Icon(Icons.adjust, color: Colors.red),
                      pointIconSize: const Size(30, 30),
                      callbackRefresh: (point) {
                        print("*********************${point}");
                      }

                      // setState(() {
                      //   print("###########");
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
                      final provider = Provider.of<DrawingProvider>(context,
                          listen: false);
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
                            backgroundColor:
                                _currentSelectedButton == entry.key
                                    ? Colors.black
                                    : Colors.white,
                            icon: Icon(entry.value,
                                color: _currentSelectedButton == entry.key
                                    ? Colors.white
                                    : Colors.black),
                            onPressed: () {
                              if (button == OptsButtonType.setting) {
                                setState(() {
                                  _currentSelectedButton =
                                      OptsButtonType.none;
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
          if (_currentSelectedButton == OptsButtonType.downloadedMaps)
            Positioned(
              right: sidePaneSize,
              top: screenSize.height * 0.15,
              bottom: screenSize.height * 0.2,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: MapTileSelector(
                  mapController: _mapController,
                  // mapController: _mapController,
                  // onPressed: () {
                  //   setState(() {
                  //     _isPanelVisible = !_isPanelVisible;
                  //   });
                  // },
                ),
              ),
            ),

// ###############################################################################

          //  layer selector =========================
          Positioned(
              bottom: 10,
              right: 10,
              child: LayerSelector(onLayerChanged: (value) {
                setState(() {
                  currentMapLayer = value;
                });
              })),
        ],
      ),
    );
  }
}
