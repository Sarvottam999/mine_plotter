// lib/providers/coordinate_provider.dart

import 'package:flutter/foundation.dart';
import 'package:myapp/services/preferences_service.dart';

class CoordinateProvider extends ChangeNotifier {
  final PreferencesService _prefs;
  
  bool _showLatLong = true;
  bool _showIndianGrid = false;
  String _selectedZone = 'Zone_IIB';

  CoordinateProvider(this._prefs) {
    _loadPreferences();
  }

  // Getters
  bool get showLatLong => _showLatLong;
  bool get showIndianGrid => _showIndianGrid;
  String get selectedZone => _selectedZone;

  // Load saved preferences
  Future<void> _loadPreferences() async {
    _showLatLong = await _prefs.getShowLatLong();
    _showIndianGrid = await _prefs.getShowIndianGrid();
    _selectedZone = await _prefs.getSelectedZone();
    notifyListeners();
  }

  // Update methods
  Future<void> setShowLatLong(bool value) async {
    _showLatLong = value;
    if (!value && !_showIndianGrid) {
      _showIndianGrid = true;
      await _prefs.setShowIndianGrid(true);
    }
    await _prefs.setShowLatLong(value);
    notifyListeners();
  }

  Future<void> setShowIndianGrid(bool value) async {
    _showIndianGrid = value;
    if (!value && !_showLatLong) {
      _showLatLong = true;
      await _prefs.setShowLatLong(true);
    }
    await _prefs.setShowIndianGrid(value);
    notifyListeners();
  }

  Future<void> setSelectedZone(String value) async {
    _selectedZone = value;
    await _prefs.setSelectedZone(value);
    notifyListeners();
  }
}