import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class RoutePainter extends CustomPainter {
  final List<Position> points;

  RoutePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final paintLine = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final minLat = points.map((p) => p.latitude).reduce(min);
    final maxLat = points.map((p) => p.latitude).reduce(max);
    final minLng = points.map((p) => p.longitude).reduce(min);
    final maxLng = points.map((p) => p.longitude).reduce(max);

    double scaleX(double lng) =>
        ((lng - minLng) / (maxLng - minLng)) * size.width;

    double scaleY(double lat) =>
        size.height -
            ((lat - minLat) / (maxLat - minLat)) * size.height;

    final path = Path();

    final first = points.first;
    path.moveTo(scaleX(first.longitude), scaleY(first.latitude));

    for (final p in points.skip(1)) {
      path.lineTo(scaleX(p.longitude), scaleY(p.latitude));
    }

    canvas.drawPath(path, paintLine);

    // Start point (green)
    final startPaint = Paint()..color = Colors.green;
    canvas.drawCircle(
      Offset(scaleX(first.longitude), scaleY(first.latitude)),
      5,
      startPaint,
    );

    // End point (red)
    final last = points.last;
    final endPaint = Paint()..color = Colors.red;
    canvas.drawCircle(
      Offset(scaleX(last.longitude), scaleY(last.latitude)),
      5,
      endPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}