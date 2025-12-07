import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/radio/presentation/bloc/radio_player_bloc.dart';
import '../../features/radio/presentation/bloc/radio_player_state.dart';

/// A record type for radio state information.
///
/// Contains the essential metadata from the radio player needed for
/// UI components like share dialogs.
typedef RadioStateInfo = ({
  String? artist,
  String? title,
  String? albumArtUrl,
  bool isPlaying,
});

/// Mixin providing convenient access to RadioPlayerBloc state.
///
/// This mixin eliminates code duplication across widgets that need to
/// access radio player state (e.g., share dialogs, greeting chips).
///
/// Usage:
/// ```dart
/// class _MyWidgetState extends State<MyWidget> with RadioStateAccessorMixin {
///   void _handleTap() {
///     final state = getRadioState();
///     if (state != null) {
///       print('Now playing: ${state.title}');
///     }
///   }
/// }
/// ```
mixin RadioStateAccessorMixin<T extends StatefulWidget> on State<T> {
  /// Gets the current radio player state as a record.
  ///
  /// Returns null if:
  /// - The RadioPlayerBloc is not available in the widget tree
  /// - The player is not in the "ready" state
  /// - An error occurs accessing the bloc
  RadioStateInfo? getRadioState() {
    try {
      final bloc = context.read<RadioPlayerBloc>();
      String? artist;
      String? title;
      String? albumArtUrl;
      bool isPlaying = false;

      bloc.state.maybeWhen(
        ready: (playing, url, a, t, artUrl, ducking, autoResume) {
          artist = a;
          title = t;
          albumArtUrl = artUrl;
          isPlaying = playing;
        },
        orElse: () {},
      );

      return (
        artist: artist,
        title: title,
        albumArtUrl: albumArtUrl,
        isPlaying: isPlaying,
      );
    } catch (e) {
      debugPrint('RadioStateAccessorMixin: Error accessing bloc - $e');
      return null;
    }
  }

  /// Convenience getter for just the album art URL.
  ///
  /// Useful when only the album art is needed, avoiding unnecessary
  /// destructuring of the full state record.
  String? get currentAlbumArtUrl => getRadioState()?.albumArtUrl;

  /// Convenience getter for checking if radio is currently playing.
  bool get isRadioPlaying => getRadioState()?.isPlaying ?? false;
}
