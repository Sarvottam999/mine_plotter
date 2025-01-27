import 'package:flutter/material.dart';
import 'package:myapp/presentantion/widgets/shape_details_panel.dart';

const double sidePaneSize = 100;
enum OptsButtonType { setting, mapElementDetailed, downloadedMaps, none }
  // Map to store button and container details
  final Map<OptsButtonType, IconData> SidePanelbuttonIcon = {
    OptsButtonType.downloadedMaps: Icons.layers,
    OptsButtonType.mapElementDetailed: Icons.map,
    OptsButtonType.setting: Icons.settings,
  };

