import 'dart:math' as math;

import 'package:flutter/material.dart';

class SecurityScanner extends StatefulWidget {
const SecurityScanner({super.key});

@override
State<SecurityScanner> createState() => _SecurityScannerState();
}

class _SecurityScannerState extends State<SecurityScanner> with SingleTickerProviderStateMixin {
late AnimationController _controller;

@override
void initState() {
super.initState();
_controller = AnimationController(
vsync: this,
duration: const Duration(seconds: 3),
)..repeat();
}

@override
void dispose() {
_controller.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return RepaintBoundary( // Критично для FPS
child: CustomPaint(
size: const Size(300, 300),
painter: RadarPainter(animationValue: _controller),
),
);
}
}

class RadarPainter extends CustomPainter {
  final Animation<double> animationValue;

  // Кэшируем Paint, чтобы не создавать объекты в методе paint (каждые 8мс)
  final Paint _gridPaint = Paint()
    ..color = Colors.green.withOpacity(0.2)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  final Paint _radarPaint = Paint()..style = PaintingStyle.fill;

  RadarPainter({required this.animationValue}) : super(repaint: animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Отрисовка сетки (статичная часть)
    for (var i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * (i / 4), _gridPaint);
    }

    // 2. Математика сканера (Sweep Gradient)
    final sweepAngle = animationValue.value * 2 * math.pi;

    _radarPaint.shader = SweepGradient(
      center: Alignment.center,
      startAngle: 0.0,
      endAngle: math.pi * 2,
      colors: [
        Colors.green.withOpacity(0.0),
        Colors.green.withOpacity(0.5),
      ],
      stops: const [0.75, 1.0],
      transform: GradientRotation(sweepAngle - math.pi / 2),
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, _radarPaint);

    // 3. Акцентная линия (луч)
    final dx = center.dx + radius * math.cos(sweepAngle - math.pi / 2);
    final dy = center.dy + radius * math.sin(sweepAngle - math.pi / 2);

    canvas.drawLine(
        center,
        Offset(dx, dy),
        _gridPaint..color = Colors.green.withOpacity(0.8)..strokeWidth = 2.0
    );
  }

  @override
  bool shouldRepaint(RadarPainter oldDelegate) => false; // Используем Animation в конструкторе
}