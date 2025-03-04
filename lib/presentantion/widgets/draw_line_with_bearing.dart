import 'dart:math';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
import 'package:provider/provider.dart';

class DrawLineWithBearing extends StatefulWidget {
  final LatLng startPoint;

  const DrawLineWithBearing({Key? key, required this.startPoint})
      : super(key: key);

  @override
  _DrawLineWithBearingState createState() => _DrawLineWithBearingState();
}

class _DrawLineWithBearingState extends State<DrawLineWithBearing> {
  final TextEditingController _bearingController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  LatLng? _calculatedEndPoint;

  LatLng calculateEndPoint(
      LatLng start, double bearing, double distanceInMeters) {
    const double earthRadius = 6371000; // Earth's radius in meters

    double lat1 = start.latitude * pi / 180;
    double lon1 = start.longitude * pi / 180;
    double bearingRad = bearing * pi / 180;

    double angularDistance = distanceInMeters / earthRadius;

    double lat2 = asin(sin(lat1) * cos(angularDistance) +
        cos(lat1) * sin(angularDistance) * cos(bearingRad));

    double lon2 = lon1 +
        atan2(sin(bearingRad) * sin(angularDistance) * cos(lat1),
            cos(angularDistance) - sin(lat1) * sin(lat2));

    return LatLng(lat2 * 180 / pi, lon2 * 180 / pi);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DrawingProvider>(context, listen: false);
    return AlertDialog(
      title: Text("Calculate Endpoint"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _bearingController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Bearing (°)"),
          ),
          TextField(
            controller: _distanceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Distance (meters)"),
          ),
          SizedBox(height: 10),
          if (_calculatedEndPoint != null)
            Text(
              "End Point: \nLat: ${_calculatedEndPoint!.latitude}, \nLng: ${_calculatedEndPoint!.longitude}",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            double? bearing = double.tryParse(_bearingController.text);
            double? distance = double.tryParse(_distanceController.text);

            if (bearing == null || distance == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please enter valid numbers")),
              );
              return;
            }

            setState(() {
              _calculatedEndPoint =
                  calculateEndPoint(widget.startPoint, bearing, distance);
            });

            if (_calculatedEndPoint != null) {
              print("_calculatedEndPoint ==>${_calculatedEndPoint}");
              // provider.addMarker(_calculatedEndPoint!);
            }
          },
          child: Text("Calculate"),
        ),
      ],
    );
  }
}
