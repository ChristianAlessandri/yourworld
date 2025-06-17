import 'package:flutter/material.dart';
import 'package:yourworld/models/badge.dart';
import 'dart:math';

class BadgeShapePainter extends CustomPainter {
  final Color color;
  final BadgeLevel level;

  BadgeShapePainter({required this.color, required this.level});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final shortestSide = min(size.width, size.height);
    double radius = shortestSide / 2;

    if (level == BadgeLevel.bronze) {
      radius *= 1.25;
    }

    Path polygonPath(int sides, double radius, Offset center) {
      final angle = (2 * pi) / sides;
      final path = Path();
      for (int i = 0; i <= sides; i++) {
        final x = center.dx + radius * cos(i * angle - pi / 2);
        final y = center.dy + radius * sin(i * angle - pi / 2);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      return path;
    }

    Gradient metallicGradient(Color baseColor) {
      return RadialGradient(
        center: Alignment.topLeft,
        radius: 1.0,
        colors: [
          baseColor.withAlpha(242),
          Colors.white.withAlpha(102),
          baseColor.withAlpha(204),
          Colors.black.withAlpha(25),
        ],
        stops: [0.0, 0.1, 0.6, 0.95],
      );
    }

    final paint = Paint()
      ..shader = metallicGradient(color)
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    switch (level) {
      case BadgeLevel.gray:
        canvas.drawCircle(center, radius, paint);
        break;
      case BadgeLevel.bronze:
        canvas.drawPath(polygonPath(3, radius, center), paint);
        break;
      case BadgeLevel.silver:
        canvas.drawPath(polygonPath(5, radius, center), paint);
        break;
      case BadgeLevel.gold:
        canvas.drawPath(polygonPath(6, radius, center), paint);
        break;
      case BadgeLevel.diamond:
        canvas.drawPath(polygonPath(8, radius, center), paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant BadgeShapePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.level != level;
  }
}
