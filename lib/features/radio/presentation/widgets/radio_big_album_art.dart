import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/album_art_widget.dart';
import '../bloc/radio_player_bloc.dart';
import '../bloc/radio_player_state.dart';

class RadioBigAlbumArt extends StatelessWidget {
  const RadioBigAlbumArt({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioPlayerBloc, RadioPlayerState>(
      builder: (context, state) {
        bool isPlaying = false;

        state.maybeWhen(
          ready: (playing, _, _, _, _, _, _) {
            isPlaying = playing;
          },
          orElse: () {},
        );

        return AnimatedScale(
          scale: isPlaying ? 1.0 : 0.85,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutBack,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isPlaying ? 0.3 : 0.15),
                  blurRadius: isPlaying ? 24 : 12,
                  offset: Offset(0, isPlaying ? 12 : 6),
                  spreadRadius: isPlaying ? 0 : -4,
                ),
              ],
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: AlbumArtWidget.roundedRect(
                width: double.infinity,
                height: double.infinity,
                borderRadius: 16,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        );
      },
    );
  }
}
