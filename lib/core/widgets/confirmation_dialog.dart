import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../themes/component_tokens.dart';
import '../themes/design_tokens.dart';
import 'haptic_widgets.dart';
import '../utils/haptic_feedback_helper.dart';

class ConfirmationDialog extends StatelessWidget {
  final String titleKey;
  final String messageKey;
  final String confirmTextKey;
  final String cancelTextKey;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.titleKey,
    required this.messageKey,
    this.confirmTextKey = 'dialog_confirm',
    this.cancelTextKey = 'dialog_cancel',
    this.icon,
    this.iconColor,
    required this.onConfirm,
    this.onCancel,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String titleKey,
    required String messageKey,
    String confirmTextKey = 'dialog_confirm',
    String cancelTextKey = 'dialog_cancel',
    IconData? icon,
    Color? iconColor,
    Color? barrierColor,
  }) {
    final completer = Completer<bool?>();

    final tokens = DialogOverlayTokens.of(context);
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: barrierColor ?? tokens.barrier,
      builder: (dialogContext) => ConfirmationDialog(
        titleKey: titleKey,
        messageKey: messageKey,
        confirmTextKey: confirmTextKey,
        cancelTextKey: cancelTextKey,
        icon: icon,
        iconColor: iconColor,
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          if (!completer.isCompleted) {
            completer.complete(true);
          }
        },
        onCancel: () {
          Navigator.of(dialogContext).pop();
          if (!completer.isCompleted) {
            completer.complete(false);
          }
        },
      ),
    ).then((value) {
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    });

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tokens = DialogOverlayTokens.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backdropOpacity = isDark 
        ? DesignTokens.backdropBlurOpacityDark 
        : DesignTokens.backdropBlurOpacityLight;

    return Dialog(
      backgroundColor: tokens.background,
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: DesignTokens.backdropBlurSigma,
            sigmaY: DesignTokens.backdropBlurSigma,
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(DesignTokens.spacingXl),
            decoration: BoxDecoration(
              color: tokens.surface.withValues(
                alpha: backdropOpacity,
              ),
              borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
              border: Border.all(
                color: tokens.outline,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (iconColor ?? colorScheme.error).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? colorScheme.error,
                  size: 24,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingL),
            ],
            Text(
              titleKey.tr(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingM),
            Text(
              messageKey.tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingXl),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                HapticTextButton(
                  onPressed: onCancel ?? () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingL,
                      vertical: DesignTokens.spacingM,
                    ),
                  ),
                  child: Text(cancelTextKey.tr()),
                ),
                const SizedBox(width: DesignTokens.spacingM),
                HapticFilledButton(
                  hapticType: HapticFeedbackType.mediumImpact,
                  onPressed: onConfirm,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingL,
                      vertical: DesignTokens.spacingM,
                    ),
                    backgroundColor: iconColor ?? colorScheme.error,
                    foregroundColor: colorScheme.onError,
                  ),
                  child: Text(confirmTextKey.tr()),
                ),
              ],
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

