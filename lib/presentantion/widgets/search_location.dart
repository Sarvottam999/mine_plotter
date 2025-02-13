// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:myapp/database/location_database.dart';

// class LocationSearchBar extends StatefulWidget {
//   final Function(LatLng) onLocationSelected;
//   final bool showCurrentLocation;
//   final LocationDatabase locationDB;

//   const LocationSearchBar({
//     Key? key,
//     required this.onLocationSelected,
//     required this.locationDB,
//     this.showCurrentLocation = true,
//   }) : super(key: key);

//   @override
//   _LocationSearchBarState createState() => _LocationSearchBarState();
// }

// class _LocationSearchBarState extends State<LocationSearchBar> {
//   final TextEditingController searchController = TextEditingController();
//   List<Map<String, dynamic>> searchResults = [];
//   bool isLoading = false;
//   String? lat, lon;

//   Future<void> searchLocation(String query) async {
//     if (query.isEmpty) {
//       setState(() {
//         searchResults = [];
//         isLoading = false;
//       });
//       return;
//     }

//     setState(() => isLoading = true);

//     try {
//       // Try to parse coordinates first
//       if (_isCoordinates(query)) {
//         _handleCoordinateSearch(query);
//         return;
//       }

//       // Search in local database
//       final results = await widget.locationDB.searchLocations(query);
      
//       setState(() {
//         searchResults = results;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error searching locations: $e');
//       setState(() {
//         searchResults = [];
//         isLoading = false;
//       });
//       _showErrorSnackBar('Error searching locations');
//     }
//   }

//   bool _isCoordinates(String query) {
//     final RegExp coordPattern = RegExp(r'^(-?\d+\.?\d*),\s*(-?\d+\.?\d*)$');
//     return coordPattern.hasMatch(query.trim());
//   }

//   void _handleCoordinateSearch(String query) {
//     final RegExp coordPattern = RegExp(r'^(-?\d+\.?\d*),\s*(-?\d+\.?\d*)$');
//     final match = coordPattern.firstMatch(query.trim());

//     if (match != null) {
//       try {
//         final lat = double.parse(match.group(1)!);
//         final lon = double.parse(match.group(2)!);

//         if (lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180) {
//           setState(() {
//             searchController.text = '$lat, $lon';
//             searchResults = [];
//             isLoading = false;
//           });
//           widget.onLocationSelected(LatLng(lat, lon));
//         } else {
//           _showErrorSnackBar('Invalid coordinates range');
//         }
//       } catch (e) {
//         _showErrorSnackBar('Invalid coordinates format');
//       }
//     }
//     setState(() => isLoading = false);
//   }

//   Future<void> getCurrentLocation() async {
//     setState(() => isLoading = true);

//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         _showErrorSnackBar('Location services are disabled');
//         return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           _showErrorSnackBar('Location permission denied');
//           return;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         _showErrorSnackBar(
//           'Location permissions permanently denied. Please enable in settings.'
//         );
//         return;
//       }

//       final Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high
//       );

//       // Find nearest location in database
//       final nearestLocation = await _findNearestLocation(position);
      
//       setState(() {
//         searchController.text = nearestLocation['display_name'] ?? 
//                               '${position.latitude}, ${position.longitude}';
//         searchResults = [];
//       });

//       widget.onLocationSelected(
//         LatLng(position.latitude, position.longitude)
//       );

//     } catch (e) {
//       _showErrorSnackBar('Error getting location: $e');
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<Map<String, dynamic>> _findNearestLocation(Position position) async {
//     final locations = await widget.locationDB.searchLocations('');
//     double minDistance = double.infinity;
//     Map<String, dynamic> nearest = {};

//     for (var location in locations) {
//       double lat = location['lat'];
//       double lon = location['lon'];
      
//       double distance = _calculateDistance(
//         position.latitude,
//         position.longitude,
//         lat,
//         lon
//       );

//       if (distance < minDistance) {
//         minDistance = distance;
//         nearest = location;
//       }
//     }

//     return nearest;
//   }

//   double _calculateDistance(
//     double lat1,
//     double lon1,
//     double lat2,
//     double lon2
//   ) {
//     var p = 0.017453292519943295; // Math.PI / 180
//     var c = cos;
//     var a = 0.5 - c((lat2 - lat1) * p)/2 + 
//             c(lat1 * p) * c(lat2 * p) * 
//             (1 - c((lon2 - lon1) * p))/2;
//     return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
//   }

//   void _showErrorSnackBar(String message) {
//     if (!context.mounted) return;
    
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         duration: const Duration(seconds: 3),
//         action: message.contains('permission') ? SnackBarAction(
//           label: 'Settings',
//           onPressed: () {
//             Geolocator.openLocationSettings();
//           },
//           textColor: Colors.white,
//         ) : null,
//       ),
//     );
//   }

//   void _showCoordinateInputDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Enter Coordinates'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               decoration: const InputDecoration(
//                 labelText: 'Latitude (-90 to 90)',
//                 hintText: 'e.g., 28.6139',
//               ),
//               keyboardType: const TextInputType.numberWithOptions(
//                 decimal: true,
//                 signed: true,
//               ),
//               onChanged: (value) => lat = value,
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               decoration: const InputDecoration(
//                 labelText: 'Longitude (-180 to 180)',
//                 hintText: 'e.g., 77.2090',
//               ),
//               keyboardType: const TextInputType.numberWithOptions(
//                 decimal: true,
//                 signed: true,
//               ),
//               onChanged: (value) => lon = value,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               if (lat != null && lon != null) {
//                 Navigator.pop(context);
//                 searchController.text = '$lat, $lon';
//                 _handleCoordinateSearch('$lat, $lon');
//               } else {
//                 _showErrorSnackBar('Please enter both latitude and longitude');
//               }
//             },
//             child: const Text('Search'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           width: MediaQuery.of(context).size.width * 0.45,
//           constraints: const BoxConstraints(minWidth: 200),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 spreadRadius: 1,
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: TextField(
//             controller: searchController,
//             decoration: InputDecoration(
//               hintText: 'Search location or enter coordinates...',
//               prefixIcon: const Icon(Icons.search),
//               suffixIcon: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (searchController.text.isNotEmpty)
//                     IconButton(
//                       icon: const Icon(Icons.clear),
//                       onPressed: () {
//                         searchController.clear();
//                         setState(() => searchResults = []);
//                       },
//                     ),
//                   if (widget.showCurrentLocation)
//                     IconButton(
//                       icon: isLoading
//                         ? const SizedBox(
//                             width: 24,
//                             height: 24,
//                             child: CircularProgressIndicator(strokeWidth: 2)
//                           )
//                         : const Icon(Icons.my_location),
//                       onPressed: isLoading ? null : getCurrentLocation,
//                     ),
//                   IconButton(
//                     icon: const Icon(Icons.format_list_numbered),
//                     onPressed: _showCoordinateInputDialog,
//                   ),
//                 ],
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide.none,
//               ),
//               filled: true,
//               fillColor: Colors.white,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 12,
//               ),
//             ),
//             onChanged: (value) {
//               if (value.length > 2) {
//                 searchLocation(value);
//               } else {
//                 setState(() => searchResults = []);
//               }
//             },
//           ),
//         ),
//         if (searchResults.isNotEmpty)
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             constraints: BoxConstraints(
//               maxHeight: MediaQuery.of(context).size.height * 0.3,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 10,
//                 ),
//               ],
//             ),
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: searchResults.length,
//               itemBuilder: (context, index) {
//                 final result = searchResults[index];
//                 return ListTile(
//                   leading: const Icon(Icons.location_on),
//                   title: Text(
//                     result['display_name'],
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   onTap: () {
//                     setState(() {
//                       searchController.text = result['display_name'];
//                       searchResults = [];
//                     });
//                     widget.onLocationSelected(
//                       LatLng(result['lat'], result['lon'])
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
// }