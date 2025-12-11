part of 'animation_bloc.dart';

@freezed
class AnimationState with _$AnimationState {
  /// Initial state before animation system is initialized
  const factory AnimationState.initial() = AnimationInitial;
  
  /// Currently playing an animation
  const factory AnimationState.playing({
    required String currentFrame,
    required int frameIndex,
    required int totalFrames,
    required String animationKey,
    required bool isLooping,
  }) = AnimationPlaying;
  
  /// Animation stopped
  const factory AnimationState.stopped({
    required String lastFrame,
    required String animationKey,
  }) = AnimationStopped;
  
  /// Error state
  const factory AnimationState.error(String message) = AnimationError;
}
