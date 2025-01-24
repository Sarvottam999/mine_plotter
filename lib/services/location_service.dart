// lib/services/location_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:myapp/database/location_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  static const String _firstLaunchKey = 'is_first_launch';
  final LocationDatabase locationDatabase;

  LocationService(this.locationDatabase);

  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstLaunchKey) ?? true;
  }

  Future<void> markFirstLaunchComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, false);
  }

  Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<void> downloadAndSaveLocations() async {
    try {
      // Download major cities
      await _downloadCities();
      
      // Download landmarks
      await _downloadLandmarks();
      
      // Mark first launch complete
      await markFirstLaunchComplete();
    } catch (e) {
      print('Error downloading locations: $e');
      // Don't mark first launch complete if download fails
    }
  }

  Future<void> _downloadCities() async {
    // Using Nominatim API to get major cities
    final response = await http.get(
      Uri.parse('https://nominatim.openstreetmap.org/search?format=json&limit=50&featuretype=city'),
      headers: {'Accept-Language': 'en-US,en;q=0.9'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> cities = json.decode(response.body);
      
      for (var city in cities) {
        await locationDatabase.addLocation({
          'display_name': city['display_name'],
          'lat': double.parse(city['lat']),
          'lon': double.parse(city['lon']),
          'type': 'city',
          'region': _extractRegion(city['display_name']),
        });
      }
      
      // Add delay to respect API rate limits
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<void> _downloadLandmarks() async {
    // Using Nominatim API to get landmarks
    final response = await http.get(
      Uri.parse('https://nominatim.openstreetmap.org/search?format=json&limit=50&featuretype=landmark'),
      headers: {'Accept-Language': 'en-US,en;q=0.9'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> landmarks = json.decode(response.body);
      
      for (var landmark in landmarks) {
        await locationDatabase.addLocation({
          'display_name': landmark['display_name'],
          'lat': double.parse(landmark['lat']),
          'lon': double.parse(landmark['lon']),
          'type': 'landmark',
          'region': _extractRegion(landmark['display_name']),
        });
      }
    }
  }

  String _extractRegion(String displayName) {
    // Simple region extraction from display name
    final parts = displayName.split(',');
    if (parts.length >= 2) {
      return parts[parts.length - 1].trim();
    }
    return 'Unknown';
  }
}