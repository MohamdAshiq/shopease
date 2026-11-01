import 'package:flutter/material.dart';

// Custom painter for fluid background wave in the header
class HeaderWavePainter extends CustomPainter {
  const HeaderWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Outer soft wave
    final outerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..style = PaintingStyle.fill;

    final outerPath = Path()
      ..moveTo(size.width * 0.45, 0)
      ..quadraticBezierTo(
        size.width * 0.65,
        size.height * 0.45,
        size.width,
        size.height * 0.55,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(outerPath, outerPaint);

    // Inner wave with higher contrast
    final innerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    final innerPath = Path()
      ..moveTo(size.width * 0.25, 0)
      ..cubicTo(
        size.width * 0.5,
        size.height * 0.3,
        size.width * 0.7,
        size.height * 0.8,
        size.width,
        size.height * 0.85,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(innerPath, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
