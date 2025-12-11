import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/services/animation_service.dart';

part 'animation_bloc.freezed.dart';
part 'animation_event.dart';
part 'animation_state.dart';

/// BLoC for managing sprite frame animations
/// 
/// Controls sprite animations for the pet:
/// - Load sprite frames
/// - Manage animation timing
/// - Handle animation transitions
/// - Emit correct frame to UI
class AnimationBloc extends Bloc<AnimationEvent, AnimationState> {
  final AnimationService animationService;
  
  Timer? _frameTimer;
  int _currentFrameIndex = 0;
  List<String> _currentFrames = [];
  AnimationConfig? _currentConfig;
  String _currentAnimationKey = 'idle';
  
  AnimationBloc({
    required this.animationService,
  }) : super(const AnimationState.initial()) {
    on<InitializeAnimationEvent>(_onInitialize);
    on<PlayAnimationEvent>(_onPlayAnimation);
    on<StopAnimationEvent>(_onStopAnimation);
    on<NextFrameEvent>(_onNextFrame);
    on<SetPetIdEvent>(_onSetPetId);
  }
  
  int? _petId;
  
  Future<void> _onInitialize(
    InitializeAnimationEvent event,
    Emitter<AnimationState> emit,
  ) async {
    await animationService.initialize();
    _petId = event.petId;
    
    // Start with idle animation
    add(const AnimationEvent.play(animationKey: 'idle'));
  }
  
  Future<void> _onSetPetId(
    SetPetIdEvent event,
    Emitter<AnimationState> emit,
  ) async {
    _petId = event.petId;
    // Restart current animation with new pet
    if (_currentAnimationKey.isNotEmpty) {
      add(AnimationEvent.play(animationKey: _currentAnimationKey));
    }
  }
  
  Future<void> _onPlayAnimation(
    PlayAnimationEvent event,
    Emitter<AnimationState> emit,
  ) async {
    if (_petId == null) {
      emit(const AnimationState.error('Pet ID not set'));
      return;
    }
    
    // Stop current animation
    _frameTimer?.cancel();
    _currentFrameIndex = 0;
    
    // Get animation config
    _currentAnimationKey = event.animationKey;
    _currentConfig = animationService.getAnimationConfigByKey(event.animationKey);
    _currentFrames = animationService.getFramePaths(_petId!, event.animationKey);
    
    if (_currentFrames.isEmpty) {
      emit(AnimationState.error('No frames found for ${event.animationKey}'));
      return;
    }
    
    // Emit first frame
    emit(AnimationState.playing(
      currentFrame: _currentFrames[0],
      frameIndex: 0,
      totalFrames: _currentFrames.length,
      animationKey: _currentAnimationKey,
      isLooping: _currentConfig?.loop ?? true,
    ));
    
    // If multiple frames, start timer
    if (_currentFrames.length > 1) {
      final duration = _currentConfig?.frameDuration ?? 
          const Duration(milliseconds: 125);
      
      _frameTimer = Timer.periodic(duration, (_) {
        add(const AnimationEvent.nextFrame());
      });
    }
  }
  
  void _onNextFrame(
    NextFrameEvent event,
    Emitter<AnimationState> emit,
  ) {
    if (_currentFrames.isEmpty) return;
    
    _currentFrameIndex++;
    
    // Check if animation is complete
    if (_currentFrameIndex >= _currentFrames.length) {
      if (_currentConfig?.loop == true) {
        _currentFrameIndex = 0;
      } else {
        // Animation complete, stop and return to idle
        _frameTimer?.cancel();
        add(const AnimationEvent.play(animationKey: 'idle'));
        return;
      }
    }
    
    emit(AnimationState.playing(
      currentFrame: _currentFrames[_currentFrameIndex],
      frameIndex: _currentFrameIndex,
      totalFrames: _currentFrames.length,
      animationKey: _currentAnimationKey,
      isLooping: _currentConfig?.loop ?? true,
    ));
  }
  
  void _onStopAnimation(
    StopAnimationEvent event,
    Emitter<AnimationState> emit,
  ) {
    _frameTimer?.cancel();
    _frameTimer = null;
    
    if (_currentFrames.isNotEmpty) {
      emit(AnimationState.stopped(
        lastFrame: _currentFrames[_currentFrameIndex],
        animationKey: _currentAnimationKey,
      ));
    }
  }
  
  /// Play a one-shot animation then return to idle
  void playOnce(String animationKey) {
    add(AnimationEvent.play(animationKey: animationKey));
  }
  
  /// Get recommended animation based on pet state
  String getAnimationForState(String petState) {
    switch (petState) {
      case 'sleeping':
        return 'sleeping';
      case 'listening':
        return 'radio';
      case 'sick':
        return 'sad';
      case 'evolving':
        return 'evolution';
      default:
        return 'idle';
    }
  }
  
  @override
  Future<void> close() {
    _frameTimer?.cancel();
    return super.close();
  }
}
