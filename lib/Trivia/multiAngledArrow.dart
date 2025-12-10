import 'package:flutter/material.dart';

class MultiAngledArrowPainter extends CustomPainter {
  final List<Offset> start;
  final List<Offset> end;
  final List<bool> visible;

  MultiAngledArrowPainter(this.start, this.end, this.visible);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < start.length; i++) {
      // Determine color based on visibility
      final paint =
          Paint()
            ..color = Colors.white.withOpacity(
              visible[i] ? 1.0 : 0.2,
            ) // full or faded
            ..strokeWidth = 5
            ..style = PaintingStyle.stroke;

      _drawAngledLine(canvas, paint, start[i], end[i]);
    }
  }

  void _drawAngledLine(Canvas canvas, Paint paint, Offset s, Offset e) {
    final mid = Offset(s.dx, e.dy);

    final path =
        Path()
          ..moveTo(s.dx, s.dy)
          ..lineTo(mid.dx, mid.dy)
          ..lineTo(e.dx, e.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant MultiAngledArrowPainter oldDelegate) {
    return oldDelegate.start != start ||
        oldDelegate.end != end ||
        oldDelegate.visible != visible;
  }
}
