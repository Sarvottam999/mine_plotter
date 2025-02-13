import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/presentantion/providers/coordinate_provider.dart';
import 'package:myapp/presentantion/providers/dowanload_provider.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
import 'package:myapp/presentantion/screens/Settings/CoordinateSetting/cordinate_setting_screen.dart';
import 'package:myapp/presentantion/screens/map_screen/map_screen.dart';
import 'package:myapp/presentantion/widgets/build_fishbone_type_selector.dart';
import 'package:myapp/presentantion/widgets/drawing_button.dart';
import 'package:myapp/presentantion/widgets/selection_button.dart';
import 'package:myapp/services/preferences_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
 
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Map Drawing App',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: SafeArea(
      child: Scaffold(
        body: DrawingApp(),
      ),
    ),
  ));
}

class PermissionChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkStoragePermission(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While checking permission, show a loading spinner
          return Center(child: CircularProgressIndicator());
        }

        // if (snapshot.hasData && snapshot.data == PermissionStatus.granted) {
        // If permission is granted, load the main app
        return DrawingApp();
        // } else {
        //   // If permission is not granted, show the storage permission component
        //   return StoragePermissionComponent();
        // }
      },
    );
  }

  // Function to check the permission
  Future<PermissionStatus> _checkStoragePermission() async {
    return await Permission.storage.status;
  }
}

// ====================================================================================

class DrawingApp extends StatelessWidget {
  //   final LocationDatabase locationDB = LocationDatabase();
  // late final LocationService locationService;

  // DrawingApp() {
  //   locationService = LocationService(locationDB);
  //   _initializeLocations();
  // }

  // Future<void> _initializeLocations() async {
  //   if (await locationService.isFirstLaunch()) {
  //     if (await locationService.hasInternetConnection()) {
  //       await locationService.downloadAndSaveLocations();
  //     }
  //   }
  // }
  // const DrawingApp({super.key});
  @override
  Widget build(BuildContext context) {
  final prefsService = PreferencesService();

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => CoordinateProvider(prefsService)),
              ChangeNotifierProvider(create: (_) => DrawingProvider()),
              ChangeNotifierProvider(
                create: (_) => MapProvider(),
              ),

            ],
            child: MaterialApp(
                debugShowCheckedModeBanner: false, home: DrawingScreen()));
      },
      // child: DrawingScreen(), // Replace with your initial screen
    );
  }
}

class DrawingScreen extends StatelessWidget {
  DrawingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          MapScreen(),
          sideBaar(),
          bottomBar(),
          undoButtons(),
          FishboneTypeSelector(),
        ],
      ),
    );
  }

  Positioned bottomBar() {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<DrawingProvider>(
              builder: (context, provider, _) {
                final details = provider.getCurrentShapeDetails(context);
                print("details=============>${details}");
                if (details == null) return const SizedBox();

                return Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    // border: Border.all(width: 2),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: details.entries
                        .map(
                          (e) => Text(
                            '${e.key}: ${e.value}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Positioned sideBaar() {
    return Positioned(
      top: 0,
      left: 10,
      bottom: 0,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
            child: Column(
              spacing: 2,
              mainAxisSize: MainAxisSize.min,
              children: [
                DrawingButton(
                  icon: Icons.adjust,
                  label: 'Add Marker',
                  shapeType: ShapeType.point,

                  // selected: provider.isAddingMarker,
                ),
                DrawingButton(
                  icon: Icons.square_outlined,
                  label: 'Square',
                  shapeType: ShapeType.square,
                ),
                DrawingButton(
                  icon: Icons.line_axis,
                  label: 'Line',
                  shapeType: ShapeType.line,
                ),
                DrawingButton(
                  icon: Icons.circle_outlined,
                  label: 'Circle',
                  shapeType: ShapeType.circle,
                ),

                DrawingButton(
                  icon: Icons.timeline_sharp,
                  // image: Image.asset(
                  //   "assets/images/1.png",
                  //   height: 20,
                  //   width: 20,
                  // ),
                  label: 'Circle',
                  shapeType: ShapeType.fishbone,
                ),


                //  DrawingButton(
                //   icon: Icons.living,
                //   image: Image.asset("assets/images/2.png", height: 30, width: 30,),
                //   label: 'Circle',
                //   shapeType: ShapeType.fishbone,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Positioned undoButtons() {
    return Positioned(
      bottom: 10,
      left: 10,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<DrawingProvider>(
                builder: (context, provider, _) => IconButton(
                  icon: const Icon(
                    Icons.redo,
                    size: 18,
                  ),
                  onPressed: provider.canRedo ? provider.redo : null,
                  tooltip: 'Redo',
                ),
              ),
              Consumer<DrawingProvider>(
                builder: (context, provider, _) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.undo,
                        size: 18,
                      ),
                      onPressed: provider.canUndo ? provider.undo : null,
                      tooltip: 'Undo',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
