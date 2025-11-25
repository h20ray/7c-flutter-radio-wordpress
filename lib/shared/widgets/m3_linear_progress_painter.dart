import 'package:flutter/material.dart';

/// Shared painter that mimics the Material 3 linear indicator treatment.
class M3LinearProgressPainter extends CustomPainter {
  const M3LinearProgressPainter({
    required this.progress,
    required this.barHeight,
    required this.activeColor,
    required this.trackColor,
    required this.thumbColor,
    required this.borderColor,
    required this.shimmerPhase,
    required this.enableShimmer,
    this.showThumb = true,
  });

  final double progress;
  final double barHeight;
  final Color activeColor;
  final Color trackColor;
  final Color thumbColor;
  final Color borderColor;
  final double shimmerPhase;
  final bool enableShimmer;
  final bool showThumb;

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final radius = Radius.circular(barHeight / 2);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = barHeight
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), trackPaint);

    final activeWidth = (size.width * progress).clamp(0.0, size.width);

    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = barHeight
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    if (activeWidth > 0) {
      canvas.drawLine(Offset(0, centerY), Offset(activeWidth, centerY), activePaint);
    }

    if (enableShimmer && activeWidth > 8) {
      final desiredWidth = size.width * 0.35;
      final shimmerWidth = desiredWidth.clamp(0.0, activeWidth).clamp(0.0, 56.0);
      final offset = (shimmerPhase % 1.0) * (activeWidth + shimmerWidth) - shimmerWidth;
      final shimmerRect = Rect.fromLTWH(offset, 0, shimmerWidth, size.height)
          .intersect(Rect.fromLTWH(0, 0, activeWidth, size.height));

      if (!shimmerRect.isEmpty) {
        final shimmerPaint = Paint()
          ..shader = LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.transparent,
              Colors.white.withValues(alpha: 0.22),
              Colors.white.withValues(alpha: 0.1),
              Colors.transparent,
            ],
            stops: const [0.0, 0.35, 0.65, 1.0],
          ).createShader(shimmerRect)
          ..blendMode = BlendMode.srcOver;

        final rrect = RRect.fromLTRBR(0, 0, activeWidth, size.height, radius);
        canvas.save();
        canvas.clipRRect(rrect);
        canvas.drawRect(shimmerRect, shimmerPaint);
        canvas.restore();
      }
    }

    if (showThumb) {
      final thumbRadius = barHeight * 0.5;
      final thumbCenter =
          Offset(activeWidth.clamp(thumbRadius, size.width - thumbRadius), centerY);

      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(thumbCenter.translate(0, 1), thumbRadius, shadowPaint);

      final thumbPaint = Paint()
        ..color = thumbColor
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
      canvas.drawCircle(thumbCenter, thumbRadius, thumbPaint);

      final borderPaint = Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..isAntiAlias = true;
      canvas.drawCircle(thumbCenter, thumbRadius, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant M3LinearProgressPainter oldDelegate) {
    return (oldDelegate.progress - progress).abs() > 0.01 ||
        oldDelegate.barHeight != barHeight ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.thumbColor != thumbColor ||
        oldDelegate.borderColor != borderColor ||
        (oldDelegate.shimmerPhase - shimmerPhase).abs() > 0.01 ||
        oldDelegate.enableShimmer != enableShimmer ||
        oldDelegate.showThumb != showThumb;
  }
}

