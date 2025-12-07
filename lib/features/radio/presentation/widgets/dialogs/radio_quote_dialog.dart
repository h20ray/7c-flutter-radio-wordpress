import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../../core/themes/component_tokens.dart';
import '../../../../../core/themes/design_tokens.dart';
import '../../../../../core/widgets/haptic_widgets.dart';
import '../../../../../core/utils/haptic_feedback_helper.dart';
import '../../../../../core/services/image_capture_service.dart';
import '../../../../../core/constants/share_constants.dart';
import '../../../../../core/di/injection_container.dart';
import '../radio_quote_share_card.dart';

/// Dialog displaying a daily quote with share functionality.
///
/// This dialog is shown when the user taps on the greeting chip.
/// It displays the quote prominently with options to share.
///
/// Usage:
/// ```dart
/// RadioQuoteDialog.show(
///   context: context,
///   quote: 'Your inspirational quote...',
///   albumArtUrl: 'https://...',
/// );
/// ```
class RadioQuoteDialog extends StatefulWidget {
  final String quote;
  final String? albumArtUrl;

  const RadioQuoteDialog({
    super.key,
    required this.quote,
    this.albumArtUrl,
  });

  /// Shows the quote dialog.
  ///
  /// Returns when the dialog is dismissed.
  static Future<void> show({
    required BuildContext context,
    required String quote,
    String? albumArtUrl,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => RadioQuoteDialog(
        quote: quote,
        albumArtUrl: albumArtUrl,
      ),
    );
  }

  @override
  State<RadioQuoteDialog> createState() => _RadioQuoteDialogState();
}

class _RadioQuoteDialogState extends State<RadioQuoteDialog> {
  final GlobalKey _shareCardKey = GlobalKey();
  final ImageCaptureService _imageCaptureService = getIt<ImageCaptureService>();
  bool _isCapturing = false;

  Future<void> _captureAndShare() async {
    if (_isCapturing) return;
    setState(() => _isCapturing = true);

    try {
      final pixelRatio = _imageCaptureService.getOptimalPixelRatio(context);
      await _imageCaptureService.captureAndShare(
        key: _shareCardKey,
        text: widget.quote,
        subject: 'share_quote_subject'.tr(),
        pixelRatio: pixelRatio,
      );
    } catch (e) {
      debugPrint('Error capturing quote share card: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('share_error_capture_failed'.tr()),
            duration: const Duration(seconds: ShareConstants.snackBarDurationSeconds),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCapturing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ShareDialogTokens.of(context);
    final theme = Theme.of(context);

    return Stack(
      children: [
        // Off-screen share card for capture
        Transform.translate(
          offset: const Offset(-10000, -10000),
          child: RepaintBoundary(
            key: _shareCardKey,
            child: RadioQuoteShareCard(
              quote: widget.quote,
              albumArtUrl: widget.albumArtUrl,
            ),
          ),
        ),
        // Visible dialog
        Dialog(
          backgroundColor: tokens.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tokens.cornerRadius),
          ),
          child: Container(
            padding: const EdgeInsets.all(DesignTokens.spacingL),
            constraints: const BoxConstraints(maxWidth: 320),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Quote icon
                Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    LucideIcons.quote,
                    size: 32,
                    color: tokens.primary,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingM),
                // Quote text
                Text(
                  widget.quote,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    height: 1.3,
                    color: tokens.onSurface,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingL),
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    HapticTextButton(
                      hapticType: HapticFeedbackType.selectionClick,
                      onPressed: _isCapturing
                          ? null
                          : () async {
                              await _captureAndShare();
                            },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingM,
                          vertical: DesignTokens.spacingS,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isCapturing)
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  tokens.primary,
                                ),
                              ),
                            )
                          else
                            Icon(
                              LucideIcons.share_2,
                              size: 18,
                              color: tokens.primary,
                            ),
                          const SizedBox(width: DesignTokens.spacingXs),
                          Text(
                            'share_action'.tr(),
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: tokens.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacingS),
                    HapticTextButton(
                      hapticType: HapticFeedbackType.selectionClick,
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingM,
                          vertical: DesignTokens.spacingS,
                        ),
                      ),
                      child: Text(
                        'close'.tr(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: tokens.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
