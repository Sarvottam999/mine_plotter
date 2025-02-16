// lib/widgets/coordinate_search.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/molecules/Buttons/icon_button.dart';
import 'package:myapp/molecules/Buttons/outline_filled_button.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
import 'package:myapp/presentantion/providers/search_provider.dart';
import 'package:myapp/presentantion/widgets/collapsed_search_view.dart';
import 'package:myapp/presentantion/widgets/stored_locations_list_view.dart';
import 'package:myapp/utils/indian_grid_converter.dart';
import 'package:provider/provider.dart';
import '../providers/coordinate_provider.dart';

class CoordinateSearch extends StatefulWidget {
  final MapController mapController;

  const CoordinateSearch({
    Key? key,
    required this.mapController,
  }) : super(key: key);

  @override
  State<CoordinateSearch> createState() => _CoordinateSearchState();
}

class _CoordinateSearchState extends State<CoordinateSearch> {
  final _formKey = GlobalKey<FormState>();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _eastingController = TextEditingController();
  final _northingController = TextEditingController();
  bool _isWGS84 = true;
    bool _isStoredLocations = false;


  void _searchLocation() {
    if (!_formKey.currentState!.validate()) return;

    LatLng? targetLocation;

    if (_isWGS84) {
      // WGS84 search
      double lat = double.parse(_latController.text);
      double lng = double.parse(_lngController.text);
      targetLocation = LatLng(lat, lng);
    } else {
      // IGS search
      final provider = context.read<CoordinateProvider>();
      double easting = double.parse(_eastingController.text);
      double northing = double.parse(_northingController.text);

      targetLocation = IndianGridConverter.gridToLatLong(
        provider.selectedZone,
        easting,
        northing,
      );
    }

    if (targetLocation != null) {
      widget.mapController.move(targetLocation, 15.0);
      Provider.of<DrawingProvider>(context, listen: false)
          .addSearchMarker(targetLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen_size = MediaQuery.of(context).size;

    return Consumer<SearchProvider>(builder: (context, searchProvider, _) {
      return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          width: screen_size.width * 0.8,
          child: Card(
            color: Colors.white,
            margin: EdgeInsets.all(8),
            child: !searchProvider.isExpanded
                ? CollapsedSearchView(
                    onTap: () => searchProvider.toggleExpanded(),
                  )
                : Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           SegmentedButton<String>(
                            showSelectedIcon:false,
                            style: ButtonStyle(
                              iconColor: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.white;
                                  }
                                  return Colors.black;
                                },
                              ),
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.black;
                                  }
                                  return Colors.white;
                                },
                              ),
                              foregroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.white;
                                  }
                                  return Colors.black;
                                },
                              ),
                            ),
                            segments: const [
                               ButtonSegment(
                              value: 'wgs84',
                              label: Text('WGS84'),
                            ),
                            ButtonSegment(
                              value: 'indian',
                              label: Text('Indian Grid'),
                            ),
                            ButtonSegment(
                              value: 'stored',
                              label: Text('Stored'),
                            ),
                              
                            ],
                           selected: {_isStoredLocations ? 'stored' : (_isWGS84 ? 'wgs84' : 'indian')},
                          onSelectionChanged: (Set<String> selected) {
                            setState(() {
                              if (selected.first == 'stored') {
                                _isStoredLocations = true;
                                _isWGS84 = true;
                              } else {
                                _isStoredLocations = false;
                                _isWGS84 = selected.first == 'wgs84';
                              }
                            });
                          },
                        ),
                          SizedBox(height: 16),

                           if (_isStoredLocations)
                          Container(
                              // height: 200,
 
                            child: StoredLocationsView(
                              mapController: widget.mapController,
                              onLocationSelected: (location) {
                                widget.mapController.move(location, 15.0);
                                Provider.of<DrawingProvider>(context, listen: false)
                                    .addSearchMarker(location);
                              },
                            ),
                          )
                          else
                          // Coordinate inputs
                          if (_isWGS84) ...[
                            TextFormField(
                              controller: _latController,
                              decoration: InputDecoration(
                                labelText: 'Latitude',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Required';
                                final lat = double.tryParse(value);
                                if (lat == null || lat < -90 || lat > 90) {
                                  return 'Invalid latitude';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: _lngController,
                              decoration: InputDecoration(
                                labelText: 'Longitude',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Required';
                                final lng = double.tryParse(value);
                                if (lng == null || lng < -180 || lng > 180) {
                                  return 'Invalid longitude';
                                }
                                return null;
                              },
                            ),
                             NButtonOutline(
                            label: 'Search',
                            // icon: Icons.add,  // Optional icon
                            isSelected: true,
                            color: Colors.black, // Optional custom color
                            onPressed: _searchLocation,
                          ),
                          ] else ...[
                            Consumer<CoordinateProvider>(
                              builder: (context, provider, _) =>
                                  DropdownButtonFormField<String>(
                                value: provider.selectedZone,
                                decoration: InputDecoration(
                                  labelText: 'Zone',
                                  border: OutlineInputBorder(),
                                ),
                                items:
                                    IndianGridConverter.zoneNames.map((zone) {
                                  return DropdownMenuItem(
                                    value: zone,
                                    child: Text(
                                        IndianGridConverter.getReadableZoneName(
                                            zone)),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    provider.setSelectedZone(value);
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: _eastingController,
                              decoration: InputDecoration(
                                labelText: 'Easting (meters)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Required';
                                return null;
                              },
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: _northingController,
                              decoration: InputDecoration(
                                labelText: 'Northing (meters)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Required';
                                return null;
                              },
                            ),
                              NButtonOutline(
                            label: 'Search',
                            // icon: Icons.add,  // Optional icon
                            isSelected: true,
                            color: Colors.black, // Optional custom color
                            onPressed: _searchLocation,
                          ),
                          ],
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              searchProvider.toggleExpanded();
                            },
                            child: Container(
                              height: 30,
                              color: Colors.white,
                              width: screen_size.width,
                              child: Icon(Icons.expand_less_outlined),
                            ),
                          )
                          // bool _isSelected = false;
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    _eastingController.dispose();
    _northingController.dispose();
    super.dispose();
  }
}
