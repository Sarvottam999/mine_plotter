import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/domain/entities/shape.dart';
import 'package:myapp/molecules/NDottedLine.dart';
import 'package:myapp/presentantion/providers/coordinate_provider.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
import 'package:myapp/utils/indian_grid_converter.dart';
import 'package:myapp/utils/util.dart';
import 'package:provider/provider.dart';

enum pointType { START, END, INTERMEDIATE }

class ShowEditInfo extends StatelessWidget {
  final Shape shape;
  const ShowEditInfo({super.key, required this.shape });

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingProvider>(builder: (context, provider, _) {
      // List<LatLng>? points = provider.selectedShape?.points;
      List<LatLng>? points = shape.points;
      if (points == null || points.isEmpty) {
        return const SizedBox();
      }

      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration:   BoxDecoration(
                boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ...points.asMap().entries.map((entry) {
                  int index = entry.key;
                  LatLng point = entry.value;
                  
                  // Calculate bearing if not the last point
                  double? bearing;
                  if (index < points.length - 1) {
                    bearing = Distance().bearing(point, points[index + 1]);
                  }
        
                  return DottedItem(
                    right: index != points.length - 1,
                    point: point,
                    bearing: bearing, // Pass the bearing
                    icon: Icon(
                      index == 0 ? Icons.radio_button_checked : Icons.circle,
                      color: Colors.pink,
                      size: index == 0 ? 18 : index == points.length - 1 ?18:12,
                    ),
                    type: index == 0
                        ? pointType.START
                        : index == points.length - 1
                            ? pointType.END
                            : pointType.INTERMEDIATE,
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class DottedItem extends StatelessWidget {
  final bool left;
  final bool right;
  final LatLng point;
  final Widget icon;
  final pointType type;
  final double? bearing; // Added bearing

  const DottedItem({
    super.key,
    this.left = false,
    this.right = false,
    required this.point,
    required this.icon,
    required this.type,
    this.bearing,
  });

  @override
  Widget build(BuildContext context) {
    final coordinateProvider = context.read<CoordinateProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 20,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (left)
                SizedBox(
                  width: 150,
                  child: CustomPaint(painter: NDottedLine(isVertical: false)),
                ),
              icon,
              if (right)
                SizedBox(
                  width: 150,
                  child: CustomPaint(painter: NDottedLine(isVertical: false)),
                ),
            ],
          ),
        ),
        pointDetail(point, coordinateProvider, type.name.toString().toUpperCase(), bearing),
      ],
    );
  }
}

Widget pointDetail(LatLng point, CoordinateProvider coordinateProvider, String text, double? bearing) {
  List<Widget> igsCoordinate = [];

  if (coordinateProvider.showIndianGrid) {
    final startGridCoords = IndianGridConverter.latLongToGrid(
      coordinateProvider.selectedZone,
      point.latitude,
      point.longitude,
    );
    igsCoordinate.add(  Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black, // Background color for "N"
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text(
              'IGS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),);
    igsCoordinate.add(
      Text('E:${truncateToFourDecimalPlaces(startGridCoords?.easting ?? 0)}', style: const TextStyle(fontSize: 12))
      );
    igsCoordinate.add(Text('N:${truncateToFourDecimalPlaces(startGridCoords?.northing ?? 0)}', style: const TextStyle(fontSize: 12)));
  }

  return SizedBox(
    width: 150,
    child: Column(
      spacing: 5,
      
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Container(
          // width: 100,
          decoration:   BoxDecoration(
        border: Border.all(color: Colors.black26),
  
              // color: Color.fromRGBO(238, 238, 238, 1),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
            if (bearing != null)  
      Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black, // Background color for label
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text(
              'Bearing',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 4), // Add spacing between label and value
          Text(
            '${bearing!.toStringAsFixed(2)}°', // ✅ Use `bearing!` (null-safe)
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
 

                Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black, // Background color for "N"
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text(
              'WGA84',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
              Text('LAT: ${truncateToFourDecimalPlaces(point.latitude)}', style: const TextStyle(fontSize: 12)),
              Text('LNG: ${truncateToFourDecimalPlaces(point.longitude)}', style: const TextStyle(fontSize: 12)),
              if (coordinateProvider.showIndianGrid) ...igsCoordinate,
            ],
          ),
        ),
      ],
    ),
  );
}




 