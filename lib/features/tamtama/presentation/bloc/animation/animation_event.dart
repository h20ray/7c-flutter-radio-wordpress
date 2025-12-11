part of 'animation_bloc.dart';

@freezed
class AnimationEvent with _$AnimationEvent {
  /// Initialize the animation system with a pet ID
  const factory AnimationEvent.initialize(int petId) = InitializeAnimationEvent;
  
  /// Update the pet ID (e.g., after evolution)
  const factory AnimationEvent.setPetId(int petId) = SetPetIdEvent;
  
  /// Play a specific animation
  const factory AnimationEvent.play({
    required String animationKey,
  }) = PlayAnimationEvent;
  
  /// Stop the current animation
  const factory AnimationEvent.stop() = StopAnimationEvent;
  
  /// Advance to next frame (internal)
  const factory AnimationEvent.nextFrame() = NextFrameEvent;
}
