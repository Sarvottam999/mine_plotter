import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/utils/contant.dart';

class ProductCard2 extends StatelessWidget {
  final String? imageUrl; // For network image
  final File? fileImage; // For file image
  final String name;
  final String time;
  final String northEast;
  final String southWest;
  final String areaSqKm;
  final VoidCallback onPressed;
  final VoidCallback onMapSelect;
  ProductCard2({
    Key? key,
    this.imageUrl,
    this.fileImage,
    required this.name,
    required this.time,
    required this.northEast,
    required this.southWest,
    required this.onPressed,
    required this.areaSqKm,
    required this.onMapSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return SizedBox(
      // width: width,
      child: GestureDetector(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                    aspectRatio: 9 / 5,
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
                                    Icon(Icons.broken_image,
                                        size: 50, color: Colors.grey),
                              ),
                      ),
                    )),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    color: Colors.black,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.all(
                          isTablet ? 2.sp : 3.sp), // Padding around the button
                      shape: CircleBorder(),
                    ),
                    onPressed: onPressed,
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                      size: isTablet ? 8.sp : 18.sp,
                    ),
                    padding: EdgeInsets.all(1.sp),
                    constraints: BoxConstraints(),
                    iconSize: 24,
                    splashRadius: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.date_range,
                      color: Colors.grey[400],
                      size: isTablet ? 16 : 16.sp,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            // -------------------------        -----------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                  decoration: BoxDecoration(
                      color: my_orange,
                      borderRadius:
                          BorderRadius.circular(isTablet ? 6.r : 4.r)),
                  child: Text("SW",
                      style: TextStyle(
                          fontSize: isTablet ? 5.sp : 10.sp,
                          color: Colors.white)),
                ),
                Flexible(
                  child: Text(
                    northEast,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            // --------------------------   -----------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                  decoration: BoxDecoration(
                      color: my_orange,
                      borderRadius:
                          BorderRadius.circular(isTablet ? 5.r : 4.r)),
                  child: Text("NE",
                      style: TextStyle(
                          fontSize: isTablet ? 5.sp : 10.sp,
                          color: Colors.white)),
                ),
                Flexible(
                  child: Text(
                    southWest,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
