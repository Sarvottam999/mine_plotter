// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// class StoragePermissionComponent extends StatefulWidget {
//   @override
//   _StoragePermissionComponentState createState() =>
//       _StoragePermissionComponentState();
// }

// class _StoragePermissionComponentState
//     extends State<StoragePermissionComponent> {
//   PermissionStatus? _status;

//   @override
//   void initState() {
//     super.initState();
//     _checkPermission();
//   }

//   // Check current storage permission status
//   Future<void> _checkPermission() async {
//     PermissionStatus status = await Permission.manageExternalStorage.status;
//     setState(() {
//       _status = status;
//     });
//   }

//   // Request storage permission
//   Future<void> _requestPermission() async {
//     PermissionStatus status = await Permission.manageExternalStorage.request();
//     setState(() {
//       _status = status;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Storage Permission"),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (_status == null)
//                 CircularProgressIndicator() // Show loading indicator if permission status is being checked
//               else if (_status == PermissionStatus.granted)
//                 Text(
//                   "Storage permission granted!",
//                   style: TextStyle(fontSize: 18, color: Colors.green),
//                 )
//               else if (_status == PermissionStatus.denied)
//                 Column(
//                   children: [
//                     Text(
//                       "Storage permission is denied.",
//                       style: TextStyle(fontSize: 18, color: Colors.red),
//                     ),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: _requestPermission,
//                       child: Text("Request Permission"),
//                     ),
//                   ],
//                 )
//               else if (_status == PermissionStatus.permanentlyDenied)
//                 Column(
//                   children: [
//                     Text(
//                       "Storage permission is permanently denied.",
//                       style: TextStyle(fontSize: 18, color: Colors.red),
//                     ),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: () {
//                         openAppSettings(); // Opens app settings to allow the user to enable the permission manually
//                       },
//                       child: Text("Open App Settings"),
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// flutter code 
