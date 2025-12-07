import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../../core/themes/design_tokens.dart';
import 'radio_volume_control.dart';
import 'radio_sleep_timer_control.dart';

/// M3 Expressive settings dialog combining volume and sleep timer controls.
/// This is the parent dialog that composes both controls following Material Design 3 guidelines.
class RadioSettingsDialog extends StatelessWidget {
  const RadioSettingsDialog({super.key});

  /// Show the settings dialog with slide-down animation.
  static Future<void> show(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Settings',
      barrierColor: Colors.black38,
      transitionDuration: DesignTokens.animationDurationShort,
      pageBuilder: (context, animation, secondaryAnimation) =>
          const RadioSettingsDialog(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.3),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: DesignTokens.animationCurveSpring),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Align(
      alignment: Alignment.topCenter,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Material(
            elevation: 6,
            shadowColor: Colors.black26,
            borderRadius: BorderRadius.circular(28),
            color: cs.surfaceContainerHigh,
            surfaceTintColor: cs.surfaceTint,
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(DesignTokens.spacingXl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Volume control section with close button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(child: RadioVolumeControl()),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          LucideIcons.x,
                          size: 20,
                          color: cs.onSurfaceVariant,
                        ),
                        style: IconButton.styleFrom(
                          minimumSize: const Size(40, 40),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Divider
                  Divider(color: cs.outlineVariant, height: 1),
                  const SizedBox(height: 24),
                  // Sleep timer section
                  const RadioSleepTimerControl(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
