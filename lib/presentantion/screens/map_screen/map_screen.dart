import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
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
import 'package:myapp/presentantion/widgets/drawing_button.dart';
import 'package:myapp/presentantion/widgets/floating_toolbar.dart';
import 'package:myapp/presentantion/widgets/map_layers.dart';
import 'package:myapp/presentantion/widgets/map_tile_selector.dart';
import 'package:myapp/presentantion/widgets/search_location.dart';
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
  bool _isDownnloadedLayerVisible = true;
  MapLayer currentMapLayer = maplayersData[0];

  // -----------------------  new   --------------------------
  OptsButtonType? _currentSelectedButton; // Tracks which button is selected

  late PolyEditor _polyEditor;
  List<LatLng> selectedPoints = [];

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
      points: selectedPoints,
      pointIcon: const Icon(Icons.location_on, color: Colors.green),
      intermediateIcon: const Icon(Icons.lens, color: Colors.blue),
      intermediateIconSize: const Size(20, 20),
      pointIconSize: const Size(30, 30),
      callbackRefresh: (point) => setState(() {
        selectedPoints = selectedPoints;
      }),
    );
    // _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                onTap: (_, point) {
                  final provider = context.read<DrawingProvider>();
                  if (provider.isAddingMarker) {
                    provider.addMarker(point);
                    setState(() {
                      selectedPoints.add(point);
                    });
                  } else if (provider.isSelectionMode) {
                    _handleShapeSelection(provider, point);
                  } else if (provider.currentShape != ShapeType.none) {
                    provider.addPoint(point);
                  } else {
                    print("clicked...");
                    Positioned(
                      bottom: 1,
                      right: 0,
                      left: 0,
                      child: Text("####################3"),
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
                // TileLayer(
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
                        if (provider.currentPoints.isNotEmpty)
                          Polyline(
                            points: provider.currentPoints,
                            strokeWidth: 2.0,
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

                DragMarkers(markers: _polyEditor.edit()),
              ]),

          // detail component ****************

          // Positioned(
          //     top: 100,
          //     right: 10,
          //     child: NIconButton(
          //         icon: Icon(Icons.layers_outlined),
          //         onPressed: () {
          //           setState(() {
          //             _isDownnloadedLayerVisible = !_isDownnloadedLayerVisible;
          //           });
          //           // Navigator.push(
          //           //   context,
          //           //   MaterialPageRoute(builder: (context) => SettingsPage()),
          //           // );
          //         })),

          // if (_isMapReady)
          // if (_currentSelectedButton ==  OptsButtonType.setting)
          // Positioned(
          //   top: 60,
          //   right: 10,
          //   child: Container(
          //     height: 35,
          //     width: 35,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.rectangle,
          //       borderRadius: BorderRadius.circular(8.0),

          //       color: Colors.white, // Set the grey color
          //     ),
          //     child: IconButton(
          //       icon: SvgPicture.asset('assets/menu.svg'),
          //       onPressed: () {
          //         setState(() {
          //           _isPanelVisible = !_isPanelVisible;
          //         });
          //       },
          //     ),
          //   ),
          // ),

          // Positioned(
          //     top: 10,
          //     right: 10,
          //     child: NIconButton(
          //         icon: Icon(Icons.settings),
          //         onPressed: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(builder: (context) => SettingsPage()),
          //           );
          //         })),

// ###############################################################################
          // **************   new  *****************
          Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 10,
              //  bottom: 0,
              child: Center(
                //  Can are here to help.

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
                    padding: EdgeInsets.all(12),
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
                            if (button ==
                                OptsButtonType.setting) {
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
              )),

          // *****************  content s *********************
          if (_currentSelectedButton == OptsButtonType.mapElementDetailed)
            Positioned(
              right: sidePaneSize,
              top: screenSize.height * 0.1,
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
              top: screenSize.height * 0.1,
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

          //  loaction search bar ========================
          Positioned(
              top: MediaQuery.of(context).padding.top, // Account for status bar
              left: 0,
              right: 0,
              child: LocationSearchBar(
                locationDB: LocationDatabase(),
                onLocationSelected: (LatLng location) {
                  // Handle selected location
                  print(
                      'Selected: ${location.latitude}, ${location.longitude}');
                },
              )),
          //

          //    LocationSearchBar(
          //     onLocationSelected: (LatLng location) {
          //       // Handle location selection
          //       // e.g., move map, add marker, etc.
          //       _mapController.move(location, 15);
          //       setState(() {
          //         // markers = [
          //         //   Marker(
          //         //     point: location,
          //         //     builder: (ctx) => Icon(Icons.location_pin),
          //         //   ),
          //         // ];
          //       });
          //     },
          //     showCurrentLocation: true, // Optional, defaults to true
          //   ),
          // ),

          // CoordinatePopup(
          //   address: '',
          //                         coordinate: LatLng(20.0121, 21.12251),
          //                         onCancel: () {
          //                  },
          //         ),

          // Consumer<DrawingProvider>(
          //   builder: (context, provider, _) {
          //     final details = provider.getCurrentShapeDetails();
          //     if (details == null) return const SizedBox();

          //     return Container(
          //       color: Colors.black,
          //       padding: const EdgeInsets.all(8.0),
          //       child: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         crossAxisAlignment: CrossAxisAlignment.end,
          //         children: details.entries
          //             .map(
          //               (e) => Text(
          //                 '${e.key}: ${e.value}',
          //                 style: const TextStyle(color: Colors.white),
          //               ),
          //             )
          //             .toList(),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}



//   Positioned sideBaar(BuildContext context) {
//     return Positioned(
//         top: 0,
//         left: 20,
//         bottom: 0,
//         child: Center(
//             child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       spreadRadius: 1,
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
//                     child: Consumer<MapProvider>(
//                         builder: (context, provider, child) =>
//                             provider.selectedPoints.length >= 3
//                                 ? Column(
//                                     spacing: 4,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       NIconButton(
//                                         icon: Icon(Icons.download),
//                                         onPressed: () =>
//                                             _showDownloadDialog(context),
//                                       ),
//                                      NIconButton(
//                                         icon: Icon(Icons.undo),
//                                         onPressed: () => provider.removeLastPoint(),
//                                       ),

//                                       NIconButton(
//                                         icon: Icon(Icons.delete),
//                                         onPressed: () => provider.clearPoints(),
//                                       ),
                                     

//                                       //  Consumer<MapProvider>(
//                                       //     builder: (context, provider, child) => provider.selectedPoints.length >= 3
//                                       //         ? NIconButton(
//                                       //              icon: Icon(Icons.download),
//                                       //             onPressed: () => _showDownloadDialog(context),
//                                       //           )
//                                       //         : SizedBox(),
//                                       //   )
//                                     ],
//                                   )
//                                 : Text("Draw by clicking on the map")
                                
                                
//                                 )))));
//   }
// }
