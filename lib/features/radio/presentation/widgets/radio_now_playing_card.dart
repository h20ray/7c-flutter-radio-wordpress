import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/album_art_widget.dart';
import '../../../../core/widgets/haptic_widgets.dart';
import '../../../../core/widgets/smooth_marquee_text.dart';
import '../../../../core/services/palette_service.dart';
import '../../../../core/utils/palette_cache.dart';
import '../../../../config/radio_config.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/models/album_art_state.dart';
import '../../data/services/album_art_service.dart';
import '../bloc/radio_player_bloc.dart';
import '../bloc/radio_player_state.dart';
import '../bloc/radio_player_event.dart';

class RadioNowPlayingCard extends StatefulWidget {
  final bool compact;

  const RadioNowPlayingCard({super.key, this.compact = false});

  @override
  State<RadioNowPlayingCard> createState() => _RadioNowPlayingCardState();
}

class _RadioNowPlayingCardState extends State<RadioNowPlayingCard> {
  PaletteColors? _cachedPalette;
  bool _isLoadingPalette = false;
  String? _currentAlbumArtUrl;
  final PaletteService _paletteService = PaletteService();
  static final Map<String, PaletteColors> _paletteCache = {};

  Future<void> _generatePalette(String albumArtUrl) async {
    if (_isLoadingPalette) return;

    if (_paletteCache.containsKey(albumArtUrl)) {
      if (mounted) {
        setState(() {
          _cachedPalette = _paletteCache[albumArtUrl];
        });
      }
      return;
    }

    if (RadioConfig.enableVerboseLogging) {
      DebugLogger.log(
        '[Palette] Starting palette generation for: $albumArtUrl',
        tag: 'Palette',
      );
    }

    setState(() {
      _isLoadingPalette = true;
    });

    try {
      final palette = await _paletteService.fetchForUrl(albumArtUrl);
      if (mounted) {
        if (RadioConfig.enableVerboseLogging) {
          DebugLogger.log(
            '[Palette] Generated palette: dominant=${palette.dominant}, vibrant=${palette.vibrant}',
            tag: 'Palette',
          );
        }
        _paletteCache[albumArtUrl] = palette;
        setState(() {
          _cachedPalette = palette;
          _isLoadingPalette = false;
        });
      }
    } catch (e) {
      if (RadioConfig.enableVerboseLogging) {
        DebugLogger.log(
          '[Palette] Error generating palette: $e',
          tag: 'Palette',
        );
      }
      if (mounted) {
        setState(() {
          _isLoadingPalette = false;
        });
      }
    }
  }

  Future<void> _generatePaletteFromFallback() async {
    if (_isLoadingPalette) return;

    const fallbackKey = 'fallback_artwork';

    if (_paletteCache.containsKey(fallbackKey)) {
      if (mounted) {
        setState(() {
          _cachedPalette = _paletteCache[fallbackKey];
        });
      }
      return;
    }

    if (RadioConfig.enableVerboseLogging) {
      DebugLogger.log(
        '[Palette] Starting palette generation for fallback image',
        tag: 'Palette',
      );
    }

    setState(() {
      _isLoadingPalette = true;
    });

    try {
      final palette = await _paletteService.fetchForImage(
        const AssetImage('assets/images/fallback_artwork.jpg'),
        cacheKey: fallbackKey,
      );
      if (mounted) {
        if (RadioConfig.enableVerboseLogging) {
          DebugLogger.log(
            '[Palette] Generated fallback palette: dominant=${palette.dominant}, vibrant=${palette.vibrant}',
            tag: 'Palette',
          );
        }
        _paletteCache[fallbackKey] = palette;
        setState(() {
          _cachedPalette = palette;
          _isLoadingPalette = false;
        });
      }
    } catch (e) {
      if (RadioConfig.enableVerboseLogging) {
        DebugLogger.log(
          '[Palette] Error generating fallback palette: $e',
          tag: 'Palette',
        );
      }
      if (mounted) {
        setState(() {
          _isLoadingPalette = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioPlayerBloc, RadioPlayerState>(
      buildWhen: (previous, current) {
        String? newArtist;
        String? newTitle;
        String? newAlbumArtUrl;
        current.maybeWhen(
          ready:
              (
                playing,
                p2,
                currentArtist,
                currentTitle,
                currentAlbumArtUrl,
                p6,
                p7,
              ) {
                newArtist = currentArtist;
                newTitle = currentTitle;
                newAlbumArtUrl = currentAlbumArtUrl;
              },
          orElse: () {},
        );

        String? oldArtist;
        String? oldTitle;
        String? oldAlbumArtUrl;
        previous.maybeWhen(
          ready:
              (
                playing,
                p2,
                currentArtist,
                currentTitle,
                currentAlbumArtUrl,
                p6,
                p7,
              ) {
                oldArtist = currentArtist;
                oldTitle = currentTitle;
                oldAlbumArtUrl = currentAlbumArtUrl;
              },
          orElse: () {},
        );

        return newArtist != oldArtist ||
            newTitle != oldTitle ||
            newAlbumArtUrl != oldAlbumArtUrl;
      },
      builder: (context, state) {
        String? artist;
        String? title;
        String? albumArtUrl;
        state.maybeWhen(
          ready:
              (
                playing,
                p2,
                currentArtist,
                currentTitle,
                currentAlbumArtUrl,
                p6,
                p7,
              ) {
                artist = currentArtist;
                title = currentTitle;
                albumArtUrl = currentAlbumArtUrl;
              },
          orElse: () {},
        );

        final String? currentArtUrl = albumArtUrl;
        if (currentArtUrl != _currentAlbumArtUrl) {
          _currentAlbumArtUrl = currentArtUrl;
          if (RadioConfig.enableVerboseLogging) {
            DebugLogger.log(
              '[Palette] Album art changed, triggering palette generation for: $currentArtUrl',
              tag: 'Palette',
            );
          }
          WidgetsBinding.instance.addPostFrameCallback((duration) {
            if (mounted) {
              if (currentArtUrl != null && currentArtUrl.isNotEmpty) {
                _generatePalette(currentArtUrl);
              } else {
                _generatePaletteFromFallback();
              }
            }
          });
        } else if (_currentAlbumArtUrl != null &&
            _cachedPalette == null &&
            !_isLoadingPalette) {
          WidgetsBinding.instance.addPostFrameCallback((duration) {
            if (mounted) {
              if (_currentAlbumArtUrl!.isNotEmpty) {
                _generatePalette(_currentAlbumArtUrl!);
              } else {
                _generatePaletteFromFallback();
              }
            }
          });
        }

        final double artSize = widget.compact ? 56 : 72;

        return _CachedNowPlayingContent(
          artist: artist,
          title: title,
          artSize: artSize,
          palette: _cachedPalette,
          isLoadingPalette: _isLoadingPalette,
        );
      },
    );
  }
}

class _CachedNowPlayingContent extends StatefulWidget {
  final String? artist;
  final String? title;
  final double artSize;
  final PaletteColors? palette;
  final bool isLoadingPalette;

  const _CachedNowPlayingContent({
    required this.artist,
    required this.title,
    required this.artSize,
    required this.palette,
    required this.isLoadingPalette,
  });

  @override
  State<_CachedNowPlayingContent> createState() =>
      _CachedNowPlayingContentState();
}

class _CachedNowPlayingContentState extends State<_CachedNowPlayingContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _colorAnimationController;
  late Animation<double> _colorAnimation;

  Color _fromBg = const Color(0xFF15232B);
  Color _toBg = const Color(0xFF15232B);
  Color _fromVibrant = const Color(0xFF15232B);
  Color _toVibrant = const Color(0xFF15232B);
  Color _fromDarkVibrant = const Color(0xFF0B1216);
  Color _toDarkVibrant = const Color(0xFF0B1216);
  Color _fromMuted = const Color(0xFF15232B);
  Color _toMuted = const Color(0xFF15232B);
  Color _stableTextColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _colorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _colorAnimation = CurvedAnimation(
      parent: _colorAnimationController,
      curve: Curves.easeOutCubic,
    );
    _colorAnimationController.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant _CachedNowPlayingContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.palette != widget.palette && widget.palette != null) {
      setState(() {
        _fromBg = _toBg;
        _toBg = widget.palette!.dominant;
        _fromVibrant = _toVibrant;
        _toVibrant = widget.palette!.vibrant;
        _fromDarkVibrant = _toDarkVibrant;
        _toDarkVibrant = widget.palette!.darkVibrant;
        _fromMuted = _toMuted;
        _toMuted = widget.palette!.muted;
        _stableTextColor =
            ThemeData.estimateBrightnessForColor(widget.palette!.dominant) ==
                Brightness.dark
            ? Colors.white
            : Colors.black87;
      });
      _colorAnimationController.reset();
      _colorAnimationController.forward();
    }
  }

  @override
  void dispose() {
    _colorAnimationController.dispose();
    super.dispose();
  }

  Color _lerpColor(Color from, Color to) {
    return Color.lerp(from, to, _colorAnimation.value) ?? to;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        final dominant = _lerpColor(_fromBg, _toBg);
        final vibrant = _lerpColor(_fromVibrant, _toVibrant);
        final darkVibrant = _lerpColor(_fromDarkVibrant, _toDarkVibrant);
        final muted = _lerpColor(_fromMuted, _toMuted);

        final gradientColors = _createSpotifyGradient(
          dominant,
          vibrant,
          darkVibrant,
          muted,
        );

        return RepaintBoundary(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                DesignTokens.cornerRadiusAlbumArt,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.lerp(
                    Colors.black,
                    darkVibrant,
                    0.2,
                  )!.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned.fill(
                  child: RepaintBoundary(
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Transform.scale(
                        scale: 1.2,
                        child: const _BlurredAlbumArtBackground(
                          filterQuality: FilterQuality.low,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors,
                        stops: const [0.0, 0.3, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: widget.artSize,
                        height: widget.artSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            DesignTokens.cornerRadiusAlbumArt,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: AlbumArtWidget.roundedRect(
                          width: widget.artSize,
                          height: widget.artSize,
                          borderRadius: DesignTokens.cornerRadiusAlbumArt,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SmoothMarqueeAuto(
                              text: widget.title?.trim().isNotEmpty == true
                                  ? widget.title!.trim()
                                  : RadioConfig.fallbackTitle,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: _stableTextColor,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.5,
                                  ),
                              scrollDuration: const Duration(seconds: 12),
                              pauseDuration: const Duration(seconds: 3),
                            ),
                            const SizedBox(height: 4),
                            SmoothMarqueeAuto(
                              text: widget.artist?.trim().isNotEmpty == true
                                  ? widget.artist!.trim()
                                  : RadioConfig.fallbackArtist,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: _stableTextColor.withValues(
                                      alpha: 0.8,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                              scrollDuration: const Duration(seconds: 10),
                              pauseDuration: const Duration(seconds: 3),
                            ),
                            const SizedBox(height: 8),
                            _PlayerControlsRow(
                              bgColor: dominant,
                              textColor: _stableTextColor,
                            ),
                          ],
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
    );
  }

  List<Color> _createSpotifyGradient(
    Color dominant,
    Color vibrant,
    Color darkVibrant,
    Color muted,
  ) {
    final brightness = ThemeData.estimateBrightnessForColor(dominant);

    if (brightness == Brightness.dark) {
      return [
        darkVibrant.withValues(alpha: 0.9),
        dominant.withValues(alpha: 0.85),
        vibrant.withValues(alpha: 0.8),
        muted.withValues(alpha: 0.75),
      ];
    } else {
      return [
        darkVibrant.withValues(alpha: 0.7),
        dominant.withValues(alpha: 0.75),
        vibrant.withValues(alpha: 0.8),
        muted.withValues(alpha: 0.7),
      ];
    }
  }
}

class _PlayerControlsRow extends StatelessWidget {
  final Color bgColor;
  final Color textColor;

  const _PlayerControlsRow({required this.bgColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final fontSize = titleStyle?.fontSize ?? 18;
    final buttonSize = fontSize * 1.2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _GlassButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _RequestWebViewPage()),
            );
          },
          icon: LucideIcons.list_music,
          bgColor: bgColor,
          textColor: textColor,
          size: buttonSize,
          tooltip: RadioConfig.requestWebViewTitle,
        ),
        const SizedBox(width: 6),
        BlocBuilder<RadioPlayerBloc, RadioPlayerState>(
          builder: (context, state) {
            bool isPlaying = false;
            bool isLoading = false;
            state.maybeWhen(
              initializing: () => isLoading = true,
              connecting: () => isLoading = true,
              buffering: () => isLoading = true,
              retrying: (p1, p2) => isLoading = true,
              ready: (playing, p2, p3, p4, p5, p6, p7) => isPlaying = playing,
              orElse: () {},
            );
            return _GlassButton(
              onPressed: () => context.read<RadioPlayerBloc>().add(
                const RadioPlayerEvent.togglePlayPause(),
              ),
              icon: isLoading
                  ? null
                  : (isPlaying ? LucideIcons.pause : LucideIcons.play),
              bgColor: bgColor,
              textColor: textColor,
              size: buttonSize,
              isLoading: isLoading,
              tooltip: isPlaying ? 'radio_pause'.tr() : 'radio_play'.tr(),
            );
          },
        ),
        const SizedBox(width: 6),
        _GlassButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.shoutbox);
          },
          icon: LucideIcons.message_circle,
          bgColor: bgColor,
          textColor: textColor,
          size: buttonSize,
          tooltip: 'Shoutbox',
        ),
      ],
    );
  }
}

class _GlassButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData? icon;
  final Color bgColor;
  final Color textColor;
  final double size;
  final bool isLoading;
  final String? tooltip;

  const _GlassButton({
    required this.onPressed,
    this.icon,
    required this.bgColor,
    required this.textColor,
    required this.size,
    this.isLoading = false,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = _getAdaptiveColor();
    final iconSize = size * 0.7;

    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: Colors.transparent,
        child: HapticInkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: size * 1.3,
            height: size * 1.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: buttonColor.withValues(alpha: 0.2),
              border: Border.all(
                color: textColor.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  decoration: BoxDecoration(
                    color: buttonColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Opacity(
                      opacity: isLoading ? 0.5 : 1.0,
                      child: Icon(icon, size: iconSize, color: textColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getAdaptiveColor() {
    final brightness = ThemeData.estimateBrightnessForColor(bgColor);
    if (brightness == Brightness.dark) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}

class _BlurredAlbumArtBackground extends StatelessWidget {
  final FilterQuality filterQuality;

  const _BlurredAlbumArtBackground({this.filterQuality = FilterQuality.low});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AlbumArtState>(
      stream: AlbumArtService.instance.albumArtStream,
      initialData: AlbumArtService.instance.currentState,
      builder: (context, snapshot) {
        final albumArtState =
            snapshot.data ?? AlbumArtService.instance.currentState;

        if (albumArtState.hasUrl) {
          return AppNetworkImage(
            imageUrl: albumArtState.url!,
            fit: BoxFit.cover,
            filterQuality: filterQuality,
            errorWidget: (context, url, error) => _buildFallbackImage(context),
            placeholder: (context, url) => _buildFallbackImage(context),
          );
        }

        return _buildFallbackImage(context);
      },
    );
  }

  Widget _buildFallbackImage(BuildContext context) {
    return Image.asset(
      RadioConfig.fallbackArtworkPath,
      fit: BoxFit.cover,
      filterQuality: filterQuality,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RequestWebViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(RadioConfig.requestWebViewTitle)),
      body: const Center(
        child: Text(
          'WebView implementation needed for: ${RadioConfig.requestWebViewUrl}',
        ),
      ),
    );
  }
}
