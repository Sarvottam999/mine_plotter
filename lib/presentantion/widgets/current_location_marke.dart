// these is correct code


// current_location_marker.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/molecules/Buttons/icon_button.dart';

class CurrentLocationLayer extends StatefulWidget {
  final MapController mapController;
  final Function(LatLng location) onLocationMarked;

  const CurrentLocationLayer({
    Key? key,
    required this.mapController,
    required this.onLocationMarked,
  }) : super(key: key);

  @override
  State<CurrentLocationLayer> createState() => _CurrentLocationLayerState();
}

class _CurrentLocationLayerState extends State<CurrentLocationLayer> {
  LatLng? _currentLocation;
  bool _isLoading = false;

  Future<void> _getCurrentLocation() async {
    print("--------------1 ");
    setState(() => _isLoading = true);
    
    try {
      // Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
    print("--------------2 ${permission} ");

        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }
    print("--------------3 ");


      // Get current position
      Position position = await Geolocator.getCurrentPosition(

        // desiredAccuracy: LocationAccuracy.high,
      );
    print("--------------4 ");


print("position ===> ${position}");
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      // Move map to current location
      widget.mapController.move(
        _currentLocation!,
        widget.mapController.camera.zoom,
      );

      // Call callback with location
      widget.onLocationMarked(_currentLocation!);

    } catch (e) {
      print("errorr =======================");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NIconButton(
      // heroTag: 'getCurrentLocation',
      onPressed: () {
        
        _isLoading ? null : _getCurrentLocation();
      },
      icon: _isLoading 
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(color: Colors.black),
          )
        : const Icon(Icons.my_location),
    );
  }
}