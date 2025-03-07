import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/molecules/Buttons/icon_button.dart';
import 'package:myapp/molecules/custom_dialog.dart';
import 'package:myapp/presentantion/providers/dowanload_provider.dart';
import 'package:myapp/presentantion/screens/MarkAreaScreen/mark_area_screen.dart';
import 'package:myapp/presentantion/screens/MarkAreaScreen/models/downloaded_map.dart';
import 'package:myapp/presentantion/screens/map_preview_screen.dart';
import 'package:myapp/presentantion/widgets/download_button.dart';
import 'package:myapp/presentantion/widgets/location_card.dart';
import 'package:myapp/utils/contant.dart';
import 'package:myapp/utils/no_content_view.dart';
import 'package:myapp/utils/util.dart';
import 'package:provider/provider.dart';

class MapListScreen extends StatefulWidget {
  @override
  State<MapListScreen> createState() => _MapListScreenState();
}

class _MapListScreenState extends State<MapListScreen> {
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final screen_size = MediaQuery.of(context).size;
    final double screenWidth = screen_size.width;

    final isTablet = screenWidth > 600;
    int crossAxisCount = screenWidth > 600 ? 2 : 2;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<MapProvider>(
        builder: (context, mapProvider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                if (mapProvider.isDownloading)
                  Container(
                    decoration: BoxDecoration(
                        color: my_orange_light,
                        border: Border.all(color: my_orange),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                  minHeight: 10,
                                  backgroundColor: Colors.black12,
                                  color: my_orange,
                                  borderRadius: BorderRadius.circular(10),
                                  value: mapProvider.currentProgress),
                            ),
                            NIconButton(
                                icon: Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.white,
                                ),
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                onPressed: () => {mapProvider.cancelDownload()})
                          ],
                        ),
                        Text(mapProvider.currentStatus),
                      ],
                    ),
                  ),

                // ====================  list =============================
                Container(
                  height: screen_size.height * 0.7,
                  child: mapProvider.downloadedMaps.length == 0
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: NoContentView(
                              text: 'No offline maps are downloaded!!',
                            ),
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 16,
                          ),
                          padding: const EdgeInsets.all(10),
                          itemCount: mapProvider.downloadedMaps.length,
                          itemBuilder: (context, index) {
                            return MapListItem(
                              map: mapProvider.downloadedMaps[index],
                              index: index,
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 28.0),
                  child: NDownloadButton(
                    width: 300,
                    hideShadowa: true,
                    label: 'DOWNLOAD MAPS',
                    primaryColor: Colors.black,
                    secondaryColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapSelectorScreen(),
                          ));
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MapListItem extends StatelessWidget {
  final DownloadedMap map;
  final int index;

  MapListItem({required this.map, required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) {
        return FutureBuilder(
            future: getPreviewImage(map.id),
            builder: (context, snapshot) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5.h),
                child: ProductCard2(
                  onMapSelect: () {
                    context.read<MapProvider>().setPreviewMap(map.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapPreviewScreen(
                          map: map,
                        ),
                      ),
                    );
                  },
                  onPressed: () {
                    _showDeleteConfirmationDialog(
                        context, index); // Show confirmation dialog
                  },
                  fileImage: snapshot.hasData ? snapshot.data! : null,
                  name: map.name,
                  time: formatDateTime(map.date),
                  northEast:
                      ' Lat : ${map.northEast.latitude.toStringAsFixed(2)} | Lag : ${map.northEast.longitude.toStringAsFixed(2)}',
                  southWest:
                      'Lat : ${map.southWest.latitude.toStringAsFixed(2)} | Lag : ${map.southWest.longitude.toStringAsFixed(2)}',
                  areaSqKm: '${map.areaSqKm.toStringAsFixed(2)} km²',
                ),
              );
            });
      },
    );
  }
}

void _showDeleteConfirmationDialog(BuildContext context, int index) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return CustomDialog(
        title: "Delete Map?",
        message:
            "This Map will be permanently deleted. Are you sure you want to proceed?",
        onConfirm: () {
          Provider.of<MapProvider>(context, listen: false).deleteMap(index);
          Navigator.pop(dialogContext); // Close dialog after delete
        },
        onCancel: () {
          Navigator.pop(dialogContext); // Close dialog
        },
        iconColor: my_orange, // Using your existing color
      );
    },
  );
}
