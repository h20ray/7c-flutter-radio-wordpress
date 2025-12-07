import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/haptic_widgets.dart';
import '../../../../core/utils/haptic_feedback_helper.dart';
import '../../../../core/services/image_capture_service.dart';
import '../../../../core/constants/share_constants.dart';
import '../../../../core/di/injection_container.dart';

/// A generic dialog for previewing and sharing a widget as an image.
///
/// This dialog displays the provided [previewWidget] in a responsive container,
/// handles the image capture using [ImageCaptureService], and shares it via the system share sheet.
class SharePreviewDialog extends StatefulWidget {
  /// The widget to be captured and shared.
  /// This widget will be wrapped in a [RepaintBoundary] internally.
  final Widget previewWidget;

  /// The text to share along with the image.
  final String shareText;

  /// The subject of the share (used in emails, etc.).
  final String shareSubject;

  /// Optional aspect ratio for the preview container. Defaults to 9/16.
  final double aspectRatio;

  /// Whether to show the Instagram mode toggle (blank background).
  /// If true, the [onToggleInstagramMode] callback must be provided.
  final bool showInstagramToggle;

  /// Callback when the Instagram mode toggle is changed.
  final ValueChanged<bool>? onToggleInstagramMode;

  /// Current state of the Instagram mode toggle.
  final bool isInstagramMode;

  const SharePreviewDialog({
    super.key,
    required this.previewWidget,
    required this.shareText,
    required this.shareSubject,
    this.aspectRatio = 9 / 16,
    this.showInstagramToggle = false,
    this.onToggleInstagramMode,
    this.isInstagramMode = false,
  });

  /// Shows the share preview dialog.
  static Future<void> show({
    required BuildContext context,
    required Widget previewWidget,
    required String shareText,
    required String shareSubject,
    double aspectRatio = 9 / 16,
    bool showInstagramToggle = false,
    ValueChanged<bool>? onToggleInstagramMode,
    bool isInstagramMode = false,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => SharePreviewDialog(
        previewWidget: previewWidget,
        shareText: shareText,
        shareSubject: shareSubject,
        aspectRatio: aspectRatio,
        showInstagramToggle: showInstagramToggle,
        onToggleInstagramMode: onToggleInstagramMode,
        isInstagramMode: isInstagramMode,
      ),
    );
  }

  @override
  State<SharePreviewDialog> createState() => _SharePreviewDialogState();
}

class _SharePreviewDialogState extends State<SharePreviewDialog> {
  final GlobalKey _previewKey = GlobalKey();
  final ImageCaptureService _imageCaptureService = getIt<ImageCaptureService>();
  bool _isCapturing = false;

  Future<void> _captureAndShare() async {
    if (_isCapturing) return;
    setState(() => _isCapturing = true);

    try {
      final pixelRatio = _imageCaptureService.getOptimalPixelRatio(context);

      // Capture image FIRST while the RepaintBoundary is still mounted
      await _imageCaptureService.captureAndShare(
        key: _previewKey,
        text: widget.shareText,
        subject: widget.shareSubject,
        pixelRatio: pixelRatio,
        initialDelayMs: ShareConstants.initialCaptureDelayMs,
        finalDelayMs: ShareConstants.finalCaptureDelayMs,
        maxWaitAttempts: ShareConstants.maxPaintWaitAttempts,
        waitDelayMs: ShareConstants.paintWaitDelayMs,
      );

      // Close dialog AFTER successful capture
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Error capturing share card: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('share_error_capture_failed'.tr()),
            duration:
                const Duration(seconds: ShareConstants.snackBarDurationSeconds),
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
    final mediaQuery = MediaQuery.of(context);

    return Dialog(
      backgroundColor: tokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.cornerRadius),
      ),
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.spacingL),
        constraints: BoxConstraints(
          maxWidth: mediaQuery.size.width * 0.9,
          maxHeight: mediaQuery.size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Preview container
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 500),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(tokens.previewCornerRadius),
                  color: tokens.surface,
                ),
                clipBehavior: Clip.antiAlias,
                child: AspectRatio(
                  aspectRatio: widget.aspectRatio,
                  child: RepaintBoundary(
                    key: _previewKey,
                    child: widget.previewWidget,
                  ),
                ),
              ),
            ),
            
            if (widget.showInstagramToggle) ...[
              const SizedBox(height: DesignTokens.spacingL),
              // Instagram mode toggle
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingM,
                  vertical: DesignTokens.spacingS,
                ),
                decoration: BoxDecoration(
                  color: tokens.optionBackground,
                  borderRadius:
                      BorderRadius.circular(DesignTokens.cornerRadiusProgress),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'share_instagram_mode_title'.tr(),
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: tokens.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'share_instagram_mode_description'.tr(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: tokens.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: widget.isInstagramMode,
                      onChanged: widget.onToggleInstagramMode,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: DesignTokens.spacingL),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                    'cancel'.tr(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: tokens.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingS),
                HapticFilledButton(
                  hapticType: HapticFeedbackType.mediumImpact,
                  onPressed: _isCapturing ? null : _captureAndShare,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingM,
                      vertical: DesignTokens.spacingS,
                    ),
                  ),
                  child: _isCapturing
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              tokens.onPrimary,
                            ),
                          ),
                        )
                      : Text('share_action'.tr()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
