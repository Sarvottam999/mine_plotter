import 'package:flutter/material.dart';

class SettingTab {
  final String id; // Unique identifier for the tab
  final String name; // Name of the tab
  final IconData icon; // Icon associated with the tab
  final Widget content; // Content associated with the tab

  SettingTab({
    required this.id,
    required this.name,
    required this.icon,
    required this.content,
  });
}
