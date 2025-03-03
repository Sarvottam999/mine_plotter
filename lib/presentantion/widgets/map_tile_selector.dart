import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/presentantion/providers/dowanload_provider.dart';
import 'package:myapp/presentantion/screens/MarkAreaScreen/models/downloaded_map.dart';
import 'package:myapp/utils/contant.dart';
import 'package:myapp/utils/util.dart';
import 'package:provider/provider.dart';

class MapTileSelector extends StatelessWidget {
  final MapController mapController;
  const MapTileSelector({Key? key, required this.mapController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return  Consumer<MapProvider>(
      builder: (context, provider, _) {
    final screen_size = MediaQuery.of(context).size;
        return Container(
          constraints: BoxConstraints( maxWidth: 300),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 17),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(15),
                color: Colors.white),
                height: 5 ,
                width: screen_size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text('Your Maps',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    ListTile(
                      title: Text('Online Map'),
                      leading: Icon(Icons.public),
                      onTap: () => provider.loadOfflineMap(null),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount:provider.downloadedMaps.length,
                        itemBuilder: (context, index) {
                          var map = provider.downloadedMaps[index];
                        return  Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8)),
                              child: Container(
                              constraints: BoxConstraints(
                                minHeight: 70
                              ),
                              margin: EdgeInsets.symmetric(vertical: 5.h),
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 255, 234, 203), 
                                  borderRadius: BorderRadius.circular(12.r), 
                                  border: Border.all(color: Colors.orange, width: 2), 
                              ),
                          child: 
                          ListTile(
                            title: Row( 
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(child: Text(map.name, style: TextStyle(fontWeight: FontWeight.bold,fontSize:isTablet?6.sp: 12.sp ),)),
                                Icon(Icons.navigate_next, color: my_orange,)
                              ],
                            ),
                            subtitle:
                                Text('${map.areaSqKm.toStringAsFixed(2)} km²'),
                            onTap: () =>
                                {goToMapArea(map, mapController), provider.loadOfflineMap(map)},
                          ),
                        ),
                        );
                      },),
                    )
                  ],
                ));
          },
        );
      }
    }

