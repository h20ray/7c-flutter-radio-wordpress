import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../themes/design_tokens.dart';
import '../../features/radio/presentation/bloc/radio_player_bloc.dart';
import '../../features/radio/presentation/bloc/radio_player_event.dart';
import '../../features/radio/presentation/bloc/radio_player_state.dart';

class FloatingPlayFab extends StatefulWidget {
  const FloatingPlayFab({super.key});

  @override
  State<FloatingPlayFab> createState() => _FloatingPlayFabState();
}

class _FloatingPlayFabState extends State<FloatingPlayFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioPlayerBloc, RadioPlayerState>(
      builder: (context, state) {
        final isPlaying = state.maybeWhen(
          ready: (playing, currentUrl, currentArtist, currentTitle,
              currentAlbumArtUrl, isDucking, canAutoResume) => playing,
          orElse: () => false,
        );

        if (isPlaying) {
          _pulseController.forward();
        } else {
          _pulseController.stop();
          _pulseController.reset();
        }

        return Positioned(
          right: DesignTokens.spacingL,
          bottom: 100,
          child: SafeArea(
            top: false,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: isPlaying ? _pulseAnimation.value : 1.0,
                  child: FloatingActionButton(
                    onPressed: () {
                      context.read<RadioPlayerBloc>().add(
                            const RadioPlayerEvent.togglePlayPause(),
                          );
                    },
                    backgroundColor: DesignTokens.colorPrimaryAccent,
                    elevation: DesignTokens.elevationFab,
                    child: Icon(
                      isPlaying ? LucideIcons.pause : LucideIcons.play,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

