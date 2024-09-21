import 'package:flutter/material.dart';
import 'dart:math';

class HalfCirclePainter extends CustomPainter {
  final double saved;
  final double target;

  HalfCirclePainter({required this.saved, required this.target});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = const Color(0xff2abf7c).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    final progressPaint = Paint()
      ..color = const Color(0xff2abf7c)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8.0;

    final double progress = (saved / target).clamp(0.0, 1.0);

    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      backgroundPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi * progress,
      false,
      progressPaint,
    );

    final progressEndAngle = pi + (pi * progress);
    final progressEndX = center.dx + radius * cos(progressEndAngle);
    final progressEndY = center.dy + radius * sin(progressEndAngle);
    final progressEnd = Offset(progressEndX, progressEndY);

    canvas.drawCircle(progressEnd, 8.0, progressPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: "\$${saved.toStringAsFixed(2)}\n",
            style: const TextStyle(
              fontSize: 34.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: "of \$${target.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black54,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: size.width);
    final textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 1,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
