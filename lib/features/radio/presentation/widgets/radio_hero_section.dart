import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/widgets/album_art_widget.dart';
import '../../../../core/services/palette_service.dart';
import '../../../../main.dart';
import '../bloc/radio_player_bloc.dart';
import '../bloc/radio_player_state.dart';

class RadioHeroSection extends StatefulWidget {
  final double height;
  final double scale;
  final double cardOverlap;

  const RadioHeroSection({
    super.key,
    required this.height,
    this.scale = 1.5,
    required this.cardOverlap,
  });

  @override
  State<RadioHeroSection> createState() => _RadioHeroSectionState();
}

class _RadioHeroSectionState extends State<RadioHeroSection>
    with SingleTickerProviderStateMixin, RouteAware {
  String? _cachedArtUrl;
  String? _lastGreeting;
  DateTime? _lastFadeTime;

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fade;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 11) return 'greeting_morning'.tr();
    if (hour >= 11 && hour < 15) return 'greeting_midday'.tr();
    if (hour >= 15 && hour < 18) return 'greeting_evening'.tr();
    return 'greeting_night'.tr();
  }

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _fadeCtrl.forward(from: 0);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  void didPushNext() {}

  @override
  void didPopNext() {
    if (mounted) _fadeCtrl.forward(from: 0);
  }

  void _restartFadeIn() {
    if (!_fadeCtrl.isAnimating && mounted) {
      final now = DateTime.now();
      if (_lastFadeTime == null ||
          now.difference(_lastFadeTime!).inMilliseconds > 500) {
        _lastFadeTime = now;
        _fadeCtrl.forward(from: 0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // In a SliverAppBar/FlexibleSpaceBar context, we don't need fixed height here.
    // The parent determines the size.
    return SizedBox(
      width: double.infinity,
      child: ClipRect(
        child: Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.grey[900],
          child: FadeTransition(
            opacity: _fade,
            child: BlocBuilder<RadioPlayerBloc, RadioPlayerState>(
              buildWhen: (previous, current) {
                String? newArtUrl;
                current.maybeWhen(
                  ready: (playing, p2, p3, p4, currentAlbumArtUrl, p6, p7) {
                    newArtUrl = currentAlbumArtUrl;
                  },
                  orElse: () {},
                );

                final changed = newArtUrl != _cachedArtUrl;
                if (changed) {
                  final oldArtUrl = _cachedArtUrl;
                  _cachedArtUrl = newArtUrl;
                  if (newArtUrl != null &&
                      newArtUrl!.isNotEmpty &&
                      newArtUrl != oldArtUrl) {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => _restartFadeIn());
                  }
                }
                return changed;
              },
              builder: (context, state) {
                String? artUrl;
                state.maybeWhen(
                  ready: (playing, p2, p3, p4, currentAlbumArtUrl, p6, p7) =>
                      artUrl = currentAlbumArtUrl,
                  orElse: () {},
                );

                _cachedArtUrl = artUrl;

                final currentGreeting = _greeting();
                if (_lastGreeting != currentGreeting) {
                  _lastGreeting = currentGreeting;
                }

                return _CachedHeroContent(
                  scale: widget.scale,
                  greeting: _lastGreeting!,
                  // Pass null or let layout determine height
                  heroHeight: widget.height, 
                  cardOverlap: widget.cardOverlap,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CachedHeroContent extends StatelessWidget {
  final double scale;
  final String greeting;
  final double heroHeight;
  final double cardOverlap;

  const _CachedHeroContent({
    required this.scale,
    required this.greeting,
    required this.heroHeight,
    required this.cardOverlap,
  });

  @override
  Widget build(BuildContext context) {
    // In a FlexibleSpaceBar, we want the content to fill the available space.
    // The Stack allows us to layer the image and the text.
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          RepaintBoundary(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Transform.scale(
                scale: scale,
                child: AlbumArtWidget.rectangle(
                  width: double.infinity,
                  height: double.infinity,
                  filterQuality: FilterQuality.low,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          BlocBuilder<RadioPlayerBloc, RadioPlayerState>(
            builder: (context, state) {
              String? artUrl;
              state.maybeWhen(
                ready: (playing, p2, p3, p4, currentAlbumArtUrl, p6, p7) =>
                    artUrl = currentAlbumArtUrl,
                orElse: () {},
              );
              
              final paletteService = PaletteService();
              final defaultGradient = LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xCC0B1216),
                  const Color(0x000B1216),
                ],
              );
              
              if (artUrl == null || artUrl!.isEmpty) {
                return Container(decoration: BoxDecoration(gradient: defaultGradient));
              }
              
              return FutureBuilder(
                future: paletteService.fetchForUrl(artUrl!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(decoration: BoxDecoration(gradient: defaultGradient));
                  }
                  
                  final palette = snapshot.data!;
                  final gradientColors = [
                    palette.darkVibrant.withValues(alpha: 0.9),
                    palette.dominant.withValues(alpha: 0.85),
                    palette.vibrant.withValues(alpha: 0.8),
                    palette.muted.withValues(alpha: 0.75),
                  ];
                  
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors,
                        stops: const [0.0, 0.3, 0.7, 1.0],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          // Content (Greeting) - Removed for strict M3 AppBar
          // The title is now handled by the SliverAppBar.large title property
          // Info Button moved to AppBar actions
          // Bottom Gradient Fade (optional, can be adjusted)
          Positioned(
            left: 0,
            right: 0,
            bottom: -2,
            height: 100, // Fixed height for gradient fade
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 1.0],
                    colors: [
                      const Color(0x000B1216),
                      Theme.of(context).colorScheme.surface,
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
}
