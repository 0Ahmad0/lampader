import 'package:flutter/material.dart';
import 'dart:math';

class QuarterCircularSliderWidget extends StatefulWidget {
  final double size;
  final double trackWidth;
  final double thumbSize;
  final Color trackColor;
  final Color? thumbColor;
  final Gradient? gradient;
  final ValueChanged<double>? onChange;

  const QuarterCircularSliderWidget({
    super.key,
    required this.size,
    this.trackWidth = 10,
    this.thumbSize = 15,
    this.trackColor = Colors.grey,
    this.thumbColor = Colors.blue,
    this.gradient,
    this.onChange,
  });

  @override
  _QuarterCircularSliderWidgetState createState() => _QuarterCircularSliderWidgetState();
}

class _QuarterCircularSliderWidgetState extends State<QuarterCircularSliderWidget>
    with SingleTickerProviderStateMixin {
  double _value = 0.0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 0, end: _value).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  void _updateValue(Offset offset, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final dx = offset.dx - center.dx;
    final dy = offset.dy - center.dy;

    double angle = atan2(dy, dx);

    // تحويل الزاوية لتبدأ من الربع الرابع (القيمة 0) وتنتهي في الربع الأول (القيمة 1)
    if (angle >= -pi / 2 && angle <= pi / 2) {
      setState(() {
        _value = (pi / 2 - angle) / pi;
        _animation = Tween<double>(begin: _animation.value, end: _value).animate(_controller);
        _controller.forward(from: 0); // تشغيل الأنيميشن
        widget.onChange?.call(_value); // استدعاء تابع onChange إذا كان موجوداً
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        RenderBox box = context.findRenderObject() as RenderBox;
        Offset localPosition = box.globalToLocal(details.globalPosition);
        _updateValue(localPosition, box.size);
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            size: Size(widget.size, widget.size),
            painter: QuarterCircularSliderPainter(
              value: _animation.value,
              trackWidth: widget.trackWidth,
              thumbSize: widget.thumbSize,
              trackColor: widget.trackColor,
              thumbColor: widget.thumbColor,
              gradient: widget.gradient,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class QuarterCircularSliderPainter extends CustomPainter {
  final double value;
  final double trackWidth;
  final double thumbSize;
  final Color trackColor;
  final Color? thumbColor;
  final Gradient? gradient;

  QuarterCircularSliderPainter({
    required this.value,
    required this.trackWidth,
    required this.thumbSize,
    required this.trackColor,
    this.thumbColor,
    this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = trackWidth
      ..style = PaintingStyle.stroke;

    Paint thumbPaint = Paint()
      ..color = thumbColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    if (gradient != null) {
      trackPaint.shader = gradient!.createShader(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
      );
    }

    double radius = min(size.width / 2, size.height / 2) - thumbSize / 2;
    double angle = (pi / 2 - value * pi);

    // رسم الربع الأول
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
      -pi / 2,
      pi / 2,
      false,
      trackPaint,
    );

    // رسم الربع الرابع
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
      0,
      pi / 2,
      false,
      trackPaint,
    );

    // حساب موقع مؤشر التمرير
    Offset thumbPos = Offset(
      size.width / 2 + radius * cos(angle),
      size.height / 2 + radius * sin(angle),
    );

    // رسم مؤشر التمرير
    canvas.drawCircle(thumbPos, thumbSize / 2, thumbPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
