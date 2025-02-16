import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:myapp/database/location_database.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
import 'package:myapp/presentantion/screens/SettingScreen/models/stored_location.dart';
import 'package:myapp/presentantion/widgets/search_bar/stored_location/location_add_form.dart';
import 'package:myapp/utils/contant.dart';
import 'package:myapp/utils/indian_grid_converter.dart';
import 'package:myapp/utils/no_content_view.dart';
import 'package:provider/provider.dart';

class StoredLocationsView extends StatefulWidget {
  final MapController mapController;
  final Function(LatLng) onLocationSelected;

  const StoredLocationsView({
    Key? key,
    required this.mapController,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  State<StoredLocationsView> createState() => _StoredLocationsViewState();
}

class _StoredLocationsViewState extends State<StoredLocationsView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isAddingLocation = false;
  bool _isWGS84 = true;

  bool _loading = false;
  List<StoredLocation> _locations = [];

  @override
  void initState() {
    super.initState();
    _loading = true;
    _loadLocations();
    _loading = false;

  }

  Future<void> _loadLocations() async {

    final locations = await LocationDatabase.instance.getAllLocations();
    setState(() {
      _locations = locations;
    });
  }

  Future<void> _addLocation(StoredLocation location) async {
    await LocationDatabase.instance.create(location);
    _loadLocations();
    setState(() {
      _isAddingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!_isAddingLocation) ...[
          Container(
            height: 300,
            child: _loading == true ? CircularProgressIndicator():
            
            
            _locations.length == 0
                ? NoContentView(
                    text: 'No saved locations found!!',
                  )
                : ListView.builder(
                    itemCount: _locations.length,
                    itemBuilder: (context, index) {
                      final location = _locations[index];
                      return LocationListItem(
                        location: location,
                        mapController: widget.mapController,
                        onLocationSelected: widget.onLocationSelected,
                        onDelete: () async {
                          if (location.id != null) {
                            await LocationDatabase.instance
                                .deleteLocation(location.id!);
                            _loadLocations();
                          }

                          // setState(() {
                          //   widget.locations.removeAt(index); // Remove item from the list
                          // });
                        },
                      );
                      // return ListTile(

                      //   title: Text(location.name),
                      //   subtitle: Text(location.isWGS84
                      //       ? '${location.latitude}, ${location.longitude}'
                      //       : '${location.zone} - E: ${location.easting}, N: ${location.northing}'),
                      //   onTap: () {
                      //     if (location.isWGS84 &&
                      //         location.latitude != null &&
                      //         location.longitude != null) {
                      //       final latLng =
                      //           LatLng(location.latitude!, location.longitude!);
                      //       // Move map to the location
                      //       widget.mapController.move(latLng, 15.0);
                      //       // Add marker through DrawingProvider
                      //       Provider.of<DrawingProvider>(context, listen: false)
                      //           .addSearchMarker(latLng);
                      //       // Call the callback
                      //       widget.onLocationSelected(latLng);
                      //     } else if (!location.isWGS84 &&
                      //         location.zone != null &&
                      //         location.easting != null &&
                      //         location.northing != null) {
                      //       // Convert Indian Grid coordinates to LatLng
                      //       final latLng = IndianGridConverter.gridToLatLong(
                      //           location.zone!,
                      //           location.easting!,
                      //           location.northing!);
                      //       // Move map to the location
                      //       if (latLng != null) {
                      //         widget.mapController.move(latLng, 15.0);
                      //         // Add marker through DrawingProvider
                      //         Provider.of<DrawingProvider>(context,
                      //                 listen: false)
                      //             .addSearchMarker(latLng);
                      //         // Call the callback
                      //         widget.onLocationSelected(latLng);
                      //       }
                      //     }
                      //   },
                      //   trailing: IconButton(
                      //     icon: Icon(Icons.delete),
                      //     onPressed: () async {
                      //       if (location.id != null) {
                      //         await LocationDatabase.instance
                      //             .deleteLocation(location.id!);
                      //         _loadLocations();
                      //       }
                      //     },
                      //   ),
                      // );
                    },
                  ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              mini: true,
              child: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _isAddingLocation = true;
                });
              },
            ),
          ),
        ] else ...[
          LocationAddForm(
            onSave: _addLocation,
            onCancel: () {
              setState(() {
                _isAddingLocation = false;
              });
            },
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------

class LocationListItem extends StatelessWidget {
  final StoredLocation location;
  final Function(LatLng) onLocationSelected;
  final Function() onDelete;
  final dynamic mapController; // Replace with correct type

  const LocationListItem({
    super.key,
    required this.location,
    required this.onLocationSelected,
    required this.onDelete,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return GestureDetector(
      onTap: () {
        
                  if (location.isWGS84 &&
              location.latitude != null &&
              location.longitude != null) {
            final latLng = LatLng(location.latitude!, location.longitude!);
            mapController.move(latLng, 15.0);
            Provider.of<DrawingProvider>(context, listen: false)
                .addSearchMarker(latLng);
            onLocationSelected(latLng);
          } else if (!location.isWGS84 &&
              location.zone != null &&
              location.easting != null &&
              location.northing != null) {
            final latLng = IndianGridConverter.gridToLatLong(
                location.zone!, location.easting!, location.northing!);
            if (latLng != null) {
              mapController.move(latLng, 15.0);
              Provider.of<DrawingProvider>(context, listen: false)
                  .addSearchMarker(latLng);
              onLocationSelected(latLng);
            }
          }
      },
      child: Container(
        constraints: BoxConstraints(
          minHeight: 70
        ),
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: EdgeInsets.all(  10),
        decoration: BoxDecoration(
      color: const Color.fromARGB(255, 255, 234, 203), // Background color
      borderRadius: BorderRadius.circular(12.r), // Rounded corners
      border: Border.all(color: Colors.orange, width: 2), // Border color
        ),
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          child: Icon(
            Icons.location_on,
            color: Colors.white,
            size: isTablet ? 10.sp : 15.sp,
          ),
        ),
      
        SizedBox(width: 12.w), // Spacing between icon and text
      
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                location.name,
                style: TextStyle(
                  fontSize: isTablet ? 4.sp : 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h), // Space between title and subtitle
              Text(
                location.isWGS84
                    ? 'LAT:${location.latitude}${degreeSymbol}, LNG:${location.longitude}${degreeSymbol}'
                    : '${location.zone}\n E: ${location.easting}, N: ${location.northing}',
                style: TextStyle(
                  fontSize: isTablet ? 4.sp : 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        // Spacer(),
      
        // Trailing Buttons (Delete & Navigate)
        SizedBox(
          // height: ,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
          
            children: [
              GestureDetector(
                onTap: () {
                  _confirmDelete(context);
                  
                },
                
                child: Icon(Icons.delete, color: Colors.black)),
                SizedBox(height: 15.h), // Space between title and subtitle
          
                Icon(Icons.navigate_next_rounded, color: my_orange)
              // IconButton(
              //   icon: Icon(Icons.delete, color: Colors.black),
              //   onPressed: () => _confirmDelete(context),
              // ),
              // IconButton(
              //   icon: Icon(Icons.navigate_next_rounded, color: my_orange),
              //   onPressed: () {},
              // ),
            ],
          ),
        ),
      ],
        ),
      ),
    );

  }
  //   return Card(
  //     color: const Color.fromARGB(255, 255, 234, 203),
  //     elevation: 0,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12.r),
  //       side: BorderSide(color: Colors.orange, width: 2), // Border
  //     ),
  //     child: ListTile(
  //       contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
  //       leading: Container(
  //         padding: EdgeInsets.all(5),
  //         decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //           color: Colors.black,
  //         ),
  //         child: Icon(
  //           Icons.location_on,
  //           color: const Color.fromARGB(255, 255, 255, 255),
  //           size: isTablet ? 10.sp : 15.sp,
  //         ),
  //       ),
  //       title: Text(
  //         location.name,
  //         style: TextStyle(
  //           fontSize: isTablet ? 8.sp : 16.sp,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       subtitle: Text(
  //         location.isWGS84
  //             ? '${location.latitude}, ${location.longitude}'
  //             : '${location.zone}\n E: ${location.easting}, N: ${location.northing}',
  //         style: TextStyle(
  //           fontSize: isTablet ? 5.sp : 16.sp,
  //           // fontSize: 14.sp,
  //           color: Colors.grey[600],
  //         ),
  //       ),
  //       onTap: () {
  //         if (location.isWGS84 &&
  //             location.latitude != null &&
  //             location.longitude != null) {
  //           final latLng = LatLng(location.latitude!, location.longitude!);
  //           mapController.move(latLng, 15.0);
  //           Provider.of<DrawingProvider>(context, listen: false)
  //               .addSearchMarker(latLng);
  //           onLocationSelected(latLng);
  //         } else if (!location.isWGS84 &&
  //             location.zone != null &&
  //             location.easting != null &&
  //             location.northing != null) {
  //           final latLng = IndianGridConverter.gridToLatLong(
  //               location.zone!, location.easting!, location.northing!);
  //           if (latLng != null) {
  //             mapController.move(latLng, 15.0);
  //             Provider.of<DrawingProvider>(context, listen: false)
  //                 .addSearchMarker(latLng);
  //             onLocationSelected(latLng);
  //           }
  //         }
  //       },
  //       trailing: Column(
  //         children: [
            
  //           IconButton(
  //           icon: Icon(
  //             Icons.delete,
  //             color: Colors.black,
  //           ),
  //           onPressed: () => _confirmDelete(context),
  //         ),
  //          IconButton(
  //           icon: Icon(
  //             Icons.navigate_next_rounded,
  //             color: Colors.black,
  //           ),
  //           onPressed: () =>{},
  //         )
          
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Delete Location?"),
          content: Text("Are you sure you want to delete this location?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text("Cancel", style: TextStyle(
                color: Colors.grey
              ),),
            ),
            TextButton(
              onPressed: () async {
                if (location.id != null) {
                  await LocationDatabase.instance.deleteLocation(location.id!);
                  onDelete();
                }
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                "Delete",
                style: TextStyle(color: my_orange),
              ),
            ),
          ],
        );
      },
    );
  }
}
