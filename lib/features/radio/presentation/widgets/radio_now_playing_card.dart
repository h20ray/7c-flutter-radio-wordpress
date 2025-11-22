import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/widgets/album_art_widget.dart';
import '../../../../core/widgets/smooth_marquee_text.dart';
import '../bloc/radio_player_bloc.dart';
import '../bloc/radio_player_state.dart';

/// Now playing card with album art, artist, and title
/// Material 3 design with elevation and rounded corners
class RadioNowPlayingCard extends StatelessWidget {
  const RadioNowPlayingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: BlocBuilder<RadioPlayerBloc, RadioPlayerState>(
        buildWhen: (previous, current) {
          return previous.maybeWhen(
            ready: (prevPlaying, _, __, ___, ____, _____, ______) => current.maybeWhen(
              ready: (currPlaying, _, __, ___, ____, _____, ______) =>
                  prevPlaying != currPlaying,
              orElse: () => true,
            ),
            orElse: () => true,
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            ready: (isPlaying, currentUrl, currentArtist, currentTitle,
                currentAlbumArtUrl, isDucking, canAutoResume) {
              final title = currentTitle;
              final artist = currentArtist;
              final hasTitle = title != null && title.isNotEmpty;
              final hasArtist = artist != null && artist.isNotEmpty;
              final String? titleText = hasTitle ? title : null;
              final String? artistText = hasArtist ? artist : null;
              
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    AlbumArtWidget.roundedRect(
                      width: 92,
                      height: 92,
                      borderRadius: 12,
                      filterQuality: FilterQuality.medium,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'radio_now_playing'.tr(),
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 4),
                          if (titleText != null)
                            SmoothMarqueeAuto(
                              text: titleText,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            )
                          else
                            Text(
                              'radio_no_metadata'.tr(),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          if (artistText != null) ...[
                            const SizedBox(height: 4),
                            SmoothMarqueeAuto(
                              text: artistText,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                          if (isDucking) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.volume_down,
                                    size: 14,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'radio_volume_reduced'.tr(),
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: Colors.orange[800],
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            orElse: () => Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  AlbumArtWidget.roundedRect(
                    width: 92,
                    height: 92,
                    borderRadius: 12,
                    filterQuality: FilterQuality.medium,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'radio_initializing'.tr(),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'radio_please_wait'.tr(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

