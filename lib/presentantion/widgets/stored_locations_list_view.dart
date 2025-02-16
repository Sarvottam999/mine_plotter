import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:myapp/database/location_database.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
import 'package:myapp/presentantion/screens/SettingScreen/models/stored_location.dart';
import 'package:myapp/presentantion/widgets/search_bar/stored_location/location_add_form.dart';
import 'package:myapp/utils/indian_grid_converter.dart';
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
  List<StoredLocation> _locations = [];

  @override
  void initState() {
    super.initState();
    _loadLocations();
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
    return  Container(
      // color: CupertinoColors.activeGreen,
      height: 390,
      // width: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_isAddingLocation) ...[
            Expanded(
              child: ListView.builder(
                itemCount: _locations.length,
                itemBuilder: (context, index) {
                  final location = _locations[index];
                  return ListTile(
                    title: Text(location.name),
                    subtitle: Text(location.isWGS84
                        ? '${location.latitude}, ${location.longitude}'
                        : '${location.zone} - E: ${location.easting}, N: ${location.northing}'),
                    // onTap: () {
                    //   if (location.isWGS84 && location.latitude != null && location.longitude != null) {
                    //     final latLng = LatLng(location.latitude!, location.longitude!);
                    //     widget.onLocationSelected(latLng);
                    //   }
                    // },
                    onTap: () {
  if (location.isWGS84 && location.latitude != null && location.longitude != null) {
    final latLng = LatLng(location.latitude!, location.longitude!);
    // Move map to the location
    widget.mapController.move(latLng, 15.0);
    // Add marker through DrawingProvider
    Provider.of<DrawingProvider>(context, listen: false).addSearchMarker(latLng);
    // Call the callback
    widget.onLocationSelected(latLng);
  } else if (!location.isWGS84 && location.zone != null && 
           location.easting != null && location.northing != null) {
    // Convert Indian Grid coordinates to LatLng
    final latLng = IndianGridConverter.gridToLatLong(
      location.zone!,
      location.easting!,
      location.northing!
    );
    // Move map to the location
    if (latLng  != null){
        widget.mapController.move(latLng, 15.0);
    // Add marker through DrawingProvider
    Provider.of<DrawingProvider>(context, listen: false).addSearchMarker(latLng);
    // Call the callback
    widget.onLocationSelected(latLng);

    }
  
  }
},
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        if (location.id != null) {
                          await LocationDatabase.instance.deleteLocation(location.id!);
                          _loadLocations();
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
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
      ),
    
    );
  }
}
