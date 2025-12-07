import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../config/share_config.dart';
import '../../../../../core/utils/palette_cache.dart';
import '../../../../../features/shared/presentation/dialogs/share_preview_dialog.dart';
import '../radio_share_card.dart';

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
  bool _useBlankBackground = false;

  @override
  Widget build(BuildContext context) {
    // Construct share text
    final shareText = widget.title != null && widget.title!.trim().isNotEmpty
        ? '${widget.title}${widget.artist != null && widget.artist!.trim().isNotEmpty ? ' - ${widget.artist}' : ''}'
        : 'Now Playing on ${ShareConfig.appNameFull}';

    return SharePreviewDialog(
      previewWidget: RadioShareCard(
        artist: widget.artist,
        title: widget.title,
        albumArtUrl: widget.albumArtUrl,
        palette: widget.palette,
        isPlaying: widget.isPlaying,
        useBlankBackground: _useBlankBackground,
      ),
      shareText: shareText,
      shareSubject: 'share_now_playing_subject'.tr(),
      aspectRatio: 9 / 16,
      showInstagramToggle: true,
      isInstagramMode: _useBlankBackground,
      onToggleInstagramMode: (value) {
        setState(() {
          _useBlankBackground = value;
        });
      },
    );
  }
}
