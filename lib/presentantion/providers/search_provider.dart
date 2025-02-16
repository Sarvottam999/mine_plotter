// lib/providers/search_provider.dart
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class SearchProvider with ChangeNotifier {
  bool _isSearchMode = false;
  String _searchType = 'wgs84'; // 'wgs84' or 'igs'

  // expanding
  bool _isExpanded = false;
bool get isExpanded => _isExpanded;


  bool get isSearchMode => _isSearchMode;
  String get searchType => _searchType;

  void toggleSearchMode() {
    _isSearchMode = !_isSearchMode;
    notifyListeners();
  }

  void setSearchType(String type) {
    _searchType = type;
    notifyListeners();
  }


  void toggleExpanded() {
  _isExpanded = !_isExpanded;
  notifyListeners();
}
}