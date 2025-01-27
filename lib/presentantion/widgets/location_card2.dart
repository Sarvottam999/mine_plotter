 
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// class LocationCard2 extends StatelessWidget {
//   final String? imageUrl; // For network image
//   final File? fileImage; // For file image
//   final String name;
//   final String time;
//   final String northEast;
//   final String southWest;
//   final String areaSqKm;
//   final VoidCallback onPressed;
//   final VoidCallback onMapSelect;

//   LocationCard2({
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
//         final double screenWidth = MediaQuery.of(context).size.width;

//     final isTablet = screenWidth > 600;
//     print("======================= ${isTablet}");
//         int crossAxisCount = screenWidth > 600 ? 2 : 2; // 3 columns for tablets, 2 for mobile


//     return Container(
//       // color: Colors.black,
//       height: screen_size.height,
//       child: Stack(
//         children: [
//           // Text("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"),
//        GridView.builder(
//              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: crossAxisCount,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//         childAspectRatio:4.8/6, // Adjust aspect ratio if needed
//              ),
//              padding: const EdgeInsets.all(10),
//              itemCount: 7,
//              itemBuilder: (context, index) {
//         return _ItemCard(onMapSelect: onMapSelect, fileImage: fileImage,
//         areaSqKm: areaSqKm,
//         name: name,
//         northEast: northEast,
//         onPressed: onPressed,
//         southWest: southWest,
//         time: time,
//         imageUrl: imageUrl,
//         );
//              },
//            ),
         
         
       
//         ],
//       ),
//     );
  
  
  
//   }
// }

class LocationCard extends StatelessWidget {
  final String? imageUrl; // For network image
  final File? fileImage; // For file image
  final String name;
  final String time;
  final String northEast;
  final String southWest;
  final String areaSqKm;
  final VoidCallback onPressed;
  final VoidCallback onMapSelect;

  LocationCard({
    this.imageUrl,
    this.fileImage,
    required this.name,
    required this.time,
    required this.northEast,
    required this.southWest,
    required this.onPressed,
    required this.areaSqKm,
    required this.onMapSelect,

  });

  @override
  Widget build(BuildContext context) {
      final screen_size = MediaQuery.of(context).size;
    final isTablet = MediaQuery.of(context).size.width > 800;
    print("======================= ${isTablet}");
    return Container(
      padding: EdgeInsets.all(2.sp),
      decoration: BoxDecoration(
      color: const Color.fromARGB(255, 0, 0, 0),
      borderRadius: BorderRadius.circular(15)
      ),
      
      child: Column(
        children: [
           Container(
            // padding: EdgeInsets.all(2.sp),
                constraints: BoxConstraints(
                  // maxHeight: 100,
                ),
                child: Stack(
                  children: [
                    AspectRatio(
                              aspectRatio: 16 / 9,
                    
                      child: GestureDetector(
                        onTap: () {
                          
                          onMapSelect();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.sp),
                          child: fileImage != null
                              ? Image.file(
                                  fileImage!,
                                  fit: BoxFit.cover,
                                  height: 100.h,
                                  width: 100.w,
                                )
                              : Image.network(
                                  imageUrl ?? '',
                                  fit: BoxFit.cover,
                                  height: 60.h,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                ),
                        ),
                      ),
                    ),
                       Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    color: Colors.black,
                   style: IconButton.styleFrom(
    backgroundColor: Colors.black, // Background color
    foregroundColor: Colors.white, // Icon color
    padding: EdgeInsets.all(2.sp), // Padding around the button
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6.sp), // Rounded corners
    ),
  ),
                    onPressed: onPressed,
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                      size: 8.sp,
                    ),
                    padding: EdgeInsets.all(1.sp),
                    constraints: BoxConstraints(),
                    iconSize: 24,
                    splashRadius: 20,
                  ),
                ),
                  ],
                ),
              ),
               Expanded(
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      // mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 3.w,
                        ),
                        Container(
                          // color: Colors.yellow,
                              // width: isTablet ?screen_size.width *0.15 :100,
                          // child: Flexible(
                                      //  child: new Text("A looooooooooooooooooong text"))
                                      
                        
                          
                          child: Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 5.sp,
                              fontWeight: FontWeight.bold,
                              // overflow: TextOverflow.ellipsis
                            ),
                            softWrap: true,
                          ),
                        ),
                        SizedBox(height: 3.sp),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.grey[400],
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Container(
                              // width: isTablet ?screen_size.width *0.15 :100,

//  width:!isTablet ?null : screen_size.width *0.2,

                              // width: screen_size.width *0.2,
                              child: Text(
                                time,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 4.sp
                                ),
                                softWrap: true,
                            overflow: TextOverflow.ellipsis
                        
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.sp),

                        
                        // -----------------------------
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(3.sp),
                          ),
                          padding:   EdgeInsets.all(2.sp),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 3,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                            // width: isTablet ?screen_size.width *0.15 :100,
                        
                                                            // width:!isTablet ?screen_size.width *0.5 : screen_size.width *0.2,
                              
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 2,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      // height: 10.w,
                                      // width: 15.w,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 1),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(1.w)),
                                      child: Text("NE", style: TextStyle(fontSize: 3.sp),),
                                    ),
                                    Flexible(
                                      child: Text(
                                        northEast ,
                                        style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: 3.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                               Container(
                            // width: isTablet ?screen_size.width *0.15 :100,
                        
                                                            // width:!isTablet ?screen_size.width*0.5 : screen_size.width *0.2,
                              
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 2,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      //     height: 10.w,
                                      // width: 15.w,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 1),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(1.w)),
                                      child: Text("SW",style: TextStyle(fontSize: 3.sp) ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        southWest,
                                        style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: 3.sp,
                                          // overflow: TextOverflow.ellipsis
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                               Container(
                            // width: isTablet ?screen_size.width *0.15 :100,
                        
                                                            // width:!isTablet ?screen_size.width*0.5 : screen_size.width *0.2,
                              
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 2,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      //     height: 10.w,
                                      // width: 15.w,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 1),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(1.w)),
                                      child: Text("Area", style: TextStyle(fontSize: 3.sp)),
                                    ),
                                    Flexible(
                                      child: Text(
                                        areaSqKm,
                                        style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: 3.sp,
                                          // overflow: TextOverflow.ellipsis
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                     
                      
                      ],
                    ),
                             
                  ],
                ),
              ),
        

        ],
      )
      
      );
  }
}


 