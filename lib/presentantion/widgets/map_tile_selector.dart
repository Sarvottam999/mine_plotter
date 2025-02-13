import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/presentantion/providers/dowanload_provider.dart';
import 'package:myapp/presentantion/screens/MarkAreaScreen/models/downloaded_map.dart';
import 'package:myapp/utils/util.dart';
import 'package:provider/provider.dart';

class MapTileSelector extends StatelessWidget {
  final MapController mapController;
  const MapTileSelector({Key? key, required this.mapController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

  
    return Consumer<MapProvider>(
      builder: (context, provider, _) {
    final screen_size = MediaQuery.of(context).size;

        // return Container(
        //   height: 500,
        //   width: 500,
        //   color: Colors.white,
        // );
        return Container(
          constraints: BoxConstraints(
        maxWidth: 300
      ),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 17),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white),
            height: 5 ,
                 width: screen_size.width * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
        
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    'Your Maps',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                for (var map in provider.downloadedMaps)
                  Container(
                    decoration: BoxDecoration(
                        color:   Colors.grey[100],
                        borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      title: Text(map.name, style: TextStyle(fontWeight: FontWeight.w500),),
                      subtitle:
                          Text('${map.areaSqKm.toStringAsFixed(2)} km²'),
                      onTap: () =>
                          {goToMapArea(map, mapController), provider.loadOfflineMap(map)},
                    ),
                  ),
                ListTile(
                  title: Text('Online Map'),
                  leading: Icon(Icons.public),
                  onTap: () => provider.loadOfflineMap(null),
                )
              ],
              // children: provider.downloadedMaps.map((item)=>Text('text')
              // ).toList()
            ));
      },
    );
  }
}
