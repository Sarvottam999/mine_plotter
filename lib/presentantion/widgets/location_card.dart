import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// TODO: add flutter_svg package to pubspec.yaml
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/utils/contant.dart';

// class ProductsScreen extends StatelessWidget {
//   const ProductsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Products"),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: GridView.builder(
//             itemCount: demoProducts.length,
//             gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//               maxCrossAxisExtent: 200,
//               childAspectRatio: 0.7,
//               mainAxisSpacing: 20,
//               crossAxisSpacing: 16,
//             ),
//             itemBuilder: (context, index) => ProductCard(
//               product: demoProducts[index],
//               onPress: () {},
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

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
  // final double width;
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
    // this.width = 300,
    //   this.aspectRetio = 1.02,
    //   required this.product,
    //   required this.onPress,
  }) : super(key: key);

  // final double width, aspectRetio;
  // final Product product;
  // final VoidCallback onPress;

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
                                          Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                    ),
                            ),
                          )
                  
                  // Container(
                  //   padding: const EdgeInsets.all(20),
                  //   decoration: BoxDecoration(
                  //     color: const Color(0xFF979797).withOpacity(0.1),
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   // child: Image.network(product.images[0]),
                  // ),
                ),
                  Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    color: Colors.black,
                   style: IconButton.styleFrom(
    backgroundColor: Colors.black,  
    padding: EdgeInsets.all(isTablet? 2.sp: 3.sp), // Padding around the button
    shape: CircleBorder(
    ),
  ),
                    onPressed: onPressed,
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                      size: isTablet? 8.sp:18.sp,
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

              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end ,
              children: [
                InkWell(  
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      // color: product.isFavourite
                      //     ? const Color(0xFFFF7643).withOpacity(0.15)
                      //     : const Color(0xFF979797).withOpacity(0.1),
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
            SizedBox(height: 10,),
            // -------------------------        -----------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                  decoration: BoxDecoration(
                              color: my_orange,
                       borderRadius: BorderRadius.circular(isTablet ? 6.r:4.r)),
                  child: Text("SW",
                      style: TextStyle(fontSize: isTablet ? 5.sp : 10.sp, color: Colors.white)),
                ),

                //    InkWell(
                //   borderRadius: BorderRadius.circular(50),
                //   onTap: () {},
                //   child: Container(
                //     padding: const EdgeInsets.all(6),
                //     height: 24,
                //     width: 24,
                //     decoration: BoxDecoration(
                //       // color: product.isFavourite
                //       //     ? const Color(0xFFFF7643).withOpacity(0.15)
                //       //     : const Color(0xFF979797).withOpacity(0.1),
                //       shape: BoxShape.circle,
                //     ),
                //     child: Icon(
                //               Icons.access_time,
                //               color: Colors.grey[400],
                //               size:isTablet? 16 :16.sp,
                //             ),
                //   ),
                // ),
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
                       borderRadius: BorderRadius.circular(isTablet ? 5.r : 4.r)),
                  child: Text("NE",
                      style: TextStyle(fontSize: isTablet ? 5.sp : 10.sp, color: Colors.white)),
                ),

                
                // InkWell(
                //   borderRadius: BorderRadius.circular(50),
                //   onTap: () {},
                //   child: Container(
                //     padding: const EdgeInsets.all(6),
                //     height: 24,
                //     width: 24,
                //     decoration: BoxDecoration(
                //       // color: product.isFavourite
                //       //     ? const Color(0xFFFF7643).withOpacity(0.15)
                //       //     : const Color(0xFF979797).withOpacity(0.1),
                //       shape: BoxShape.circle,
                //     ),
                //     child: Icon(
                //       Icons.access_time,
                //       color: Colors.grey[400],
                //       size: isTablet ? 16 : 16.sp,
                //     ),
                //   ),
                // ),
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

class Product {
  final int id;
  final String title, description;
  final List<String> images;
  final List<Color> colors;
  final double rating, price;
  final bool isFavourite, isPopular;

  Product({
    required this.id,
    required this.images,
    required this.colors,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    required this.title,
    required this.price,
    required this.description,
  });
}

// Our demo Products

List<Product> demoProducts = [
  Product(
    id: 1,
    images: ["https://i.postimg.cc/c19zpJ6f/Image-Popular-Product-1.png"],
    colors: [
      const Color(0xFFF6625E),
      const Color(0xFF836DB8),
      const Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Wireless Controller for PS4™",
    price: 64.99,
    description: description,
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 2,
    images: [
      "https://i.postimg.cc/CxD6nH74/Image-Popular-Product-2.png",
    ],
    colors: [
      const Color(0xFFF6625E),
      const Color(0xFF836DB8),
      const Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Nike Sport White - Man Pant",
    price: 50.5,
    description: description,
    rating: 4.1,
    isPopular: true,
  ),
  Product(
    id: 3,
    images: [
      "https://i.postimg.cc/1XjYwvbv/glap.png",
    ],
    colors: [
      const Color(0xFFF6625E),
      const Color(0xFF836DB8),
      const Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Gloves XC Omega - Polygon",
    price: 36.55,
    description: description,
    rating: 4.1,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 4,
    images: [
      "https://i.postimg.cc/d1QWXMYW/Image-Popular-Product-3.png",
    ],
    colors: [
      const Color(0xFFF6625E),
      const Color(0xFF836DB8),
      const Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Gloves XC Omega - Polygon",
    price: 36.55,
    description: description,
    rating: 4.1,
    isFavourite: false,
    isPopular: true,
  ),
];

const heartIcon =
    '''<svg width="18" height="16" viewBox="0 0 18 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M16.5266 8.61383L9.27142 15.8877C9.12207 16.0374 8.87889 16.0374 8.72858 15.8877L1.47343 8.61383C0.523696 7.66069 0 6.39366 0 5.04505C0 3.69644 0.523696 2.42942 1.47343 1.47627C2.45572 0.492411 3.74438 0 5.03399 0C6.3236 0 7.61225 0.492411 8.59454 1.47627C8.81857 1.70088 9.18143 1.70088 9.40641 1.47627C11.3691 -0.491451 14.5629 -0.491451 16.5266 1.47627C17.4763 2.42846 18 3.69548 18 5.04505C18 6.39366 17.4763 7.66165 16.5266 8.61383Z" fill="#DBDEE4"/>
</svg>
''';

const String description =
    "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";
