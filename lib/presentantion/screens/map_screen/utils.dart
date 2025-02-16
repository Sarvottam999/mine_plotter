import 'package:flutter/material.dart';
import 'package:myapp/presentantion/widgets/shape_details_panel.dart';

const double sidePaneSize = 80;
enum OptsButtonType { setting, mapElementDetailed, downloadedMaps, none }
  // Map to store button and container details
  final Map<OptsButtonType, IconData> SidePanelbuttonIcon = {
    OptsButtonType.mapElementDetailed: Icons.shape_line_outlined,
    OptsButtonType.downloadedMaps: Icons.layers_outlined,
    OptsButtonType.setting: Icons.settings_outlined,
  };

