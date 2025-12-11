// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'animation_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnimationEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnimationEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnimationEvent()';
}


}

/// @nodoc
class $AnimationEventCopyWith<$Res>  {
$AnimationEventCopyWith(AnimationEvent _, $Res Function(AnimationEvent) __);
}


/// Adds pattern-matching-related methods to [AnimationEvent].
extension AnimationEventPatterns on AnimationEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InitializeAnimationEvent value)?  initialize,TResult Function( SetPetIdEvent value)?  setPetId,TResult Function( PlayAnimationEvent value)?  play,TResult Function( StopAnimationEvent value)?  stop,TResult Function( NextFrameEvent value)?  nextFrame,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InitializeAnimationEvent() when initialize != null:
return initialize(_that);case SetPetIdEvent() when setPetId != null:
return setPetId(_that);case PlayAnimationEvent() when play != null:
return play(_that);case StopAnimationEvent() when stop != null:
return stop(_that);case NextFrameEvent() when nextFrame != null:
return nextFrame(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InitializeAnimationEvent value)  initialize,required TResult Function( SetPetIdEvent value)  setPetId,required TResult Function( PlayAnimationEvent value)  play,required TResult Function( StopAnimationEvent value)  stop,required TResult Function( NextFrameEvent value)  nextFrame,}){
final _that = this;
switch (_that) {
case InitializeAnimationEvent():
return initialize(_that);case SetPetIdEvent():
return setPetId(_that);case PlayAnimationEvent():
return play(_that);case StopAnimationEvent():
return stop(_that);case NextFrameEvent():
return nextFrame(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InitializeAnimationEvent value)?  initialize,TResult? Function( SetPetIdEvent value)?  setPetId,TResult? Function( PlayAnimationEvent value)?  play,TResult? Function( StopAnimationEvent value)?  stop,TResult? Function( NextFrameEvent value)?  nextFrame,}){
final _that = this;
switch (_that) {
case InitializeAnimationEvent() when initialize != null:
return initialize(_that);case SetPetIdEvent() when setPetId != null:
return setPetId(_that);case PlayAnimationEvent() when play != null:
return play(_that);case StopAnimationEvent() when stop != null:
return stop(_that);case NextFrameEvent() when nextFrame != null:
return nextFrame(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int petId)?  initialize,TResult Function( int petId)?  setPetId,TResult Function( String animationKey)?  play,TResult Function()?  stop,TResult Function()?  nextFrame,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InitializeAnimationEvent() when initialize != null:
return initialize(_that.petId);case SetPetIdEvent() when setPetId != null:
return setPetId(_that.petId);case PlayAnimationEvent() when play != null:
return play(_that.animationKey);case StopAnimationEvent() when stop != null:
return stop();case NextFrameEvent() when nextFrame != null:
return nextFrame();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int petId)  initialize,required TResult Function( int petId)  setPetId,required TResult Function( String animationKey)  play,required TResult Function()  stop,required TResult Function()  nextFrame,}) {final _that = this;
switch (_that) {
case InitializeAnimationEvent():
return initialize(_that.petId);case SetPetIdEvent():
return setPetId(_that.petId);case PlayAnimationEvent():
return play(_that.animationKey);case StopAnimationEvent():
return stop();case NextFrameEvent():
return nextFrame();case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int petId)?  initialize,TResult? Function( int petId)?  setPetId,TResult? Function( String animationKey)?  play,TResult? Function()?  stop,TResult? Function()?  nextFrame,}) {final _that = this;
switch (_that) {
case InitializeAnimationEvent() when initialize != null:
return initialize(_that.petId);case SetPetIdEvent() when setPetId != null:
return setPetId(_that.petId);case PlayAnimationEvent() when play != null:
return play(_that.animationKey);case StopAnimationEvent() when stop != null:
return stop();case NextFrameEvent() when nextFrame != null:
return nextFrame();case _:
  return null;

}
}

}

/// @nodoc


class InitializeAnimationEvent implements AnimationEvent {
  const InitializeAnimationEvent(this.petId);
  

 final  int petId;

/// Create a copy of AnimationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InitializeAnimationEventCopyWith<InitializeAnimationEvent> get copyWith => _$InitializeAnimationEventCopyWithImpl<InitializeAnimationEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InitializeAnimationEvent&&(identical(other.petId, petId) || other.petId == petId));
}


@override
int get hashCode => Object.hash(runtimeType,petId);

@override
String toString() {
  return 'AnimationEvent.initialize(petId: $petId)';
}


}

/// @nodoc
abstract mixin class $InitializeAnimationEventCopyWith<$Res> implements $AnimationEventCopyWith<$Res> {
  factory $InitializeAnimationEventCopyWith(InitializeAnimationEvent value, $Res Function(InitializeAnimationEvent) _then) = _$InitializeAnimationEventCopyWithImpl;
@useResult
$Res call({
 int petId
});




}
/// @nodoc
class _$InitializeAnimationEventCopyWithImpl<$Res>
    implements $InitializeAnimationEventCopyWith<$Res> {
  _$InitializeAnimationEventCopyWithImpl(this._self, this._then);

  final InitializeAnimationEvent _self;
  final $Res Function(InitializeAnimationEvent) _then;

/// Create a copy of AnimationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? petId = null,}) {
  return _then(InitializeAnimationEvent(
null == petId ? _self.petId : petId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class SetPetIdEvent implements AnimationEvent {
  const SetPetIdEvent(this.petId);
  

 final  int petId;

/// Create a copy of AnimationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetPetIdEventCopyWith<SetPetIdEvent> get copyWith => _$SetPetIdEventCopyWithImpl<SetPetIdEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetPetIdEvent&&(identical(other.petId, petId) || other.petId == petId));
}


@override
int get hashCode => Object.hash(runtimeType,petId);

@override
String toString() {
  return 'AnimationEvent.setPetId(petId: $petId)';
}


}

/// @nodoc
abstract mixin class $SetPetIdEventCopyWith<$Res> implements $AnimationEventCopyWith<$Res> {
  factory $SetPetIdEventCopyWith(SetPetIdEvent value, $Res Function(SetPetIdEvent) _then) = _$SetPetIdEventCopyWithImpl;
@useResult
$Res call({
 int petId
});




}
/// @nodoc
class _$SetPetIdEventCopyWithImpl<$Res>
    implements $SetPetIdEventCopyWith<$Res> {
  _$SetPetIdEventCopyWithImpl(this._self, this._then);

  final SetPetIdEvent _self;
  final $Res Function(SetPetIdEvent) _then;

/// Create a copy of AnimationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? petId = null,}) {
  return _then(SetPetIdEvent(
null == petId ? _self.petId : petId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class PlayAnimationEvent implements AnimationEvent {
  const PlayAnimationEvent({required this.animationKey});
  

 final  String animationKey;

/// Create a copy of AnimationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayAnimationEventCopyWith<PlayAnimationEvent> get copyWith => _$PlayAnimationEventCopyWithImpl<PlayAnimationEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayAnimationEvent&&(identical(other.animationKey, animationKey) || other.animationKey == animationKey));
}


@override
int get hashCode => Object.hash(runtimeType,animationKey);

@override
String toString() {
  return 'AnimationEvent.play(animationKey: $animationKey)';
}


}

/// @nodoc
abstract mixin class $PlayAnimationEventCopyWith<$Res> implements $AnimationEventCopyWith<$Res> {
  factory $PlayAnimationEventCopyWith(PlayAnimationEvent value, $Res Function(PlayAnimationEvent) _then) = _$PlayAnimationEventCopyWithImpl;
@useResult
$Res call({
 String animationKey
});




}
/// @nodoc
class _$PlayAnimationEventCopyWithImpl<$Res>
    implements $PlayAnimationEventCopyWith<$Res> {
  _$PlayAnimationEventCopyWithImpl(this._self, this._then);

  final PlayAnimationEvent _self;
  final $Res Function(PlayAnimationEvent) _then;

/// Create a copy of AnimationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? animationKey = null,}) {
  return _then(PlayAnimationEvent(
animationKey: null == animationKey ? _self.animationKey : animationKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class StopAnimationEvent implements AnimationEvent {
  const StopAnimationEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StopAnimationEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnimationEvent.stop()';
}


}




/// @nodoc


class NextFrameEvent implements AnimationEvent {
  const NextFrameEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NextFrameEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnimationEvent.nextFrame()';
}


}




/// @nodoc
mixin _$AnimationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnimationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnimationState()';
}


}

/// @nodoc
class $AnimationStateCopyWith<$Res>  {
$AnimationStateCopyWith(AnimationState _, $Res Function(AnimationState) __);
}


/// Adds pattern-matching-related methods to [AnimationState].
extension AnimationStatePatterns on AnimationState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AnimationInitial value)?  initial,TResult Function( AnimationPlaying value)?  playing,TResult Function( AnimationStopped value)?  stopped,TResult Function( AnimationError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AnimationInitial() when initial != null:
return initial(_that);case AnimationPlaying() when playing != null:
return playing(_that);case AnimationStopped() when stopped != null:
return stopped(_that);case AnimationError() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AnimationInitial value)  initial,required TResult Function( AnimationPlaying value)  playing,required TResult Function( AnimationStopped value)  stopped,required TResult Function( AnimationError value)  error,}){
final _that = this;
switch (_that) {
case AnimationInitial():
return initial(_that);case AnimationPlaying():
return playing(_that);case AnimationStopped():
return stopped(_that);case AnimationError():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AnimationInitial value)?  initial,TResult? Function( AnimationPlaying value)?  playing,TResult? Function( AnimationStopped value)?  stopped,TResult? Function( AnimationError value)?  error,}){
final _that = this;
switch (_that) {
case AnimationInitial() when initial != null:
return initial(_that);case AnimationPlaying() when playing != null:
return playing(_that);case AnimationStopped() when stopped != null:
return stopped(_that);case AnimationError() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( String currentFrame,  int frameIndex,  int totalFrames,  String animationKey,  bool isLooping)?  playing,TResult Function( String lastFrame,  String animationKey)?  stopped,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AnimationInitial() when initial != null:
return initial();case AnimationPlaying() when playing != null:
return playing(_that.currentFrame,_that.frameIndex,_that.totalFrames,_that.animationKey,_that.isLooping);case AnimationStopped() when stopped != null:
return stopped(_that.lastFrame,_that.animationKey);case AnimationError() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( String currentFrame,  int frameIndex,  int totalFrames,  String animationKey,  bool isLooping)  playing,required TResult Function( String lastFrame,  String animationKey)  stopped,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case AnimationInitial():
return initial();case AnimationPlaying():
return playing(_that.currentFrame,_that.frameIndex,_that.totalFrames,_that.animationKey,_that.isLooping);case AnimationStopped():
return stopped(_that.lastFrame,_that.animationKey);case AnimationError():
return error(_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( String currentFrame,  int frameIndex,  int totalFrames,  String animationKey,  bool isLooping)?  playing,TResult? Function( String lastFrame,  String animationKey)?  stopped,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case AnimationInitial() when initial != null:
return initial();case AnimationPlaying() when playing != null:
return playing(_that.currentFrame,_that.frameIndex,_that.totalFrames,_that.animationKey,_that.isLooping);case AnimationStopped() when stopped != null:
return stopped(_that.lastFrame,_that.animationKey);case AnimationError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AnimationInitial implements AnimationState {
  const AnimationInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnimationInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnimationState.initial()';
}


}




/// @nodoc


class AnimationPlaying implements AnimationState {
  const AnimationPlaying({required this.currentFrame, required this.frameIndex, required this.totalFrames, required this.animationKey, required this.isLooping});
  

 final  String currentFrame;
 final  int frameIndex;
 final  int totalFrames;
 final  String animationKey;
 final  bool isLooping;

/// Create a copy of AnimationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnimationPlayingCopyWith<AnimationPlaying> get copyWith => _$AnimationPlayingCopyWithImpl<AnimationPlaying>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnimationPlaying&&(identical(other.currentFrame, currentFrame) || other.currentFrame == currentFrame)&&(identical(other.frameIndex, frameIndex) || other.frameIndex == frameIndex)&&(identical(other.totalFrames, totalFrames) || other.totalFrames == totalFrames)&&(identical(other.animationKey, animationKey) || other.animationKey == animationKey)&&(identical(other.isLooping, isLooping) || other.isLooping == isLooping));
}


@override
int get hashCode => Object.hash(runtimeType,currentFrame,frameIndex,totalFrames,animationKey,isLooping);

@override
String toString() {
  return 'AnimationState.playing(currentFrame: $currentFrame, frameIndex: $frameIndex, totalFrames: $totalFrames, animationKey: $animationKey, isLooping: $isLooping)';
}


}

/// @nodoc
abstract mixin class $AnimationPlayingCopyWith<$Res> implements $AnimationStateCopyWith<$Res> {
  factory $AnimationPlayingCopyWith(AnimationPlaying value, $Res Function(AnimationPlaying) _then) = _$AnimationPlayingCopyWithImpl;
@useResult
$Res call({
 String currentFrame, int frameIndex, int totalFrames, String animationKey, bool isLooping
});




}
/// @nodoc
class _$AnimationPlayingCopyWithImpl<$Res>
    implements $AnimationPlayingCopyWith<$Res> {
  _$AnimationPlayingCopyWithImpl(this._self, this._then);

  final AnimationPlaying _self;
  final $Res Function(AnimationPlaying) _then;

/// Create a copy of AnimationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? currentFrame = null,Object? frameIndex = null,Object? totalFrames = null,Object? animationKey = null,Object? isLooping = null,}) {
  return _then(AnimationPlaying(
currentFrame: null == currentFrame ? _self.currentFrame : currentFrame // ignore: cast_nullable_to_non_nullable
as String,frameIndex: null == frameIndex ? _self.frameIndex : frameIndex // ignore: cast_nullable_to_non_nullable
as int,totalFrames: null == totalFrames ? _self.totalFrames : totalFrames // ignore: cast_nullable_to_non_nullable
as int,animationKey: null == animationKey ? _self.animationKey : animationKey // ignore: cast_nullable_to_non_nullable
as String,isLooping: null == isLooping ? _self.isLooping : isLooping // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class AnimationStopped implements AnimationState {
  const AnimationStopped({required this.lastFrame, required this.animationKey});
  

 final  String lastFrame;
 final  String animationKey;

/// Create a copy of AnimationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnimationStoppedCopyWith<AnimationStopped> get copyWith => _$AnimationStoppedCopyWithImpl<AnimationStopped>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnimationStopped&&(identical(other.lastFrame, lastFrame) || other.lastFrame == lastFrame)&&(identical(other.animationKey, animationKey) || other.animationKey == animationKey));
}


@override
int get hashCode => Object.hash(runtimeType,lastFrame,animationKey);

@override
String toString() {
  return 'AnimationState.stopped(lastFrame: $lastFrame, animationKey: $animationKey)';
}


}

/// @nodoc
abstract mixin class $AnimationStoppedCopyWith<$Res> implements $AnimationStateCopyWith<$Res> {
  factory $AnimationStoppedCopyWith(AnimationStopped value, $Res Function(AnimationStopped) _then) = _$AnimationStoppedCopyWithImpl;
@useResult
$Res call({
 String lastFrame, String animationKey
});




}
/// @nodoc
class _$AnimationStoppedCopyWithImpl<$Res>
    implements $AnimationStoppedCopyWith<$Res> {
  _$AnimationStoppedCopyWithImpl(this._self, this._then);

  final AnimationStopped _self;
  final $Res Function(AnimationStopped) _then;

/// Create a copy of AnimationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lastFrame = null,Object? animationKey = null,}) {
  return _then(AnimationStopped(
lastFrame: null == lastFrame ? _self.lastFrame : lastFrame // ignore: cast_nullable_to_non_nullable
as String,animationKey: null == animationKey ? _self.animationKey : animationKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AnimationError implements AnimationState {
  const AnimationError(this.message);
  

 final  String message;

/// Create a copy of AnimationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnimationErrorCopyWith<AnimationError> get copyWith => _$AnimationErrorCopyWithImpl<AnimationError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnimationError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AnimationState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $AnimationErrorCopyWith<$Res> implements $AnimationStateCopyWith<$Res> {
  factory $AnimationErrorCopyWith(AnimationError value, $Res Function(AnimationError) _then) = _$AnimationErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AnimationErrorCopyWithImpl<$Res>
    implements $AnimationErrorCopyWith<$Res> {
  _$AnimationErrorCopyWithImpl(this._self, this._then);

  final AnimationError _self;
  final $Res Function(AnimationError) _then;

/// Create a copy of AnimationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AnimationError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
