// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gamification_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GamificationEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GamificationEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GamificationEvent()';
}


}

/// @nodoc
class $GamificationEventCopyWith<$Res>  {
$GamificationEventCopyWith(GamificationEvent _, $Res Function(GamificationEvent) __);
}


/// Adds pattern-matching-related methods to [GamificationEvent].
extension GamificationEventPatterns on GamificationEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _StatsUpdated value)?  statsUpdated,TResult Function( _StatsFailed value)?  statsFailed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _StatsUpdated() when statsUpdated != null:
return statsUpdated(_that);case _StatsFailed() when statsFailed != null:
return statsFailed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _StatsUpdated value)  statsUpdated,required TResult Function( _StatsFailed value)  statsFailed,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _StatsUpdated():
return statsUpdated(_that);case _StatsFailed():
return statsFailed(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _StatsUpdated value)?  statsUpdated,TResult? Function( _StatsFailed value)?  statsFailed,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _StatsUpdated() when statsUpdated != null:
return statsUpdated(_that);case _StatsFailed() when statsFailed != null:
return statsFailed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( UserListeningStatsEntity stats)?  statsUpdated,TResult Function( Failure failure)?  statsFailed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _StatsUpdated() when statsUpdated != null:
return statsUpdated(_that.stats);case _StatsFailed() when statsFailed != null:
return statsFailed(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( UserListeningStatsEntity stats)  statsUpdated,required TResult Function( Failure failure)  statsFailed,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _StatsUpdated():
return statsUpdated(_that.stats);case _StatsFailed():
return statsFailed(_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( UserListeningStatsEntity stats)?  statsUpdated,TResult? Function( Failure failure)?  statsFailed,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _StatsUpdated() when statsUpdated != null:
return statsUpdated(_that.stats);case _StatsFailed() when statsFailed != null:
return statsFailed(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements GamificationEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GamificationEvent.started()';
}


}




/// @nodoc


class _StatsUpdated implements GamificationEvent {
  const _StatsUpdated(this.stats);
  

 final  UserListeningStatsEntity stats;

/// Create a copy of GamificationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatsUpdatedCopyWith<_StatsUpdated> get copyWith => __$StatsUpdatedCopyWithImpl<_StatsUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatsUpdated&&(identical(other.stats, stats) || other.stats == stats));
}


@override
int get hashCode => Object.hash(runtimeType,stats);

@override
String toString() {
  return 'GamificationEvent.statsUpdated(stats: $stats)';
}


}

/// @nodoc
abstract mixin class _$StatsUpdatedCopyWith<$Res> implements $GamificationEventCopyWith<$Res> {
  factory _$StatsUpdatedCopyWith(_StatsUpdated value, $Res Function(_StatsUpdated) _then) = __$StatsUpdatedCopyWithImpl;
@useResult
$Res call({
 UserListeningStatsEntity stats
});




}
/// @nodoc
class __$StatsUpdatedCopyWithImpl<$Res>
    implements _$StatsUpdatedCopyWith<$Res> {
  __$StatsUpdatedCopyWithImpl(this._self, this._then);

  final _StatsUpdated _self;
  final $Res Function(_StatsUpdated) _then;

/// Create a copy of GamificationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? stats = null,}) {
  return _then(_StatsUpdated(
null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as UserListeningStatsEntity,
  ));
}


}

/// @nodoc


class _StatsFailed implements GamificationEvent {
  const _StatsFailed(this.failure);
  

 final  Failure failure;

/// Create a copy of GamificationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatsFailedCopyWith<_StatsFailed> get copyWith => __$StatsFailedCopyWithImpl<_StatsFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatsFailed&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'GamificationEvent.statsFailed(failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$StatsFailedCopyWith<$Res> implements $GamificationEventCopyWith<$Res> {
  factory _$StatsFailedCopyWith(_StatsFailed value, $Res Function(_StatsFailed) _then) = __$StatsFailedCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class __$StatsFailedCopyWithImpl<$Res>
    implements _$StatsFailedCopyWith<$Res> {
  __$StatsFailedCopyWithImpl(this._self, this._then);

  final _StatsFailed _self;
  final $Res Function(_StatsFailed) _then;

/// Create a copy of GamificationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(_StatsFailed(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

/// @nodoc
mixin _$GamificationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GamificationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GamificationState()';
}


}

/// @nodoc
class $GamificationStateCopyWith<$Res>  {
$GamificationStateCopyWith(GamificationState _, $Res Function(GamificationState) __);
}


/// Adds pattern-matching-related methods to [GamificationState].
extension GamificationStatePatterns on GamificationState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( GamificationStatusViewData data)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.data);case _Error() when error != null:
return error(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( GamificationStatusViewData data)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.data);case _Error():
return error(_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( GamificationStatusViewData data)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.data);case _Error() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements GamificationState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GamificationState.initial()';
}


}




/// @nodoc


class _Loading implements GamificationState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GamificationState.loading()';
}


}




/// @nodoc


class _Loaded implements GamificationState {
  const _Loaded(this.data);
  

 final  GamificationStatusViewData data;

/// Create a copy of GamificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'GamificationState.loaded(data: $data)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $GamificationStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 GamificationStatusViewData data
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of GamificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_Loaded(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as GamificationStatusViewData,
  ));
}


}

/// @nodoc


class _Error implements GamificationState {
  const _Error(this.failure);
  

 final  Failure failure;

/// Create a copy of GamificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'GamificationState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $GamificationStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of GamificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(_Error(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
