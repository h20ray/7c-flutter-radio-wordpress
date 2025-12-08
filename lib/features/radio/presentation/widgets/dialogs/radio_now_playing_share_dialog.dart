import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../config/share_config.dart';
import '../../../../../core/constants/share_constants.dart';
import '../../../../../core/utils/palette_cache.dart';
import '../../../../../features/shared/presentation/dialogs/share_preview_dialog.dart';
import '../radio_share_card.dart';
import '../radio_share_regular_card.dart';
import '../radio_share_regular_canvas.dart';

/// Dialog for sharing the currently playing track with Instagram mode toggle.
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
  /// Converts a Color to hex string format for Instagram (e.g., '#FF5733')
  String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  /// Creates a smooth gradient from dominant color (lighter top, darker bottom)
  /// Similar to Apple Music's blob blur effect
  Color _lightenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  Color _darkenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final shareText = widget.title != null && widget.title!.trim().isNotEmpty
        ? '${widget.title}${widget.artist != null && widget.artist!.trim().isNotEmpty ? ' - ${widget.artist}' : ''}'
        : 'Now Playing on ${ShareConfig.appNameFull}';

    String? topColor;
    String? bottomColor;
    if (widget.palette != null) {
      final dominant = widget.palette!.dominant;
      final lighter = _lightenColor(dominant, 0.15);
      final darker = _darkenColor(dominant, 0.2);
      topColor = _colorToHex(lighter);
      bottomColor = _colorToHex(darker);
    }

    final shareCard = RadioShareCard(
      artist: widget.artist,
      title: widget.title,
      albumArtUrl: widget.albumArtUrl,
      palette: widget.palette,
      isPlaying: widget.isPlaying,
    );

    return SharePreviewDialog(
      previewWidget: RadioShareRegularCard(
        artist: widget.artist,
        title: widget.title,
        albumArtUrl: widget.albumArtUrl,
        palette: widget.palette,
        isPlaying: widget.isPlaying,
      ),
      shareText: shareText,
      shareSubject: 'share_now_playing_subject'.tr(),
      aspectRatio: ShareConstants.stickerAspectRatio,
      stickerWidgetBuilder: () => shareCard,
      regularShareWidgetBuilder: () => RadioShareRegularCanvas(
        artist: widget.artist,
        title: widget.title,
        albumArtUrl: widget.albumArtUrl,
        palette: widget.palette,
        isPlaying: widget.isPlaying,
      ),
      stickerTopColor: topColor,
      stickerBottomColor: bottomColor,
    );
  }
}
