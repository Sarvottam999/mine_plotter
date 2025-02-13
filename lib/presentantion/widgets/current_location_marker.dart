// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';

// class CurrentLocationSearch extends StatefulWidget {
//   final MapController mapController;
//   final Function(LatLng) onLocationFound;

//   const CurrentLocationSearch({
//     Key? key,
//     required this.mapController,
//     required this.onLocationFound,
//   }) : super(key: key);

//   @override
//   State<CurrentLocationSearch> createState() => _CurrentLocationSearchState();
// }

// class _CurrentLocationSearchState extends State<CurrentLocationSearch> {
//   bool _isLoading = false;

//   Future<void> _getCurrentLocation() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Check if location permission is granted
//       var status = await Permission.location.status;
//       if (!status.isGranted) {
//         status = await Permission.location.request();
//         if (!status.isGranted) {
//           throw Exception('Location permission denied');
//         }
//       }

//       // Check if location service is enabled
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         throw Exception('Location services are disabled');
//       }

//       // Get current position
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       final location = LatLng(position.latitude, position.longitude);

//       // Move map to current location
//       widget.mapController.move(location, 15.0);

//       // Notify parent about the found location
//       widget.onLocationFound(location);

//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error getting location: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(8),
//           onTap: _isLoading ? null : _getCurrentLocation,
//           child: Container(
//             padding: const EdgeInsets.all(12),
//             child: _isLoading
//                 ? const SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   )
//                 : const Icon(Icons.my_location),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Extension widget for combining the location button with markers
// class CurrentLocationLayer extends StatelessWidget {
//   final MapController mapController;
//   final Function(LatLng)? onLocationMarked;

//   const CurrentLocationLayer({
//     Key? key,
//     required this.mapController,
//     this.onLocationMarked,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned(
//           right: 10,
//           bottom: 100, // Adjust this value based on your layout
//           child: CurrentLocationSearch(
//             mapController: mapController,
//             onLocationFound: (location) {
//               if (onLocationMarked != null) {
//                 onLocationMarked!(location);
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// // Custom marker widget
// class LocationMarker extends StatelessWidget {
//   final void Function()? onTap;

//   const LocationMarker({Key? key, this.onTap}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: const Icon(
//         Icons.location_on,
//         color: Colors.red,
//         size: 30,
//       ),
//     );
//   }
// }