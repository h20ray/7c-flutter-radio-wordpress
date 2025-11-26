// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tamtama_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TamtamaEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TamtamaEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaEvent()';
}


}

/// @nodoc
class $TamtamaEventCopyWith<$Res>  {
$TamtamaEventCopyWith(TamtamaEvent _, $Res Function(TamtamaEvent) __);
}


/// Adds pattern-matching-related methods to [TamtamaEvent].
extension TamtamaEventPatterns on TamtamaEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadTamtamaEvent value)?  load,TResult Function( FeedPetEvent value)?  feedPet,TResult Function( PlayWithPetEvent value)?  playWithPet,TResult Function( TamtamaUpdatedEvent value)?  updated,TResult Function( TamtamaErrorEvent value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadTamtamaEvent() when load != null:
return load(_that);case FeedPetEvent() when feedPet != null:
return feedPet(_that);case PlayWithPetEvent() when playWithPet != null:
return playWithPet(_that);case TamtamaUpdatedEvent() when updated != null:
return updated(_that);case TamtamaErrorEvent() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadTamtamaEvent value)  load,required TResult Function( FeedPetEvent value)  feedPet,required TResult Function( PlayWithPetEvent value)  playWithPet,required TResult Function( TamtamaUpdatedEvent value)  updated,required TResult Function( TamtamaErrorEvent value)  error,}){
final _that = this;
switch (_that) {
case LoadTamtamaEvent():
return load(_that);case FeedPetEvent():
return feedPet(_that);case PlayWithPetEvent():
return playWithPet(_that);case TamtamaUpdatedEvent():
return updated(_that);case TamtamaErrorEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadTamtamaEvent value)?  load,TResult? Function( FeedPetEvent value)?  feedPet,TResult? Function( PlayWithPetEvent value)?  playWithPet,TResult? Function( TamtamaUpdatedEvent value)?  updated,TResult? Function( TamtamaErrorEvent value)?  error,}){
final _that = this;
switch (_that) {
case LoadTamtamaEvent() when load != null:
return load(_that);case FeedPetEvent() when feedPet != null:
return feedPet(_that);case PlayWithPetEvent() when playWithPet != null:
return playWithPet(_that);case TamtamaUpdatedEvent() when updated != null:
return updated(_that);case TamtamaErrorEvent() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  load,TResult Function()?  feedPet,TResult Function()?  playWithPet,TResult Function( TamtamaEntity tamtama)?  updated,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadTamtamaEvent() when load != null:
return load();case FeedPetEvent() when feedPet != null:
return feedPet();case PlayWithPetEvent() when playWithPet != null:
return playWithPet();case TamtamaUpdatedEvent() when updated != null:
return updated(_that.tamtama);case TamtamaErrorEvent() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  load,required TResult Function()  feedPet,required TResult Function()  playWithPet,required TResult Function( TamtamaEntity tamtama)  updated,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case LoadTamtamaEvent():
return load();case FeedPetEvent():
return feedPet();case PlayWithPetEvent():
return playWithPet();case TamtamaUpdatedEvent():
return updated(_that.tamtama);case TamtamaErrorEvent():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  load,TResult? Function()?  feedPet,TResult? Function()?  playWithPet,TResult? Function( TamtamaEntity tamtama)?  updated,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case LoadTamtamaEvent() when load != null:
return load();case FeedPetEvent() when feedPet != null:
return feedPet();case PlayWithPetEvent() when playWithPet != null:
return playWithPet();case TamtamaUpdatedEvent() when updated != null:
return updated(_that.tamtama);case TamtamaErrorEvent() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class LoadTamtamaEvent implements TamtamaEvent {
  const LoadTamtamaEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadTamtamaEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaEvent.load()';
}


}




/// @nodoc


class FeedPetEvent implements TamtamaEvent {
  const FeedPetEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedPetEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaEvent.feedPet()';
}


}




/// @nodoc


class PlayWithPetEvent implements TamtamaEvent {
  const PlayWithPetEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayWithPetEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaEvent.playWithPet()';
}


}




/// @nodoc


class TamtamaUpdatedEvent implements TamtamaEvent {
  const TamtamaUpdatedEvent(this.tamtama);
  

 final  TamtamaEntity tamtama;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TamtamaUpdatedEventCopyWith<TamtamaUpdatedEvent> get copyWith => _$TamtamaUpdatedEventCopyWithImpl<TamtamaUpdatedEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TamtamaUpdatedEvent&&(identical(other.tamtama, tamtama) || other.tamtama == tamtama));
}


@override
int get hashCode => Object.hash(runtimeType,tamtama);

@override
String toString() {
  return 'TamtamaEvent.updated(tamtama: $tamtama)';
}


}

/// @nodoc
abstract mixin class $TamtamaUpdatedEventCopyWith<$Res> implements $TamtamaEventCopyWith<$Res> {
  factory $TamtamaUpdatedEventCopyWith(TamtamaUpdatedEvent value, $Res Function(TamtamaUpdatedEvent) _then) = _$TamtamaUpdatedEventCopyWithImpl;
@useResult
$Res call({
 TamtamaEntity tamtama
});




}
/// @nodoc
class _$TamtamaUpdatedEventCopyWithImpl<$Res>
    implements $TamtamaUpdatedEventCopyWith<$Res> {
  _$TamtamaUpdatedEventCopyWithImpl(this._self, this._then);

  final TamtamaUpdatedEvent _self;
  final $Res Function(TamtamaUpdatedEvent) _then;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tamtama = null,}) {
  return _then(TamtamaUpdatedEvent(
null == tamtama ? _self.tamtama : tamtama // ignore: cast_nullable_to_non_nullable
as TamtamaEntity,
  ));
}


}

/// @nodoc


class TamtamaErrorEvent implements TamtamaEvent {
  const TamtamaErrorEvent(this.message);
  

 final  String message;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TamtamaErrorEventCopyWith<TamtamaErrorEvent> get copyWith => _$TamtamaErrorEventCopyWithImpl<TamtamaErrorEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TamtamaErrorEvent&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TamtamaEvent.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $TamtamaErrorEventCopyWith<$Res> implements $TamtamaEventCopyWith<$Res> {
  factory $TamtamaErrorEventCopyWith(TamtamaErrorEvent value, $Res Function(TamtamaErrorEvent) _then) = _$TamtamaErrorEventCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TamtamaErrorEventCopyWithImpl<$Res>
    implements $TamtamaErrorEventCopyWith<$Res> {
  _$TamtamaErrorEventCopyWithImpl(this._self, this._then);

  final TamtamaErrorEvent _self;
  final $Res Function(TamtamaErrorEvent) _then;

/// Create a copy of TamtamaEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TamtamaErrorEvent(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$TamtamaState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TamtamaState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaState()';
}


}

/// @nodoc
class $TamtamaStateCopyWith<$Res>  {
$TamtamaStateCopyWith(TamtamaState _, $Res Function(TamtamaState) __);
}


/// Adds pattern-matching-related methods to [TamtamaState].
extension TamtamaStatePatterns on TamtamaState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( TamtamaEntity tamtama)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.tamtama);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( TamtamaEntity tamtama)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.tamtama);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( TamtamaEntity tamtama)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.tamtama);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements TamtamaState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaState.initial()';
}


}




/// @nodoc


class _Loading implements TamtamaState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TamtamaState.loading()';
}


}




/// @nodoc


class _Loaded implements TamtamaState {
  const _Loaded(this.tamtama);
  

 final  TamtamaEntity tamtama;

/// Create a copy of TamtamaState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.tamtama, tamtama) || other.tamtama == tamtama));
}


@override
int get hashCode => Object.hash(runtimeType,tamtama);

@override
String toString() {
  return 'TamtamaState.loaded(tamtama: $tamtama)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $TamtamaStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 TamtamaEntity tamtama
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of TamtamaState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tamtama = null,}) {
  return _then(_Loaded(
null == tamtama ? _self.tamtama : tamtama // ignore: cast_nullable_to_non_nullable
as TamtamaEntity,
  ));
}


}

/// @nodoc


class _Error implements TamtamaState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of TamtamaState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TamtamaState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $TamtamaStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of TamtamaState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
