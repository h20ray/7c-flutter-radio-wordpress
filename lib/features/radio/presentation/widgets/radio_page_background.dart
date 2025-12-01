import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/services/palette_service.dart';
import '../../../../core/utils/palette_cache.dart';
import '../../../../config/radio_config.dart';
import '../bloc/radio_player_bloc.dart';
import '../bloc/radio_player_state.dart';

class RadioPageBackground extends StatefulWidget {
  const RadioPageBackground({super.key});

  @override
  State<RadioPageBackground> createState() => _RadioPageBackgroundState();
}

class _RadioPageBackgroundState extends State<RadioPageBackground>
    with TickerProviderStateMixin {
  String? _cachedArtUrl;
  PaletteColors? _currentPalette;
  final PaletteService _paletteService = PaletteService();
  bool _isUsingFallback = false;
  bool _isPlaying = false;
  String? _targetArtUrl; // Target art URL for smooth transitions
  PaletteColors? _targetPalette; // Target palette for smooth transitions

  late final AnimationController _blobController;
  late final Animation<double> _blobAnimation;
  late final AnimationController _blurController;
  late final Animation<double> _blurAnimation;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  bool _hasInitializedPalette = false;

  @override
  void initState() {
    super.initState();
    
    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
    
    _blobAnimation = CurvedAnimation(
      parent: _blobController,
      curve: Curves.easeInOutSine,
    );

    _blurController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _blurAnimation = Tween<double>(
      begin: 40.0,
      end: 60.0,
    ).animate(CurvedAnimation(
      parent: _blurController,
      curve: Curves.easeInOut,
    ));

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitializedPalette) {
      _hasInitializedPalette = true;
      _initializeFallbackPalette();
    }
  }

  void _updateAnimationState(bool isPlaying) {
    if (_isPlaying == isPlaying) return;
    _isPlaying = isPlaying;

    if (isPlaying) {
      if (!_blobController.isAnimating) {
        _blobController.repeat(reverse: true);
      }
      if (!_blurController.isAnimating) {
        _blurController.repeat(reverse: true);
      }
      // Fade to album art when playing
      _fadeToTarget();
    } else {
      _blobController.stop();
      _blurController.stop();
      // Fade to fallback when paused
      _fadeToFallback();
    }
  }

  void _fadeToTarget() {
    if (_targetArtUrl != _cachedArtUrl || _targetPalette != _currentPalette) {
      _targetArtUrl = _cachedArtUrl;
      _targetPalette = _currentPalette;
      _fadeController.forward();
    }
  }

  void _fadeToFallback() {
    if (_targetArtUrl != null || _targetPalette != null) {
      _targetArtUrl = null;
      _targetPalette = null;
      _fadeController.reverse();
    }
  }

  @override
  void dispose() {
    _blobController.dispose();
    _blurController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _initializeFallbackPalette() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fallbackColor = isDark
        ? const Color(0xFF15232B)
        : const Color(0xFF2C3E50);
    
    try {
      final fallbackProvider = AssetImage(RadioConfig.fallbackArtworkPath);
      final palette = await _paletteService.fetchForImage(
        fallbackProvider,
        cacheKey: 'fallback_artwork',
      );
      if (mounted && _currentPalette == null) {
        setState(() {
          _currentPalette = palette;
          _isUsingFallback = true;
          if (!_isPlaying) {
            _targetPalette = null; // No target when paused
            _fadeController.value = 0.0; // Start with fallback visible when paused
          }
        });
      }
    } catch (e) {
      if (mounted && _currentPalette == null) {
        setState(() {
          _currentPalette = _paletteService.getCached('fallback_artwork') ??
              _createFallbackPalette(fallbackColor);
          _isUsingFallback = true;
        });
      }
    }
  }

  PaletteColors _createFallbackPalette(Color base) {
    final hsl = HSLColor.fromColor(base);
    final dominant = base;
    final vibrant = hsl.withSaturation((hsl.saturation * 1.2).clamp(0.0, 1.0)).toColor();
    final darkVibrant = hsl.withLightness((hsl.lightness * 0.5).clamp(0.0, 1.0)).toColor();
    final muted = hsl.withSaturation((hsl.saturation * 0.5).clamp(0.0, 1.0)).toColor();
    return PaletteColors(
      dominant: dominant,
      vibrant: vibrant,
      darkVibrant: darkVibrant,
      muted: muted,
    );
  }

  Future<void> _updatePalette(String? artUrl) async {
    if (artUrl == null || artUrl.isEmpty) {
      if (!_isUsingFallback) {
        await _initializeFallbackPalette();
      }
      return;
    }

    try {
      final palette = await _paletteService.fetchForUrl(artUrl);
      if (mounted) {
        setState(() {
          _currentPalette = palette;
          _isUsingFallback = false;
          if (_isPlaying) {
            _targetPalette = palette;
            _targetArtUrl = artUrl;
            _fadeController.forward();
          }
        });
      }
    } catch (e) {
      if (!_isUsingFallback) {
        await _initializeFallbackPalette();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioPlayerBloc, RadioPlayerState>(
      builder: (context, state) {
        bool isPlaying = false;
        String? artUrl;
        state.maybeWhen(
          ready: (playing, p2, p3, p4, currentAlbumArtUrl, p6, p7) {
            isPlaying = playing;
            artUrl = currentAlbumArtUrl;
          },
          orElse: () {},
        );
        
        _updateAnimationState(isPlaying);
        
        if (artUrl != _cachedArtUrl) {
          _cachedArtUrl = artUrl;
          _updatePalette(artUrl);
          if (isPlaying) {
            _targetArtUrl = artUrl;
            _targetPalette = _currentPalette;
          }
        }
        
        return Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.grey[900],
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildBaseBackgroundWithFade(),
              _buildMeshGradientWithFade(),
              Container(
                color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.7),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBaseBackgroundWithFade() {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([_blurAnimation, _fadeAnimation]),
        builder: (context, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Fallback background (always visible, opacity controlled by fade)
              Opacity(
                opacity: 1.0 - _fadeAnimation.value,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: _blurAnimation.value,
                    sigmaY: _blurAnimation.value,
                  ),
                  child: _buildFallbackImage(),
                ),
              ),
              // Album art background (fades in when playing)
              Opacity(
                opacity: _fadeAnimation.value,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: _blurAnimation.value,
                    sigmaY: _blurAnimation.value,
                  ),
                  child: _targetArtUrl != null && _targetArtUrl!.isNotEmpty
                      ? AppNetworkImage(
                          imageUrl: _targetArtUrl!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.low,
                          errorWidget: (context, url, error) => _buildFallbackImage(),
                        )
                      : _buildFallbackImage(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }


  Widget _buildFallbackImage() {
    return Image.asset(
      RadioConfig.fallbackArtworkPath,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.low,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.grey[900],
        );
      },
    );
  }

  Widget _buildMeshGradientWithFade() {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([_blobAnimation, _fadeAnimation]),
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 20.0,
                sigmaY: 20.0,
              ),
              child: _targetPalette != null
                  ? Stack(
                      children: [
                        _buildBlob(
                          color: _targetPalette!.dominant,
                          alignment: Alignment(
                            -0.8 + (_blobAnimation.value * 0.15),
                            -0.8 + (_blobAnimation.value * 0.1),
                          ),
                          size: 1.4,
                        ),
                        _buildBlob(
                          color: _targetPalette!.vibrant,
                          alignment: Alignment(
                            0.8 - (_blobAnimation.value * 0.15),
                            -0.4 + (_blobAnimation.value * 0.1),
                          ),
                          size: 1.1,
                        ),
                        _buildBlob(
                          color: _targetPalette!.darkVibrant,
                          alignment: Alignment(
                            -0.5 + (_blobAnimation.value * 0.1),
                            0.5 + (_blobAnimation.value * 0.2),
                          ),
                          size: 1.3,
                        ),
                        _buildBlob(
                          color: _targetPalette!.muted,
                          alignment: Alignment(
                            0.6 - (_blobAnimation.value * 0.1),
                            0.8 - (_blobAnimation.value * 0.15),
                          ),
                          size: 1.2,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }


  Widget _buildBlob({
    required Color color,
    required Alignment alignment,
    required double size,
  }) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 280 * size,
        height: 280 * size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.8,
            colors: [
              color.withValues(alpha: 0.5),
              color.withValues(alpha: 0.2),
              color.withValues(alpha: 0.0),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }
}
