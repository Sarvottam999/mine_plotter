

// lib/widgets/draggable_coordinate_marker.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
import 'package:myapp/utils/indian_grid_converter.dart';
import 'package:provider/provider.dart';
import '../providers/coordinate_provider.dart';

class DraggableCoordinateMarker extends StatelessWidget {
  const DraggableCoordinateMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingProvider>(
      builder: (context, markerProvider, _) {
        if (!markerProvider.isSelectionMode || markerProvider.markerPosition == null) {
          return SizedBox.shrink();
        }

        return Stack(
          children: [
            // Coordinate Display
            Positioned(

              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                       
                
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Consumer<CoordinateProvider>(
                    builder: (context, coordProvider, _) {
                      final position = markerProvider.markerPosition!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (coordProvider.showLatLong) ...[
                            Text(
                              'WGS84:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Lat: ${position.latitude.toStringAsFixed(6)}°',
                            ),
                            Text(
                              'Lng: ${position.longitude.toStringAsFixed(6)}°',
                            ),
                          ],
                          if (coordProvider.showIndianGrid) ...[
                            SizedBox(height: 8),
                            Text(
                              '${coordProvider.selectedZone}:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Builder(
                              builder: (context) {
                                final gridCoords = IndianGridConverter.latLongToGrid(
                                  coordProvider.selectedZone,
                                  position.latitude,
                                  position.longitude,
                                );
                                if (gridCoords != null) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'E: ${gridCoords.easting.toStringAsFixed(3)} m',
                                      ),
                                      Text(
                                        'N: ${gridCoords.northing.toStringAsFixed(3)} m',
                                      ),
                                    ],
                                  );
                                }
                                return Text('Grid conversion failed');
                              },
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),

            // Drag Marker Layer
            // DragMarkers(
            //   markers: [
            //     DragMarker(
            //       size: Size(10, 10),
            //       point: markerProvider.markerPosition!,
            //       offset: Offset(0.0, -24.0),
            //       builder: (context, pos, isDragging) =>   Icon(
            //         Icons.location_on,
            //         color: Colors.red,
            //         size: 48,
            //       ),
            //       onDragEnd: (details, point) {
            //         markerProvider.updateMarkerPosition1(point);
            //       },
            //     ),
            //   ],
            // ),
             DragMarkers(
                alignment: Alignment.topCenter,


                      markers: [
                        DragMarker(
  key: GlobalKey<DragMarkerWidgetState>(),
  point: markerProvider.markerPosition!,
  size: const Size(300, 200),
  // Offset calculation:
  // X: -150 (half of width to center horizontally)
  // Y: -(container height + spacing + pin height)
  // Example: If pin height is 32px:
  // Y = -(150 + 20 + 32) = -202
  // offset: const Offset(-150, -202),
              offset: const Offset(0.0, -8.0),

  builder: (_, pos, ___) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 2.0
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              // BoxShadow(
              //   blurRadius: 10,
              //   color: const Color.fromARGB(255, 152, 152, 152),
              //   offset: Offset(1, 3)
              // )
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('LAT: ${pos.latitude.toString()}'),
              Text('LNG: ${pos.longitude.toString()}'),
            ],
          ),
        ),
        SizedBox(height: 20),
        SvgPicture.asset(
          'assets/map_pin.svg',
          height: 32, // Fixed height for pin
        )
      ],
    );
  },
  onDragEnd: (details, point) {
    markerProvider.updateMarkerPosition1(point);
  },
),
      //                     DragMarker(

      //   key: GlobalKey<DragMarkerWidgetState>(),
      //   point: markerProvider.markerPosition!,
      //   size: const Size(300, 200),
      //   offset: const Offset(-50, -100), 
      //   builder: (_, pos, ___) {
      //     return 
      //     Column(
      //       children: [
      //         Container(
      //           padding: EdgeInsets.all(8),
                
      //           decoration: BoxDecoration(
      //   color: Colors.white,
      //   border: Border.all(
      //       color: Colors.black, // Set border color
      //       width: 2.0),   // Set border width
      //   borderRadius: BorderRadius.all(
      //       Radius.circular(10.0)), // Set rounded corner radius
      //   boxShadow: [BoxShadow(blurRadius: 10,color: const Color.fromARGB(255, 152, 152, 152),offset: Offset(1,3))] // Make rounded corner of border
      //           ),
                
      //       // color: Colors.blueGrey,
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Text(
      //             'LNT: ${pos.latitude.toString()}',
      //             // style: const TextStyle(color: Colors.black),
      //           ),
      //           Text(
      //             'LNG: ${pos.longitude.toString()}',
      //             // style: const TextStyle(color: Colors.white),
      //           ),
      //         ],
      //       ),
      //     ),
      //     SizedBox(height: 20,),

      //     SvgPicture.asset('assets/map_pin.svg')


      //       ],
      //     );
          
          
          
      //   },
      //     onDragEnd: (details, point) {
      //               markerProvider.updateMarkerPosition1(point);
      //             },
      
      // ),


                      ],
                    ),
          ],
        );
      },
    );
  }
}










// // lib/widgets/draggable_coordinate_marker.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
// import 'package:myapp/utils/indian_grid_converter.dart';
// import 'package:provider/provider.dart';
// import '../providers/coordinate_provider.dart';

// class DraggableCoordinateMarker extends StatefulWidget {
//   final MapController mapController;

//   const DraggableCoordinateMarker({
//     Key? key,
//     required this.mapController,
//   }) : super(key: key);

//   @override
//   State<DraggableCoordinateMarker> createState() => _DraggableCoordinateMarkerState();
// }

// class _DraggableCoordinateMarkerState extends State<DraggableCoordinateMarker> {
//   LatLng? _markerPosition;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Coordinate Display
//         if (_markerPosition != null)
//           Positioned(
//             top: 10,
//             left: 10,
//             child: Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 4,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Consumer<CoordinateProvider>(
//                 builder: (context, provider, _) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (provider.showLatLong) ...[
//                         Text(
//                           'WGS84:',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           'Lat: ${_markerPosition!.latitude.toStringAsFixed(6)}°',
//                         ),
//                         Text(
//                           'Lng: ${_markerPosition!.longitude.toStringAsFixed(6)}°',
//                         ),
//                       ],
//                       if (provider.showIndianGrid) ...[
//                         SizedBox(height: 8),
//                         Text(
//                           '${provider.selectedZone}:',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         Builder(
//                           builder: (context) {
//                             final gridCoords = IndianGridConverter.latLongToGrid(
//                               provider.selectedZone,
//                               _markerPosition!.latitude,
//                               _markerPosition!.longitude,
//                             );
//                             if (gridCoords != null) {
//                               return Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'E: ${gridCoords.easting.toStringAsFixed(3)} m',
//                                   ),
//                                   Text(
//                                     'N: ${gridCoords.northing.toStringAsFixed(3)} m',
//                                   ),
//                                 ],
//                               );
//                             }
//                             return Text('Grid conversion failed');
//                           },
//                         ),
//                       ],
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ),

//         // Drag Marker Layer
//         DragMarkers(
//           markers: [
//                   DragMarker(
//         // key: GlobalKey<DragMarkerWidgetState>(),
//         point:_markerPosition ?? const LatLng(45.535, -122.675),
//         size: const Size.square(50),
//         offset: const Offset(0, -20),
//         builder: (_, __, ___) => const Icon(
//           Icons.location_on,
//           size: 50,
//           color: Colors.blueGrey,
//         ),
//          onDragEnd: (details, point) {
//                 setState(() {
//                   _markerPosition = point;
//                 });
//               },
//       ),
//             // DragMarker(
//             //   point: _markerPosition ?? LatLng(0, 0),
//             //   offset: Offset(0.0, -24.0),
//             //   builder: (ctx) => Icon(
//             //     Icons.location_on,
//             //     color: Colors.red,
//             //     size: 48,
//             //   ),
//             //   onDragEnd: (details, point) {
//             //     setState(() {
//             //       _markerPosition = point;
//             //     });
//             //   },
//             //   onTap: () {
//             //     // Optional: Add tap behavior
//             //   },
//             // ),
//           ],
//         ),
//       ],
//     );
//   }
// }