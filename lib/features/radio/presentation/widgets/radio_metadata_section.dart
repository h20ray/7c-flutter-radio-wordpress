import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/smooth_marquee_text.dart';
import '../../../../config/radio_config.dart';
import '../bloc/radio_player_bloc.dart';
import '../bloc/radio_player_state.dart';

class RadioMetadataSection extends StatelessWidget {
  const RadioMetadataSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final subtitleColor = theme.colorScheme.onSurfaceVariant;

    return BlocBuilder<RadioPlayerBloc, RadioPlayerState>(
      builder: (context, state) {
        String? title;
        String? artist;

        state.maybeWhen(
          ready: (playing, currentUrl, currentArtist, currentTitle,
              currentAlbumArtUrl, isDucking, canAutoResume) {
            title = currentTitle;
            artist = currentArtist;
          },
          orElse: () {},
        );

        final normalizedTitle = title?.trim().isNotEmpty == true
            ? title!.trim()
            : RadioConfig.fallbackTitle;
        final normalizedArtist = artist?.trim().isNotEmpty == true
            ? artist!.trim()
            : RadioConfig.fallbackArtist;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: SmoothMarqueeAuto(
                key: ValueKey(normalizedTitle),
                text: normalizedTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
                scrollDuration: const Duration(seconds: 12),
                pauseDuration: const Duration(seconds: 3),
              ),
            ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: SmoothMarqueeAuto(
                key: ValueKey(normalizedArtist),
                text: normalizedArtist,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: subtitleColor,
                  fontWeight: FontWeight.w400,
                ),
                scrollDuration: const Duration(seconds: 10),
                pauseDuration: const Duration(seconds: 3),
              ),
            ),
          ],
        );
      },
    );
  }
}

