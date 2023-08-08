import 'dart:math';

import 'package:flutter/material.dart';

class DottedBorderCircle extends StatelessWidget {
  final double radius;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final double dotSpacing;
  final String velocity;
  final double maxSpeed;
  final TextStyle velocityTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  DottedBorderCircle({
    required this.radius,
    required this.fillColor,
    required this.borderColor,
    required this.borderWidth,
    required this.dotSpacing,
    required this.velocity,
    required this.maxSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: CustomPaint(
        painter: DottedCirclePainter(
          fillColor: fillColor,
          borderColor: borderColor,
          borderWidth: borderWidth,
          dotSpacing: dotSpacing,
          velocity: velocity,
          maxSpeed: maxSpeed,
        ),
      ),
    );
  }
}

class DottedCirclePainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final double dotSpacing;
  final String velocity;
  final double maxSpeed;

  DottedCirclePainter({
    required this.fillColor,
    required this.borderColor,
    required this.borderWidth,
    required this.dotSpacing,
    required this.velocity,
    required this.maxSpeed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final circlePaint = Paint()..color = fillColor;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // Draw filled circle
    canvas.drawCircle(center, size.width / 2, circlePaint);

    // Draw dotted border
    final double circleCircumference = 2 * pi * (size.width / 2);
    final int totalDots = (circleCircumference / dotSpacing).round();
    final double dotSpace = circleCircumference / totalDots;
    for (int i = 0; i < totalDots; i++) {
      final double angle = i * dotSpace;
      final double x = center.dx + (size.width / 2) * cos(angle);
      final double y = center.dy + (size.height / 2) * sin(angle);
      final dotCenter = Offset(x, y);
      canvas.drawCircle(dotCenter, borderWidth / 2, borderPaint);
    }

    // Draw velocity text
    final textPainter = TextPainter(
      text: TextSpan(text: velocity, style: TextStyle(color: Colors.white)),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textWidth = textPainter.width;
    final textHeight = textPainter.height;
    final textOffset = Offset(
        size.width / 2 - textWidth / 2, size.height / 2 - textHeight / 2);
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
