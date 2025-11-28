// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wordpress_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WordPressEvent {

 bool get forceRefresh; int? get categoryId;
/// Create a copy of WordPressEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WordPressEventCopyWith<WordPressEvent> get copyWith => _$WordPressEventCopyWithImpl<WordPressEvent>(this as WordPressEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WordPressEvent&&(identical(other.forceRefresh, forceRefresh) || other.forceRefresh == forceRefresh)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}


@override
int get hashCode => Object.hash(runtimeType,forceRefresh,categoryId);

@override
String toString() {
  return 'WordPressEvent(forceRefresh: $forceRefresh, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class $WordPressEventCopyWith<$Res>  {
  factory $WordPressEventCopyWith(WordPressEvent value, $Res Function(WordPressEvent) _then) = _$WordPressEventCopyWithImpl;
@useResult
$Res call({
 bool forceRefresh, int? categoryId
});




}
/// @nodoc
class _$WordPressEventCopyWithImpl<$Res>
    implements $WordPressEventCopyWith<$Res> {
  _$WordPressEventCopyWithImpl(this._self, this._then);

  final WordPressEvent _self;
  final $Res Function(WordPressEvent) _then;

/// Create a copy of WordPressEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? forceRefresh = null,Object? categoryId = freezed,}) {
  return _then(_self.copyWith(
forceRefresh: null == forceRefresh ? _self.forceRefresh : forceRefresh // ignore: cast_nullable_to_non_nullable
as bool,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [WordPressEvent].
extension WordPressEventPatterns on WordPressEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GetPostsEvent value)?  getPosts,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GetPostsEvent() when getPosts != null:
return getPosts(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GetPostsEvent value)  getPosts,}){
final _that = this;
switch (_that) {
case GetPostsEvent():
return getPosts(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GetPostsEvent value)?  getPosts,}){
final _that = this;
switch (_that) {
case GetPostsEvent() when getPosts != null:
return getPosts(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool forceRefresh,  int? categoryId)?  getPosts,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GetPostsEvent() when getPosts != null:
return getPosts(_that.forceRefresh,_that.categoryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool forceRefresh,  int? categoryId)  getPosts,}) {final _that = this;
switch (_that) {
case GetPostsEvent():
return getPosts(_that.forceRefresh,_that.categoryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool forceRefresh,  int? categoryId)?  getPosts,}) {final _that = this;
switch (_that) {
case GetPostsEvent() when getPosts != null:
return getPosts(_that.forceRefresh,_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc


class GetPostsEvent extends WordPressEvent {
  const GetPostsEvent({this.forceRefresh = false, this.categoryId}): super._();
  

@override@JsonKey() final  bool forceRefresh;
@override final  int? categoryId;

/// Create a copy of WordPressEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetPostsEventCopyWith<GetPostsEvent> get copyWith => _$GetPostsEventCopyWithImpl<GetPostsEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetPostsEvent&&(identical(other.forceRefresh, forceRefresh) || other.forceRefresh == forceRefresh)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}


@override
int get hashCode => Object.hash(runtimeType,forceRefresh,categoryId);

@override
String toString() {
  return 'WordPressEvent.getPosts(forceRefresh: $forceRefresh, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class $GetPostsEventCopyWith<$Res> implements $WordPressEventCopyWith<$Res> {
  factory $GetPostsEventCopyWith(GetPostsEvent value, $Res Function(GetPostsEvent) _then) = _$GetPostsEventCopyWithImpl;
@override @useResult
$Res call({
 bool forceRefresh, int? categoryId
});




}
/// @nodoc
class _$GetPostsEventCopyWithImpl<$Res>
    implements $GetPostsEventCopyWith<$Res> {
  _$GetPostsEventCopyWithImpl(this._self, this._then);

  final GetPostsEvent _self;
  final $Res Function(GetPostsEvent) _then;

/// Create a copy of WordPressEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? forceRefresh = null,Object? categoryId = freezed,}) {
  return _then(GetPostsEvent(
forceRefresh: null == forceRefresh ? _self.forceRefresh : forceRefresh // ignore: cast_nullable_to_non_nullable
as bool,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$WordPressState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WordPressState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WordPressState()';
}


}

/// @nodoc
class $WordPressStateCopyWith<$Res>  {
$WordPressStateCopyWith(WordPressState _, $Res Function(WordPressState) __);
}


/// Adds pattern-matching-related methods to [WordPressState].
extension WordPressStatePatterns on WordPressState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( int? categoryId)?  loading,TResult Function( List<PostEntity> posts,  Map<int?, List<PostEntity>> postsByCategory,  int? selectedCategoryId,  Map<int?, bool> hasMoreByCategory,  Map<int?, bool> isLoadingByCategory,  Map<int?, Failure?> errorsByCategory)?  loaded,TResult Function( Failure failure,  int? categoryId)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading(_that.categoryId);case _Loaded() when loaded != null:
return loaded(_that.posts,_that.postsByCategory,_that.selectedCategoryId,_that.hasMoreByCategory,_that.isLoadingByCategory,_that.errorsByCategory);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( int? categoryId)  loading,required TResult Function( List<PostEntity> posts,  Map<int?, List<PostEntity>> postsByCategory,  int? selectedCategoryId,  Map<int?, bool> hasMoreByCategory,  Map<int?, bool> isLoadingByCategory,  Map<int?, Failure?> errorsByCategory)  loaded,required TResult Function( Failure failure,  int? categoryId)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading(_that.categoryId);case _Loaded():
return loaded(_that.posts,_that.postsByCategory,_that.selectedCategoryId,_that.hasMoreByCategory,_that.isLoadingByCategory,_that.errorsByCategory);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( int? categoryId)?  loading,TResult? Function( List<PostEntity> posts,  Map<int?, List<PostEntity>> postsByCategory,  int? selectedCategoryId,  Map<int?, bool> hasMoreByCategory,  Map<int?, bool> isLoadingByCategory,  Map<int?, Failure?> errorsByCategory)?  loaded,TResult? Function( Failure failure,  int? categoryId)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading(_that.categoryId);case _Loaded() when loaded != null:
return loaded(_that.posts,_that.postsByCategory,_that.selectedCategoryId,_that.hasMoreByCategory,_that.isLoadingByCategory,_that.errorsByCategory);case _Error() when error != null:
return error(_that.failure,_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements WordPressState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WordPressState.initial()';
}


}




/// @nodoc


class _Loading implements WordPressState {
  const _Loading({this.categoryId});
  

 final  int? categoryId;

/// Create a copy of WordPressState
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
  return 'WordPressState.loading(categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$LoadingCopyWith<$Res> implements $WordPressStateCopyWith<$Res> {
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

/// Create a copy of WordPressState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categoryId = freezed,}) {
  return _then(_Loading(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class _Loaded implements WordPressState {
  const _Loaded({required final  List<PostEntity> posts, required final  Map<int?, List<PostEntity>> postsByCategory, this.selectedCategoryId, final  Map<int?, bool> hasMoreByCategory = const {}, final  Map<int?, bool> isLoadingByCategory = const {}, final  Map<int?, Failure?> errorsByCategory = const {}}): _posts = posts,_postsByCategory = postsByCategory,_hasMoreByCategory = hasMoreByCategory,_isLoadingByCategory = isLoadingByCategory,_errorsByCategory = errorsByCategory;
  

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


/// Create a copy of WordPressState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._posts, _posts)&&const DeepCollectionEquality().equals(other._postsByCategory, _postsByCategory)&&(identical(other.selectedCategoryId, selectedCategoryId) || other.selectedCategoryId == selectedCategoryId)&&const DeepCollectionEquality().equals(other._hasMoreByCategory, _hasMoreByCategory)&&const DeepCollectionEquality().equals(other._isLoadingByCategory, _isLoadingByCategory)&&const DeepCollectionEquality().equals(other._errorsByCategory, _errorsByCategory));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_posts),const DeepCollectionEquality().hash(_postsByCategory),selectedCategoryId,const DeepCollectionEquality().hash(_hasMoreByCategory),const DeepCollectionEquality().hash(_isLoadingByCategory),const DeepCollectionEquality().hash(_errorsByCategory));

@override
String toString() {
  return 'WordPressState.loaded(posts: $posts, postsByCategory: $postsByCategory, selectedCategoryId: $selectedCategoryId, hasMoreByCategory: $hasMoreByCategory, isLoadingByCategory: $isLoadingByCategory, errorsByCategory: $errorsByCategory)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $WordPressStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<PostEntity> posts, Map<int?, List<PostEntity>> postsByCategory, int? selectedCategoryId, Map<int?, bool> hasMoreByCategory, Map<int?, bool> isLoadingByCategory, Map<int?, Failure?> errorsByCategory
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of WordPressState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? posts = null,Object? postsByCategory = null,Object? selectedCategoryId = freezed,Object? hasMoreByCategory = null,Object? isLoadingByCategory = null,Object? errorsByCategory = null,}) {
  return _then(_Loaded(
posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<PostEntity>,postsByCategory: null == postsByCategory ? _self._postsByCategory : postsByCategory // ignore: cast_nullable_to_non_nullable
as Map<int?, List<PostEntity>>,selectedCategoryId: freezed == selectedCategoryId ? _self.selectedCategoryId : selectedCategoryId // ignore: cast_nullable_to_non_nullable
as int?,hasMoreByCategory: null == hasMoreByCategory ? _self._hasMoreByCategory : hasMoreByCategory // ignore: cast_nullable_to_non_nullable
as Map<int?, bool>,isLoadingByCategory: null == isLoadingByCategory ? _self._isLoadingByCategory : isLoadingByCategory // ignore: cast_nullable_to_non_nullable
as Map<int?, bool>,errorsByCategory: null == errorsByCategory ? _self._errorsByCategory : errorsByCategory // ignore: cast_nullable_to_non_nullable
as Map<int?, Failure?>,
  ));
}


}

/// @nodoc


class _Error implements WordPressState {
  const _Error({required this.failure, this.categoryId});
  

 final  Failure failure;
 final  int? categoryId;

/// Create a copy of WordPressState
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
  return 'WordPressState.error(failure: $failure, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $WordPressStateCopyWith<$Res> {
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

/// Create a copy of WordPressState
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
