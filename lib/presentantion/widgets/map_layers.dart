import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/presentantion/providers/dowanload_provider.dart';
import 'package:myapp/presentantion/screens/MarkAreaScreen/models/downloaded_map.dart';
import 'package:myapp/utils/contant.dart';
import 'package:myapp/utils/util.dart';
import 'package:provider/provider.dart';

List<MapLayer> maplayersData = [
  MapLayer(
      id: 'map',
      // icon: Icons.terrain,
      label: 'Map',
      image: 'assets/images/layer_icons/terrain.jpg',
      url: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      subdomains: ['a', 'b', 'c'],
      offline: false
      
      ),

//  MapLayer(
//       id: 'terrain',
//       icon: Icons.terrain,
//       label: 'Terrain',
//       image: 'assets/images/layer_icons/terrain.jpg',
// url: 'http://mt0.google.com/vt/lyrs=p&hl=en&x={x}&y={y}&z={z}',
//       subdomains: ['a', 'b', 'c']

//     ),
  MapLayer(
      id: 'satellite',
      // icon: Icons.satellite_alt,
      label: 'Satellite',
      image: 'assets/images/layer_icons/satelight.jpg',
      url: 'http://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
      subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
      offline: false
      ),

//     MapLayer(
//       id: 'traffic',
//       icon: Icons.traffic,
//       label: 'Traffic',
//       image: 'assets/images/layer_icons/traffic.jpg',
// url: 'http://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
//       subdomains: ['mt0','mt1','mt2','mt3']

//     ),
];

class LayerSelector extends StatefulWidget {
  final Function(MapLayer) onLayerChanged;
  final  MapController mapController;

  const LayerSelector({
    Key? key,
    required this.onLayerChanged,
    required this.mapController,
  }) : super(key: key);

  @override
  State<LayerSelector> createState() => _LayerSelectorState();
}

class _LayerSelectorState extends State<LayerSelector> {
  bool showAllLayers = false; // Add this flag to control visibility
  List _maplayersData = maplayersData;
  MapLayer selectedLayer = maplayersData[0];

  @override
  void initState() { 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Consumer<MapProvider>(
                  builder: (context, provider, _) {

                    // print(('### 1  ${provider.downloadedMaps.map((e) => e.id,)}'));
                    // print(('### 2 -----${selectedLayer.id} -- ${provider.downloadedMaps
                    //                        .where((layer) => layer.id != selectedLayer.id)}'));
                    return Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width *0.9
          
                ),
                padding: EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (showAllLayers)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                                 Row(  // Wrap it in Column if you want a vertical list, or use ListView if needed
                                             children: provider.downloadedMaps
                                             .where((layer) => layer.id != selectedLayer.id)
                                             .map((map) {
                                               return _buildOfflineLayerButton(
                                                 map,widget.mapController, provider
                                 
                                               //   MapLayer(
                                               //   id: map.id,
                                               //   date: map.date,
                                               //   name: map.name,
                                               //   areaSqKm: map.areaSqKm
                                               // )
                                               );
                                               
                                               
                                               // return Container(
                                               //   height: 100,
                                               //   width: 100,
                                               //   decoration: BoxDecoration(
                                               //     borderRadius: BorderRadius.circular(8),
                                               //   ),
                                               //   child: Container(
                                               //     constraints: BoxConstraints(minHeight: 70),
                                               //     margin: EdgeInsets.symmetric(vertical: 5.h),
                                               //     decoration: BoxDecoration(
                                               //       color: const Color.fromARGB(255, 255, 234, 203),
                                               //       borderRadius: BorderRadius.circular(12.r),
                                               //       border: Border.all(color: Colors.orange, width: 2),
                                               //     ),
                                               //     child: ListTile(
                                               //       title: Row(
                                               //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                               //         children: [
                                               //           Flexible(
                                               //             child: Text(
                                               //               map.name,
                                               //               style: TextStyle(
                                               //                 fontWeight: FontWeight.bold,
                                               //                 // fontSize: isTablet ? 6.sp : 12.sp,
                                               //               ),
                                               //             ),
                                               //           ),
                                               //           Icon(Icons.navigate_next, color: my_orange),
                                               //         ],
                                               //       ),
                                               //       subtitle: Text('${map.areaSqKm.toStringAsFixed(2)} km²'),
                                               //       onTap: () {
                                               //         goToMapArea(map, widget.mapController);
                                               //         provider.loadOfflineMap(map);
                                               //       },
                                               //     ),
                                               //   ),
                                               // );
                                             
                                             
                                             }).toList(),  // Convert the map() result to a list of widgets
                                 ),
                  
                  
                              
                              
                              
                              
                              
                              ..._maplayersData
                                .where((layer) => layer.id != selectedLayer.id)
                                .map((layer) => _buildLayerButton(layer, provider))
                                .toList(),
                  
                               
                  
                                 
                  //                         Consumer<MapProvider>(
                  //                           builder: (context, provider, _) {
                  //                           // var map = provider.downloadedMaps[index];
                  
                  //                                provider.downloadedMaps.map((e) =>Container(
                  //                           decoration: BoxDecoration(
                  //                               borderRadius: BorderRadius.circular(8)),
                  //                               child: Container(
                  //                               constraints: BoxConstraints(
                  //                                 minHeight: 70
                  //                               ),
                  //                               margin: EdgeInsets.symmetric(vertical: 5.h),
                  //                               decoration: BoxDecoration(
                  //                                   color: const Color.fromARGB(255, 255, 234, 203), 
                  //                                   borderRadius: BorderRadius.circular(12.r), 
                  //                                   border: Border.all(color: Colors.orange, width: 2), 
                  //                               ),
                  //                           child: 
                  //                           ListTile(
                  //                             title: Row( 
                  //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                               children: [
                  //                                 Flexible(child: Text(map.name, style: TextStyle(fontWeight: FontWeight.bold,fontSize:isTablet?6.sp: 12.sp ),)),
                  //                                 Icon(Icons.navigate_next, color: my_orange,)
                  //                               ],
                  //                             ),
                  //                             subtitle:
                  //                                 Text('${map.areaSqKm.toStringAsFixed(2)} km²'),
                  //                             onTap: () =>
                  //                                 {goToMapArea(map, mapController), provider.loadOfflineMap(map)},
                  //                           ),
                  //                         ),
                  //                         )
                  
                  // ).toList();
                  
                  
                  //                             // return 
                  //                           })
                  
                  
                                
                                
                                ]
                          ),
                        ),
                      _buildMainLayerButton(provider),
                    ],
                  ),
                ));
              
           
      }
    );
  }

  Widget _buildMainLayerButton(MapProvider map_provider) {

    if (map_provider.currentTilePath != null || selectedLayer.offline) {

      // return Container(
      //   child: Text(selectedLayer.label  ?? ""),
      // );
      return InkWell(
          onTap: () {
          setState(() {
            showAllLayers = !showAllLayers;
          });
          // map_provider.loadOfflineMap(null);

        },
        child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5)
              
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        // color: my_orange
                        color: my_orange_light,

                        //  borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            
                     
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:  8.0),
                          child: SizedBox(
                            height: 20,
                            child: Text('Offline map'),
                          ),
                        ),
                      ),
                    ), 
                    const SizedBox(height: 4),
        
                      Text(
                  selectedLayer.label ?? '',
                  style:   TextStyle(fontSize: 10,
                  
                        // color: isSelected ? Colors.black : Colors.grey,
                  ),
                ),
                    const SizedBox(height: 4),
        
        
                    Text(
                      formatDateTime(selectedLayer.date ?? ''),
                      style: TextStyle(
                        fontSize: 10,
                        // color: isSelected ? Colors.black : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${selectedLayer.areaSqKm?.toStringAsFixed(2)} km²',
                      style: TextStyle(
                        fontSize: 10,
                        // color: isSelected ? Colors.blue : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Text(
                    //   selectedLayer.northEast.toString(),
                    //   style: TextStyle(
                    //     fontSize: 10,
                    //     color: isSelected ? Colors.blue : Colors.grey,
                    //   ),
                    // ),
                    // const SizedBox(height: 4),
              
                  ],
                ),
                
              ),
            ],
          ),
      );
      

      
    }
    MapLayer currentLayer =
        _maplayersData.firstWhere((layer) => layer.id == selectedLayer.id);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            showAllLayers = !showAllLayers;
          });
          map_provider.loadOfflineMap(null);

        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.asset(
                    currentLayer.image ?? '',
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Icon(currentLayer.icon, size: 24),
              const SizedBox(height: 4),
              Text(
                currentLayer.label ?? '',
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLayerButton(MapLayer layer, MapProvider map_provider) {
    bool isSelected = selectedLayer.id == layer.id;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            selectedLayer = layer;
          });
          widget.onLayerChanged(layer);
          map_provider.loadOfflineMap(null);
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey.shade200 : Colors.transparent,
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
               
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.asset(
                    layer.image ?? '',
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ), 
              const SizedBox(height: 4),
              Text(
                layer.label ?? '',
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Colors.blue : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


   Widget _buildOfflineLayerButton(DownloadedMap layer, MapController mapController, MapProvider map_provider ) {
    bool isSelected = selectedLayer.id == layer.id;
    return Material(
      color: Colors.transparent,
      child: InkWell(
       onTap: () =>{

         setState(() {
            selectedLayer = MapLayer(
              
              offline: true,
              id: layer.id,
              label: layer.name,
              date: layer.date,
              areaSqKm: layer.areaSqKm,
            );
          }),
        
        goToMapArea(layer, mapController), map_provider.loadOfflineMap(layer)},
    
        // onTap: () {
        //   setState(() {
        //     selectedLayer = layer;
        //   });
        //   widget.onLayerChanged(layer);
        // },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                      // color: my_orange_light,
                  borderRadius: BorderRadius.circular(5)
            
                // color: isSelected ? Colors.grey.shade200 : Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      // color: my_orange
                      color: my_orange_light,
    
                   
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(

                        padding: const EdgeInsets.symmetric(horizontal:  8.0),
                        child: SizedBox(
                          // layer.image,
                          height: 20,
                          // width: 60,
                              child: Text('Offline map'),
                        
                          // width: 60,
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ), 
                  const SizedBox(height: 4),
                  Text(
                layer.name,
                style:   TextStyle(fontSize: 10,
                
                      color: isSelected ? Colors.black : Colors.grey,
                ),
              ),

                  const SizedBox(height: 4),

                  Text(
                    formatDateTime(layer.date),
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? Colors.black : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${layer.areaSqKm.toStringAsFixed(2)} km²',
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? Colors.blue : Colors.grey,
                    ),
                  ),
                   // Text(
                  //   layer.northEast.toString(),
                  //   style: TextStyle(
                  //     fontSize: 10,
                  //     color: isSelected ? Colors.blue : Colors.grey,
                  //   ),
                  // ),
                  // const SizedBox(height: 4),
              
                ],
              ),
              
            ),
          ],
        ),
      ),
    );
  }


}

class MapLayer {
  final String? id;
  // final IconData icon;
  final String? label;
  final String? image;
  final String? url;
  final List<String>? subdomains;
  final bool offline;

  // for off line map
  final String? name;
  final String? date;
  final double? areaSqKm;

  MapLayer({
      this.id,
    // required this.icon,
      this.label,
      this.image,
      this.url,
      this.subdomains,
      required this.offline,
  // for off line map

      this.name,
      this.date,
      this.areaSqKm,
  });
}

// Usage example:
// class MapScreen extends StatelessWidget {
//   const MapScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           FlutterMap(
//             options: MapOptions(
//               center: const LatLng(51.5, -0.09),
//               zoom: 13.0,
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//               ),
//               LayerSelector(
//                 onLayerChanged: (layerId) {
//                   // Handle layer change here
//                   print('Selected layer: $layerId');
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
