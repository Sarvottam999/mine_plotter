import 'package:flutter/material.dart';

class NDottedLine extends CustomPainter {
  final bool isVertical; // New parameter to control vertical or horizontal line
  
  NDottedLine({this.isVertical = false}); // Constructor to accept isVertical

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    double dashHeight = 4, dashSpace = 4, startX = 0, startY = 0;

    // If isVertical is true, draw vertically; otherwise, draw horizontally
    if (isVertical) {
      while (startY < size.height) {
        canvas.drawLine(
          Offset(startX, startY),
          Offset(startX, startY + dashHeight),
          paint,
        );
        startY += dashHeight + dashSpace;
      }
    } else {
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, size.height / 2),
          Offset(startX + dashHeight, size.height / 2),
          paint,
        );
        startX += dashHeight + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
