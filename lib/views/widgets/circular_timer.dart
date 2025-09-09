import 'dart:math';
import 'dart:ui' show FontFeature; // <- necesario para FontFeature
import 'package:flutter/material.dart';

class CircularTimer extends StatelessWidget {
  final Duration elapsed;
  final String mainText;
  final String subText;
  final double size;
  final double stroke;

  const CircularTimer({
    super.key,
    required this.elapsed,
    required this.mainText,
    required this.subText,
    this.size = 300,
    this.stroke = 12,
  });

  @override
  Widget build(BuildContext context) {
    final p = (elapsed.inMilliseconds % 60000) / 60000.0;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          progress: p,
          trackColor: Theme.of(context)
              .colorScheme
              .onSurface
              .withValues(alpha: 0.15), // <-- reemplazo
          progressColor: Theme.of(context).colorScheme.primary,
          stroke: stroke,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                mainText,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Text(
                subText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double stroke;

  _RingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - stroke) / 2;

    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = trackColor
      ..strokeCap = StrokeCap.round;

    final active = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = progressColor
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi,
      false,
      base,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      (2 * pi) * progress,
      false,
      active,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress ||
      old.trackColor != trackColor ||
      old.progressColor != progressColor ||
      old.stroke != stroke;
}
