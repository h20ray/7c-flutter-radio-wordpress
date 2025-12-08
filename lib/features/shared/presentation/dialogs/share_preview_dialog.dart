import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/haptic_widgets.dart';
import '../../../../core/utils/haptic_feedback_helper.dart';
import '../../../../core/constants/share_constants.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/image_capture_service.dart';
import '../../../../core/services/instagram_sticker_service.dart';
import '../../../radio/presentation/widgets/radio_share_card.dart';

/// A generic dialog for previewing and sharing a widget as an image.
///
/// This dialog displays the provided [previewWidget] in a responsive container,
/// handles the image capture using [ImageCaptureService], and shares it via the system share sheet.
class SharePreviewDialog extends StatefulWidget {
  /// The widget shown in the preview.
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

  /// Optional widget builder for regular share capture (with background).
  /// If not provided, [previewWidget] will be used.
  final Widget Function()? regularShareWidgetBuilder;

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
    this.regularShareWidgetBuilder,
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
    Widget Function()? regularShareWidgetBuilder,
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
        regularShareWidgetBuilder: regularShareWidgetBuilder,
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
  final GlobalKey _regularCaptureKey = GlobalKey();
  final GlobalKey _instagramPreviewKey = GlobalKey();
  final ImageCaptureService _imageCaptureService = getIt<ImageCaptureService>();
  final InstagramStickerService _instagramStickerService = getIt<InstagramStickerService>();
  bool _isCapturing = false;
  bool _isSharingToInstagram = false;

  Widget _getPreviewWidget() {
    return widget.previewWidget;
  }

  Widget _getRegularShareWidget() {
    if (widget.regularShareWidgetBuilder != null) {
      return widget.regularShareWidgetBuilder!();
    }
    if (widget.stickerWidgetBuilder != null) {
      final baseWidget = widget.stickerWidgetBuilder!();
      if (baseWidget is RadioShareCard) {
        return RadioShareCard(
          artist: baseWidget.artist,
          title: baseWidget.title,
          albumArtUrl: baseWidget.albumArtUrl,
          palette: baseWidget.palette,
          isPlaying: baseWidget.isPlaying,
          hasBackground: true,
        );
      }
      return baseWidget;
    }
    if (widget.previewWidget is RadioShareCard) {
      final baseWidget = widget.previewWidget as RadioShareCard;
      return RadioShareCard(
        artist: baseWidget.artist,
        title: baseWidget.title,
        albumArtUrl: baseWidget.albumArtUrl,
        palette: baseWidget.palette,
        isPlaying: baseWidget.isPlaying,
        hasBackground: true,
      );
    }
    return widget.previewWidget;
  }

  Future<void> _captureAndShare() async {
    if (_isCapturing) return;
    setState(() => _isCapturing = true);

    try {
      const pixelRatio = ShareConstants.stickerPixelRatio;

      final shareFile = await _imageCaptureService.captureWidgetToRegularShareFile(
        _regularCaptureKey,
        pixelRatio: pixelRatio,
        initialDelayMs: ShareConstants.initialCaptureDelayMs,
        finalDelayMs: ShareConstants.finalCaptureDelayMs,
        maxWaitAttempts: ShareConstants.maxPaintWaitAttempts,
        waitDelayMs: ShareConstants.paintWaitDelayMs,
        fileNamePrefix: 'share',
      );

      if (shareFile == null) {
        throw Exception('Failed to capture image');
      }

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(shareFile.path)],
          text: widget.shareText,
          subject: widget.shareSubject,
        ),
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
        _instagramPreviewKey,
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
    final mediaQuery = MediaQuery.of(context);
    final regularPreviewWidget = _getPreviewWidget();
    final regularCaptureWidget = _getRegularShareWidget();
    final instagramPreviewWidget = widget.stickerWidgetBuilder != null
        ? widget.stickerWidgetBuilder!()
        : widget.previewWidget;
    final aspectRatio = widget.stickerWidgetBuilder != null
        ? ShareConstants.stickerAspectRatio
        : widget.aspectRatio;

    const dialogPadding = DesignTokens.spacingL;
    const buttonHeight = 40.0;
    const buttonSpacing = DesignTokens.spacingL;

    return Dialog(
      backgroundColor: tokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.cornerRadius),
      ),
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final maxDialogWidth = mediaQuery.size.width * 0.9;
              final maxDialogHeight = mediaQuery.size.height * 0.85;
              
              final availableWidth = (maxDialogWidth - (dialogPadding * 2)).clamp(0.0, double.infinity);
              final availableHeight = (maxDialogHeight - (dialogPadding * 2) - buttonHeight - buttonSpacing).clamp(0.0, double.infinity);
              
              double previewWidth = availableWidth;
              double previewHeight = previewWidth / aspectRatio;
              
              if (previewHeight > availableHeight) {
                previewHeight = availableHeight;
                previewWidth = previewHeight * aspectRatio;
              }
              
              previewWidth = previewWidth.clamp(0.0, availableWidth);
              previewHeight = previewHeight.clamp(0.0, availableHeight);

              return Container(
                padding: const EdgeInsets.all(dialogPadding),
                constraints: BoxConstraints(
                  maxWidth: maxDialogWidth,
                  maxHeight: maxDialogHeight,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: previewWidth,
                        height: previewHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(tokens.previewCornerRadius),
                          color: tokens.surface,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: RepaintBoundary(
                          key: _previewKey,
                          child: regularPreviewWidget,
                        ),
                      ),
                    ),
                const SizedBox(height: buttonSpacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                                    LucideIcons.instagram,
                                    size: 16,
                                    color: tokens.onPrimary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text('share_instagram'.tr()),
                                ],
                              ),
                      ),
                    if (widget.stickerWidgetBuilder != null)
                      const SizedBox(width: DesignTokens.spacingS),
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
              );
            },
          ),
          Positioned(
            left: -10000,
            top: -10000,
            child: SizedBox(
              width: 500,
              height: 615,
              child: RepaintBoundary(
                key: _instagramPreviewKey,
                child: instagramPreviewWidget,
              ),
            ),
          ),
      Positioned(
        left: -20000,
        top: -20000,
        child: SizedBox(
          width: ShareConstants.regularShareWidth,
          height: ShareConstants.regularShareHeight,
          child: RepaintBoundary(
            key: _regularCaptureKey,
            child: regularCaptureWidget,
          ),
        ),
      ),
        ],
      ),
    );
  }
}
