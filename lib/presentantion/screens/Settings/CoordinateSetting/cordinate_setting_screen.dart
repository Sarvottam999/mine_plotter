// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:myapp/presentantion/providers/coordinate_provider.dart';
import 'package:myapp/utils/indian_grid_converter.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<CoordinateProvider>(
        builder: (context, provider, _) {
          return ListView(
            children: [
              SwitchListTile(
                activeTrackColor: Colors.black,
                inactiveTrackColor: Colors.white,
                activeColor: Colors.yellow,
                title: Text('Show Latitude/Longitude'),
                subtitle: Text('Display coordinates in Lat/Long format'),
                value: provider.showLatLong,
                onChanged: (value) => provider.setShowLatLong(value),
              ),
              SwitchListTile(
                activeTrackColor: Colors.black,
                inactiveTrackColor: Colors.white,
                activeColor: Colors.yellow,
                title: Text('Show Indian Grid'),
                subtitle: Text('Display coordinates in Indian Grid format'),
                value: provider.showIndianGrid,
                onChanged: (value) => provider.setShowIndianGrid(value),
              ),
              if (provider.showIndianGrid) ...[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black54,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Select Zone',
                    ),
                    value: provider.selectedZone,
                    items: IndianGridConverter.zoneDefinitions.keys
                        .map((String zone) {
                      return DropdownMenuItem(
                        value: zone,
                        child: Text(zone.replaceAll('_', ' ')),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        provider.setSelectedZone(value);
                      }
                    },
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
