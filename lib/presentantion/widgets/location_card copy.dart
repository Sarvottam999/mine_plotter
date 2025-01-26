// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:myapp/presentantion/providers/dowanload_provider.dart';
// import 'package:provider/provider.dart';

// class LocationCard2 extends StatelessWidget {
//   final String? imageUrl; // For network image
//   final File? fileImage; // For file image
//   final String name;
//   final String time;
//   final String northEast;
//   final String southWest;
//   final VoidCallback onPressed;

//   LocationCard2({
//     this.imageUrl,
//     this.fileImage,
//     required this.name,
//     required this.time,
//     required this.northEast,
//     required this.southWest,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final screen_size = MediaQuery.of(context).size;
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 2.sp, horizontal: 2.sp),
//       decoration: BoxDecoration(
//         color: Colors.grey[900],
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: Row(
//         children: [
//           // Left Image Section
//           Expanded(
//             flex: 2,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8.sp),
//               child: fileImage != null
//                   ? Image.file(
//                       fileImage!,
//                       fit: BoxFit.cover,
//                       height: 200,
//                     )
//                   : Image.network(
//                       imageUrl ?? '',
//                       fit: BoxFit.cover,
//                       height: 200,
//                       errorBuilder: (context, error, stackTrace) => Icon(
//                           Icons.broken_image,
//                           size: 50,
//                           color: Colors.grey),
//                     ),
//             ),
//           ),
//           // Right Content Section
//           Expanded(
//             flex: 3,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title and Bookmark
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: screen_size.width * 0.5,
//                               child: Text(
//                                 name,
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 4),
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.access_time,
//                                   color: Colors.grey[400],
//                                   size: 16,
//                                 ),
//                                 SizedBox(width: 4),
//                                 Container(
//                                   width: screen_size.width * 0.15,
//                                   child: Text(
//                                     time,
//                                     style: TextStyle(
//                                       color: Colors.grey[400],
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: onPressed,
//                         icon: Icon(
//                           Icons.cancel_outlined,
//                           color: Colors.blue[400],
//                         ),
//                         padding: EdgeInsets.all(8),
//                         constraints: BoxConstraints(),
//                         iconSize: 24,
//                         splashRadius: 20,
//                       ),
//                     ],
//                   ),
//                   // Location Details
//                   SizedBox(height: 16),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[800],
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       spacing: 1,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           spacing: 2,
//                           children: [
//                             Container(
//                               alignment: Alignment.center,
//                               height: 10.w,
//                               width: 15.w,
//                               padding: EdgeInsets.all(1),
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(1.w)),
//                               child: Text("NE"),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 northEast,
//                                 style: TextStyle(
//                                     color: Colors.grey[300],
//                                     fontSize: 14, ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           spacing: 2,
//                           children: [
//                             Container(
//                               alignment: Alignment.center,
//                               height: 10.w,
//                           width: 15.w,
//                               padding: EdgeInsets.all(1),
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(1.w)),
//                               child: Text("SW"),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 southWest,
//                                 style: TextStyle(
//                                   color: Colors.grey[300],
//                                   fontSize: 14,
//                                   // overflow: TextOverflow.ellipsis
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   // // View Details Button
//                   // SizedBox(height: 16),
//                   // ElevatedButton(
//                   //   onPressed: () {},
//                   //   style: ElevatedButton.styleFrom(
//                   //     backgroundColor: Colors.blue[600],
//                   //     shape: RoundedRectangleBorder(
//                   //       borderRadius: BorderRadius.circular(16),
//                   //     ),
//                   //     padding: EdgeInsets.symmetric(vertical: 12),
//                   //   ),
//                   //   child: Center(
//                   //     child: Text(
//                   //       'View Details',
//                   //       style: TextStyle(fontSize: 16, color: Colors.white),
//                   //     ),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
