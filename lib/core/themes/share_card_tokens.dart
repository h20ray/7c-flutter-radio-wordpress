import 'package:flutter/material.dart';

class ShareCardTokens {
  ShareCardTokens._({
    required this.background,
    required this.overlayGradient,
    required this.textPrimary,
    required this.textSecondary,
    required this.iconBackground,
    required this.iconForeground,
  });

  factory ShareCardTokens.of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    
    return ShareCardTokens._(
      background: brightness == Brightness.dark ? Colors.black : Colors.black,
      overlayGradient: [
        Colors.black.withValues(alpha: 0.4),
        Colors.black.withValues(alpha: 0.2),
        Colors.black.withValues(alpha: 0.6),
        Colors.black.withValues(alpha: 0.85),
      ],
      textPrimary: Colors.white,
      textSecondary: Colors.white.withValues(alpha: 0.8),
      iconBackground: Colors.white,
      iconForeground: Colors.black,
    );
  }

  final Color background;
  final List<Color> overlayGradient;
  final Color textPrimary;
  final Color textSecondary;
  final Color iconBackground;
  final Color iconForeground;
}

