import 'dart:ui';

import 'package:flutter/material.dart';

import '../themes/app_color_system.dart';
import '../themes/design_tokens.dart';

class GlassAppBarBackground extends StatelessWidget {
  final Widget child;

  const GlassAppBarBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final colors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    final navTint = colorScheme.primary.withValues(alpha: isDark ? 0.25 : 0.18);
    final glassBackground = Color.alphaBlend(navTint, colors.navBackground);
    final glassOpacity = isDark ? 0.92 : 0.88;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: DesignTokens.backdropBlurSigma,
          sigmaY: DesignTokens.backdropBlurSigma,
        ),
        child: Container(
          color: glassBackground.withValues(alpha: glassOpacity),
          child: child,
        ),
      ),
    );
  }
}
