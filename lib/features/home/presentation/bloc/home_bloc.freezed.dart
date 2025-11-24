// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent()';
}


}

/// @nodoc
class $HomeEventCopyWith<$Res>  {
$HomeEventCopyWith(HomeEvent _, $Res Function(HomeEvent) __);
}


/// Adds pattern-matching-related methods to [HomeEvent].
extension HomeEventPatterns on HomeEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TabChangedEvent value)?  tabChanged,TResult Function( FilterChipSelectedEvent value)?  filterChipSelected,TResult Function( LoadFeaturedContentEvent value)?  loadFeaturedContent,TResult Function( NowPlayingUpdatedEvent value)?  nowPlayingUpdated,TResult Function( NowPlayingErrorEvent value)?  nowPlayingError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TabChangedEvent() when tabChanged != null:
return tabChanged(_that);case FilterChipSelectedEvent() when filterChipSelected != null:
return filterChipSelected(_that);case LoadFeaturedContentEvent() when loadFeaturedContent != null:
return loadFeaturedContent(_that);case NowPlayingUpdatedEvent() when nowPlayingUpdated != null:
return nowPlayingUpdated(_that);case NowPlayingErrorEvent() when nowPlayingError != null:
return nowPlayingError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TabChangedEvent value)  tabChanged,required TResult Function( FilterChipSelectedEvent value)  filterChipSelected,required TResult Function( LoadFeaturedContentEvent value)  loadFeaturedContent,required TResult Function( NowPlayingUpdatedEvent value)  nowPlayingUpdated,required TResult Function( NowPlayingErrorEvent value)  nowPlayingError,}){
final _that = this;
switch (_that) {
case TabChangedEvent():
return tabChanged(_that);case FilterChipSelectedEvent():
return filterChipSelected(_that);case LoadFeaturedContentEvent():
return loadFeaturedContent(_that);case NowPlayingUpdatedEvent():
return nowPlayingUpdated(_that);case NowPlayingErrorEvent():
return nowPlayingError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TabChangedEvent value)?  tabChanged,TResult? Function( FilterChipSelectedEvent value)?  filterChipSelected,TResult? Function( LoadFeaturedContentEvent value)?  loadFeaturedContent,TResult? Function( NowPlayingUpdatedEvent value)?  nowPlayingUpdated,TResult? Function( NowPlayingErrorEvent value)?  nowPlayingError,}){
final _that = this;
switch (_that) {
case TabChangedEvent() when tabChanged != null:
return tabChanged(_that);case FilterChipSelectedEvent() when filterChipSelected != null:
return filterChipSelected(_that);case LoadFeaturedContentEvent() when loadFeaturedContent != null:
return loadFeaturedContent(_that);case NowPlayingUpdatedEvent() when nowPlayingUpdated != null:
return nowPlayingUpdated(_that);case NowPlayingErrorEvent() when nowPlayingError != null:
return nowPlayingError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int tabIndex)?  tabChanged,TResult Function( String category)?  filterChipSelected,TResult Function()?  loadFeaturedContent,TResult Function( NowPlayingEntity nowPlaying)?  nowPlayingUpdated,TResult Function( String message)?  nowPlayingError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TabChangedEvent() when tabChanged != null:
return tabChanged(_that.tabIndex);case FilterChipSelectedEvent() when filterChipSelected != null:
return filterChipSelected(_that.category);case LoadFeaturedContentEvent() when loadFeaturedContent != null:
return loadFeaturedContent();case NowPlayingUpdatedEvent() when nowPlayingUpdated != null:
return nowPlayingUpdated(_that.nowPlaying);case NowPlayingErrorEvent() when nowPlayingError != null:
return nowPlayingError(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int tabIndex)  tabChanged,required TResult Function( String category)  filterChipSelected,required TResult Function()  loadFeaturedContent,required TResult Function( NowPlayingEntity nowPlaying)  nowPlayingUpdated,required TResult Function( String message)  nowPlayingError,}) {final _that = this;
switch (_that) {
case TabChangedEvent():
return tabChanged(_that.tabIndex);case FilterChipSelectedEvent():
return filterChipSelected(_that.category);case LoadFeaturedContentEvent():
return loadFeaturedContent();case NowPlayingUpdatedEvent():
return nowPlayingUpdated(_that.nowPlaying);case NowPlayingErrorEvent():
return nowPlayingError(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int tabIndex)?  tabChanged,TResult? Function( String category)?  filterChipSelected,TResult? Function()?  loadFeaturedContent,TResult? Function( NowPlayingEntity nowPlaying)?  nowPlayingUpdated,TResult? Function( String message)?  nowPlayingError,}) {final _that = this;
switch (_that) {
case TabChangedEvent() when tabChanged != null:
return tabChanged(_that.tabIndex);case FilterChipSelectedEvent() when filterChipSelected != null:
return filterChipSelected(_that.category);case LoadFeaturedContentEvent() when loadFeaturedContent != null:
return loadFeaturedContent();case NowPlayingUpdatedEvent() when nowPlayingUpdated != null:
return nowPlayingUpdated(_that.nowPlaying);case NowPlayingErrorEvent() when nowPlayingError != null:
return nowPlayingError(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class TabChangedEvent implements HomeEvent {
  const TabChangedEvent(this.tabIndex);
  

 final  int tabIndex;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TabChangedEventCopyWith<TabChangedEvent> get copyWith => _$TabChangedEventCopyWithImpl<TabChangedEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TabChangedEvent&&(identical(other.tabIndex, tabIndex) || other.tabIndex == tabIndex));
}


@override
int get hashCode => Object.hash(runtimeType,tabIndex);

@override
String toString() {
  return 'HomeEvent.tabChanged(tabIndex: $tabIndex)';
}


}

/// @nodoc
abstract mixin class $TabChangedEventCopyWith<$Res> implements $HomeEventCopyWith<$Res> {
  factory $TabChangedEventCopyWith(TabChangedEvent value, $Res Function(TabChangedEvent) _then) = _$TabChangedEventCopyWithImpl;
@useResult
$Res call({
 int tabIndex
});




}
/// @nodoc
class _$TabChangedEventCopyWithImpl<$Res>
    implements $TabChangedEventCopyWith<$Res> {
  _$TabChangedEventCopyWithImpl(this._self, this._then);

  final TabChangedEvent _self;
  final $Res Function(TabChangedEvent) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tabIndex = null,}) {
  return _then(TabChangedEvent(
null == tabIndex ? _self.tabIndex : tabIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class FilterChipSelectedEvent implements HomeEvent {
  const FilterChipSelectedEvent(this.category);
  

 final  String category;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilterChipSelectedEventCopyWith<FilterChipSelectedEvent> get copyWith => _$FilterChipSelectedEventCopyWithImpl<FilterChipSelectedEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterChipSelectedEvent&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode => Object.hash(runtimeType,category);

@override
String toString() {
  return 'HomeEvent.filterChipSelected(category: $category)';
}


}

/// @nodoc
abstract mixin class $FilterChipSelectedEventCopyWith<$Res> implements $HomeEventCopyWith<$Res> {
  factory $FilterChipSelectedEventCopyWith(FilterChipSelectedEvent value, $Res Function(FilterChipSelectedEvent) _then) = _$FilterChipSelectedEventCopyWithImpl;
@useResult
$Res call({
 String category
});




}
/// @nodoc
class _$FilterChipSelectedEventCopyWithImpl<$Res>
    implements $FilterChipSelectedEventCopyWith<$Res> {
  _$FilterChipSelectedEventCopyWithImpl(this._self, this._then);

  final FilterChipSelectedEvent _self;
  final $Res Function(FilterChipSelectedEvent) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? category = null,}) {
  return _then(FilterChipSelectedEvent(
null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LoadFeaturedContentEvent implements HomeEvent {
  const LoadFeaturedContentEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadFeaturedContentEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.loadFeaturedContent()';
}


}




/// @nodoc


class NowPlayingUpdatedEvent implements HomeEvent {
  const NowPlayingUpdatedEvent(this.nowPlaying);
  

 final  NowPlayingEntity nowPlaying;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NowPlayingUpdatedEventCopyWith<NowPlayingUpdatedEvent> get copyWith => _$NowPlayingUpdatedEventCopyWithImpl<NowPlayingUpdatedEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NowPlayingUpdatedEvent&&(identical(other.nowPlaying, nowPlaying) || other.nowPlaying == nowPlaying));
}


@override
int get hashCode => Object.hash(runtimeType,nowPlaying);

@override
String toString() {
  return 'HomeEvent.nowPlayingUpdated(nowPlaying: $nowPlaying)';
}


}

/// @nodoc
abstract mixin class $NowPlayingUpdatedEventCopyWith<$Res> implements $HomeEventCopyWith<$Res> {
  factory $NowPlayingUpdatedEventCopyWith(NowPlayingUpdatedEvent value, $Res Function(NowPlayingUpdatedEvent) _then) = _$NowPlayingUpdatedEventCopyWithImpl;
@useResult
$Res call({
 NowPlayingEntity nowPlaying
});




}
/// @nodoc
class _$NowPlayingUpdatedEventCopyWithImpl<$Res>
    implements $NowPlayingUpdatedEventCopyWith<$Res> {
  _$NowPlayingUpdatedEventCopyWithImpl(this._self, this._then);

  final NowPlayingUpdatedEvent _self;
  final $Res Function(NowPlayingUpdatedEvent) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? nowPlaying = null,}) {
  return _then(NowPlayingUpdatedEvent(
null == nowPlaying ? _self.nowPlaying : nowPlaying // ignore: cast_nullable_to_non_nullable
as NowPlayingEntity,
  ));
}


}

/// @nodoc


class NowPlayingErrorEvent implements HomeEvent {
  const NowPlayingErrorEvent(this.message);
  

 final  String message;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NowPlayingErrorEventCopyWith<NowPlayingErrorEvent> get copyWith => _$NowPlayingErrorEventCopyWithImpl<NowPlayingErrorEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NowPlayingErrorEvent&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'HomeEvent.nowPlayingError(message: $message)';
}


}

/// @nodoc
abstract mixin class $NowPlayingErrorEventCopyWith<$Res> implements $HomeEventCopyWith<$Res> {
  factory $NowPlayingErrorEventCopyWith(NowPlayingErrorEvent value, $Res Function(NowPlayingErrorEvent) _then) = _$NowPlayingErrorEventCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$NowPlayingErrorEventCopyWithImpl<$Res>
    implements $NowPlayingErrorEventCopyWith<$Res> {
  _$NowPlayingErrorEventCopyWithImpl(this._self, this._then);

  final NowPlayingErrorEvent _self;
  final $Res Function(NowPlayingErrorEvent) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(NowPlayingErrorEvent(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$HomeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeState()';
}


}

/// @nodoc
class $HomeStateCopyWith<$Res>  {
$HomeStateCopyWith(HomeState _, $Res Function(HomeState) __);
}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( int selectedTabIndex,  String? selectedCategory,  NowPlayingEntity nowPlaying,  String? nowPlayingError)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.selectedTabIndex,_that.selectedCategory,_that.nowPlaying,_that.nowPlayingError);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( int selectedTabIndex,  String? selectedCategory,  NowPlayingEntity nowPlaying,  String? nowPlayingError)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.selectedTabIndex,_that.selectedCategory,_that.nowPlaying,_that.nowPlayingError);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( int selectedTabIndex,  String? selectedCategory,  NowPlayingEntity nowPlaying,  String? nowPlayingError)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.selectedTabIndex,_that.selectedCategory,_that.nowPlaying,_that.nowPlayingError);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements HomeState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeState.initial()';
}


}




/// @nodoc


class _Loading implements HomeState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeState.loading()';
}


}




/// @nodoc


class _Loaded implements HomeState {
  const _Loaded({required this.selectedTabIndex, required this.selectedCategory, required this.nowPlaying, this.nowPlayingError});
  

 final  int selectedTabIndex;
 final  String? selectedCategory;
 final  NowPlayingEntity nowPlaying;
 final  String? nowPlayingError;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.selectedTabIndex, selectedTabIndex) || other.selectedTabIndex == selectedTabIndex)&&(identical(other.selectedCategory, selectedCategory) || other.selectedCategory == selectedCategory)&&(identical(other.nowPlaying, nowPlaying) || other.nowPlaying == nowPlaying)&&(identical(other.nowPlayingError, nowPlayingError) || other.nowPlayingError == nowPlayingError));
}


@override
int get hashCode => Object.hash(runtimeType,selectedTabIndex,selectedCategory,nowPlaying,nowPlayingError);

@override
String toString() {
  return 'HomeState.loaded(selectedTabIndex: $selectedTabIndex, selectedCategory: $selectedCategory, nowPlaying: $nowPlaying, nowPlayingError: $nowPlayingError)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 int selectedTabIndex, String? selectedCategory, NowPlayingEntity nowPlaying, String? nowPlayingError
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? selectedTabIndex = null,Object? selectedCategory = freezed,Object? nowPlaying = null,Object? nowPlayingError = freezed,}) {
  return _then(_Loaded(
selectedTabIndex: null == selectedTabIndex ? _self.selectedTabIndex : selectedTabIndex // ignore: cast_nullable_to_non_nullable
as int,selectedCategory: freezed == selectedCategory ? _self.selectedCategory : selectedCategory // ignore: cast_nullable_to_non_nullable
as String?,nowPlaying: null == nowPlaying ? _self.nowPlaying : nowPlaying // ignore: cast_nullable_to_non_nullable
as NowPlayingEntity,nowPlayingError: freezed == nowPlayingError ? _self.nowPlayingError : nowPlayingError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Error implements HomeState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of HomeState
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
  return 'HomeState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
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

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
