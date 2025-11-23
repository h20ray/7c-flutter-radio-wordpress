// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'radio_player_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RadioPlayerState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadioPlayerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RadioPlayerState()';
}


}

/// @nodoc
class $RadioPlayerStateCopyWith<$Res>  {
$RadioPlayerStateCopyWith(RadioPlayerState _, $Res Function(RadioPlayerState) __);
}


/// Adds pattern-matching-related methods to [RadioPlayerState].
extension RadioPlayerStatePatterns on RadioPlayerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Initializing value)?  initializing,TResult Function( _Connecting value)?  connecting,TResult Function( _Buffering value)?  buffering,TResult Function( _Retrying value)?  retrying,TResult Function( _Ready value)?  ready,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Initializing() when initializing != null:
return initializing(_that);case _Connecting() when connecting != null:
return connecting(_that);case _Buffering() when buffering != null:
return buffering(_that);case _Retrying() when retrying != null:
return retrying(_that);case _Ready() when ready != null:
return ready(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Initializing value)  initializing,required TResult Function( _Connecting value)  connecting,required TResult Function( _Buffering value)  buffering,required TResult Function( _Retrying value)  retrying,required TResult Function( _Ready value)  ready,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Initializing():
return initializing(_that);case _Connecting():
return connecting(_that);case _Buffering():
return buffering(_that);case _Retrying():
return retrying(_that);case _Ready():
return ready(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Initializing value)?  initializing,TResult? Function( _Connecting value)?  connecting,TResult? Function( _Buffering value)?  buffering,TResult? Function( _Retrying value)?  retrying,TResult? Function( _Ready value)?  ready,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Initializing() when initializing != null:
return initializing(_that);case _Connecting() when connecting != null:
return connecting(_that);case _Buffering() when buffering != null:
return buffering(_that);case _Retrying() when retrying != null:
return retrying(_that);case _Ready() when ready != null:
return ready(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  initializing,TResult Function()?  connecting,TResult Function()?  buffering,TResult Function( int attempt,  String reason)?  retrying,TResult Function( bool isPlaying,  String? currentUrl,  String? currentArtist,  String? currentTitle,  String? currentAlbumArtUrl,  bool isDucking,  bool canAutoResume)?  ready,TResult Function( Failure failure,  String? message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Initializing() when initializing != null:
return initializing();case _Connecting() when connecting != null:
return connecting();case _Buffering() when buffering != null:
return buffering();case _Retrying() when retrying != null:
return retrying(_that.attempt,_that.reason);case _Ready() when ready != null:
return ready(_that.isPlaying,_that.currentUrl,_that.currentArtist,_that.currentTitle,_that.currentAlbumArtUrl,_that.isDucking,_that.canAutoResume);case _Error() when error != null:
return error(_that.failure,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  initializing,required TResult Function()  connecting,required TResult Function()  buffering,required TResult Function( int attempt,  String reason)  retrying,required TResult Function( bool isPlaying,  String? currentUrl,  String? currentArtist,  String? currentTitle,  String? currentAlbumArtUrl,  bool isDucking,  bool canAutoResume)  ready,required TResult Function( Failure failure,  String? message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Initializing():
return initializing();case _Connecting():
return connecting();case _Buffering():
return buffering();case _Retrying():
return retrying(_that.attempt,_that.reason);case _Ready():
return ready(_that.isPlaying,_that.currentUrl,_that.currentArtist,_that.currentTitle,_that.currentAlbumArtUrl,_that.isDucking,_that.canAutoResume);case _Error():
return error(_that.failure,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  initializing,TResult? Function()?  connecting,TResult? Function()?  buffering,TResult? Function( int attempt,  String reason)?  retrying,TResult? Function( bool isPlaying,  String? currentUrl,  String? currentArtist,  String? currentTitle,  String? currentAlbumArtUrl,  bool isDucking,  bool canAutoResume)?  ready,TResult? Function( Failure failure,  String? message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Initializing() when initializing != null:
return initializing();case _Connecting() when connecting != null:
return connecting();case _Buffering() when buffering != null:
return buffering();case _Retrying() when retrying != null:
return retrying(_that.attempt,_that.reason);case _Ready() when ready != null:
return ready(_that.isPlaying,_that.currentUrl,_that.currentArtist,_that.currentTitle,_that.currentAlbumArtUrl,_that.isDucking,_that.canAutoResume);case _Error() when error != null:
return error(_that.failure,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements RadioPlayerState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RadioPlayerState.initial()';
}


}




/// @nodoc


class _Initializing implements RadioPlayerState {
  const _Initializing();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initializing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RadioPlayerState.initializing()';
}


}




/// @nodoc


class _Connecting implements RadioPlayerState {
  const _Connecting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Connecting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RadioPlayerState.connecting()';
}


}




/// @nodoc


class _Buffering implements RadioPlayerState {
  const _Buffering();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Buffering);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RadioPlayerState.buffering()';
}


}




/// @nodoc


class _Retrying implements RadioPlayerState {
  const _Retrying({required this.attempt, required this.reason});
  

 final  int attempt;
 final  String reason;

/// Create a copy of RadioPlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RetryingCopyWith<_Retrying> get copyWith => __$RetryingCopyWithImpl<_Retrying>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Retrying&&(identical(other.attempt, attempt) || other.attempt == attempt)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,attempt,reason);

@override
String toString() {
  return 'RadioPlayerState.retrying(attempt: $attempt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$RetryingCopyWith<$Res> implements $RadioPlayerStateCopyWith<$Res> {
  factory _$RetryingCopyWith(_Retrying value, $Res Function(_Retrying) _then) = __$RetryingCopyWithImpl;
@useResult
$Res call({
 int attempt, String reason
});




}
/// @nodoc
class __$RetryingCopyWithImpl<$Res>
    implements _$RetryingCopyWith<$Res> {
  __$RetryingCopyWithImpl(this._self, this._then);

  final _Retrying _self;
  final $Res Function(_Retrying) _then;

/// Create a copy of RadioPlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? attempt = null,Object? reason = null,}) {
  return _then(_Retrying(
attempt: null == attempt ? _self.attempt : attempt // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Ready implements RadioPlayerState {
  const _Ready({required this.isPlaying, this.currentUrl, this.currentArtist, this.currentTitle, this.currentAlbumArtUrl, this.isDucking = false, this.canAutoResume = false});
  

 final  bool isPlaying;
 final  String? currentUrl;
 final  String? currentArtist;
 final  String? currentTitle;
 final  String? currentAlbumArtUrl;
@JsonKey() final  bool isDucking;
@JsonKey() final  bool canAutoResume;

/// Create a copy of RadioPlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadyCopyWith<_Ready> get copyWith => __$ReadyCopyWithImpl<_Ready>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ready&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.currentUrl, currentUrl) || other.currentUrl == currentUrl)&&(identical(other.currentArtist, currentArtist) || other.currentArtist == currentArtist)&&(identical(other.currentTitle, currentTitle) || other.currentTitle == currentTitle)&&(identical(other.currentAlbumArtUrl, currentAlbumArtUrl) || other.currentAlbumArtUrl == currentAlbumArtUrl)&&(identical(other.isDucking, isDucking) || other.isDucking == isDucking)&&(identical(other.canAutoResume, canAutoResume) || other.canAutoResume == canAutoResume));
}


@override
int get hashCode => Object.hash(runtimeType,isPlaying,currentUrl,currentArtist,currentTitle,currentAlbumArtUrl,isDucking,canAutoResume);

@override
String toString() {
  return 'RadioPlayerState.ready(isPlaying: $isPlaying, currentUrl: $currentUrl, currentArtist: $currentArtist, currentTitle: $currentTitle, currentAlbumArtUrl: $currentAlbumArtUrl, isDucking: $isDucking, canAutoResume: $canAutoResume)';
}


}

/// @nodoc
abstract mixin class _$ReadyCopyWith<$Res> implements $RadioPlayerStateCopyWith<$Res> {
  factory _$ReadyCopyWith(_Ready value, $Res Function(_Ready) _then) = __$ReadyCopyWithImpl;
@useResult
$Res call({
 bool isPlaying, String? currentUrl, String? currentArtist, String? currentTitle, String? currentAlbumArtUrl, bool isDucking, bool canAutoResume
});




}
/// @nodoc
class __$ReadyCopyWithImpl<$Res>
    implements _$ReadyCopyWith<$Res> {
  __$ReadyCopyWithImpl(this._self, this._then);

  final _Ready _self;
  final $Res Function(_Ready) _then;

/// Create a copy of RadioPlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isPlaying = null,Object? currentUrl = freezed,Object? currentArtist = freezed,Object? currentTitle = freezed,Object? currentAlbumArtUrl = freezed,Object? isDucking = null,Object? canAutoResume = null,}) {
  return _then(_Ready(
isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,currentUrl: freezed == currentUrl ? _self.currentUrl : currentUrl // ignore: cast_nullable_to_non_nullable
as String?,currentArtist: freezed == currentArtist ? _self.currentArtist : currentArtist // ignore: cast_nullable_to_non_nullable
as String?,currentTitle: freezed == currentTitle ? _self.currentTitle : currentTitle // ignore: cast_nullable_to_non_nullable
as String?,currentAlbumArtUrl: freezed == currentAlbumArtUrl ? _self.currentAlbumArtUrl : currentAlbumArtUrl // ignore: cast_nullable_to_non_nullable
as String?,isDucking: null == isDucking ? _self.isDucking : isDucking // ignore: cast_nullable_to_non_nullable
as bool,canAutoResume: null == canAutoResume ? _self.canAutoResume : canAutoResume // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _Error implements RadioPlayerState {
  const _Error({required this.failure, this.message});
  

 final  Failure failure;
 final  String? message;

/// Create a copy of RadioPlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,failure,message);

@override
String toString() {
  return 'RadioPlayerState.error(failure: $failure, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $RadioPlayerStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure, String? message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of RadioPlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? message = freezed,}) {
  return _then(_Error(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
