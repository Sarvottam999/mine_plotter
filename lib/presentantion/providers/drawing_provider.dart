import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/core/enum/fishbone_type.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/domain/entities/circle_shape.dart';
import 'package:myapp/domain/entities/fishbone_shape.dart';
import 'package:myapp/domain/entities/line_shape.dart';
import 'package:myapp/domain/entities/marker_point.dart';
import 'package:myapp/domain/entities/shape.dart';
import 'package:myapp/domain/entities/square_shape.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Replace the simple shape lists with a state class
 

class DrawingState {
  final List<Shape> shapes;
  final List<LatLng> markers;

  DrawingState({
    required this.shapes,
    required this.markers,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'shapes': shapes.map((shape) => shape.toJson()).toList(),
      'markers': markers.map((marker) => {'lat': marker.latitude, 'lng': marker.longitude}).toList(),
    };
  }

  // Create from JSON
  // factory DrawingState.fromJson(Map<String, dynamic> json) {
  //   return DrawingState(
  //     shapes: (json['shapes'] as List).map((shape) => Shape.fromJson(shape)).toList(),
  //     markers: (json['markers'] as List).map((m) => LatLng(m['lat'], m['lng'])).toList(),
  //   );
  // }
  factory DrawingState.fromJson(Map<String, dynamic> json) {
  return DrawingState(
    shapes: (json['shapes'] as List?)?.map((shape) => Shape.fromJson(shape)).toList() ?? [],
    markers: (json['markers'] as List?)?.map((m) => LatLng(m['lat'], m['lng'])).toList() ?? [],
  );
}

}



class DrawingProvider with ChangeNotifier {
  ShapeType _currentShape = ShapeType.none;
  List<Shape> _shapes = [];
  List<LatLng> _currentPoints = [];
  LatLng? _currentCursor;
  FishboneType _currentFishboneType = FishboneType.strip_anti_personal;

  bool isSelectionMode = false;
  bool isEditMode = false;
  int? selectedPointIndex;

  // ---
    Shape? _selectedShape;

  bool _isEditing = false;
  bool get isEditing => _isEditing;
  Shape? get selectedShape => _selectedShape;

//----------------------  pointer
  List<LatLng> _markers = [];
  bool _isAddingMarker = false;
  void updateMarkerPosition1(LatLng newPosition) {
    _markerPosition = newPosition;
    notifyListeners();
  }

  //------------ dragable map pointer ------------
    LatLng? _markerPosition;
      LatLng? get markerPosition => _markerPosition;



 // Add getters
  List<LatLng> get markers => _markers;
  bool get isAddingMarker => _isAddingMarker;
void toggleMarkerMode() {
    _isAddingMarker = !_isAddingMarker;
    if (_isAddingMarker) {
      _currentShape = ShapeType.none;
    }
    notifyListeners();
  }
  void addMarker(LatLng position) {
  // Save current state before making changes
  _undoStack.add(DrawingState(
    shapes: List.from(_shapes),
    markers: List.from(_markers),
  ));
  _redoStack.clear(); // Clear redo stack when new action is performed

  _markers.add(position);
  _isAddingMarker = false;
  _currentShape = ShapeType.none;
      updateCurrentState();


  notifyListeners();
}
    void updateMarkerPosition(int index, LatLng newPosition) {
    if (index < 0 || index >= _markers.length) return;
    
    notifyListeners();
  }

  void removeMarker(int index) {
    if (index < 0 || index >= _markers.length) return;
    _markers.removeAt(index);
    notifyListeners();
  }
  
  // --------------------------------------------


final List<DrawingState> _undoStack = [];
final List<DrawingState> _redoStack = [];

// void _saveCurrentState() {
//   _undoStack.add(DrawingState(
//     shapes: List.from(_shapes),
//     markers: List.from(_markers),
//   ));
//   _redoStack.clear();
// }


  ShapeType get currentShape => _currentShape;
  List<Shape> get shapes => _shapes;
  List<LatLng> get currentPoints => _currentPoints;
  LatLng? get currentCursor => _currentCursor;

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  FishboneType get currentFishboneType => _currentFishboneType;
  void setFishboneType(FishboneType type) {
    _currentFishboneType = type;
    notifyListeners();
  }


  void setCurrentShape(ShapeType type) {
    if (_isEditing) {
      _isEditing = false;
      _selectedShape = null;
    }
    _isAddingMarker = type == ShapeType.marker;

    _currentShape = type;
    _currentPoints = [];
    notifyListeners();
  }

  void addPoint(LatLng point) {
    _currentPoints.add(point);

    if (_currentPoints.length == 2) {
      Shape? newShape;

      switch (_currentShape) {
        case ShapeType.line:
          newShape = LineShape(points: List.from(_currentPoints));
          break;
        case ShapeType.square:
          newShape = SquareShape(points: List.from(_currentPoints));
          break;
        case ShapeType.circle:
          newShape = CircleShape(points: List.from(_currentPoints));
          break; 
        case ShapeType.fishbone:
          newShape = FishboneShape(
            points: List.from(_currentPoints),
            fishboneType: _currentFishboneType,
          );
          break;
        default:
          break;
      }

      
          if (newShape != null) {
      // Save current state to undo stack before adding new shape
      _undoStack.add(DrawingState(
        shapes: List.from(_shapes),
        markers: List.from(_markers),
      ));
      _redoStack.clear();

      _shapes.add(newShape);
      
      _currentPoints = [];
      _currentShape = ShapeType.none;

      updateCurrentState();

    }

    }

    notifyListeners();
  }


  void undo() {
  if (_undoStack.isEmpty) return;

  // Save current state to redo stack
  _redoStack.add(DrawingState(
    shapes: List.from(_shapes),
    markers: List.from(_markers),
  ));

  // Restore previous state
  final previousState = _undoStack.removeLast();
  _shapes = List.from(previousState.shapes);
  _markers = List.from(previousState.markers);
  
  notifyListeners();
}

void redo() {
  if (_redoStack.isEmpty) return;

  // Save current state to undo stack
  _undoStack.add(DrawingState(
    shapes: List.from(_shapes),
    markers: List.from(_markers),
  ));

  // Restore next state
  final nextState = _redoStack.removeLast();
  _shapes = List.from(nextState.shapes);
  _markers = List.from(nextState.markers);
  
  notifyListeners();
}

  void updateCursor(LatLng? point) {
    _currentCursor = point;
    notifyListeners();
  }

  Map<String, dynamic>? getCurrentShapeDetails(BuildContext context) {
    if (_currentShape == ShapeType.none) return null;

    List<LatLng> points = List.from(_currentPoints);
    if (_currentCursor != null && _currentPoints.isNotEmpty) {
      points.add(_currentCursor!);
    }

    Shape tempShape;
    switch (_currentShape) {
      case ShapeType.line:
        tempShape = LineShape(points: points);
        break;
      case ShapeType.square:
        tempShape = SquareShape(points: points);
        break;
      case ShapeType.circle:
        tempShape = CircleShape(points: points);
        break;
      
      default:
        return null;
    }

    Map<String, dynamic> details = tempShape.getDetails(context);
    if (_currentCursor != null) {
      details['cursor'] =
          '${_currentCursor!.latitude.toStringAsFixed(6)}, ${_currentCursor!.longitude.toStringAsFixed(6)}';
    }

    return details;
  }


  //  edit delete  =====================   Add these new methods
  void toggleSelectionMode(LatLng? centerPosition) {
    if (!isSelectionMode) {
      _markerPosition = centerPosition;
    }
    isSelectionMode = !isSelectionMode;
    if (!isSelectionMode) {
      _selectedShape = null;
    }
    _currentShape = ShapeType.none;
    notifyListeners();
  }

   void selectShape(Shape? shape) {
    _selectedShape = shape;
    _isEditing = true;
    _currentShape = ShapeType.none;
    notifyListeners();
  }


  
  void cancelEdit() {
    _selectedShape = null;
    _isEditing = false;
    notifyListeners();
  }

  void updateShapePoints(List<LatLng> newPoints) {
    if (_selectedShape != null) {
      int index = _shapes.indexOf(_selectedShape!);
      if (index != -1) {
        _shapes[index].points = newPoints;
        notifyListeners();
      }
    }
  }

  void deleteSelectedShape() {
    if (_selectedShape != null) {
      _shapes.remove(_selectedShape);
      _selectedShape = null;
      _isEditing = false;
      notifyListeners();
    }
  }

  // =================  edit shape ======================
  // Add new methods
  void startEditing() {
    isEditMode = true;
    notifyListeners();
  }

  void stopEditing() {
    isEditMode = false;
    selectedPointIndex = null;
    notifyListeners();
  }

  void updatePointPosition(LatLng newPosition) {
    if (selectedShape != null && selectedPointIndex != null) {
      selectedShape!.points[selectedPointIndex!] = newPosition;
      notifyListeners();
    }
  }

  // -------------- for search functionality -------------
  void addSearchMarker(LatLng position) {
  _markers.add(position);
  notifyListeners();
}

// =================  state =============

  List<DrawingState> _savedStates = [];
  List<String> _pageNames = []; // Store names for each page
  int _currentStateIndex = -1;

  List<DrawingState> get savedStates => _savedStates;
  List<String> get pageNames => _pageNames; // Getter for page names
  int get currentStateIndex => _currentStateIndex;

  void saveCurrentState() {
    _savedStates.add(DrawingState(
      shapes: List.from(_shapes),
      markers: List.from(_markers),
    ));
    _pageNames.add("Page ${_savedStates.length}"); // Default name
    _currentStateIndex = _savedStates.length - 1;
      saveData(); // Save changes

    notifyListeners();
  }

  void renamePage(int index, String newName) {
    if (index >= 0 && index < _pageNames.length) {
      _pageNames[index] = newName;
      saveData(); // Save changes

      
      notifyListeners();
    }
  }

  void deleteState(int index) {
    if (index < 0 || index >= _savedStates.length) return;

    _savedStates.removeAt(index);
    _pageNames.removeAt(index);

    if (_currentStateIndex == index) {
      _currentStateIndex = -1;
      _shapes.clear();
      _markers.clear();
    } else if (_currentStateIndex > index) {
      _currentStateIndex--;
    }

    notifyListeners();
  }

  void createNewState() {
    _shapes.clear();
    _markers.clear();
    _currentStateIndex = -1;
    saveCurrentState();
    notifyListeners();
  }
      void switchToState(int index) {
    if (index < 0 || index >= _savedStates.length) return;
    _currentStateIndex = index;
    _shapes = List.from(_savedStates[index].shapes);
    _markers = List.from(_savedStates[index].markers);
    notifyListeners();
  }
    void updateCurrentState() {
  if (_currentStateIndex != -1) {
    _savedStates[_currentStateIndex] = DrawingState(
      shapes: List.from(_shapes),
      markers: List.from(_markers),
    );
      saveData(); // Save changes

    notifyListeners();
  }
}
 

Future<void> saveData() async {
  print("########## saving ");

  try {
    final file = await _getLocalFile();
    
    // Convert the saved states and page names to a JSON string
    Map<String, dynamic> data = {
      'savedStates': _savedStates.map((state) => state.toJson()).toList(),
      'pageNames': _pageNames,
      'currentStateIndex': _currentStateIndex
    };

    String jsonString = jsonEncode(data);
    
    // Write to the file
    await file.writeAsString(jsonString);

    print("########## Saved successfully!");
  } catch (e) {
    print("Error saving data: $e");
  }
}


// Future<void> loadData() async {
//   print("########## loding ");
//   final prefs = await SharedPreferences.getInstance();

//   List<String>? savedStatesJson = prefs.getStringList('savedStates');
//   List<String>? pageNamesJson = prefs.getStringList('pageNames');
//   int? savedIndex = prefs.getInt('currentStateIndex');
//   print("## ${savedStatesJson}");
//   print("## ${pageNamesJson}");
//   print("## ${savedIndex}");

//   if (savedStatesJson != null && pageNamesJson != null) {
//     _savedStates = savedStatesJson.map((json) => DrawingState.fromJson(jsonDecode(json))).toList();
//   print("-- 1${_savedStates}");

//     _pageNames = List.from(pageNamesJson);
//   print("-- 1${_pageNames}");

//     _currentStateIndex = savedIndex ?? -1;
//   print("-- 1${_currentStateIndex}");


//       if (_currentStateIndex >= 0 && _currentStateIndex < _savedStates.length) {
//     print("== ${_savedStates} ${_savedStates[_currentStateIndex]}, ${_savedStates[_currentStateIndex].shapes}");

//       _shapes = List.from(_savedStates[_currentStateIndex].shapes);
//   print("-- 2${_shapes} - ${_savedStates[_currentStateIndex].shapes}");

//       _markers = List.from(_savedStates[_currentStateIndex].markers);
//   print("-- 3${_markers} - ${_savedStates[_currentStateIndex].shapes}");

//     } else {
//       _shapes = [];
//       _markers = [];
//     }


 

//     notifyListeners();
//   }
// }

Future<void> loadData() async {
  print("########## loading ");

  try {
    final file = await _getLocalFile();
    print("1 -- file -- ${file}");

    if (!await file.exists()) {
      print("No saved file found.");
      return;
    }

    // Read file as string
    String jsonString = await file.readAsString();

    // Decode JSON
    Map<String, dynamic> data = jsonDecode(jsonString);

    print("1 -- data -- ${data}");


    // Convert JSON back into Dart objects
    _savedStates = (data['savedStates'] as List)
        .map((json) => DrawingState.fromJson(json))
        .toList();
    print("1 -- _savedStates -- ${_savedStates}");


    _pageNames = List<String>.from(data['pageNames']);
    _currentStateIndex = data['currentStateIndex'] ?? -1;
    print("1 -- _currentStateIndex -- ${_currentStateIndex}");
          if (_currentStateIndex >= 0 && _currentStateIndex < _savedStates.length) {
    print("== ${_savedStates} ${_savedStates[_currentStateIndex]}, ${_savedStates[_currentStateIndex].shapes}");

      _shapes = List.from(_savedStates[_currentStateIndex].shapes);
  print("-- 2${_shapes} - ${_savedStates[_currentStateIndex].shapes}");

      _markers = List.from(_savedStates[_currentStateIndex].markers);
  print("-- 3${_markers} - ${_savedStates[_currentStateIndex].shapes}");

    } else {
      _shapes = [];
      _markers = [];
    }



    print("########## Loaded successfully!");
    notifyListeners();
  } catch (e) {
    print("Error loading data: $e");
  }
}


 



}


Future<File> _getLocalFile() async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/drawing_states.json');
}
