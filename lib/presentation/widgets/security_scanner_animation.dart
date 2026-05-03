import 'dart:math' as math;
import 'package:flutter/material.dart';

class SecurityScannerAnimation extends StatefulWidget {
  final Color color;
  final double size;

  const SecurityScannerAnimation({
    super.key,
    required this.color,
    this.size = 200,
  });

  @override
  State<SecurityScannerAnimation> createState() => _SecurityScannerAnimationState();
}

class _SecurityScannerAnimationState extends State<SecurityScannerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: ScannerPainter(
            progress: _controller.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class ScannerPainter extends CustomPainter {
  final double progress;
  final Color color;

  ScannerPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final bgPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw static concentric circles
    for (var i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * (i / 4), bgPaint);
    }

    // Draw pulsating waves (Sine based)
    final wavePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (var i = 0; i < 3; i++) {
      final waveProgress = (progress + (i * 0.33)) % 1.0;
      final waveRadius = radius * waveProgress;
      final opacity = (1.0 - waveProgress).clamp(0.0, 1.0);
      
      wavePaint.color = color.withOpacity(opacity * 0.5);
      canvas.drawCircle(center, waveRadius, wavePaint);
    }

    // Draw Rotating Radar Sweep (Math heavy gradient)
    final sweepAngle = progress * 2 * math.pi;
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: sweepAngle - (math.pi / 2),
        endAngle: sweepAngle,
        colors: [
          color.withOpacity(0.0),
          color.withOpacity(0.5),
        ],
        stops: const [0.75, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 2); // Start from top
    canvas.translate(-center.dx, -center.dy);
    canvas.drawCircle(center, radius, sweepPaint);
    canvas.restore();

    // Draw scanning "data" points (Sine wave movement)
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4) + (progress * math.pi * 0.5);
      final distanceFactor = 0.5 + 0.3 * math.sin(progress * 2 * math.pi + i);
      final pointOffset = Offset(
        center.dx + math.cos(angle) * radius * distanceFactor,
        center.dy + math.sin(angle) * radius * distanceFactor,
      );
      
      final pointSize = 2.0 + 2.0 * math.sin(progress * 4 * math.pi + i);
      canvas.drawCircle(pointOffset, pointSize, pointPaint);
    }
    
    // Draw the "active" scanning line (Moving sine wave across the circle)
    final scanLineY = center.dy - radius + (radius * 2 * progress);
    final linePaint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (double x = center.dx - radius; x <= center.dx + radius; x += 2) {
      // Calculate if the point is inside the circle
      final dx = x - center.dx;
      final maxY = math.sqrt(math.max(0, radius * radius - dx * dx));
      
      if ((scanLineY - center.dy).abs() <= maxY) {
        final sineOffset = 5 * math.sin((x / radius * 10) + (progress * 2 * math.pi));
        if (x == center.dx - radius) {
          path.moveTo(x, scanLineY + sineOffset);
        } else {
          path.lineTo(x, scanLineY + sineOffset);
        }
      }
    }
    //canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant ScannerPainter oldDelegate) => true;
}
