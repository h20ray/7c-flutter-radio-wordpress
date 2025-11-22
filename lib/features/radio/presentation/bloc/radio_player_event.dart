import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/radio_entity.dart';

part 'radio_player_event.freezed.dart';

/// Events for RadioPlayerBloc
@freezed
class RadioPlayerEvent with _$RadioPlayerEvent {
  /// Initialize the radio player with configuration
  const factory RadioPlayerEvent.initialize(
    RadioEntity config, {
    @Default(false) bool autoPlay,
  }) = _Initialize;

  /// Start radio playback
  const factory RadioPlayerEvent.play() = _Play;

  /// Pause radio playback
  const factory RadioPlayerEvent.pause() = _Pause;

  /// Toggle between play and pause
  const factory RadioPlayerEvent.togglePlayPause() = _TogglePlayPause;

  /// Reset the radio player to initial state
  const factory RadioPlayerEvent.reset() = _Reset;

  /// Playback state changed (internal event from stream)
  const factory RadioPlayerEvent.playbackStateChanged(bool isPlaying) =
      _PlaybackStateChanged;

  /// Metadata updated (internal event from stream)
  const factory RadioPlayerEvent.metadataUpdated(
    String? artist,
    String? title,
  ) = _MetadataUpdated;

  /// Album art fetched (internal event)
  const factory RadioPlayerEvent.albumArtFetched(String albumArtUrl) =
      _AlbumArtFetched;

  /// Error occurred (internal event)
  const factory RadioPlayerEvent.errorOccurred(String message) = _ErrorOccurred;

  /// State changed (internal event)
  const factory RadioPlayerEvent.stateChanged(String state) = _StateChanged;

  /// Retrying connection (internal event)
  const factory RadioPlayerEvent.retrying(
    int attempt,
    String reason,
  ) = _Retrying;

  /// Set custom metadata for notification
  const factory RadioPlayerEvent.setCustomMetadata({
    required String artist,
    required String title,
    String? artworkUrl,
  }) = _SetCustomMetadata;

  /// Update station configuration
  const factory RadioPlayerEvent.updateStation({
    required String title,
    required String url,
    required bool parseStreamMetadata,
    required bool lookupOnlineArtwork,
    String? logoAssetPath,
    String? logoNetworkUrl,
  }) = _UpdateStation;
}

