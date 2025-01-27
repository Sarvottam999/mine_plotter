// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:myapp/presentantion/providers/dowanload_provider.dart';
// import 'package:provider/provider.dart';

// class LocationCard extends StatelessWidget {
//   final String? imageUrl; // For network image
//   final File? fileImage; // For file image
//   final String name;
//   final String time;
//   final String northEast;
//   final String southWest;
//   final String areaSqKm;
//   final VoidCallback onPressed;
//   final VoidCallback onMapSelect;

//   LocationCard({
//     this.imageUrl,
//     this.fileImage,
//     required this.name,
//     required this.time,
//     required this.northEast,
//     required this.southWest,
//     required this.onPressed,
//     required this.areaSqKm,
//     required this.onMapSelect,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final screen_size = MediaQuery.of(context).size;
//     final isTablet = MediaQuery.of(context).size.width > 600;
//     print("======================= ${isTablet}");

//     return Stack(
//       children: [
//         Container(
//           width:! isTablet ?screen_size.width  : null,
//           margin: EdgeInsets.symmetric(horizontal: 5),
//           padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: isTablet ?5.sp: 15.sp),
//           decoration: BoxDecoration(
//             color: Colors.grey[900],
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Row(
//             // crossAxisAlignment: CrossAxisAlignment.start,
//             spacing: 8.w,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Left Image Section
//               Container(
//                 constraints: BoxConstraints(
//                   maxWidth: 200,
//                 ),
//                 child: GestureDetector(
//                   onTap: () {
                    
//                     onMapSelect();
//                   },
//                   child: ClipRRect(
                    
//                     borderRadius: BorderRadius.circular(5.sp),
//                     child: fileImage != null
//                         ? Image.file(
//                             fileImage!,
//                             fit: BoxFit.cover,
//                             height: 100.h,
//                             width: 100.w,
//                           )
//                         : Image.network(
//                             imageUrl ?? '',
//                             fit: BoxFit.cover,
//                             height: 60.h,
//                             errorBuilder: (context, error, stackTrace) =>
//                                 Icon(Icons.broken_image, size: 50, color: Colors.grey),
//                           ),
//                   ),
//                 ),
//               ),
        
//               Expanded(
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   // crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Flexible(
//                           child: Container(
//                                                               width:!isTablet ?screen_size.width *0.5 : screen_size.width *0.2,

                            
//                             child: Text(
//                               name,
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 overflow: TextOverflow.ellipsis
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               Icons.access_time,
//                               color: Colors.grey[400],
//                               size: 16,
//                             ),
//                             SizedBox(width: 4),
//                             Container(
//  width:!isTablet ?null : screen_size.width *0.2,

//                               // width: screen_size.width *0.2,
//                               child: Text(
//                                 time,
//                                 style: TextStyle(
//                                   color: Colors.grey[400],
//                                   fontSize: 14
//                                 ),
//                                 softWrap: true,
//                             overflow: TextOverflow.ellipsis
                        
//                               ),
//                             ),
//                           ],
//                         ),
                        
//                         // -----------------------------
//                         Expanded(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.grey[800],
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             padding: const EdgeInsets.all(12),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               spacing: 3,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                                               width:!isTablet ?screen_size.width *0.5 : screen_size.width *0.2,
                                
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     spacing: 2,
//                                     children: [
//                                       Container(
//                                         alignment: Alignment.center,
//                                         // height: 10.w,
//                                         // width: 15.w,
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 3, vertical: 1),
//                                         decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             borderRadius: BorderRadius.circular(1.w)),
//                                         child: Text("NE"),
//                                       ),
//                                       Flexible(
//                                         child: Text(
//                                           northEast,
//                                           style: TextStyle(
//                                             color: Colors.grey[300],
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                  Container(
//                                                               width:!isTablet ?screen_size.width*0.5 : screen_size.width *0.2,
                                
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     spacing: 2,
//                                     children: [
//                                       Container(
//                                         alignment: Alignment.center,
//                                         //     height: 10.w,
//                                         // width: 15.w,
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 3, vertical: 1),
//                                         decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             borderRadius: BorderRadius.circular(1.w)),
//                                         child: Text("SW"),
//                                       ),
//                                       Flexible(
//                                         child: Text(
//                                           southWest,
//                                           style: TextStyle(
//                                             color: Colors.grey[300],
//                                             fontSize: 14,
//                                             // overflow: TextOverflow.ellipsis
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                  Container(
//                                                               width:!isTablet ?screen_size.width*0.5 : screen_size.width *0.2,
                                
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     spacing: 2,
//                                     children: [
//                                       Container(
//                                         alignment: Alignment.center,
//                                         //     height: 10.w,
//                                         // width: 15.w,
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 3, vertical: 1),
//                                         decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             borderRadius: BorderRadius.circular(1.w)),
//                                         child: Text("Area"),
//                                       ),
//                                       Flexible(
//                                         child: Text(
//                                           areaSqKm,
//                                           style: TextStyle(
//                                             color: Colors.grey[300],
//                                             fontSize: 14,
//                                             // overflow: TextOverflow.ellipsis
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
                      
//                 //                       ListTile(
//                 //   title: Text('Online Map'),
//                 //   leading: Icon(Icons.public),
//                 //   onTap: onMapSelect,
//                 // ),

                      
//                       ],
//                     ),
                             
//                   ],
//                 ),
//               ),
        
//               // Right Content Section
//             ],
//           ),
//         ),
     
       
     
//       ],
//     );
  
  
  
//   }
// }
