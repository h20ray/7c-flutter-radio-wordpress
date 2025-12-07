import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../config/share_config.dart';
import '../../../../../core/themes/component_tokens.dart';
import '../../../../../core/themes/design_tokens.dart';
import '../../../../../core/widgets/haptic_widgets.dart';
import '../../../../../core/utils/haptic_feedback_helper.dart';
import '../../../../../core/services/image_capture_service.dart';
import '../../../../../core/constants/share_constants.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/utils/palette_cache.dart';
import '../radio_share_card.dart';

/// Dialog for sharing the currently playing track with Instagram mode toggle.
///
/// Features:
/// - Preview of the share card (9:16 aspect ratio)
/// - Instagram mode toggle for blank background
/// - Share button with loading state
///
/// Usage:
/// ```dart
/// RadioNowPlayingShareDialog.show(
///   context: context,
///   artist: 'Artist Name',
///   title: 'Track Title',
///   albumArtUrl: 'https://...',
///   palette: palette,
///   isPlaying: true,
/// );
/// ```
class RadioNowPlayingShareDialog extends StatefulWidget {
  final String? artist;
  final String? title;
  final String? albumArtUrl;
  final PaletteColors? palette;
  final bool isPlaying;

  const RadioNowPlayingShareDialog({
    super.key,
    this.artist,
    this.title,
    this.albumArtUrl,
    this.palette,
    this.isPlaying = false,
  });

  /// Shows the now playing share dialog.
  ///
  /// Returns when the dialog is dismissed.
  static Future<void> show({
    required BuildContext context,
    String? artist,
    String? title,
    String? albumArtUrl,
    PaletteColors? palette,
    bool isPlaying = false,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => RadioNowPlayingShareDialog(
        artist: artist,
        title: title,
        albumArtUrl: albumArtUrl,
        palette: palette,
        isPlaying: isPlaying,
      ),
    );
  }

  @override
  State<RadioNowPlayingShareDialog> createState() =>
      _RadioNowPlayingShareDialogState();
}

class _RadioNowPlayingShareDialogState
    extends State<RadioNowPlayingShareDialog> {
  final GlobalKey _previewCardKey = GlobalKey();
  final ImageCaptureService _imageCaptureService = getIt<ImageCaptureService>();
  bool _isCapturing = false;
  bool _useBlankBackground = false;

  Future<void> _captureAndShare() async {
    if (_isCapturing) return;
    setState(() => _isCapturing = true);

    try {
      final pixelRatio = _imageCaptureService.getOptimalPixelRatio(context);
      final shareText = widget.title != null && widget.title!.trim().isNotEmpty
          ? '${widget.title}${widget.artist != null && widget.artist!.trim().isNotEmpty ? ' - ${widget.artist}' : ''}'
          : 'Now Playing on ${ShareConfig.appNameFull}';

      // Capture image FIRST while the RepaintBoundary is still mounted
      await _imageCaptureService.captureAndShare(
        key: _previewCardKey,
        text: shareText,
        subject: 'share_now_playing_subject'.tr(),
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
      debugPrint('Error capturing radio share card: $e');
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
                  aspectRatio: 9 / 16,
                  child: RepaintBoundary(
                    key: _previewCardKey,
                    child: RadioShareCard(
                      artist: widget.artist,
                      title: widget.title,
                      albumArtUrl: widget.albumArtUrl,
                      palette: widget.palette,
                      isPlaying: widget.isPlaying,
                      useBlankBackground: _useBlankBackground,
                    ),
                  ),
                ),
              ),
            ),
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
                    value: _useBlankBackground,
                    onChanged: (value) {
                      setState(() {
                        _useBlankBackground = value;
                      });
                    },
                  ),
                ],
              ),
            ),
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
