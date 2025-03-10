// these is correct code


import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/molecules/Buttons/icon_button.dart';
import 'package:myapp/molecules/snakbar.dart';

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
    setState(() => _isLoading = true);
    
    try {
      // Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }


      Position position = await Geolocator.getCurrentPosition(

      );


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
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error getting location: $e')),
      // );
       CustomSnackbar.show(
  context,
  message: "Location access denied. Please allow location permissions to proceed.",
  type: SnackbarType.error,
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