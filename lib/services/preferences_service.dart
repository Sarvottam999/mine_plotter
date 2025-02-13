// lib/services/preferences_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String keyShowLatLong = 'show_lat_long';
  static const String keyShowIndianGrid = 'show_indian_grid';
  static const String keySelectedZone = 'selected_zone';

  Future<bool> getShowLatLong() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyShowLatLong) ?? true;
  }

  Future<bool> getShowIndianGrid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyShowIndianGrid) ?? false;
  }

  Future<String> getSelectedZone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keySelectedZone) ?? 'Zone_IIB';
  }

  Future<void> setShowLatLong(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyShowLatLong, value);
  }

  Future<void> setShowIndianGrid(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyShowIndianGrid, value);
  }

  Future<void> setSelectedZone(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keySelectedZone, value);
  }
}