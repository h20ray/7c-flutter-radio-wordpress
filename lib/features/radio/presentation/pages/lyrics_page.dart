import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/radio_config.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/palette_service.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/utils/palette_cache.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/shimmer_skeleton.dart';
import '../../../shared/presentation/dialogs/share_preview_dialog.dart';
import '../bloc/lyrics_bloc.dart';
import '../bloc/radio_player_bloc.dart';
import '../bloc/radio_player_state.dart';
import '../widgets/lyric_share_card.dart';

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
      ready:
          (
            playing,
            currentUrl,
            currentArtist,
            currentTitle,
            currentAlbumArtUrl,
            isDucking,
            canAutoResume,
          ) {
            artist = currentArtist;
            title = currentTitle;
            albumArtUrl = currentAlbumArtUrl;
          },
      orElse: () {},
    );

    if (artist == null || title == null || artist!.isEmpty || title!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('lyrics_title'.tr())),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.music_off,
                size: 64,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: DesignTokens.spacingL),
              Text(
                'lyrics_no_current_song'.tr(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return BlocListener<RadioPlayerBloc, RadioPlayerState>(
      listenWhen: (previous, current) {
        String? prevArtist;
        String? prevTitle;
        String? currArtist;
        String? currTitle;
        
        previous.maybeWhen(
          ready: (playing, url, artist, title, albumArt, ducking, autoResume) {
            prevArtist = artist;
            prevTitle = title;
          },
          orElse: () {},
        );
        
        current.maybeWhen(
          ready: (playing, url, artist, title, albumArt, ducking, autoResume) {
            currArtist = artist;
            currTitle = title;
          },
          orElse: () {},
        );
        
        return currArtist != null && 
               currTitle != null && 
               currArtist!.isNotEmpty && 
               currTitle!.isNotEmpty &&
               (currArtist != prevArtist || currTitle != prevTitle);
      },
      listener: (context, state) {
        state.maybeWhen(
          ready: (playing, url, currentArtist, currentTitle, albumArt, ducking, autoResume) {
            if (currentArtist != null && 
                currentTitle != null && 
                currentArtist.isNotEmpty && 
                currentTitle.isNotEmpty) {
              final prefetchBloc = getIt<LyricsBloc>();
              if (prefetchBloc.state == const LyricsState.initial()) {
                prefetchBloc.add(LyricsEvent.load(artist: currentArtist, title: currentTitle));
              }
            }
          },
          orElse: () {},
        );
      },
      child: BlocProvider(
        create: (context) {
          final bloc = getIt<LyricsBloc>();
          if (bloc.state == const LyricsState.initial()) {
            bloc.add(LyricsEvent.load(artist: artist!, title: title!));
          }
          return bloc;
        },
        child: Scaffold(
          appBar: AppBar(title: Text('lyrics_title'.tr())),
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
      ),
    );
  }
}

class _LyricsContent extends StatefulWidget {
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
  State<_LyricsContent> createState() => _LyricsContentState();
}

class _LyricsContentState extends State<_LyricsContent> {
  static const int _maxCharacters = 150;

  final PaletteService _paletteService = getIt<PaletteService>();
  final Set<int> _selectedIndices = {};
  PaletteColors? _palette;
  bool _isLoadingPalette = false;
  bool _isSelectionMode = false;
  late final List<String> _lines;

  void _clearSelection() {
    setState(() {
      _selectedIndices.clear();
      _isSelectionMode = false;
    });
  }

  // Current character count of selected lyrics
  int get _currentCharCount {
    if (_selectedIndices.isEmpty) return 0;
    final sorted = _selectedIndices.toList()..sort();
    return sorted.map((i) => _lines[i]).join('\n').length;
  }

  // Prevent selection from exceeding the character cap (Apple Music style)
  bool _wouldExceedLimit(int index) {
    final lineText = _lines[index];
    final additionalChars = _selectedIndices.isEmpty
        ? lineText.length
        : lineText.length + 1;
    return (_currentCharCount + additionalChars) > _maxCharacters;
  }

  // Only allow building contiguous selections
  bool _isAdjacentToSelection(int index) {
    if (_selectedIndices.isEmpty) return true;
    final sorted = _selectedIndices.toList()..sort();
    return index == sorted.first - 1 || index == sorted.last + 1;
  }

  // Deselect is allowed only at the edges to keep selection contiguous
  bool _canDeselect(int index) {
    if (!_selectedIndices.contains(index)) return false;
    if (_selectedIndices.length == 1) return true;
    final sorted = _selectedIndices.toList()..sort();
    return index == sorted.first || index == sorted.last;
  }

  @override
  void initState() {
    super.initState();
    _lines = _parseLines(widget.lyrics.lyrics);
    _loadPalette();
  }

  @override
  void didUpdateWidget(covariant _LyricsContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.albumArtUrl != oldWidget.albumArtUrl) {
      _loadPalette();
    }
    if (widget.lyrics != oldWidget.lyrics) {
      setState(() {
        _lines
          ..clear()
          ..addAll(_parseLines(widget.lyrics.lyrics));
        _selectedIndices.clear();
      });
    }
  }

  List<String> _parseLines(String raw) {
    return raw
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  Future<void> _loadPalette() async {
    final url = widget.albumArtUrl;
    if (url == null || url.isEmpty) {
      setState(() => _palette = null);
      return;
    }
    if (_isLoadingPalette) return;
    final cached = _paletteService.getCached(url);
    if (cached != null) {
      setState(() => _palette = cached);
      return;
    }
    setState(() => _isLoadingPalette = true);
    try {
      final palette = await _paletteService.fetchForUrl(url);
      if (mounted) {
        setState(() => _palette = palette);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingPalette = false);
      }
    }
  }

  String _toHex(Color color) {
    final argb = color.toARGB32();
    final value = argb.toRadixString(16).padLeft(8, '0');
    return '#${value.substring(2).toUpperCase()}';
  }

  Future<void> _shareSelection() async {
    if (_selectedIndices.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('lyrics_select_prompt'.tr()),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }
    final sorted = _selectedIndices.toList()..sort();
    final selectedLines = sorted.map((i) => _lines[i]).toList();
    final shareText = selectedLines.join('\n');
    final stickerTop = _palette != null ? _toHex(_palette!.vibrant) : null;
    final stickerBottom = _palette != null
        ? _toHex(_palette!.darkVibrant)
        : null;

    await SharePreviewDialog.show(
      context: context,
      previewWidget: LyricShareCard(
        lines: selectedLines,
        artist: widget.artist,
        title: widget.title,
        albumArtUrl: widget.albumArtUrl,
        palette: _palette,
        isSticker: true,
        showPreviewOnly: true,
      ),
      regularShareWidgetBuilder: () => LyricShareCard(
        lines: selectedLines,
        artist: widget.artist,
        title: widget.title,
        albumArtUrl: widget.albumArtUrl,
        palette: _palette,
        hasBackground: true,
      ),
      shareText: shareText,
      shareSubject: '${widget.title} - ${widget.artist}',
      stickerWidgetBuilder: () => LyricShareCard(
        lines: selectedLines,
        artist: widget.artist,
        title: widget.title,
        albumArtUrl: widget.albumArtUrl,
        palette: _palette,
        isSticker: true,
      ),
      stickerTopColor: stickerTop,
      stickerBottomColor: stickerBottom,
    );
  }

  // Long press enters selection mode and seeds first line
  void _handleLongPressSelection(int index) {
    HapticFeedback.mediumImpact();
    setState(() {
      _isSelectionMode = true;
      if (!_selectedIndices.contains(index)) {
        if (!_wouldExceedLimit(index)) {
          _selectedIndices.add(index);
        }
      }
    });
  }

  // Tap toggles selection while enforcing contiguity and character cap
  void _handleTapSelection(int index) {
    if (!_isSelectionMode) return;

    HapticFeedback.selectionClick();

    setState(() {
      if (_selectedIndices.contains(index)) {
        if (_canDeselect(index)) {
          _selectedIndices.remove(index);
          if (_selectedIndices.isEmpty) {
            _isSelectionMode = false;
          }
        } else {
          HapticFeedback.heavyImpact();
        }
      } else {
        if (_isAdjacentToSelection(index)) {
          if (!_wouldExceedLimit(index)) {
            _selectedIndices.add(index);
          } else {
            // Character limit reached - show feedback
            HapticFeedback.heavyImpact();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('lyrics_character_limit_reached'.tr()),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        } else {
          // Not adjacent - show feedback
          HapticFeedback.lightImpact();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final hasSelection = _selectedIndices.isNotEmpty;

    return PopScope(
      canPop: !_isSelectionMode,
      onPopInvokedWithResult: (didPop, result) async {
        if (_isSelectionMode) {
          await HapticFeedback.selectionClick();
          _clearSelection();
          return;
        }
      },
      child: Stack(
        children: [
          CustomScrollView(
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
                            borderRadius: BorderRadius.circular(
                              DesignTokens.cornerRadiusAlbumArt,
                            ),
                            child:
                                widget.albumArtUrl != null &&
                                    widget.albumArtUrl!.isNotEmpty
                                ? AppNetworkImage(
                                    imageUrl: widget.albumArtUrl!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        _buildAlbumArtFallback(colors),
                                    placeholder: (context, url) =>
                                        _buildAlbumArtFallback(colors),
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
                                  widget.lyrics.title,
                                  style: textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colors.textPrimary,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: DesignTokens.spacingXs),
                                Text(
                                  widget.lyrics.artist,
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
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingL,
                ),
                sliver: SliverList.separated(
                  itemBuilder: (context, index) {
                    final line = _lines[index];
                    final isSelected = _selectedIndices.contains(index);
                    final isAdjacent = _isAdjacentToSelection(index);
                    final wouldExceed = !isSelected && _wouldExceedLimit(index);

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _handleTapSelection(index),
                      onLongPress: () => _handleLongPressSelection(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.all(DesignTokens.spacingM),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.surfaces.surfaceContainerHighest
                                    .withValues(alpha: 0.5)
                              : (isAdjacent && !wouldExceed && hasSelection)
                              ? colors.surfaces.surfaceContainerHighest
                                    .withValues(alpha: 0.25)
                              : colors.surfaces.surfaceContainerHighest
                                    .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(
                            DesignTokens.cornerRadiusCard,
                          ),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary.withValues(
                                    alpha: 0.5,
                                  )
                                : (isAdjacent && !wouldExceed && hasSelection)
                                ? theme.colorScheme.primary.withValues(
                                    alpha: 0.2,
                                  )
                                : Colors.transparent,
                            width: isSelected
                                ? 2.0
                                : DimensionTokens.borderWidthThin,
                          ),
                        ),
                        child: Text(
                          line,
                          style: textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                            color: wouldExceed && hasSelection
                                ? colors.textPrimary.withValues(alpha: 0.4)
                                : colors.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontSize: DesignTokens.fontSizeBody + 1,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, index) =>
                      const SizedBox(height: DesignTokens.spacingS),
                  itemCount: _lines.length,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(DesignTokens.spacingL),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingM,
                      vertical: DesignTokens.spacingS,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surfaces.surfaceContainerHighest.withValues(
                        alpha: 0.2,
                      ),
                      borderRadius: BorderRadius.circular(
                        DesignTokens.cornerRadiusProgress,
                      ),
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
                        Container(
                          decoration: BoxDecoration(
                            color: colors.textSecondary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(
                              DesignTokens.cornerRadiusPill,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignTokens.spacingS,
                            vertical: DesignTokens.spacingXs,
                          ),
                          child: Text(
                            'Source: ${widget.lyrics.source}',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.textSecondary,
                              fontSize: DesignTokens.fontSizeCaption,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: DesignTokens.spacingXl * 3),
              ),
            ],
          ),
          if (hasSelection)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(
                        context,
                      ).scaffoldBackgroundColor.withValues(alpha: 0.0),
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      DesignTokens.spacingL,
                      DesignTokens.spacingL,
                      DesignTokens.spacingL,
                      DesignTokens.spacingL,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: DesignTokens.spacingS,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: DesignTokens.spacingM,
                                  vertical: DesignTokens.spacingXs,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      _currentCharCount > _maxCharacters * 0.8
                                      ? theme.colorScheme.errorContainer
                                            .withValues(alpha: 0.3)
                                      : colors.surfaces.surfaceContainerHighest
                                            .withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(
                                    DesignTokens.cornerRadiusPill,
                                  ),
                                ),
                                child: Text(
                                  '$_currentCharCount / $_maxCharacters',
                                  style: textTheme.bodySmall?.copyWith(
                                    color:
                                        _currentCharCount > _maxCharacters * 0.8
                                        ? theme.colorScheme.error
                                        : colors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _shareSelection,
                            icon: const Icon(Icons.share),
                            label: Text('lyrics_share'.tr()),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: DesignTokens.spacingL,
                                vertical: DesignTokens.spacingM,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAlbumArtFallback(dynamic colors) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: colors.surfaces.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusAlbumArt),
      ),
      child: Image.asset(
        RadioConfig.fallbackArtworkPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.music_note, size: 32, color: colors.textSecondary),
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
                            highlightColor: skeletonColor.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          const SizedBox(height: DesignTokens.spacingXs),
                          ShimmerContainer(
                            width: 150,
                            height: 20,
                            borderRadius: 6,
                            baseColor: skeletonColor.withValues(alpha: 0.3),
                            highlightColor: skeletonColor.withValues(
                              alpha: 0.5,
                            ),
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
                    color: colors.surfaces.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(
                      DesignTokens.cornerRadiusCard,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      12,
                      (index) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: DesignTokens.spacingS,
                        ),
                        child: ShimmerContainer(
                          width: index % 3 == 0
                              ? double.infinity
                              : (index % 3 == 1 ? 250 : 180),
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
                color: colors.surfaces.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
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
