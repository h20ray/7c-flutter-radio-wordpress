// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RequestEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RequestEvent()';
}


}

/// @nodoc
class $RequestEventCopyWith<$Res>  {
$RequestEventCopyWith(RequestEvent _, $Res Function(RequestEvent) __);
}


/// Adds pattern-matching-related methods to [RequestEvent].
extension RequestEventPatterns on RequestEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadTracksEvent value)?  loadTracks,TResult Function( SubmitRequestEvent value)?  submit,TResult Function( ResetRequestEvent value)?  reset,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadTracksEvent() when loadTracks != null:
return loadTracks(_that);case SubmitRequestEvent() when submit != null:
return submit(_that);case ResetRequestEvent() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadTracksEvent value)  loadTracks,required TResult Function( SubmitRequestEvent value)  submit,required TResult Function( ResetRequestEvent value)  reset,}){
final _that = this;
switch (_that) {
case LoadTracksEvent():
return loadTracks(_that);case SubmitRequestEvent():
return submit(_that);case ResetRequestEvent():
return reset(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadTracksEvent value)?  loadTracks,TResult? Function( SubmitRequestEvent value)?  submit,TResult? Function( ResetRequestEvent value)?  reset,}){
final _that = this;
switch (_that) {
case LoadTracksEvent() when loadTracks != null:
return loadTracks(_that);case SubmitRequestEvent() when submit != null:
return submit(_that);case ResetRequestEvent() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String streamUrl,  String? query,  int page,  int limit,  bool random)?  loadTracks,TResult Function( String streamUrl,  String requestId,  String? title,  String? artist)?  submit,TResult Function()?  reset,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadTracksEvent() when loadTracks != null:
return loadTracks(_that.streamUrl,_that.query,_that.page,_that.limit,_that.random);case SubmitRequestEvent() when submit != null:
return submit(_that.streamUrl,_that.requestId,_that.title,_that.artist);case ResetRequestEvent() when reset != null:
return reset();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String streamUrl,  String? query,  int page,  int limit,  bool random)  loadTracks,required TResult Function( String streamUrl,  String requestId,  String? title,  String? artist)  submit,required TResult Function()  reset,}) {final _that = this;
switch (_that) {
case LoadTracksEvent():
return loadTracks(_that.streamUrl,_that.query,_that.page,_that.limit,_that.random);case SubmitRequestEvent():
return submit(_that.streamUrl,_that.requestId,_that.title,_that.artist);case ResetRequestEvent():
return reset();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String streamUrl,  String? query,  int page,  int limit,  bool random)?  loadTracks,TResult? Function( String streamUrl,  String requestId,  String? title,  String? artist)?  submit,TResult? Function()?  reset,}) {final _that = this;
switch (_that) {
case LoadTracksEvent() when loadTracks != null:
return loadTracks(_that.streamUrl,_that.query,_that.page,_that.limit,_that.random);case SubmitRequestEvent() when submit != null:
return submit(_that.streamUrl,_that.requestId,_that.title,_that.artist);case ResetRequestEvent() when reset != null:
return reset();case _:
  return null;

}
}

}

/// @nodoc


class LoadTracksEvent implements RequestEvent {
  const LoadTracksEvent({required this.streamUrl, this.query, this.page = 1, this.limit = 20, this.random = false});
  

 final  String streamUrl;
 final  String? query;
@JsonKey() final  int page;
@JsonKey() final  int limit;
@JsonKey() final  bool random;

/// Create a copy of RequestEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadTracksEventCopyWith<LoadTracksEvent> get copyWith => _$LoadTracksEventCopyWithImpl<LoadTracksEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadTracksEvent&&(identical(other.streamUrl, streamUrl) || other.streamUrl == streamUrl)&&(identical(other.query, query) || other.query == query)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.random, random) || other.random == random));
}


@override
int get hashCode => Object.hash(runtimeType,streamUrl,query,page,limit,random);

@override
String toString() {
  return 'RequestEvent.loadTracks(streamUrl: $streamUrl, query: $query, page: $page, limit: $limit, random: $random)';
}


}

/// @nodoc
abstract mixin class $LoadTracksEventCopyWith<$Res> implements $RequestEventCopyWith<$Res> {
  factory $LoadTracksEventCopyWith(LoadTracksEvent value, $Res Function(LoadTracksEvent) _then) = _$LoadTracksEventCopyWithImpl;
@useResult
$Res call({
 String streamUrl, String? query, int page, int limit, bool random
});




}
/// @nodoc
class _$LoadTracksEventCopyWithImpl<$Res>
    implements $LoadTracksEventCopyWith<$Res> {
  _$LoadTracksEventCopyWithImpl(this._self, this._then);

  final LoadTracksEvent _self;
  final $Res Function(LoadTracksEvent) _then;

/// Create a copy of RequestEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? streamUrl = null,Object? query = freezed,Object? page = null,Object? limit = null,Object? random = null,}) {
  return _then(LoadTracksEvent(
streamUrl: null == streamUrl ? _self.streamUrl : streamUrl // ignore: cast_nullable_to_non_nullable
as String,query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String?,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,random: null == random ? _self.random : random // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SubmitRequestEvent implements RequestEvent {
  const SubmitRequestEvent({required this.streamUrl, required this.requestId, this.title, this.artist});
  

 final  String streamUrl;
 final  String requestId;
 final  String? title;
 final  String? artist;

/// Create a copy of RequestEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmitRequestEventCopyWith<SubmitRequestEvent> get copyWith => _$SubmitRequestEventCopyWithImpl<SubmitRequestEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitRequestEvent&&(identical(other.streamUrl, streamUrl) || other.streamUrl == streamUrl)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.title, title) || other.title == title)&&(identical(other.artist, artist) || other.artist == artist));
}


@override
int get hashCode => Object.hash(runtimeType,streamUrl,requestId,title,artist);

@override
String toString() {
  return 'RequestEvent.submit(streamUrl: $streamUrl, requestId: $requestId, title: $title, artist: $artist)';
}


}

/// @nodoc
abstract mixin class $SubmitRequestEventCopyWith<$Res> implements $RequestEventCopyWith<$Res> {
  factory $SubmitRequestEventCopyWith(SubmitRequestEvent value, $Res Function(SubmitRequestEvent) _then) = _$SubmitRequestEventCopyWithImpl;
@useResult
$Res call({
 String streamUrl, String requestId, String? title, String? artist
});




}
/// @nodoc
class _$SubmitRequestEventCopyWithImpl<$Res>
    implements $SubmitRequestEventCopyWith<$Res> {
  _$SubmitRequestEventCopyWithImpl(this._self, this._then);

  final SubmitRequestEvent _self;
  final $Res Function(SubmitRequestEvent) _then;

/// Create a copy of RequestEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? streamUrl = null,Object? requestId = null,Object? title = freezed,Object? artist = freezed,}) {
  return _then(SubmitRequestEvent(
streamUrl: null == streamUrl ? _self.streamUrl : streamUrl // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ResetRequestEvent implements RequestEvent {
  const ResetRequestEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetRequestEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RequestEvent.reset()';
}


}




/// @nodoc
mixin _$RequestState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RequestState()';
}


}

/// @nodoc
class $RequestStateCopyWith<$Res>  {
$RequestStateCopyWith(RequestState _, $Res Function(RequestState) __);
}


/// Adds pattern-matching-related methods to [RequestState].
extension RequestStatePatterns on RequestState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Success value)?  success,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Success value)  success,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Success():
return success(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Success value)?  success,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<RequestableTrackEntity> tracks,  int page,  bool hasMore)?  loaded,TResult Function()?  success,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.tracks,_that.page,_that.hasMore);case _Success() when success != null:
return success();case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<RequestableTrackEntity> tracks,  int page,  bool hasMore)  loaded,required TResult Function()  success,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.tracks,_that.page,_that.hasMore);case _Success():
return success();case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<RequestableTrackEntity> tracks,  int page,  bool hasMore)?  loaded,TResult? Function()?  success,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.tracks,_that.page,_that.hasMore);case _Success() when success != null:
return success();case _Error() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements RequestState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RequestState.initial()';
}


}




/// @nodoc


class _Loading implements RequestState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RequestState.loading()';
}


}




/// @nodoc


class _Loaded implements RequestState {
  const _Loaded({required final  List<RequestableTrackEntity> tracks, required this.page, required this.hasMore}): _tracks = tracks;
  

 final  List<RequestableTrackEntity> _tracks;
 List<RequestableTrackEntity> get tracks {
  if (_tracks is EqualUnmodifiableListView) return _tracks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tracks);
}

 final  int page;
 final  bool hasMore;

/// Create a copy of RequestState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._tracks, _tracks)&&(identical(other.page, page) || other.page == page)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_tracks),page,hasMore);

@override
String toString() {
  return 'RequestState.loaded(tracks: $tracks, page: $page, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $RequestStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<RequestableTrackEntity> tracks, int page, bool hasMore
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of RequestState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tracks = null,Object? page = null,Object? hasMore = null,}) {
  return _then(_Loaded(
tracks: null == tracks ? _self._tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<RequestableTrackEntity>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _Success implements RequestState {
  const _Success();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RequestState.success()';
}


}




/// @nodoc


class _Error implements RequestState {
  const _Error(this.failure);
  

 final  Failure failure;

/// Create a copy of RequestState
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
  return 'RequestState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $RequestStateCopyWith<$Res> {
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

/// Create a copy of RequestState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(_Error(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
