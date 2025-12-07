import 'package:flutter/material.dart';

import 'app_color_system.dart';
import 'design_tokens.dart';

/// Component tokens for action chips used in radio menu and other areas.
///
/// Provides consistent styling for interactive chip components following
/// Material 3 guidelines and the app's design system.
///
/// Usage:
/// ```dart
/// final tokens = ActionChipTokens.of(context);
/// Container(
///   decoration: BoxDecoration(
///     color: tokens.background,
///     border: Border.all(color: tokens.border),
///     borderRadius: BorderRadius.circular(tokens.cornerRadius),
///   ),
///   child: Row(
///     children: [
///       Icon(icon, color: tokens.icon),
///       Text(label, style: TextStyle(color: tokens.text)),
///     ],
///   ),
/// );
/// ```
class ActionChipTokens {
  ActionChipTokens._({
    required this.background,
    required this.backgroundPressed,
    required this.border,
    required this.text,
    required this.icon,
    required this.loadingIndicator,
    required this.cornerRadius,
    required this.padding,
    required this.iconSize,
    required this.spacing,
  });

  factory ActionChipTokens.of(BuildContext context) {
    final colors = context.appColors;
    final scheme = colors.colorScheme;

    return ActionChipTokens._(
      background: Colors.transparent,
      backgroundPressed: scheme.onSurface.withValues(alpha: 0.08),
      border: colors.textSecondary.withValues(alpha: 0.2),
      text: colors.textSecondary,
      icon: colors.textSecondary,
      loadingIndicator: scheme.primary,
      cornerRadius: DesignTokens.cornerRadiusPill,
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingS,
        vertical: DesignTokens.spacingS,
      ),
      iconSize: DimensionTokens.iconSizeSmall,
      spacing: DesignTokens.spacingXs,
    );
  }

  /// Background color for the chip
  final Color background;

  /// Background color when pressed
  final Color backgroundPressed;

  /// Border color
  final Color border;

  /// Text label color
  final Color text;

  /// Icon color
  final Color icon;

  /// Loading indicator color
  final Color loadingIndicator;

  /// Corner radius (pill shape)
  final double cornerRadius;

  /// Internal padding
  final EdgeInsets padding;

  /// Icon size
  final double iconSize;

  /// Spacing between icon and text
  final double spacing;
}
