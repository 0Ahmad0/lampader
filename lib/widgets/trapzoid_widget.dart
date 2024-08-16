import 'package:flutter/material.dart';

class TrapezoidWidget extends StatelessWidget {
  final double width;
  final double height;
  final double topWidth;
  final Gradient gradient;

  const TrapezoidWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.topWidth,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: TrapezoidPainter(topWidth: topWidth, gradient: gradient),
    );
  }
}

class TrapezoidPainter extends CustomPainter {
  final double topWidth;
  final Gradient gradient;

  TrapezoidPainter({required this.topWidth, required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;

    Path path = Path()
      ..moveTo((size.width - topWidth) / 2, 0) // النقطة العلوية اليسرى
      ..lineTo((size.width + topWidth) / 2, 0) // النقطة العلوية اليمنى
      ..lineTo(size.width, size.height) // النقطة السفلية اليمنى
      ..lineTo(0, size.height) // النقطة السفلية اليسرى
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
