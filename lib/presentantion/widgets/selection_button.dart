// Create new file: lib/presentation/widgets/selection_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:myapp/molecules/Buttons/icon_button.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
import 'package:provider/provider.dart';
 
class SelectionButton extends StatelessWidget {
    final MapController mapController;

  const SelectionButton({Key? key, required this.mapController,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingProvider>(
      builder: (context, provider, _) {
        final isSelected = provider.isSelectionMode;
        
        return 
        NIconButton(
          backgroundColor: isSelected ?Colors.black: Colors.white ,
          icon: Icon(Icons.near_me, color:isSelected? Colors.white: Colors.black,) ,
          
          onPressed: () => provider.toggleSelectionMode(mapController.camera.center),
          
          );
        
        // IconButton(
        //   icon: Icon(Icons.near_me, color:isSelected? Colors.white: Colors.black,),
        //    style: ElevatedButton.styleFrom(
        //     splashFactory: NoSplash.splashFactory,
        //     backgroundColor: isSelected ?Colors.black: Colors.white ,
        //     // foregroundColor: Colors.white,
        //   ),
        //   onPressed: () => provider.toggleSelectionMode(mapController.camera.center),
        // );
      },
    );
  }
}