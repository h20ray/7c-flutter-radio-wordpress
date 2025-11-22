import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failures.dart';

part 'radio_player_state.freezed.dart';

/// States for RadioPlayerBloc
@freezed
class RadioPlayerState with _$RadioPlayerState {
  /// Initial state - player not initialized
  const factory RadioPlayerState.initial() = _Initial;

  /// Player is initializing
  const factory RadioPlayerState.initializing() = _Initializing;

  /// Player is connecting to stream
  const factory RadioPlayerState.connecting() = _Connecting;

  /// Player is buffering stream data
  const factory RadioPlayerState.buffering() = _Buffering;

  /// Player is retrying connection
  const factory RadioPlayerState.retrying({
    required int attempt,
    required String reason,
  }) = _Retrying;

  /// Player is ready and can be controlled
  const factory RadioPlayerState.ready({
    required bool isPlaying,
    String? currentUrl,
    String? currentArtist,
    String? currentTitle,
    String? currentAlbumArtUrl,
    @Default(false) bool isDucking,
    @Default(false) bool canAutoResume,
  }) = _Ready;

  /// Error state with specific failure type
  const factory RadioPlayerState.error({
    required Failure failure,
    String? message,
  }) = _Error;
}

