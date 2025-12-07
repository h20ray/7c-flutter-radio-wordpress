// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_feed_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NewsFeedEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsFeedEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewsFeedEvent()';
}


}

/// @nodoc
class $NewsFeedEventCopyWith<$Res>  {
$NewsFeedEventCopyWith(NewsFeedEvent _, $Res Function(NewsFeedEvent) __);
}


/// Adds pattern-matching-related methods to [NewsFeedEvent].
extension NewsFeedEventPatterns on NewsFeedEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GetPostsEvent value)?  getPosts,TResult Function( LoadMorePostsEvent value)?  loadMorePosts,TResult Function( LoadCachedDataEvent value)?  loadCachedData,TResult Function( SavePostOfflineEvent value)?  savePostOffline,TResult Function( RemovePostOfflineEvent value)?  removePostOffline,TResult Function( CheckPostOfflineStatusEvent value)?  checkPostOfflineStatus,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GetPostsEvent() when getPosts != null:
return getPosts(_that);case LoadMorePostsEvent() when loadMorePosts != null:
return loadMorePosts(_that);case LoadCachedDataEvent() when loadCachedData != null:
return loadCachedData(_that);case SavePostOfflineEvent() when savePostOffline != null:
return savePostOffline(_that);case RemovePostOfflineEvent() when removePostOffline != null:
return removePostOffline(_that);case CheckPostOfflineStatusEvent() when checkPostOfflineStatus != null:
return checkPostOfflineStatus(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GetPostsEvent value)  getPosts,required TResult Function( LoadMorePostsEvent value)  loadMorePosts,required TResult Function( LoadCachedDataEvent value)  loadCachedData,required TResult Function( SavePostOfflineEvent value)  savePostOffline,required TResult Function( RemovePostOfflineEvent value)  removePostOffline,required TResult Function( CheckPostOfflineStatusEvent value)  checkPostOfflineStatus,}){
final _that = this;
switch (_that) {
case GetPostsEvent():
return getPosts(_that);case LoadMorePostsEvent():
return loadMorePosts(_that);case LoadCachedDataEvent():
return loadCachedData(_that);case SavePostOfflineEvent():
return savePostOffline(_that);case RemovePostOfflineEvent():
return removePostOffline(_that);case CheckPostOfflineStatusEvent():
return checkPostOfflineStatus(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GetPostsEvent value)?  getPosts,TResult? Function( LoadMorePostsEvent value)?  loadMorePosts,TResult? Function( LoadCachedDataEvent value)?  loadCachedData,TResult? Function( SavePostOfflineEvent value)?  savePostOffline,TResult? Function( RemovePostOfflineEvent value)?  removePostOffline,TResult? Function( CheckPostOfflineStatusEvent value)?  checkPostOfflineStatus,}){
final _that = this;
switch (_that) {
case GetPostsEvent() when getPosts != null:
return getPosts(_that);case LoadMorePostsEvent() when loadMorePosts != null:
return loadMorePosts(_that);case LoadCachedDataEvent() when loadCachedData != null:
return loadCachedData(_that);case SavePostOfflineEvent() when savePostOffline != null:
return savePostOffline(_that);case RemovePostOfflineEvent() when removePostOffline != null:
return removePostOffline(_that);case CheckPostOfflineStatusEvent() when checkPostOfflineStatus != null:
return checkPostOfflineStatus(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool forceRefresh,  int? categoryId,  bool useNewsPageLimit)?  getPosts,TResult Function( int? categoryId)?  loadMorePosts,TResult Function()?  loadCachedData,TResult Function( PostEntity post)?  savePostOffline,TResult Function( int postId)?  removePostOffline,TResult Function( int postId)?  checkPostOfflineStatus,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GetPostsEvent() when getPosts != null:
return getPosts(_that.forceRefresh,_that.categoryId,_that.useNewsPageLimit);case LoadMorePostsEvent() when loadMorePosts != null:
return loadMorePosts(_that.categoryId);case LoadCachedDataEvent() when loadCachedData != null:
return loadCachedData();case SavePostOfflineEvent() when savePostOffline != null:
return savePostOffline(_that.post);case RemovePostOfflineEvent() when removePostOffline != null:
return removePostOffline(_that.postId);case CheckPostOfflineStatusEvent() when checkPostOfflineStatus != null:
return checkPostOfflineStatus(_that.postId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool forceRefresh,  int? categoryId,  bool useNewsPageLimit)  getPosts,required TResult Function( int? categoryId)  loadMorePosts,required TResult Function()  loadCachedData,required TResult Function( PostEntity post)  savePostOffline,required TResult Function( int postId)  removePostOffline,required TResult Function( int postId)  checkPostOfflineStatus,}) {final _that = this;
switch (_that) {
case GetPostsEvent():
return getPosts(_that.forceRefresh,_that.categoryId,_that.useNewsPageLimit);case LoadMorePostsEvent():
return loadMorePosts(_that.categoryId);case LoadCachedDataEvent():
return loadCachedData();case SavePostOfflineEvent():
return savePostOffline(_that.post);case RemovePostOfflineEvent():
return removePostOffline(_that.postId);case CheckPostOfflineStatusEvent():
return checkPostOfflineStatus(_that.postId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool forceRefresh,  int? categoryId,  bool useNewsPageLimit)?  getPosts,TResult? Function( int? categoryId)?  loadMorePosts,TResult? Function()?  loadCachedData,TResult? Function( PostEntity post)?  savePostOffline,TResult? Function( int postId)?  removePostOffline,TResult? Function( int postId)?  checkPostOfflineStatus,}) {final _that = this;
switch (_that) {
case GetPostsEvent() when getPosts != null:
return getPosts(_that.forceRefresh,_that.categoryId,_that.useNewsPageLimit);case LoadMorePostsEvent() when loadMorePosts != null:
return loadMorePosts(_that.categoryId);case LoadCachedDataEvent() when loadCachedData != null:
return loadCachedData();case SavePostOfflineEvent() when savePostOffline != null:
return savePostOffline(_that.post);case RemovePostOfflineEvent() when removePostOffline != null:
return removePostOffline(_that.postId);case CheckPostOfflineStatusEvent() when checkPostOfflineStatus != null:
return checkPostOfflineStatus(_that.postId);case _:
  return null;

}
}

}

/// @nodoc


class GetPostsEvent implements NewsFeedEvent {
  const GetPostsEvent({this.forceRefresh = false, this.categoryId, this.useNewsPageLimit = false});
  

@JsonKey() final  bool forceRefresh;
 final  int? categoryId;
@JsonKey() final  bool useNewsPageLimit;

/// Create a copy of NewsFeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetPostsEventCopyWith<GetPostsEvent> get copyWith => _$GetPostsEventCopyWithImpl<GetPostsEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetPostsEvent&&(identical(other.forceRefresh, forceRefresh) || other.forceRefresh == forceRefresh)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.useNewsPageLimit, useNewsPageLimit) || other.useNewsPageLimit == useNewsPageLimit));
}


@override
int get hashCode => Object.hash(runtimeType,forceRefresh,categoryId,useNewsPageLimit);

@override
String toString() {
  return 'NewsFeedEvent.getPosts(forceRefresh: $forceRefresh, categoryId: $categoryId, useNewsPageLimit: $useNewsPageLimit)';
}


}

/// @nodoc
abstract mixin class $GetPostsEventCopyWith<$Res> implements $NewsFeedEventCopyWith<$Res> {
  factory $GetPostsEventCopyWith(GetPostsEvent value, $Res Function(GetPostsEvent) _then) = _$GetPostsEventCopyWithImpl;
@useResult
$Res call({
 bool forceRefresh, int? categoryId, bool useNewsPageLimit
});




}
/// @nodoc
class _$GetPostsEventCopyWithImpl<$Res>
    implements $GetPostsEventCopyWith<$Res> {
  _$GetPostsEventCopyWithImpl(this._self, this._then);

  final GetPostsEvent _self;
  final $Res Function(GetPostsEvent) _then;

/// Create a copy of NewsFeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? forceRefresh = null,Object? categoryId = freezed,Object? useNewsPageLimit = null,}) {
  return _then(GetPostsEvent(
forceRefresh: null == forceRefresh ? _self.forceRefresh : forceRefresh // ignore: cast_nullable_to_non_nullable
as bool,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,useNewsPageLimit: null == useNewsPageLimit ? _self.useNewsPageLimit : useNewsPageLimit // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class LoadMorePostsEvent implements NewsFeedEvent {
  const LoadMorePostsEvent({this.categoryId});
  

 final  int? categoryId;

/// Create a copy of NewsFeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadMorePostsEventCopyWith<LoadMorePostsEvent> get copyWith => _$LoadMorePostsEventCopyWithImpl<LoadMorePostsEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadMorePostsEvent&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId);

@override
String toString() {
  return 'NewsFeedEvent.loadMorePosts(categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class $LoadMorePostsEventCopyWith<$Res> implements $NewsFeedEventCopyWith<$Res> {
  factory $LoadMorePostsEventCopyWith(LoadMorePostsEvent value, $Res Function(LoadMorePostsEvent) _then) = _$LoadMorePostsEventCopyWithImpl;
@useResult
$Res call({
 int? categoryId
});




}
/// @nodoc
class _$LoadMorePostsEventCopyWithImpl<$Res>
    implements $LoadMorePostsEventCopyWith<$Res> {
  _$LoadMorePostsEventCopyWithImpl(this._self, this._then);

  final LoadMorePostsEvent _self;
  final $Res Function(LoadMorePostsEvent) _then;

/// Create a copy of NewsFeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categoryId = freezed,}) {
  return _then(LoadMorePostsEvent(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class LoadCachedDataEvent implements NewsFeedEvent {
  const LoadCachedDataEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadCachedDataEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewsFeedEvent.loadCachedData()';
}


}




/// @nodoc


class SavePostOfflineEvent implements NewsFeedEvent {
  const SavePostOfflineEvent(this.post);
  

 final  PostEntity post;

/// Create a copy of NewsFeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavePostOfflineEventCopyWith<SavePostOfflineEvent> get copyWith => _$SavePostOfflineEventCopyWithImpl<SavePostOfflineEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavePostOfflineEvent&&(identical(other.post, post) || other.post == post));
}


@override
int get hashCode => Object.hash(runtimeType,post);

@override
String toString() {
  return 'NewsFeedEvent.savePostOffline(post: $post)';
}


}

/// @nodoc
abstract mixin class $SavePostOfflineEventCopyWith<$Res> implements $NewsFeedEventCopyWith<$Res> {
  factory $SavePostOfflineEventCopyWith(SavePostOfflineEvent value, $Res Function(SavePostOfflineEvent) _then) = _$SavePostOfflineEventCopyWithImpl;
@useResult
$Res call({
 PostEntity post
});




}
/// @nodoc
class _$SavePostOfflineEventCopyWithImpl<$Res>
    implements $SavePostOfflineEventCopyWith<$Res> {
  _$SavePostOfflineEventCopyWithImpl(this._self, this._then);

  final SavePostOfflineEvent _self;
  final $Res Function(SavePostOfflineEvent) _then;

/// Create a copy of NewsFeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? post = null,}) {
  return _then(SavePostOfflineEvent(
null == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as PostEntity,
  ));
}


}

/// @nodoc


class RemovePostOfflineEvent implements NewsFeedEvent {
  const RemovePostOfflineEvent(this.postId);
  

 final  int postId;

/// Create a copy of NewsFeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemovePostOfflineEventCopyWith<RemovePostOfflineEvent> get copyWith => _$RemovePostOfflineEventCopyWithImpl<RemovePostOfflineEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemovePostOfflineEvent&&(identical(other.postId, postId) || other.postId == postId));
}


@override
int get hashCode => Object.hash(runtimeType,postId);

@override
String toString() {
  return 'NewsFeedEvent.removePostOffline(postId: $postId)';
}


}

/// @nodoc
abstract mixin class $RemovePostOfflineEventCopyWith<$Res> implements $NewsFeedEventCopyWith<$Res> {
  factory $RemovePostOfflineEventCopyWith(RemovePostOfflineEvent value, $Res Function(RemovePostOfflineEvent) _then) = _$RemovePostOfflineEventCopyWithImpl;
@useResult
$Res call({
 int postId
});




}
/// @nodoc
class _$RemovePostOfflineEventCopyWithImpl<$Res>
    implements $RemovePostOfflineEventCopyWith<$Res> {
  _$RemovePostOfflineEventCopyWithImpl(this._self, this._then);

  final RemovePostOfflineEvent _self;
  final $Res Function(RemovePostOfflineEvent) _then;

/// Create a copy of NewsFeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? postId = null,}) {
  return _then(RemovePostOfflineEvent(
null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class CheckPostOfflineStatusEvent implements NewsFeedEvent {
  const CheckPostOfflineStatusEvent(this.postId);
  

 final  int postId;

/// Create a copy of NewsFeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckPostOfflineStatusEventCopyWith<CheckPostOfflineStatusEvent> get copyWith => _$CheckPostOfflineStatusEventCopyWithImpl<CheckPostOfflineStatusEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckPostOfflineStatusEvent&&(identical(other.postId, postId) || other.postId == postId));
}


@override
int get hashCode => Object.hash(runtimeType,postId);

@override
String toString() {
  return 'NewsFeedEvent.checkPostOfflineStatus(postId: $postId)';
}


}

/// @nodoc
abstract mixin class $CheckPostOfflineStatusEventCopyWith<$Res> implements $NewsFeedEventCopyWith<$Res> {
  factory $CheckPostOfflineStatusEventCopyWith(CheckPostOfflineStatusEvent value, $Res Function(CheckPostOfflineStatusEvent) _then) = _$CheckPostOfflineStatusEventCopyWithImpl;
@useResult
$Res call({
 int postId
});




}
/// @nodoc
class _$CheckPostOfflineStatusEventCopyWithImpl<$Res>
    implements $CheckPostOfflineStatusEventCopyWith<$Res> {
  _$CheckPostOfflineStatusEventCopyWithImpl(this._self, this._then);

  final CheckPostOfflineStatusEvent _self;
  final $Res Function(CheckPostOfflineStatusEvent) _then;

/// Create a copy of NewsFeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? postId = null,}) {
  return _then(CheckPostOfflineStatusEvent(
null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$NewsFeedState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsFeedState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewsFeedState()';
}


}

/// @nodoc
class $NewsFeedStateCopyWith<$Res>  {
$NewsFeedStateCopyWith(NewsFeedState _, $Res Function(NewsFeedState) __);
}


/// Adds pattern-matching-related methods to [NewsFeedState].
extension NewsFeedStatePatterns on NewsFeedState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( int? categoryId)?  loading,TResult Function( List<PostEntity> posts,  Map<int?, List<PostEntity>> postsByCategory,  int? selectedCategoryId,  Map<int?, bool> hasMoreByCategory,  Map<int?, bool> isLoadingByCategory,  Map<int?, Failure?> errorsByCategory,  Map<int?, int> currentPageByCategory,  Set<int> offlinePostIds)?  loaded,TResult Function( Failure failure,  int? categoryId)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading(_that.categoryId);case _Loaded() when loaded != null:
return loaded(_that.posts,_that.postsByCategory,_that.selectedCategoryId,_that.hasMoreByCategory,_that.isLoadingByCategory,_that.errorsByCategory,_that.currentPageByCategory,_that.offlinePostIds);case _Error() when error != null:
return error(_that.failure,_that.categoryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( int? categoryId)  loading,required TResult Function( List<PostEntity> posts,  Map<int?, List<PostEntity>> postsByCategory,  int? selectedCategoryId,  Map<int?, bool> hasMoreByCategory,  Map<int?, bool> isLoadingByCategory,  Map<int?, Failure?> errorsByCategory,  Map<int?, int> currentPageByCategory,  Set<int> offlinePostIds)  loaded,required TResult Function( Failure failure,  int? categoryId)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading(_that.categoryId);case _Loaded():
return loaded(_that.posts,_that.postsByCategory,_that.selectedCategoryId,_that.hasMoreByCategory,_that.isLoadingByCategory,_that.errorsByCategory,_that.currentPageByCategory,_that.offlinePostIds);case _Error():
return error(_that.failure,_that.categoryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( int? categoryId)?  loading,TResult? Function( List<PostEntity> posts,  Map<int?, List<PostEntity>> postsByCategory,  int? selectedCategoryId,  Map<int?, bool> hasMoreByCategory,  Map<int?, bool> isLoadingByCategory,  Map<int?, Failure?> errorsByCategory,  Map<int?, int> currentPageByCategory,  Set<int> offlinePostIds)?  loaded,TResult? Function( Failure failure,  int? categoryId)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading(_that.categoryId);case _Loaded() when loaded != null:
return loaded(_that.posts,_that.postsByCategory,_that.selectedCategoryId,_that.hasMoreByCategory,_that.isLoadingByCategory,_that.errorsByCategory,_that.currentPageByCategory,_that.offlinePostIds);case _Error() when error != null:
return error(_that.failure,_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements NewsFeedState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewsFeedState.initial()';
}


}




/// @nodoc


class _Loading implements NewsFeedState {
  const _Loading({this.categoryId});
  

 final  int? categoryId;

/// Create a copy of NewsFeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadingCopyWith<_Loading> get copyWith => __$LoadingCopyWithImpl<_Loading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId);

@override
String toString() {
  return 'NewsFeedState.loading(categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$LoadingCopyWith<$Res> implements $NewsFeedStateCopyWith<$Res> {
  factory _$LoadingCopyWith(_Loading value, $Res Function(_Loading) _then) = __$LoadingCopyWithImpl;
@useResult
$Res call({
 int? categoryId
});




}
/// @nodoc
class __$LoadingCopyWithImpl<$Res>
    implements _$LoadingCopyWith<$Res> {
  __$LoadingCopyWithImpl(this._self, this._then);

  final _Loading _self;
  final $Res Function(_Loading) _then;

/// Create a copy of NewsFeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categoryId = freezed,}) {
  return _then(_Loading(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class _Loaded implements NewsFeedState {
  const _Loaded({required final  List<PostEntity> posts, required final  Map<int?, List<PostEntity>> postsByCategory, this.selectedCategoryId, final  Map<int?, bool> hasMoreByCategory = const {}, final  Map<int?, bool> isLoadingByCategory = const {}, final  Map<int?, Failure?> errorsByCategory = const {}, final  Map<int?, int> currentPageByCategory = const {}, final  Set<int> offlinePostIds = const {}}): _posts = posts,_postsByCategory = postsByCategory,_hasMoreByCategory = hasMoreByCategory,_isLoadingByCategory = isLoadingByCategory,_errorsByCategory = errorsByCategory,_currentPageByCategory = currentPageByCategory,_offlinePostIds = offlinePostIds;
  

 final  List<PostEntity> _posts;
 List<PostEntity> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

 final  Map<int?, List<PostEntity>> _postsByCategory;
 Map<int?, List<PostEntity>> get postsByCategory {
  if (_postsByCategory is EqualUnmodifiableMapView) return _postsByCategory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_postsByCategory);
}

 final  int? selectedCategoryId;
 final  Map<int?, bool> _hasMoreByCategory;
@JsonKey() Map<int?, bool> get hasMoreByCategory {
  if (_hasMoreByCategory is EqualUnmodifiableMapView) return _hasMoreByCategory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_hasMoreByCategory);
}

 final  Map<int?, bool> _isLoadingByCategory;
@JsonKey() Map<int?, bool> get isLoadingByCategory {
  if (_isLoadingByCategory is EqualUnmodifiableMapView) return _isLoadingByCategory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_isLoadingByCategory);
}

 final  Map<int?, Failure?> _errorsByCategory;
@JsonKey() Map<int?, Failure?> get errorsByCategory {
  if (_errorsByCategory is EqualUnmodifiableMapView) return _errorsByCategory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errorsByCategory);
}

 final  Map<int?, int> _currentPageByCategory;
@JsonKey() Map<int?, int> get currentPageByCategory {
  if (_currentPageByCategory is EqualUnmodifiableMapView) return _currentPageByCategory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_currentPageByCategory);
}

 final  Set<int> _offlinePostIds;
@JsonKey() Set<int> get offlinePostIds {
  if (_offlinePostIds is EqualUnmodifiableSetView) return _offlinePostIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_offlinePostIds);
}


/// Create a copy of NewsFeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._posts, _posts)&&const DeepCollectionEquality().equals(other._postsByCategory, _postsByCategory)&&(identical(other.selectedCategoryId, selectedCategoryId) || other.selectedCategoryId == selectedCategoryId)&&const DeepCollectionEquality().equals(other._hasMoreByCategory, _hasMoreByCategory)&&const DeepCollectionEquality().equals(other._isLoadingByCategory, _isLoadingByCategory)&&const DeepCollectionEquality().equals(other._errorsByCategory, _errorsByCategory)&&const DeepCollectionEquality().equals(other._currentPageByCategory, _currentPageByCategory)&&const DeepCollectionEquality().equals(other._offlinePostIds, _offlinePostIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_posts),const DeepCollectionEquality().hash(_postsByCategory),selectedCategoryId,const DeepCollectionEquality().hash(_hasMoreByCategory),const DeepCollectionEquality().hash(_isLoadingByCategory),const DeepCollectionEquality().hash(_errorsByCategory),const DeepCollectionEquality().hash(_currentPageByCategory),const DeepCollectionEquality().hash(_offlinePostIds));

@override
String toString() {
  return 'NewsFeedState.loaded(posts: $posts, postsByCategory: $postsByCategory, selectedCategoryId: $selectedCategoryId, hasMoreByCategory: $hasMoreByCategory, isLoadingByCategory: $isLoadingByCategory, errorsByCategory: $errorsByCategory, currentPageByCategory: $currentPageByCategory, offlinePostIds: $offlinePostIds)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $NewsFeedStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<PostEntity> posts, Map<int?, List<PostEntity>> postsByCategory, int? selectedCategoryId, Map<int?, bool> hasMoreByCategory, Map<int?, bool> isLoadingByCategory, Map<int?, Failure?> errorsByCategory, Map<int?, int> currentPageByCategory, Set<int> offlinePostIds
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of NewsFeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? posts = null,Object? postsByCategory = null,Object? selectedCategoryId = freezed,Object? hasMoreByCategory = null,Object? isLoadingByCategory = null,Object? errorsByCategory = null,Object? currentPageByCategory = null,Object? offlinePostIds = null,}) {
  return _then(_Loaded(
posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<PostEntity>,postsByCategory: null == postsByCategory ? _self._postsByCategory : postsByCategory // ignore: cast_nullable_to_non_nullable
as Map<int?, List<PostEntity>>,selectedCategoryId: freezed == selectedCategoryId ? _self.selectedCategoryId : selectedCategoryId // ignore: cast_nullable_to_non_nullable
as int?,hasMoreByCategory: null == hasMoreByCategory ? _self._hasMoreByCategory : hasMoreByCategory // ignore: cast_nullable_to_non_nullable
as Map<int?, bool>,isLoadingByCategory: null == isLoadingByCategory ? _self._isLoadingByCategory : isLoadingByCategory // ignore: cast_nullable_to_non_nullable
as Map<int?, bool>,errorsByCategory: null == errorsByCategory ? _self._errorsByCategory : errorsByCategory // ignore: cast_nullable_to_non_nullable
as Map<int?, Failure?>,currentPageByCategory: null == currentPageByCategory ? _self._currentPageByCategory : currentPageByCategory // ignore: cast_nullable_to_non_nullable
as Map<int?, int>,offlinePostIds: null == offlinePostIds ? _self._offlinePostIds : offlinePostIds // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}


}

/// @nodoc


class _Error implements NewsFeedState {
  const _Error({required this.failure, this.categoryId});
  

 final  Failure failure;
 final  int? categoryId;

/// Create a copy of NewsFeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}


@override
int get hashCode => Object.hash(runtimeType,failure,categoryId);

@override
String toString() {
  return 'NewsFeedState.error(failure: $failure, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $NewsFeedStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure, int? categoryId
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of NewsFeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? categoryId = freezed,}) {
  return _then(_Error(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
