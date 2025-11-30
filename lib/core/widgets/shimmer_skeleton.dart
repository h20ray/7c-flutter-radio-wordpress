import 'package:flutter/material.dart';

class ShimmerSkeleton extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration period;

  const ShimmerSkeleton({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.period = const Duration(milliseconds: 1500),
  });

  @override
  State<ShimmerSkeleton> createState() => _ShimmerSkeletonState();
}

class _ShimmerSkeletonState extends State<ShimmerSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.period,
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
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 - _controller.value * 2, 0.0),
              end: Alignment(1.0 - _controller.value * 2, 0.0),
              colors: [
                widget.baseColor,
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration period;

  const ShimmerContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 0,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBaseColor = baseColor ??
        theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
    final effectiveHighlightColor = highlightColor ??
        theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);

    return ShimmerSkeleton(
      baseColor: effectiveBaseColor,
      highlightColor: effectiveHighlightColor,
      period: period,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: effectiveBaseColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double borderRadius;
  final Duration period;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    this.borderRadius = 8,
    this.period = const Duration(milliseconds: 1500),
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = color.withValues(alpha: 0.25);
    final highlight = color.withValues(alpha: 0.5);

    return ShimmerSkeleton(
      baseColor: baseColor,
      highlightColor: highlight,
      period: period,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
