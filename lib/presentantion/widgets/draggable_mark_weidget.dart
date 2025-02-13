


// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
// import 'package:latlong2/latlong.dart';

// class DraggableMarkerWidget extends StatefulWidget {
//   final MapController mapController;
//   final Function(LatLng) onMarkerDragged;
//   final List<LatLng> points;

//   const DraggableMarkerWidget({
//     Key? key,
//     required this.mapController,
//     required this.onMarkerDragged,
//     required this.points,
//   }) : super(key: key);

//   @override
//   State<DraggableMarkerWidget> createState() => _DraggableMarkerWidgetState();
// }

// class _DraggableMarkerWidgetState extends State<DraggableMarkerWidget> {
//   LatLng? _markerPosition;

//   @override
//   Widget build(BuildContext context) {
//     return DragMarkers(
//       markers:    widget.points.map((e) {
//         return  DragMarker(
//             key: GlobalKey<DragMarkerWidgetState>(),
//             point: e,
//             size: const Size(75, 50),
//             builder: (_, pos, __) {
//               return GestureDetector(
//                 // onTap: () => _showMarkerPopup(context, pos),
//                 child: const Icon(
//                   Icons.location_on,
//                   size: 50,
//                   color: Colors.red,
//                 ),
//               );
//             },
//             onDragEnd: (details, point) {
//               debugPrint("Marker moved to: $point");
//             },
//           );
        
//       })  .toList()    
// ,
//       // markers:    [
//       //         DragMarker(
//       //           size: Size(400, 400),
//       //       point: LatLng(45.535, -122.675),
//       //       offset: const Offset(0.0, -8.0),
//       //       builder: (buildContext, latLng, booll) =>   Icon(Icons.location_on, size: 50),
//       //       onDragUpdate: (details, latLng) => print(latLng),
//       //     ),
//       //       ] 
//     );
//   }
// }
