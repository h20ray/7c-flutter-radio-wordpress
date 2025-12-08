import 'package:flutter/material.dart';

import '../../../../core/utils/palette_cache.dart';
import 'radio_share_card.dart';

/// Wrapper for regular-share capture with enforced background.
class RadioShareRegularCard extends StatelessWidget {
  final String? artist;
  final String? title;
  final String? albumArtUrl;
  final PaletteColors? palette;
  final bool isPlaying;

  const RadioShareRegularCard({
    super.key,
    this.artist,
    this.title,
    this.albumArtUrl,
    this.palette,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return RadioShareCard(
      artist: artist,
      title: title,
      albumArtUrl: albumArtUrl,
      palette: palette,
      isPlaying: isPlaying,
      hasBackground: true,
    );
  }
}

