import 'dart:math' as math;
import 'package:flutter/material.dart';

class SecurityScanner extends StatefulWidget {
  final Color color;
  final double dimensionLength;

  const SecurityScanner({
    super.key,
    this.color = Colors.green,
    this.dimensionLength = 300,
  });

  @override
  State<SecurityScanner> createState() => _SecurityScannerState();
}

class _SecurityScannerState extends State<SecurityScanner>
    with SingleTickerProviderStateMixin {
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
  Widget build(BuildContext context) {
    final size = Size(widget.dimensionLength, widget.dimensionLength);
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          CustomPaint(
            size: size,
            painter: StaticGridPainter(color: widget.color),
          ),
          RepaintBoundary(
            child: CustomPaint(
              size: size,
              painter: RadarScannerPainter(
                animationValue: _controller,
                color: widget.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class StaticGridPainter extends CustomPainter {
  final Color color;

  const StaticGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (var i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * (i / 4), paint);
    }
  }

  @override
  bool shouldRepaint(StaticGridPainter oldDelegate) =>
      oldDelegate.color != color;
}

class RadarScannerPainter extends CustomPainter {
  final Animation<double> animationValue;
  final Color color;

  RadarScannerPainter({required this.animationValue, required this.color})
    : super(repaint: animationValue);

  Paint? _radarPaint;
  Paint? _accentLinePaint;
  Shader? _shader;
  Size? _lastSize;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    if (_radarPaint == null || _accentLinePaint == null || _shader == null || _lastSize != size) {
      _shader = SweepGradient(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: math.pi * 2,
        colors: [color.withValues(alpha: 0.0), color.withValues(alpha: 0.5)],
        stops: const [0.75, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

      _radarPaint = Paint()
        ..style = PaintingStyle.fill
        ..shader = _shader;

      _accentLinePaint = Paint()
        ..color = color.withValues(alpha: 0.8)
        ..strokeWidth = 2.0;
      
      _lastSize = size;
    }

    final sweepAngle = animationValue.value * 2 * math.pi;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(sweepAngle - math.pi / 2);
    canvas.translate(-center.dx, -center.dy);

    canvas.drawCircle(center, radius, _radarPaint!);
    canvas.drawLine(center, Offset(center.dx + radius, center.dy), _accentLinePaint!);

    canvas.restore();
  }

  @override
  bool shouldRepaint(RadarScannerPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.animationValue != animationValue;
}
