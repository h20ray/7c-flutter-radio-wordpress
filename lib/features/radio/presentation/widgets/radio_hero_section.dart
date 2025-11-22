import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/widgets/album_art_widget.dart';
import '../../../../core/services/palette_service.dart';
import '../bloc/radio_player_bloc.dart';
import '../bloc/radio_player_state.dart';

/// Hero section with album art backdrop and gradient overlay
/// Displays greeting and station name
class RadioHeroSection extends StatefulWidget {
  final double height;
  final double scale;
  final double cardOverlap;

  const RadioHeroSection({
    super.key,
    required this.height,
    required this.scale,
    required this.cardOverlap,
  });

  @override
  State<RadioHeroSection> createState() => _RadioHeroSectionState();
}

class _RadioHeroSectionState extends State<RadioHeroSection> {
  final PaletteService _paletteService = PaletteService();
  Color? _dominantColor;

  @override
  void initState() {
    super.initState();
    _updatePalette();
  }

  Future<void> _updatePalette() async {
    final palette = await _paletteService.fetchForImage(
      const AssetImage('assets/images/fallback_artwork.jpg'),
      cacheKey: 'hero_fallback',
    );
    if (mounted) {
      setState(() {
        _dominantColor = palette.dominant;
      });
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'greeting_morning'.tr();
    } else if (hour < 17) {
      return 'greeting_midday'.tr();
    } else if (hour < 21) {
      return 'greeting_evening'.tr();
    } else {
      return 'greeting_night'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioPlayerBloc, RadioPlayerState>(
      buildWhen: (previous, current) {
        String? newArtUrl;
        current.maybeWhen(
          ready: (_, __, ___, ____, currentAlbumArtUrl, _____, ______) {
            newArtUrl = currentAlbumArtUrl;
          },
          orElse: () {},
        );
        return newArtUrl != _lastArtUrl;
      },
      builder: (context, state) {
        String? artUrl;
        state.maybeWhen(
          ready: (_, __, ___, ____, currentAlbumArtUrl, _____, ______) {
            artUrl = currentAlbumArtUrl;
          },
          orElse: () {},
        );
        _lastArtUrl = artUrl;

        return Container(
          height: widget.height + widget.cardOverlap,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _dominantColor ?? Theme.of(context).colorScheme.primary,
                Colors.black,
              ],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (artUrl != null && artUrl!.isNotEmpty)
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.3,
                    child: AlbumArtWidget.rectangle(
                      width: double.infinity,
                      height: widget.height,
                      filterQuality: FilterQuality.low,
                    ),
                  ),
                ),
              Positioned(
                left: 24,
                right: 24,
                bottom: widget.cardOverlap + 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getGreeting(),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'radio_station_name'.tr(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String? _lastArtUrl;
}

