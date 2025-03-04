import 'package:flutter/material.dart';

enum SnackbarType { info, warning, error, success }

class CustomSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    required SnackbarType type,
  }) {
    Color backgroundColor;
    Color borderColor;
    IconData icon;

    switch (type) {
      case SnackbarType.info:
        backgroundColor = Colors.blue.shade50;
        borderColor = Colors.blue;
        icon = Icons.info_outline;
        break;
      case SnackbarType.warning:
        backgroundColor = Colors.orange.shade100;
        borderColor = Colors.orange;
        icon = Icons.warning_amber_rounded;
        break;
      case SnackbarType.error:
        backgroundColor = Colors.red.shade50;
        borderColor = Colors.red;
        icon = Icons.error_outline;
        break;
      case SnackbarType.success:
        backgroundColor = Colors.green.shade100;
        borderColor = Colors.green;
        icon = Icons.check_circle_outline;
        break;
    }

    final snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: borderColor),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
