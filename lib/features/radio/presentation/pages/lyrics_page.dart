import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/widgets/shimmer_skeleton.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../config/radio_config.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/lyrics_bloc.dart';
import '../bloc/radio_player_bloc.dart';
import '../bloc/radio_player_state.dart';

class LyricsPage extends StatelessWidget {
  const LyricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final radioPlayerBloc = context.read<RadioPlayerBloc>();
    final radioState = radioPlayerBloc.state;
    
    String? artist;
    String? title;

    String? albumArtUrl;
    radioState.maybeWhen(
      ready: (playing, currentUrl, currentArtist, currentTitle,
          currentAlbumArtUrl, isDucking, canAutoResume) {
        artist = currentArtist;
        title = currentTitle;
        albumArtUrl = currentAlbumArtUrl;
      },
      orElse: () {},
    );

    if (artist == null || title == null || artist!.isEmpty || title!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('lyrics_title'.tr()),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.music_off,
                size: 64,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: DesignTokens.spacingL),
              Text(
                'lyrics_no_current_song'.tr(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final bloc = getIt<LyricsBloc>();
    if (bloc.state == const LyricsState.initial()) {
      bloc.add(LyricsEvent.load(artist: artist!, title: title!));
    }

    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('lyrics_title'.tr()),
        ),
        body: BlocBuilder<LyricsBloc, LyricsState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const _LyricsLoadingState(),
              loaded: (lyrics) {
                return _LyricsContent(
                  lyrics: lyrics,
                  artist: artist!,
                  title: title!,
                  albumArtUrl: albumArtUrl,
                );
              },
              error: (failure) => _LyricsErrorState(
                failure: failure,
                artist: artist!,
                title: title!,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LyricsContent extends StatelessWidget {
  final dynamic lyrics;
  final String artist;
  final String title;
  final String? albumArtUrl;

  const _LyricsContent({
    required this.lyrics,
    required this.artist,
    required this.title,
    this.albumArtUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(DesignTokens.spacingL),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
                      child: albumArtUrl != null && albumArtUrl!.isNotEmpty
                          ? AppNetworkImage(
                              imageUrl: albumArtUrl!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => _buildAlbumArtFallback(colors),
                              placeholder: (context, url) => _buildAlbumArtFallback(colors),
                            )
                          : _buildAlbumArtFallback(colors),
                    ),
                    const SizedBox(width: DesignTokens.spacingL),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            lyrics.title,
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: DesignTokens.spacingXs),
                          Text(
                            lyrics.artist,
                            style: textTheme.titleMedium?.copyWith(
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingXl),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.all(DesignTokens.spacingL),
                    decoration: BoxDecoration(
                      color: colors.surfaces.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
                    ),
                    child: SelectableText(
                      lyrics.lyrics,
                      style: textTheme.bodyLarge?.copyWith(
                        height: 1.8,
                        color: colors.textPrimary,
                        fontSize: DesignTokens.fontSizeBody + 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingL),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingM,
                    vertical: DesignTokens.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surfaces.surfaceContainerHighest.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusProgress),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: colors.textSecondary,
                      ),
                      const SizedBox(width: DesignTokens.spacingXs),
                      Text(
                        'Source: ${lyrics.source}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.textSecondary,
                          fontSize: DesignTokens.fontSizeCaption,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingXl),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlbumArtFallback(dynamic colors) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: colors.surfaces.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
      ),
      child: Image.asset(
        RadioConfig.fallbackArtworkPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.music_note,
          size: 32,
          color: colors.textSecondary,
        ),
      ),
    );
  }
}

class _LyricsLoadingState extends StatelessWidget {
  const _LyricsLoadingState();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final skeletonColor = colors.surfaces.surfaceContainerHighest;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(DesignTokens.spacingL),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ShimmerContainer(
                      width: 80,
                      height: 80,
                      borderRadius: DesignTokens.cornerRadiusCard,
                      baseColor: skeletonColor.withValues(alpha: 0.3),
                      highlightColor: skeletonColor.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: DesignTokens.spacingL),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ShimmerContainer(
                            width: 200,
                            height: 28,
                            borderRadius: 8,
                            baseColor: skeletonColor.withValues(alpha: 0.3),
                            highlightColor: skeletonColor.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: DesignTokens.spacingXs),
                          ShimmerContainer(
                            width: 150,
                            height: 20,
                            borderRadius: 6,
                            baseColor: skeletonColor.withValues(alpha: 0.3),
                            highlightColor: skeletonColor.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingXl),
                Container(
                  padding: const EdgeInsets.all(DesignTokens.spacingL),
                  decoration: BoxDecoration(
                    color: colors.surfaces.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      12,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: DesignTokens.spacingS),
                        child: ShimmerContainer(
                          width: index % 3 == 0 ? double.infinity : (index % 3 == 1 ? 250 : 180),
                          height: 16,
                          borderRadius: 4,
                          baseColor: skeletonColor.withValues(alpha: 0.3),
                          highlightColor: skeletonColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingL),
                ShimmerContainer(
                  width: 120,
                  height: 20,
                  borderRadius: 6,
                  baseColor: skeletonColor.withValues(alpha: 0.3),
                  highlightColor: skeletonColor.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LyricsErrorState extends StatelessWidget {
  final dynamic failure;
  final String artist;
  final String title;

  const _LyricsErrorState({
    required this.failure,
    required this.artist,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacingL),
              decoration: BoxDecoration(
                color: colors.surfaces.surfaceContainerHighest.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.music_off,
                size: 48,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingL),
            Text(
              'lyrics_not_found'.tr(),
              style: theme.textTheme.titleLarge?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spacingS),
            Text(
              failure.message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spacingXl),
            FilledButton.icon(
              onPressed: () {
                context.read<LyricsBloc>().add(
                      LyricsEvent.load(artist: artist, title: title),
                    );
              },
              icon: const Icon(Icons.refresh),
              label: Text('retry'.tr()),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingL,
                  vertical: DesignTokens.spacingM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

