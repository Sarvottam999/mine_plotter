// lib/presentation/widgets/shape_details_panel.dart

import 'package:flutter/material.dart';
import 'package:myapp/core/enum/fishbone_type.dart';
import 'package:myapp/presentantion/widgets/showEditInfo.dart';
import 'package:myapp/utils/contant.dart';
import 'package:myapp/utils/no_content_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../providers/drawing_provider.dart';
import '../../domain/entities/shape.dart';
import 'dart:math';
import 'package:myapp/domain/entities/shape.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShapeDetailsPanel extends StatelessWidget {
  final MapController mapController;
  // final VoidCallback onPressed;

  const ShapeDetailsPanel({
    Key? key,
    required this.mapController,
    // required this.onPressed,
  }) : super(key: key);

  void _focusOnShape(Shape shape) {
    if (shape.points.isEmpty) return;

    // Calculate bounds of the shape
    double minLat = shape.points[0].latitude;
    double maxLat = shape.points[0].latitude;
    double minLng = shape.points[0].longitude;
    double maxLng = shape.points[0].longitude;

    for (var point in shape.points) {
      minLat = min(minLat, point.latitude);
      maxLat = max(maxLat, point.latitude);
      minLng = min(minLng, point.longitude);
      maxLng = max(maxLng, point.longitude);
    }

    // Add some padding
    double latPadding = (maxLat - minLat) * 0.2;
    double lngPadding = (maxLng - minLng) * 0.2;

    // Create bounds with padding
    LatLngBounds bounds = LatLngBounds(
      LatLng(minLat - latPadding, minLng - lngPadding),
      LatLng(maxLat + latPadding, maxLng + lngPadding),
    );

    // Animate map to fit bounds
    mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(50.0),
        maxZoom: 18,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen_size = MediaQuery.of(context).size;
    return Container(

      constraints: BoxConstraints(maxWidth: 300),
      padding: EdgeInsets.symmetric(horizontal: 17),
      width: screen_size.width * 0.6,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black26
        ),
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Elements',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                // Container(
                //   height: 35,
                //   width: 35,
                //   decoration: BoxDecoration(>
                //     shape: BoxShape.rectangle,
                //     borderRadius: BorderRadius.circular(8.0),

                //     color: Colors.blueGrey[50], // Set the grey color
                //   ),
                //   child: IconButton(
                //       icon:SvgPicture.asset('assets/menu.svg'),
                //       //  Icon(
                //       //   Icons.close,
                //       //   size: 18,
                //       // ),
                //       onPressed: onPressed),
                // ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<DrawingProvider>(
              builder: (context, provider, _) {
                if (provider.shapes.isEmpty) {
                  return NoContentView(text: 'Empty list!', sub_text : "You did not add any elements to the map.");
                  // return Center(
                  //   child: Padding(
                  //     padding: EdgeInsets.all(16.0),
                  //     child: Image.asset(
                  //       'assets/nothing_found.png',
                  //       width: double.infinity,
                  //     ),
                  //   ),
                  // );
                }

                return ListView.builder(
                  itemCount: provider.shapes.length,
                  itemBuilder: (context, index) {
                    final shape = provider.shapes[index];
                    final details = shape.getDetails(context);

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                            border: Border.all(color: my_orange, width: 2), // Border color & thickness

                          color: my_orange_light,
                          borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () => _focusOnShape(shape),
                        child: Padding(
                          padding: const  EdgeInsets.symmetric(
                               vertical: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                    child: Icon(
                                      size: 15,
                                      _getShapeIcon(shape),
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    // flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Element ${index + 1}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600]),
                                          ),
                                          Container(
                                            child: Text(
                                              '${details['type']}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 20,
                                    ),
                                    onPressed: () =>
                                        provider.selectShape(shape),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Colors.white,
                              ),

                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                
                                child: ShowEditInfo(shape: shape,))


                              // ...details.entries
                              //     .where((e) => e.key != 'type')
                              //     .map((e) => Padding(
                              //           padding: const EdgeInsets.symmetric(
                              //               horizontal: 10, vertical: 4.0),
                              //           child: Text(
                              //               '${_formatKey(e.key)}: ${e.value}'),
                              //         )),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getShapeIcon(Shape shape) {
    switch (shape.type) {
      case ShapeType.line:
        return Icons.show_chart;
      case ShapeType.square:
        return Icons.square_outlined;
      case ShapeType.circle:
        return Icons.circle_outlined;
      case ShapeType.fishbone:
        return Icons.linear_scale;
      default:
        return Icons.shape_line;
    }
  }

  String _formatKey(String key) {
    return key
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
