import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFBBBBBB) // Adjust the color as needed
      ..strokeWidth = 1 // Adjust the line thickness as needed
      ..strokeCap = StrokeCap.square;

    const dashWidth = 10.0; // Adjust the length of each dash
    const dashSpace = 10.0; // Adjust the space between dashes

    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );

      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
