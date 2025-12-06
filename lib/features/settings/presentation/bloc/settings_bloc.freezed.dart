// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsEvent()';
}


}

/// @nodoc
class $SettingsEventCopyWith<$Res>  {
$SettingsEventCopyWith(SettingsEvent _, $Res Function(SettingsEvent) __);
}


/// Adds pattern-matching-related methods to [SettingsEvent].
extension SettingsEventPatterns on SettingsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadOfflineNewsSettingsEvent value)?  loadOfflineNewsSettings,TResult Function( UpdateMaxPostsEvent value)?  updateMaxPosts,TResult Function( UpdateMaxSizeMBEvent value)?  updateMaxSizeMB,TResult Function( ToggleAutoSaveEvent value)?  toggleAutoSave,TResult Function( LoadOfflineNewsStatsEvent value)?  loadOfflineNewsStats,TResult Function( ClearAllOfflinePostsEvent value)?  clearAllOfflinePosts,TResult Function( SaveSettingsEvent value)?  saveSettings,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadOfflineNewsSettingsEvent() when loadOfflineNewsSettings != null:
return loadOfflineNewsSettings(_that);case UpdateMaxPostsEvent() when updateMaxPosts != null:
return updateMaxPosts(_that);case UpdateMaxSizeMBEvent() when updateMaxSizeMB != null:
return updateMaxSizeMB(_that);case ToggleAutoSaveEvent() when toggleAutoSave != null:
return toggleAutoSave(_that);case LoadOfflineNewsStatsEvent() when loadOfflineNewsStats != null:
return loadOfflineNewsStats(_that);case ClearAllOfflinePostsEvent() when clearAllOfflinePosts != null:
return clearAllOfflinePosts(_that);case SaveSettingsEvent() when saveSettings != null:
return saveSettings(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadOfflineNewsSettingsEvent value)  loadOfflineNewsSettings,required TResult Function( UpdateMaxPostsEvent value)  updateMaxPosts,required TResult Function( UpdateMaxSizeMBEvent value)  updateMaxSizeMB,required TResult Function( ToggleAutoSaveEvent value)  toggleAutoSave,required TResult Function( LoadOfflineNewsStatsEvent value)  loadOfflineNewsStats,required TResult Function( ClearAllOfflinePostsEvent value)  clearAllOfflinePosts,required TResult Function( SaveSettingsEvent value)  saveSettings,}){
final _that = this;
switch (_that) {
case LoadOfflineNewsSettingsEvent():
return loadOfflineNewsSettings(_that);case UpdateMaxPostsEvent():
return updateMaxPosts(_that);case UpdateMaxSizeMBEvent():
return updateMaxSizeMB(_that);case ToggleAutoSaveEvent():
return toggleAutoSave(_that);case LoadOfflineNewsStatsEvent():
return loadOfflineNewsStats(_that);case ClearAllOfflinePostsEvent():
return clearAllOfflinePosts(_that);case SaveSettingsEvent():
return saveSettings(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadOfflineNewsSettingsEvent value)?  loadOfflineNewsSettings,TResult? Function( UpdateMaxPostsEvent value)?  updateMaxPosts,TResult? Function( UpdateMaxSizeMBEvent value)?  updateMaxSizeMB,TResult? Function( ToggleAutoSaveEvent value)?  toggleAutoSave,TResult? Function( LoadOfflineNewsStatsEvent value)?  loadOfflineNewsStats,TResult? Function( ClearAllOfflinePostsEvent value)?  clearAllOfflinePosts,TResult? Function( SaveSettingsEvent value)?  saveSettings,}){
final _that = this;
switch (_that) {
case LoadOfflineNewsSettingsEvent() when loadOfflineNewsSettings != null:
return loadOfflineNewsSettings(_that);case UpdateMaxPostsEvent() when updateMaxPosts != null:
return updateMaxPosts(_that);case UpdateMaxSizeMBEvent() when updateMaxSizeMB != null:
return updateMaxSizeMB(_that);case ToggleAutoSaveEvent() when toggleAutoSave != null:
return toggleAutoSave(_that);case LoadOfflineNewsStatsEvent() when loadOfflineNewsStats != null:
return loadOfflineNewsStats(_that);case ClearAllOfflinePostsEvent() when clearAllOfflinePosts != null:
return clearAllOfflinePosts(_that);case SaveSettingsEvent() when saveSettings != null:
return saveSettings(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadOfflineNewsSettings,TResult Function( int maxPosts)?  updateMaxPosts,TResult Function( int maxSizeMB)?  updateMaxSizeMB,TResult Function( bool enabled)?  toggleAutoSave,TResult Function()?  loadOfflineNewsStats,TResult Function()?  clearAllOfflinePosts,TResult Function()?  saveSettings,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadOfflineNewsSettingsEvent() when loadOfflineNewsSettings != null:
return loadOfflineNewsSettings();case UpdateMaxPostsEvent() when updateMaxPosts != null:
return updateMaxPosts(_that.maxPosts);case UpdateMaxSizeMBEvent() when updateMaxSizeMB != null:
return updateMaxSizeMB(_that.maxSizeMB);case ToggleAutoSaveEvent() when toggleAutoSave != null:
return toggleAutoSave(_that.enabled);case LoadOfflineNewsStatsEvent() when loadOfflineNewsStats != null:
return loadOfflineNewsStats();case ClearAllOfflinePostsEvent() when clearAllOfflinePosts != null:
return clearAllOfflinePosts();case SaveSettingsEvent() when saveSettings != null:
return saveSettings();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadOfflineNewsSettings,required TResult Function( int maxPosts)  updateMaxPosts,required TResult Function( int maxSizeMB)  updateMaxSizeMB,required TResult Function( bool enabled)  toggleAutoSave,required TResult Function()  loadOfflineNewsStats,required TResult Function()  clearAllOfflinePosts,required TResult Function()  saveSettings,}) {final _that = this;
switch (_that) {
case LoadOfflineNewsSettingsEvent():
return loadOfflineNewsSettings();case UpdateMaxPostsEvent():
return updateMaxPosts(_that.maxPosts);case UpdateMaxSizeMBEvent():
return updateMaxSizeMB(_that.maxSizeMB);case ToggleAutoSaveEvent():
return toggleAutoSave(_that.enabled);case LoadOfflineNewsStatsEvent():
return loadOfflineNewsStats();case ClearAllOfflinePostsEvent():
return clearAllOfflinePosts();case SaveSettingsEvent():
return saveSettings();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadOfflineNewsSettings,TResult? Function( int maxPosts)?  updateMaxPosts,TResult? Function( int maxSizeMB)?  updateMaxSizeMB,TResult? Function( bool enabled)?  toggleAutoSave,TResult? Function()?  loadOfflineNewsStats,TResult? Function()?  clearAllOfflinePosts,TResult? Function()?  saveSettings,}) {final _that = this;
switch (_that) {
case LoadOfflineNewsSettingsEvent() when loadOfflineNewsSettings != null:
return loadOfflineNewsSettings();case UpdateMaxPostsEvent() when updateMaxPosts != null:
return updateMaxPosts(_that.maxPosts);case UpdateMaxSizeMBEvent() when updateMaxSizeMB != null:
return updateMaxSizeMB(_that.maxSizeMB);case ToggleAutoSaveEvent() when toggleAutoSave != null:
return toggleAutoSave(_that.enabled);case LoadOfflineNewsStatsEvent() when loadOfflineNewsStats != null:
return loadOfflineNewsStats();case ClearAllOfflinePostsEvent() when clearAllOfflinePosts != null:
return clearAllOfflinePosts();case SaveSettingsEvent() when saveSettings != null:
return saveSettings();case _:
  return null;

}
}

}

/// @nodoc


class LoadOfflineNewsSettingsEvent implements SettingsEvent {
  const LoadOfflineNewsSettingsEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadOfflineNewsSettingsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsEvent.loadOfflineNewsSettings()';
}


}




/// @nodoc


class UpdateMaxPostsEvent implements SettingsEvent {
  const UpdateMaxPostsEvent(this.maxPosts);
  

 final  int maxPosts;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateMaxPostsEventCopyWith<UpdateMaxPostsEvent> get copyWith => _$UpdateMaxPostsEventCopyWithImpl<UpdateMaxPostsEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateMaxPostsEvent&&(identical(other.maxPosts, maxPosts) || other.maxPosts == maxPosts));
}


@override
int get hashCode => Object.hash(runtimeType,maxPosts);

@override
String toString() {
  return 'SettingsEvent.updateMaxPosts(maxPosts: $maxPosts)';
}


}

/// @nodoc
abstract mixin class $UpdateMaxPostsEventCopyWith<$Res> implements $SettingsEventCopyWith<$Res> {
  factory $UpdateMaxPostsEventCopyWith(UpdateMaxPostsEvent value, $Res Function(UpdateMaxPostsEvent) _then) = _$UpdateMaxPostsEventCopyWithImpl;
@useResult
$Res call({
 int maxPosts
});




}
/// @nodoc
class _$UpdateMaxPostsEventCopyWithImpl<$Res>
    implements $UpdateMaxPostsEventCopyWith<$Res> {
  _$UpdateMaxPostsEventCopyWithImpl(this._self, this._then);

  final UpdateMaxPostsEvent _self;
  final $Res Function(UpdateMaxPostsEvent) _then;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? maxPosts = null,}) {
  return _then(UpdateMaxPostsEvent(
null == maxPosts ? _self.maxPosts : maxPosts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class UpdateMaxSizeMBEvent implements SettingsEvent {
  const UpdateMaxSizeMBEvent(this.maxSizeMB);
  

 final  int maxSizeMB;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateMaxSizeMBEventCopyWith<UpdateMaxSizeMBEvent> get copyWith => _$UpdateMaxSizeMBEventCopyWithImpl<UpdateMaxSizeMBEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateMaxSizeMBEvent&&(identical(other.maxSizeMB, maxSizeMB) || other.maxSizeMB == maxSizeMB));
}


@override
int get hashCode => Object.hash(runtimeType,maxSizeMB);

@override
String toString() {
  return 'SettingsEvent.updateMaxSizeMB(maxSizeMB: $maxSizeMB)';
}


}

/// @nodoc
abstract mixin class $UpdateMaxSizeMBEventCopyWith<$Res> implements $SettingsEventCopyWith<$Res> {
  factory $UpdateMaxSizeMBEventCopyWith(UpdateMaxSizeMBEvent value, $Res Function(UpdateMaxSizeMBEvent) _then) = _$UpdateMaxSizeMBEventCopyWithImpl;
@useResult
$Res call({
 int maxSizeMB
});




}
/// @nodoc
class _$UpdateMaxSizeMBEventCopyWithImpl<$Res>
    implements $UpdateMaxSizeMBEventCopyWith<$Res> {
  _$UpdateMaxSizeMBEventCopyWithImpl(this._self, this._then);

  final UpdateMaxSizeMBEvent _self;
  final $Res Function(UpdateMaxSizeMBEvent) _then;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? maxSizeMB = null,}) {
  return _then(UpdateMaxSizeMBEvent(
null == maxSizeMB ? _self.maxSizeMB : maxSizeMB // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ToggleAutoSaveEvent implements SettingsEvent {
  const ToggleAutoSaveEvent(this.enabled);
  

 final  bool enabled;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToggleAutoSaveEventCopyWith<ToggleAutoSaveEvent> get copyWith => _$ToggleAutoSaveEventCopyWithImpl<ToggleAutoSaveEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleAutoSaveEvent&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,enabled);

@override
String toString() {
  return 'SettingsEvent.toggleAutoSave(enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $ToggleAutoSaveEventCopyWith<$Res> implements $SettingsEventCopyWith<$Res> {
  factory $ToggleAutoSaveEventCopyWith(ToggleAutoSaveEvent value, $Res Function(ToggleAutoSaveEvent) _then) = _$ToggleAutoSaveEventCopyWithImpl;
@useResult
$Res call({
 bool enabled
});




}
/// @nodoc
class _$ToggleAutoSaveEventCopyWithImpl<$Res>
    implements $ToggleAutoSaveEventCopyWith<$Res> {
  _$ToggleAutoSaveEventCopyWithImpl(this._self, this._then);

  final ToggleAutoSaveEvent _self;
  final $Res Function(ToggleAutoSaveEvent) _then;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enabled = null,}) {
  return _then(ToggleAutoSaveEvent(
null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class LoadOfflineNewsStatsEvent implements SettingsEvent {
  const LoadOfflineNewsStatsEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadOfflineNewsStatsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsEvent.loadOfflineNewsStats()';
}


}




/// @nodoc


class ClearAllOfflinePostsEvent implements SettingsEvent {
  const ClearAllOfflinePostsEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearAllOfflinePostsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsEvent.clearAllOfflinePosts()';
}


}




/// @nodoc


class SaveSettingsEvent implements SettingsEvent {
  const SaveSettingsEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveSettingsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsEvent.saveSettings()';
}


}




/// @nodoc
mixin _$SettingsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsState()';
}


}

/// @nodoc
class $SettingsStateCopyWith<$Res>  {
$SettingsStateCopyWith(SettingsState _, $Res Function(SettingsState) __);
}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( OfflineNewsSettingsEntity settings,  OfflineNewsStats? stats,  bool isSaving,  Failure? error)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.settings,_that.stats,_that.isSaving,_that.error);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( OfflineNewsSettingsEntity settings,  OfflineNewsStats? stats,  bool isSaving,  Failure? error)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.settings,_that.stats,_that.isSaving,_that.error);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( OfflineNewsSettingsEntity settings,  OfflineNewsStats? stats,  bool isSaving,  Failure? error)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.settings,_that.stats,_that.isSaving,_that.error);case _Error() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements SettingsState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsState.initial()';
}


}




/// @nodoc


class _Loading implements SettingsState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsState.loading()';
}


}




/// @nodoc


class _Loaded implements SettingsState {
  const _Loaded({required this.settings, required this.stats, this.isSaving = false, this.error});
  

 final  OfflineNewsSettingsEntity settings;
 final  OfflineNewsStats? stats;
@JsonKey() final  bool isSaving;
 final  Failure? error;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,settings,stats,isSaving,error);

@override
String toString() {
  return 'SettingsState.loaded(settings: $settings, stats: $stats, isSaving: $isSaving, error: $error)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 OfflineNewsSettingsEntity settings, OfflineNewsStats? stats, bool isSaving, Failure? error
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? settings = null,Object? stats = freezed,Object? isSaving = null,Object? error = freezed,}) {
  return _then(_Loaded(
settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as OfflineNewsSettingsEntity,stats: freezed == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as OfflineNewsStats?,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

/// @nodoc


class _Error implements SettingsState {
  const _Error({required this.failure});
  

 final  Failure failure;

/// Create a copy of SettingsState
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
  return 'SettingsState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
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

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(_Error(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
