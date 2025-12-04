// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_search_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NewsSearchEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsSearchEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewsSearchEvent()';
}


}

/// @nodoc
class $NewsSearchEventCopyWith<$Res>  {
$NewsSearchEventCopyWith(NewsSearchEvent _, $Res Function(NewsSearchEvent) __);
}


/// Adds pattern-matching-related methods to [NewsSearchEvent].
extension NewsSearchEventPatterns on NewsSearchEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SearchPostsEvent value)?  searchPosts,TResult Function( LoadMoreSearchResultsEvent value)?  loadMoreSearchResults,TResult Function( ClearSearchEvent value)?  clearSearch,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SearchPostsEvent() when searchPosts != null:
return searchPosts(_that);case LoadMoreSearchResultsEvent() when loadMoreSearchResults != null:
return loadMoreSearchResults(_that);case ClearSearchEvent() when clearSearch != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SearchPostsEvent value)  searchPosts,required TResult Function( LoadMoreSearchResultsEvent value)  loadMoreSearchResults,required TResult Function( ClearSearchEvent value)  clearSearch,}){
final _that = this;
switch (_that) {
case SearchPostsEvent():
return searchPosts(_that);case LoadMoreSearchResultsEvent():
return loadMoreSearchResults(_that);case ClearSearchEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SearchPostsEvent value)?  searchPosts,TResult? Function( LoadMoreSearchResultsEvent value)?  loadMoreSearchResults,TResult? Function( ClearSearchEvent value)?  clearSearch,}){
final _that = this;
switch (_that) {
case SearchPostsEvent() when searchPosts != null:
return searchPosts(_that);case LoadMoreSearchResultsEvent() when loadMoreSearchResults != null:
return loadMoreSearchResults(_that);case ClearSearchEvent() when clearSearch != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String query)?  searchPosts,TResult Function()?  loadMoreSearchResults,TResult Function()?  clearSearch,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SearchPostsEvent() when searchPosts != null:
return searchPosts(_that.query);case LoadMoreSearchResultsEvent() when loadMoreSearchResults != null:
return loadMoreSearchResults();case ClearSearchEvent() when clearSearch != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String query)  searchPosts,required TResult Function()  loadMoreSearchResults,required TResult Function()  clearSearch,}) {final _that = this;
switch (_that) {
case SearchPostsEvent():
return searchPosts(_that.query);case LoadMoreSearchResultsEvent():
return loadMoreSearchResults();case ClearSearchEvent():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String query)?  searchPosts,TResult? Function()?  loadMoreSearchResults,TResult? Function()?  clearSearch,}) {final _that = this;
switch (_that) {
case SearchPostsEvent() when searchPosts != null:
return searchPosts(_that.query);case LoadMoreSearchResultsEvent() when loadMoreSearchResults != null:
return loadMoreSearchResults();case ClearSearchEvent() when clearSearch != null:
return clearSearch();case _:
  return null;

}
}

}

/// @nodoc


class SearchPostsEvent implements NewsSearchEvent {
  const SearchPostsEvent({required this.query});
  

 final  String query;

/// Create a copy of NewsSearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchPostsEventCopyWith<SearchPostsEvent> get copyWith => _$SearchPostsEventCopyWithImpl<SearchPostsEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchPostsEvent&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'NewsSearchEvent.searchPosts(query: $query)';
}


}

/// @nodoc
abstract mixin class $SearchPostsEventCopyWith<$Res> implements $NewsSearchEventCopyWith<$Res> {
  factory $SearchPostsEventCopyWith(SearchPostsEvent value, $Res Function(SearchPostsEvent) _then) = _$SearchPostsEventCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$SearchPostsEventCopyWithImpl<$Res>
    implements $SearchPostsEventCopyWith<$Res> {
  _$SearchPostsEventCopyWithImpl(this._self, this._then);

  final SearchPostsEvent _self;
  final $Res Function(SearchPostsEvent) _then;

/// Create a copy of NewsSearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(SearchPostsEvent(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LoadMoreSearchResultsEvent implements NewsSearchEvent {
  const LoadMoreSearchResultsEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadMoreSearchResultsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewsSearchEvent.loadMoreSearchResults()';
}


}




/// @nodoc


class ClearSearchEvent implements NewsSearchEvent {
  const ClearSearchEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearSearchEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewsSearchEvent.clearSearch()';
}


}




/// @nodoc
mixin _$NewsSearchState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsSearchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewsSearchState()';
}


}

/// @nodoc
class $NewsSearchStateCopyWith<$Res>  {
$NewsSearchStateCopyWith(NewsSearchState _, $Res Function(NewsSearchState) __);
}


/// Adds pattern-matching-related methods to [NewsSearchState].
extension NewsSearchStatePatterns on NewsSearchState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<PostEntity> results,  String query,  int page,  bool hasMore,  bool isLoadingMore,  Failure? error)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.results,_that.query,_that.page,_that.hasMore,_that.isLoadingMore,_that.error);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<PostEntity> results,  String query,  int page,  bool hasMore,  bool isLoadingMore,  Failure? error)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.results,_that.query,_that.page,_that.hasMore,_that.isLoadingMore,_that.error);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<PostEntity> results,  String query,  int page,  bool hasMore,  bool isLoadingMore,  Failure? error)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.results,_that.query,_that.page,_that.hasMore,_that.isLoadingMore,_that.error);case _Error() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements NewsSearchState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewsSearchState.initial()';
}


}




/// @nodoc


class _Loading implements NewsSearchState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewsSearchState.loading()';
}


}




/// @nodoc


class _Loaded implements NewsSearchState {
  const _Loaded({required final  List<PostEntity> results, required this.query, this.page = 1, this.hasMore = false, this.isLoadingMore = false, this.error}): _results = results;
  

 final  List<PostEntity> _results;
 List<PostEntity> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

 final  String query;
@JsonKey() final  int page;
@JsonKey() final  bool hasMore;
@JsonKey() final  bool isLoadingMore;
 final  Failure? error;

/// Create a copy of NewsSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.query, query) || other.query == query)&&(identical(other.page, page) || other.page == page)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_results),query,page,hasMore,isLoadingMore,error);

@override
String toString() {
  return 'NewsSearchState.loaded(results: $results, query: $query, page: $page, hasMore: $hasMore, isLoadingMore: $isLoadingMore, error: $error)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $NewsSearchStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<PostEntity> results, String query, int page, bool hasMore, bool isLoadingMore, Failure? error
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of NewsSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? results = null,Object? query = null,Object? page = null,Object? hasMore = null,Object? isLoadingMore = null,Object? error = freezed,}) {
  return _then(_Loaded(
results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<PostEntity>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

/// @nodoc


class _Error implements NewsSearchState {
  const _Error({required this.failure});
  

 final  Failure failure;

/// Create a copy of NewsSearchState
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
  return 'NewsSearchState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $NewsSearchStateCopyWith<$Res> {
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

/// Create a copy of NewsSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(_Error(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
