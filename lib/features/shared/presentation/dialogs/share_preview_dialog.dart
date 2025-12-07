import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/haptic_widgets.dart';
import '../../../../core/utils/haptic_feedback_helper.dart';
import '../../../../core/services/image_capture_service.dart';
import '../../../../core/services/instagram_sticker_service.dart';
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

  /// Optional widget builder for Instagram sticker format (square 1:1).
  /// If not provided, [previewWidget] will be used in a square container.
  final Widget Function()? stickerWidgetBuilder;

  /// Optional top gradient color for Instagram Stories background (hex format like '#FF5733').
  final String? stickerTopColor;

  /// Optional bottom gradient color for Instagram Stories background (hex format like '#C70039').
  final String? stickerBottomColor;

  const SharePreviewDialog({
    super.key,
    required this.previewWidget,
    required this.shareText,
    required this.shareSubject,
    this.aspectRatio = 9 / 16,
    this.stickerWidgetBuilder,
    this.stickerTopColor,
    this.stickerBottomColor,
  });

  /// Shows the share preview dialog.
  static Future<void> show({
    required BuildContext context,
    required Widget previewWidget,
    required String shareText,
    required String shareSubject,
    double aspectRatio = 9 / 16,
    Widget Function()? stickerWidgetBuilder,
    String? stickerTopColor,
    String? stickerBottomColor,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => SharePreviewDialog(
        previewWidget: previewWidget,
        shareText: shareText,
        shareSubject: shareSubject,
        aspectRatio: aspectRatio,
        stickerWidgetBuilder: stickerWidgetBuilder,
        stickerTopColor: stickerTopColor,
        stickerBottomColor: stickerBottomColor,
      ),
    );
  }

  @override
  State<SharePreviewDialog> createState() => _SharePreviewDialogState();
}

class _SharePreviewDialogState extends State<SharePreviewDialog> {
  final GlobalKey _previewKey = GlobalKey();
  final GlobalKey _stickerPreviewKey = GlobalKey();
  final ImageCaptureService _imageCaptureService = getIt<ImageCaptureService>();
  final InstagramStickerService _instagramStickerService = getIt<InstagramStickerService>();
  bool _isCapturing = false;
  bool _isSharingToInstagram = false;

  Future<void> _captureAndShare() async {
    if (_isCapturing) return;
    setState(() => _isCapturing = true);

    try {
      final pixelRatio = _imageCaptureService.getOptimalPixelRatio(context);

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

  Future<void> _captureAndShareToInstagram() async {
    if (_isSharingToInstagram) return;
    setState(() => _isSharingToInstagram = true);

    try {
      const pixelRatio = ShareConstants.stickerPixelRatio;

      final stickerFile = await _imageCaptureService.captureWidgetToStickerFile(
        _stickerPreviewKey,
        pixelRatio: pixelRatio,
        initialDelayMs: ShareConstants.initialCaptureDelayMs,
        finalDelayMs: ShareConstants.finalCaptureDelayMs,
        maxWaitAttempts: ShareConstants.maxPaintWaitAttempts,
        waitDelayMs: ShareConstants.paintWaitDelayMs,
        fileNamePrefix: 'instagram_sticker',
      );

      if (stickerFile == null) {
        throw Exception('Failed to capture sticker');
      }

      final result = await _instagramStickerService.shareSticker(
        stickerFile,
        topColor: widget.stickerTopColor,
        bottomColor: widget.stickerBottomColor,
      );

      if (mounted) {
        if (result == InstagramShareResult.success) {
          Navigator.pop(context);
        } else if (result == InstagramShareResult.instagramNotInstalled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('share_instagram_not_installed'.tr()),
              duration: const Duration(seconds: ShareConstants.snackBarDurationSeconds),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('share_instagram_failed'.tr()),
              duration: const Duration(seconds: ShareConstants.snackBarDurationSeconds),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error sharing to Instagram: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('share_instagram_failed'.tr()),
            duration: const Duration(seconds: ShareConstants.snackBarDurationSeconds),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSharingToInstagram = false);
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
      child: Stack(
        children: [
          Container(
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

                const SizedBox(height: DesignTokens.spacingL),
                
                // Action buttons
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: DesignTokens.spacingS,
                  runSpacing: DesignTokens.spacingS,
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
                    if (widget.stickerWidgetBuilder != null)
                      HapticFilledButton(
                        hapticType: HapticFeedbackType.mediumImpact,
                        onPressed: (_isSharingToInstagram || _isCapturing) 
                            ? null 
                            : _captureAndShareToInstagram,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignTokens.spacingM,
                            vertical: DesignTokens.spacingS,
                          ),
                          backgroundColor: tokens.primary,
                        ),
                        child: _isSharingToInstagram
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
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.auto_stories,
                                    size: 16,
                                    color: tokens.onPrimary,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      'share_to_story'.tr(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    HapticFilledButton(
                      hapticType: HapticFeedbackType.mediumImpact,
                      onPressed: (_isCapturing || _isSharingToInstagram) 
                          ? null 
                          : _captureAndShare,
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
          
          // Sticker preview for Instagram (off-screen, used for capture)
          Positioned(
            left: -10000,
            top: -10000,
            child: SizedBox(
              width: 400,
              height: 400,
              child: RepaintBoundary(
                key: _stickerPreviewKey,
                child: widget.stickerWidgetBuilder != null
                    ? widget.stickerWidgetBuilder!()
                    : widget.previewWidget,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
