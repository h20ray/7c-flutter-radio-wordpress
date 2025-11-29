// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NewsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewsEvent()';
}


}

/// @nodoc
class $NewsEventCopyWith<$Res>  {
$NewsEventCopyWith(NewsEvent _, $Res Function(NewsEvent) __);
}


/// Adds pattern-matching-related methods to [NewsEvent].
extension NewsEventPatterns on NewsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GetNewsPostsEvent value)?  getPosts,TResult Function( LoadMoreNewsPostsEvent value)?  loadMorePosts,TResult Function( SearchNewsPostsEvent value)?  searchPosts,TResult Function( LoadMoreNewsSearchResultsEvent value)?  loadMoreSearchResults,TResult Function( ClearNewsSearchEvent value)?  clearSearch,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GetNewsPostsEvent() when getPosts != null:
return getPosts(_that);case LoadMoreNewsPostsEvent() when loadMorePosts != null:
return loadMorePosts(_that);case SearchNewsPostsEvent() when searchPosts != null:
return searchPosts(_that);case LoadMoreNewsSearchResultsEvent() when loadMoreSearchResults != null:
return loadMoreSearchResults(_that);case ClearNewsSearchEvent() when clearSearch != null:
return clearSearch(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GetNewsPostsEvent value)  getPosts,required TResult Function( LoadMoreNewsPostsEvent value)  loadMorePosts,required TResult Function( SearchNewsPostsEvent value)  searchPosts,required TResult Function( LoadMoreNewsSearchResultsEvent value)  loadMoreSearchResults,required TResult Function( ClearNewsSearchEvent value)  clearSearch,}){
final _that = this;
switch (_that) {
case GetNewsPostsEvent():
return getPosts(_that);case LoadMoreNewsPostsEvent():
return loadMorePosts(_that);case SearchNewsPostsEvent():
return searchPosts(_that);case LoadMoreNewsSearchResultsEvent():
return loadMoreSearchResults(_that);case ClearNewsSearchEvent():
return clearSearch(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GetNewsPostsEvent value)?  getPosts,TResult? Function( LoadMoreNewsPostsEvent value)?  loadMorePosts,TResult? Function( SearchNewsPostsEvent value)?  searchPosts,TResult? Function( LoadMoreNewsSearchResultsEvent value)?  loadMoreSearchResults,TResult? Function( ClearNewsSearchEvent value)?  clearSearch,}){
final _that = this;
switch (_that) {
case GetNewsPostsEvent() when getPosts != null:
return getPosts(_that);case LoadMoreNewsPostsEvent() when loadMorePosts != null:
return loadMorePosts(_that);case SearchNewsPostsEvent() when searchPosts != null:
return searchPosts(_that);case LoadMoreNewsSearchResultsEvent() when loadMoreSearchResults != null:
return loadMoreSearchResults(_that);case ClearNewsSearchEvent() when clearSearch != null:
return clearSearch(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool forceRefresh,  int? categoryId,  bool useNewsPageLimit)?  getPosts,TResult Function( int? categoryId)?  loadMorePosts,TResult Function( String query)?  searchPosts,TResult Function()?  loadMoreSearchResults,TResult Function()?  clearSearch,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GetNewsPostsEvent() when getPosts != null:
return getPosts(_that.forceRefresh,_that.categoryId,_that.useNewsPageLimit);case LoadMoreNewsPostsEvent() when loadMorePosts != null:
return loadMorePosts(_that.categoryId);case SearchNewsPostsEvent() when searchPosts != null:
return searchPosts(_that.query);case LoadMoreNewsSearchResultsEvent() when loadMoreSearchResults != null:
return loadMoreSearchResults();case ClearNewsSearchEvent() when clearSearch != null:
return clearSearch();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool forceRefresh,  int? categoryId,  bool useNewsPageLimit)  getPosts,required TResult Function( int? categoryId)  loadMorePosts,required TResult Function( String query)  searchPosts,required TResult Function()  loadMoreSearchResults,required TResult Function()  clearSearch,}) {final _that = this;
switch (_that) {
case GetNewsPostsEvent():
return getPosts(_that.forceRefresh,_that.categoryId,_that.useNewsPageLimit);case LoadMoreNewsPostsEvent():
return loadMorePosts(_that.categoryId);case SearchNewsPostsEvent():
return searchPosts(_that.query);case LoadMoreNewsSearchResultsEvent():
return loadMoreSearchResults();case ClearNewsSearchEvent():
return clearSearch();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool forceRefresh,  int? categoryId,  bool useNewsPageLimit)?  getPosts,TResult? Function( int? categoryId)?  loadMorePosts,TResult? Function( String query)?  searchPosts,TResult? Function()?  loadMoreSearchResults,TResult? Function()?  clearSearch,}) {final _that = this;
switch (_that) {
case GetNewsPostsEvent() when getPosts != null:
return getPosts(_that.forceRefresh,_that.categoryId,_that.useNewsPageLimit);case LoadMoreNewsPostsEvent() when loadMorePosts != null:
return loadMorePosts(_that.categoryId);case SearchNewsPostsEvent() when searchPosts != null:
return searchPosts(_that.query);case LoadMoreNewsSearchResultsEvent() when loadMoreSearchResults != null:
return loadMoreSearchResults();case ClearNewsSearchEvent() when clearSearch != null:
return clearSearch();case _:
  return null;

}
}

}

/// @nodoc


class GetNewsPostsEvent extends NewsEvent {
  const GetNewsPostsEvent({this.forceRefresh = false, this.categoryId, this.useNewsPageLimit = false}): super._();
  

@JsonKey() final  bool forceRefresh;
 final  int? categoryId;
@JsonKey() final  bool useNewsPageLimit;

/// Create a copy of NewsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetNewsPostsEventCopyWith<GetNewsPostsEvent> get copyWith => _$GetNewsPostsEventCopyWithImpl<GetNewsPostsEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetNewsPostsEvent&&(identical(other.forceRefresh, forceRefresh) || other.forceRefresh == forceRefresh)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.useNewsPageLimit, useNewsPageLimit) || other.useNewsPageLimit == useNewsPageLimit));
}


@override
int get hashCode => Object.hash(runtimeType,forceRefresh,categoryId,useNewsPageLimit);

@override
String toString() {
  return 'NewsEvent.getPosts(forceRefresh: $forceRefresh, categoryId: $categoryId, useNewsPageLimit: $useNewsPageLimit)';
}


}

/// @nodoc
abstract mixin class $GetNewsPostsEventCopyWith<$Res> implements $NewsEventCopyWith<$Res> {
  factory $GetNewsPostsEventCopyWith(GetNewsPostsEvent value, $Res Function(GetNewsPostsEvent) _then) = _$GetNewsPostsEventCopyWithImpl;
@useResult
$Res call({
 bool forceRefresh, int? categoryId, bool useNewsPageLimit
});




}
/// @nodoc
class _$GetNewsPostsEventCopyWithImpl<$Res>
    implements $GetNewsPostsEventCopyWith<$Res> {
  _$GetNewsPostsEventCopyWithImpl(this._self, this._then);

  final GetNewsPostsEvent _self;
  final $Res Function(GetNewsPostsEvent) _then;

/// Create a copy of NewsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? forceRefresh = null,Object? categoryId = freezed,Object? useNewsPageLimit = null,}) {
  return _then(GetNewsPostsEvent(
forceRefresh: null == forceRefresh ? _self.forceRefresh : forceRefresh // ignore: cast_nullable_to_non_nullable
as bool,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,useNewsPageLimit: null == useNewsPageLimit ? _self.useNewsPageLimit : useNewsPageLimit // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class LoadMoreNewsPostsEvent extends NewsEvent {
  const LoadMoreNewsPostsEvent({this.categoryId}): super._();
  

 final  int? categoryId;

/// Create a copy of NewsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadMoreNewsPostsEventCopyWith<LoadMoreNewsPostsEvent> get copyWith => _$LoadMoreNewsPostsEventCopyWithImpl<LoadMoreNewsPostsEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadMoreNewsPostsEvent&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId);

@override
String toString() {
  return 'NewsEvent.loadMorePosts(categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class $LoadMoreNewsPostsEventCopyWith<$Res> implements $NewsEventCopyWith<$Res> {
  factory $LoadMoreNewsPostsEventCopyWith(LoadMoreNewsPostsEvent value, $Res Function(LoadMoreNewsPostsEvent) _then) = _$LoadMoreNewsPostsEventCopyWithImpl;
@useResult
$Res call({
 int? categoryId
});




}
/// @nodoc
class _$LoadMoreNewsPostsEventCopyWithImpl<$Res>
    implements $LoadMoreNewsPostsEventCopyWith<$Res> {
  _$LoadMoreNewsPostsEventCopyWithImpl(this._self, this._then);

  final LoadMoreNewsPostsEvent _self;
  final $Res Function(LoadMoreNewsPostsEvent) _then;

/// Create a copy of NewsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categoryId = freezed,}) {
  return _then(LoadMoreNewsPostsEvent(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class SearchNewsPostsEvent extends NewsEvent {
  const SearchNewsPostsEvent({required this.query}): super._();
  

 final  String query;

/// Create a copy of NewsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchNewsPostsEventCopyWith<SearchNewsPostsEvent> get copyWith => _$SearchNewsPostsEventCopyWithImpl<SearchNewsPostsEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchNewsPostsEvent&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'NewsEvent.searchPosts(query: $query)';
}


}

/// @nodoc
abstract mixin class $SearchNewsPostsEventCopyWith<$Res> implements $NewsEventCopyWith<$Res> {
  factory $SearchNewsPostsEventCopyWith(SearchNewsPostsEvent value, $Res Function(SearchNewsPostsEvent) _then) = _$SearchNewsPostsEventCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$SearchNewsPostsEventCopyWithImpl<$Res>
    implements $SearchNewsPostsEventCopyWith<$Res> {
  _$SearchNewsPostsEventCopyWithImpl(this._self, this._then);

  final SearchNewsPostsEvent _self;
  final $Res Function(SearchNewsPostsEvent) _then;

/// Create a copy of NewsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(SearchNewsPostsEvent(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LoadMoreNewsSearchResultsEvent extends NewsEvent {
  const LoadMoreNewsSearchResultsEvent(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadMoreNewsSearchResultsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewsEvent.loadMoreSearchResults()';
}


}




/// @nodoc


class ClearNewsSearchEvent extends NewsEvent {
  const ClearNewsSearchEvent(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearNewsSearchEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewsEvent.clearSearch()';
}


}




/// @nodoc
mixin _$NewsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewsState()';
}


}

/// @nodoc
class $NewsStateCopyWith<$Res>  {
$NewsStateCopyWith(NewsState _, $Res Function(NewsState) __);
}


/// Adds pattern-matching-related methods to [NewsState].
extension NewsStatePatterns on NewsState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( int? categoryId)?  loading,TResult Function( List<PostEntity> posts,  Map<int?, List<PostEntity>> postsByCategory,  int? selectedCategoryId,  Map<int?, bool> hasMoreByCategory,  Map<int?, bool> isLoadingByCategory,  Map<int?, Failure?> errorsByCategory,  Map<int?, int> currentPageByCategory,  List<PostEntity>? searchResults,  String? searchQuery,  int searchPage,  bool hasMoreSearchResults,  bool isLoadingSearch,  Failure? searchError)?  loaded,TResult Function( Failure failure,  int? categoryId)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading(_that.categoryId);case _Loaded() when loaded != null:
return loaded(_that.posts,_that.postsByCategory,_that.selectedCategoryId,_that.hasMoreByCategory,_that.isLoadingByCategory,_that.errorsByCategory,_that.currentPageByCategory,_that.searchResults,_that.searchQuery,_that.searchPage,_that.hasMoreSearchResults,_that.isLoadingSearch,_that.searchError);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( int? categoryId)  loading,required TResult Function( List<PostEntity> posts,  Map<int?, List<PostEntity>> postsByCategory,  int? selectedCategoryId,  Map<int?, bool> hasMoreByCategory,  Map<int?, bool> isLoadingByCategory,  Map<int?, Failure?> errorsByCategory,  Map<int?, int> currentPageByCategory,  List<PostEntity>? searchResults,  String? searchQuery,  int searchPage,  bool hasMoreSearchResults,  bool isLoadingSearch,  Failure? searchError)  loaded,required TResult Function( Failure failure,  int? categoryId)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading(_that.categoryId);case _Loaded():
return loaded(_that.posts,_that.postsByCategory,_that.selectedCategoryId,_that.hasMoreByCategory,_that.isLoadingByCategory,_that.errorsByCategory,_that.currentPageByCategory,_that.searchResults,_that.searchQuery,_that.searchPage,_that.hasMoreSearchResults,_that.isLoadingSearch,_that.searchError);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( int? categoryId)?  loading,TResult? Function( List<PostEntity> posts,  Map<int?, List<PostEntity>> postsByCategory,  int? selectedCategoryId,  Map<int?, bool> hasMoreByCategory,  Map<int?, bool> isLoadingByCategory,  Map<int?, Failure?> errorsByCategory,  Map<int?, int> currentPageByCategory,  List<PostEntity>? searchResults,  String? searchQuery,  int searchPage,  bool hasMoreSearchResults,  bool isLoadingSearch,  Failure? searchError)?  loaded,TResult? Function( Failure failure,  int? categoryId)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading(_that.categoryId);case _Loaded() when loaded != null:
return loaded(_that.posts,_that.postsByCategory,_that.selectedCategoryId,_that.hasMoreByCategory,_that.isLoadingByCategory,_that.errorsByCategory,_that.currentPageByCategory,_that.searchResults,_that.searchQuery,_that.searchPage,_that.hasMoreSearchResults,_that.isLoadingSearch,_that.searchError);case _Error() when error != null:
return error(_that.failure,_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements NewsState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewsState.initial()';
}


}




/// @nodoc


class _Loading implements NewsState {
  const _Loading({this.categoryId});
  

 final  int? categoryId;

/// Create a copy of NewsState
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
  return 'NewsState.loading(categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$LoadingCopyWith<$Res> implements $NewsStateCopyWith<$Res> {
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

/// Create a copy of NewsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categoryId = freezed,}) {
  return _then(_Loading(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class _Loaded implements NewsState {
  const _Loaded({required final  List<PostEntity> posts, required final  Map<int?, List<PostEntity>> postsByCategory, this.selectedCategoryId, final  Map<int?, bool> hasMoreByCategory = const {}, final  Map<int?, bool> isLoadingByCategory = const {}, final  Map<int?, Failure?> errorsByCategory = const {}, final  Map<int?, int> currentPageByCategory = const {}, final  List<PostEntity>? searchResults, this.searchQuery, this.searchPage = 1, this.hasMoreSearchResults = false, this.isLoadingSearch = false, this.searchError}): _posts = posts,_postsByCategory = postsByCategory,_hasMoreByCategory = hasMoreByCategory,_isLoadingByCategory = isLoadingByCategory,_errorsByCategory = errorsByCategory,_currentPageByCategory = currentPageByCategory,_searchResults = searchResults;
  

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

 final  List<PostEntity>? _searchResults;
 List<PostEntity>? get searchResults {
  final value = _searchResults;
  if (value == null) return null;
  if (_searchResults is EqualUnmodifiableListView) return _searchResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  String? searchQuery;
@JsonKey() final  int searchPage;
@JsonKey() final  bool hasMoreSearchResults;
@JsonKey() final  bool isLoadingSearch;
 final  Failure? searchError;

/// Create a copy of NewsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._posts, _posts)&&const DeepCollectionEquality().equals(other._postsByCategory, _postsByCategory)&&(identical(other.selectedCategoryId, selectedCategoryId) || other.selectedCategoryId == selectedCategoryId)&&const DeepCollectionEquality().equals(other._hasMoreByCategory, _hasMoreByCategory)&&const DeepCollectionEquality().equals(other._isLoadingByCategory, _isLoadingByCategory)&&const DeepCollectionEquality().equals(other._errorsByCategory, _errorsByCategory)&&const DeepCollectionEquality().equals(other._currentPageByCategory, _currentPageByCategory)&&const DeepCollectionEquality().equals(other._searchResults, _searchResults)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.searchPage, searchPage) || other.searchPage == searchPage)&&(identical(other.hasMoreSearchResults, hasMoreSearchResults) || other.hasMoreSearchResults == hasMoreSearchResults)&&(identical(other.isLoadingSearch, isLoadingSearch) || other.isLoadingSearch == isLoadingSearch)&&(identical(other.searchError, searchError) || other.searchError == searchError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_posts),const DeepCollectionEquality().hash(_postsByCategory),selectedCategoryId,const DeepCollectionEquality().hash(_hasMoreByCategory),const DeepCollectionEquality().hash(_isLoadingByCategory),const DeepCollectionEquality().hash(_errorsByCategory),const DeepCollectionEquality().hash(_currentPageByCategory),const DeepCollectionEquality().hash(_searchResults),searchQuery,searchPage,hasMoreSearchResults,isLoadingSearch,searchError);

@override
String toString() {
  return 'NewsState.loaded(posts: $posts, postsByCategory: $postsByCategory, selectedCategoryId: $selectedCategoryId, hasMoreByCategory: $hasMoreByCategory, isLoadingByCategory: $isLoadingByCategory, errorsByCategory: $errorsByCategory, currentPageByCategory: $currentPageByCategory, searchResults: $searchResults, searchQuery: $searchQuery, searchPage: $searchPage, hasMoreSearchResults: $hasMoreSearchResults, isLoadingSearch: $isLoadingSearch, searchError: $searchError)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $NewsStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<PostEntity> posts, Map<int?, List<PostEntity>> postsByCategory, int? selectedCategoryId, Map<int?, bool> hasMoreByCategory, Map<int?, bool> isLoadingByCategory, Map<int?, Failure?> errorsByCategory, Map<int?, int> currentPageByCategory, List<PostEntity>? searchResults, String? searchQuery, int searchPage, bool hasMoreSearchResults, bool isLoadingSearch, Failure? searchError
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of NewsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? posts = null,Object? postsByCategory = null,Object? selectedCategoryId = freezed,Object? hasMoreByCategory = null,Object? isLoadingByCategory = null,Object? errorsByCategory = null,Object? currentPageByCategory = null,Object? searchResults = freezed,Object? searchQuery = freezed,Object? searchPage = null,Object? hasMoreSearchResults = null,Object? isLoadingSearch = null,Object? searchError = freezed,}) {
  return _then(_Loaded(
posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<PostEntity>,postsByCategory: null == postsByCategory ? _self._postsByCategory : postsByCategory // ignore: cast_nullable_to_non_nullable
as Map<int?, List<PostEntity>>,selectedCategoryId: freezed == selectedCategoryId ? _self.selectedCategoryId : selectedCategoryId // ignore: cast_nullable_to_non_nullable
as int?,hasMoreByCategory: null == hasMoreByCategory ? _self._hasMoreByCategory : hasMoreByCategory // ignore: cast_nullable_to_non_nullable
as Map<int?, bool>,isLoadingByCategory: null == isLoadingByCategory ? _self._isLoadingByCategory : isLoadingByCategory // ignore: cast_nullable_to_non_nullable
as Map<int?, bool>,errorsByCategory: null == errorsByCategory ? _self._errorsByCategory : errorsByCategory // ignore: cast_nullable_to_non_nullable
as Map<int?, Failure?>,currentPageByCategory: null == currentPageByCategory ? _self._currentPageByCategory : currentPageByCategory // ignore: cast_nullable_to_non_nullable
as Map<int?, int>,searchResults: freezed == searchResults ? _self._searchResults : searchResults // ignore: cast_nullable_to_non_nullable
as List<PostEntity>?,searchQuery: freezed == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String?,searchPage: null == searchPage ? _self.searchPage : searchPage // ignore: cast_nullable_to_non_nullable
as int,hasMoreSearchResults: null == hasMoreSearchResults ? _self.hasMoreSearchResults : hasMoreSearchResults // ignore: cast_nullable_to_non_nullable
as bool,isLoadingSearch: null == isLoadingSearch ? _self.isLoadingSearch : isLoadingSearch // ignore: cast_nullable_to_non_nullable
as bool,searchError: freezed == searchError ? _self.searchError : searchError // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

/// @nodoc


class _Error implements NewsState {
  const _Error({required this.failure, this.categoryId});
  

 final  Failure failure;
 final  int? categoryId;

/// Create a copy of NewsState
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
  return 'NewsState.error(failure: $failure, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $NewsStateCopyWith<$Res> {
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

/// Create a copy of NewsState
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
