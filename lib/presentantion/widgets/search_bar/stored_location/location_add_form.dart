import 'package:flutter/material.dart';
import 'package:myapp/molecules/Buttons/outline_filled_button.dart';
import 'package:myapp/presentantion/screens/SettingScreen/models/stored_location.dart';
import 'package:myapp/utils/indian_grid_converter.dart';

class LocationAddForm extends StatefulWidget {
  final Function(StoredLocation) onSave;
  final VoidCallback onCancel;

  const LocationAddForm({
    Key? key,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<LocationAddForm> createState() => _LocationAddFormState();
}

class _LocationAddFormState extends State<LocationAddForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _eastingController = TextEditingController();
  final _northingController = TextEditingController();
  bool _isWGS84 = true;
  String _selectedZone = IndianGridConverter.zoneNames.first;

  @override
  void dispose() {
    _nameController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _eastingController.dispose();
    _northingController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final location = StoredLocation(
        name: _nameController.text,
        isWGS84: _isWGS84,
        latitude: _isWGS84 ? double.parse(_latController.text) : null,
        longitude: _isWGS84 ? double.parse(_lngController.text) : null,
        zone: !_isWGS84 ? _selectedZone : null,
        easting: !_isWGS84 ? double.parse(_eastingController.text) : null,
        northing: !_isWGS84 ? double.parse(_northingController.text) : null,
      );
      widget.onSave(location);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add New Location',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Location Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: true,
                label: Text('WGS84'),
              ),
              ButtonSegment(
                value: false,
                label: Text('Indian Grid'),
              ),
            ],
            selected: {_isWGS84},
            onSelectionChanged: (Set<bool> selected) {
              setState(() {
                _isWGS84 = selected.first;
              });
            },
          ),
          SizedBox(height: 16),
          if (_isWGS84) ...[
            TextFormField(
              controller: _latController,
              decoration: InputDecoration(
                labelText: 'Latitude',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
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
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                final lng = double.tryParse(value);
                if (lng == null || lng < -180 || lng > 180) {
                  return 'Invalid longitude';
                }
                return null;
              },
            ),
          ] else ...[
            DropdownButtonFormField<String>(
              value: _selectedZone,
              decoration: InputDecoration(
                labelText: 'Zone',
                border: OutlineInputBorder(),
              ),
              items: IndianGridConverter.zoneNames.map((zone) {
                return DropdownMenuItem(
                  value: zone,
                  child: Text(IndianGridConverter.getReadableZoneName(zone)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedZone = value;
                  });
                }
              },
            ),
            SizedBox(height: 8),
            Row(
              children: [
                  Expanded(
                    child: TextFormField(
                                  controller: _eastingController,
                                  decoration: InputDecoration(
                                    labelText: 'Easting (meters)',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return 'Required';
                                    if (double.tryParse(value) == null) return 'Invalid number';
                                    return null;
                                  },
                                ),
                  ),
            SizedBox(width: 18),
            Expanded(
              child: TextFormField(
                controller: _northingController,
                decoration: InputDecoration(
                  labelText: 'Northing (meters)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
            ),

              ],
            ),
          
          ],
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: widget.onCancel,
                child: Text('Cancel', style: TextStyle(
                  color: Colors.black
                ),),
              ),
              SizedBox(width: 8),
               NButtonOutline(
                            label: 'Save',
                            // icon: Icons.add,  // Optional icon
                            isSelected: true,
                            color: Colors.black, // Optional custom color
                            onPressed: _handleSave,
                          ),

              
              // ElevatedButton(
              //   onPressed: _handleSave,
              //   child: Text('Save'),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
