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

  late final AnimationController _blobController;
  late final Animation<double> _blobAnimation;

  @override
  void initState() {
    super.initState();
    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
    
    _blobAnimation = CurvedAnimation(
      parent: _blobController,
      curve: Curves.easeInOutSine,
    );
  }

  @override
  void dispose() {
    _blobController.dispose();
    super.dispose();
  }

  Future<void> _updatePalette(String? artUrl) async {
    if (artUrl == null || artUrl.isEmpty) {
      if (mounted) setState(() => _currentPalette = null);
      return;
    }

    try {
      final palette = await _paletteService.fetchForUrl(artUrl);
      if (mounted) {
        setState(() {
          _currentPalette = palette;
        });
      }
    } catch (e) {
      // Fallback or ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.grey[900],
      child: BlocListener<RadioPlayerBloc, RadioPlayerState>(
        listenWhen: (previous, current) {
          String? newArtUrl;
          current.maybeWhen(
            ready: (playing, p2, p3, p4, currentAlbumArtUrl, p6, p7) {
              newArtUrl = currentAlbumArtUrl;
            },
            orElse: () {},
          );
          return newArtUrl != _cachedArtUrl;
        },
        listener: (context, state) {
          String? artUrl;
          state.maybeWhen(
            ready: (playing, p2, p3, p4, currentAlbumArtUrl, p6, p7) =>
                artUrl = currentAlbumArtUrl,
            orElse: () {},
          );
          _cachedArtUrl = artUrl;
          _updatePalette(artUrl);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Base background (blurred image) - kept for depth
            _buildBaseBackground(),
            
            // Animated Mesh Gradient Overlay
            if (_currentPalette != null)
              _buildMeshGradient(_currentPalette!),

            // Theme Overlay to ensure text readability
            Container(
              color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBaseBackground() {
    return RepaintBoundary(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: _cachedArtUrl != null && _cachedArtUrl!.isNotEmpty
            ? AppNetworkImage(
                imageUrl: _cachedArtUrl!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
                errorWidget: (context, url, error) => _buildFallbackImage(),
              )
            : _buildFallbackImage(),
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

  Widget _buildMeshGradient(PaletteColors palette) {
    return AnimatedBuilder(
      animation: _blobAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            _buildBlob(
              color: palette.dominant,
              alignment: Alignment(-0.8 + (_blobAnimation.value * 0.2), -0.8),
              size: 1.5,
            ),
            _buildBlob(
              color: palette.vibrant,
              alignment: Alignment(0.8 - (_blobAnimation.value * 0.2), -0.4),
              size: 1.2,
            ),
            _buildBlob(
              color: palette.darkVibrant,
              alignment: Alignment(-0.5, 0.5 + (_blobAnimation.value * 0.3)),
              size: 1.4,
            ),
            _buildBlob(
              color: palette.muted,
              alignment: Alignment(0.6, 0.8 - (_blobAnimation.value * 0.2)),
              size: 1.3,
            ),
            // Glass effect on top of blobs
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(color: Colors.transparent),
            ),
          ],
        );
      },
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
        width: 300 * size,
        height: 300 * size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: 0.6),
              color.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }
}
