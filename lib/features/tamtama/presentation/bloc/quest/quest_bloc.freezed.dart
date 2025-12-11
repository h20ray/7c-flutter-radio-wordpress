// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quest_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuestEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuestEvent()';
}


}

/// @nodoc
class $QuestEventCopyWith<$Res>  {
$QuestEventCopyWith(QuestEvent _, $Res Function(QuestEvent) __);
}


/// Adds pattern-matching-related methods to [QuestEvent].
extension QuestEventPatterns on QuestEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadQuestsEvent value)?  load,TResult Function( IncrementProgressEvent value)?  incrementProgress,TResult Function( ClaimQuestEvent value)?  claimQuest,TResult Function( ClaimAllQuestsEvent value)?  claimAll,TResult Function( RefreshQuestsEvent value)?  refresh,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadQuestsEvent() when load != null:
return load(_that);case IncrementProgressEvent() when incrementProgress != null:
return incrementProgress(_that);case ClaimQuestEvent() when claimQuest != null:
return claimQuest(_that);case ClaimAllQuestsEvent() when claimAll != null:
return claimAll(_that);case RefreshQuestsEvent() when refresh != null:
return refresh(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadQuestsEvent value)  load,required TResult Function( IncrementProgressEvent value)  incrementProgress,required TResult Function( ClaimQuestEvent value)  claimQuest,required TResult Function( ClaimAllQuestsEvent value)  claimAll,required TResult Function( RefreshQuestsEvent value)  refresh,}){
final _that = this;
switch (_that) {
case LoadQuestsEvent():
return load(_that);case IncrementProgressEvent():
return incrementProgress(_that);case ClaimQuestEvent():
return claimQuest(_that);case ClaimAllQuestsEvent():
return claimAll(_that);case RefreshQuestsEvent():
return refresh(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadQuestsEvent value)?  load,TResult? Function( IncrementProgressEvent value)?  incrementProgress,TResult? Function( ClaimQuestEvent value)?  claimQuest,TResult? Function( ClaimAllQuestsEvent value)?  claimAll,TResult? Function( RefreshQuestsEvent value)?  refresh,}){
final _that = this;
switch (_that) {
case LoadQuestsEvent() when load != null:
return load(_that);case IncrementProgressEvent() when incrementProgress != null:
return incrementProgress(_that);case ClaimQuestEvent() when claimQuest != null:
return claimQuest(_that);case ClaimAllQuestsEvent() when claimAll != null:
return claimAll(_that);case RefreshQuestsEvent() when refresh != null:
return refresh(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  load,TResult Function( QuestType type,  int amount)?  incrementProgress,TResult Function( String questId)?  claimQuest,TResult Function()?  claimAll,TResult Function()?  refresh,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadQuestsEvent() when load != null:
return load();case IncrementProgressEvent() when incrementProgress != null:
return incrementProgress(_that.type,_that.amount);case ClaimQuestEvent() when claimQuest != null:
return claimQuest(_that.questId);case ClaimAllQuestsEvent() when claimAll != null:
return claimAll();case RefreshQuestsEvent() when refresh != null:
return refresh();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  load,required TResult Function( QuestType type,  int amount)  incrementProgress,required TResult Function( String questId)  claimQuest,required TResult Function()  claimAll,required TResult Function()  refresh,}) {final _that = this;
switch (_that) {
case LoadQuestsEvent():
return load();case IncrementProgressEvent():
return incrementProgress(_that.type,_that.amount);case ClaimQuestEvent():
return claimQuest(_that.questId);case ClaimAllQuestsEvent():
return claimAll();case RefreshQuestsEvent():
return refresh();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  load,TResult? Function( QuestType type,  int amount)?  incrementProgress,TResult? Function( String questId)?  claimQuest,TResult? Function()?  claimAll,TResult? Function()?  refresh,}) {final _that = this;
switch (_that) {
case LoadQuestsEvent() when load != null:
return load();case IncrementProgressEvent() when incrementProgress != null:
return incrementProgress(_that.type,_that.amount);case ClaimQuestEvent() when claimQuest != null:
return claimQuest(_that.questId);case ClaimAllQuestsEvent() when claimAll != null:
return claimAll();case RefreshQuestsEvent() when refresh != null:
return refresh();case _:
  return null;

}
}

}

/// @nodoc


class LoadQuestsEvent implements QuestEvent {
  const LoadQuestsEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadQuestsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuestEvent.load()';
}


}




/// @nodoc


class IncrementProgressEvent implements QuestEvent {
  const IncrementProgressEvent({required this.type, this.amount = 1});
  

 final  QuestType type;
@JsonKey() final  int amount;

/// Create a copy of QuestEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncrementProgressEventCopyWith<IncrementProgressEvent> get copyWith => _$IncrementProgressEventCopyWithImpl<IncrementProgressEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IncrementProgressEvent&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,type,amount);

@override
String toString() {
  return 'QuestEvent.incrementProgress(type: $type, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $IncrementProgressEventCopyWith<$Res> implements $QuestEventCopyWith<$Res> {
  factory $IncrementProgressEventCopyWith(IncrementProgressEvent value, $Res Function(IncrementProgressEvent) _then) = _$IncrementProgressEventCopyWithImpl;
@useResult
$Res call({
 QuestType type, int amount
});




}
/// @nodoc
class _$IncrementProgressEventCopyWithImpl<$Res>
    implements $IncrementProgressEventCopyWith<$Res> {
  _$IncrementProgressEventCopyWithImpl(this._self, this._then);

  final IncrementProgressEvent _self;
  final $Res Function(IncrementProgressEvent) _then;

/// Create a copy of QuestEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = null,Object? amount = null,}) {
  return _then(IncrementProgressEvent(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ClaimQuestEvent implements QuestEvent {
  const ClaimQuestEvent(this.questId);
  

 final  String questId;

/// Create a copy of QuestEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClaimQuestEventCopyWith<ClaimQuestEvent> get copyWith => _$ClaimQuestEventCopyWithImpl<ClaimQuestEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClaimQuestEvent&&(identical(other.questId, questId) || other.questId == questId));
}


@override
int get hashCode => Object.hash(runtimeType,questId);

@override
String toString() {
  return 'QuestEvent.claimQuest(questId: $questId)';
}


}

/// @nodoc
abstract mixin class $ClaimQuestEventCopyWith<$Res> implements $QuestEventCopyWith<$Res> {
  factory $ClaimQuestEventCopyWith(ClaimQuestEvent value, $Res Function(ClaimQuestEvent) _then) = _$ClaimQuestEventCopyWithImpl;
@useResult
$Res call({
 String questId
});




}
/// @nodoc
class _$ClaimQuestEventCopyWithImpl<$Res>
    implements $ClaimQuestEventCopyWith<$Res> {
  _$ClaimQuestEventCopyWithImpl(this._self, this._then);

  final ClaimQuestEvent _self;
  final $Res Function(ClaimQuestEvent) _then;

/// Create a copy of QuestEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? questId = null,}) {
  return _then(ClaimQuestEvent(
null == questId ? _self.questId : questId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ClaimAllQuestsEvent implements QuestEvent {
  const ClaimAllQuestsEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClaimAllQuestsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuestEvent.claimAll()';
}


}




/// @nodoc


class RefreshQuestsEvent implements QuestEvent {
  const RefreshQuestsEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshQuestsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuestEvent.refresh()';
}


}




/// @nodoc
mixin _$QuestState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuestState()';
}


}

/// @nodoc
class $QuestStateCopyWith<$Res>  {
$QuestStateCopyWith(QuestState _, $Res Function(QuestState) __);
}


/// Adds pattern-matching-related methods to [QuestState].
extension QuestStatePatterns on QuestState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( QuestInitial value)?  initial,TResult Function( QuestLoading value)?  loading,TResult Function( QuestLoaded value)?  loaded,TResult Function( QuestError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case QuestInitial() when initial != null:
return initial(_that);case QuestLoading() when loading != null:
return loading(_that);case QuestLoaded() when loaded != null:
return loaded(_that);case QuestError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( QuestInitial value)  initial,required TResult Function( QuestLoading value)  loading,required TResult Function( QuestLoaded value)  loaded,required TResult Function( QuestError value)  error,}){
final _that = this;
switch (_that) {
case QuestInitial():
return initial(_that);case QuestLoading():
return loading(_that);case QuestLoaded():
return loaded(_that);case QuestError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( QuestInitial value)?  initial,TResult? Function( QuestLoading value)?  loading,TResult? Function( QuestLoaded value)?  loaded,TResult? Function( QuestError value)?  error,}){
final _that = this;
switch (_that) {
case QuestInitial() when initial != null:
return initial(_that);case QuestLoading() when loading != null:
return loading(_that);case QuestLoaded() when loaded != null:
return loaded(_that);case QuestError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( DailyQuestsEntity quests)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case QuestInitial() when initial != null:
return initial();case QuestLoading() when loading != null:
return loading();case QuestLoaded() when loaded != null:
return loaded(_that.quests);case QuestError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( DailyQuestsEntity quests)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case QuestInitial():
return initial();case QuestLoading():
return loading();case QuestLoaded():
return loaded(_that.quests);case QuestError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( DailyQuestsEntity quests)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case QuestInitial() when initial != null:
return initial();case QuestLoading() when loading != null:
return loading();case QuestLoaded() when loaded != null:
return loaded(_that.quests);case QuestError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class QuestInitial implements QuestState {
  const QuestInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuestState.initial()';
}


}




/// @nodoc


class QuestLoading implements QuestState {
  const QuestLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuestState.loading()';
}


}




/// @nodoc


class QuestLoaded implements QuestState {
  const QuestLoaded({required this.quests});
  

 final  DailyQuestsEntity quests;

/// Create a copy of QuestState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestLoadedCopyWith<QuestLoaded> get copyWith => _$QuestLoadedCopyWithImpl<QuestLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestLoaded&&(identical(other.quests, quests) || other.quests == quests));
}


@override
int get hashCode => Object.hash(runtimeType,quests);

@override
String toString() {
  return 'QuestState.loaded(quests: $quests)';
}


}

/// @nodoc
abstract mixin class $QuestLoadedCopyWith<$Res> implements $QuestStateCopyWith<$Res> {
  factory $QuestLoadedCopyWith(QuestLoaded value, $Res Function(QuestLoaded) _then) = _$QuestLoadedCopyWithImpl;
@useResult
$Res call({
 DailyQuestsEntity quests
});




}
/// @nodoc
class _$QuestLoadedCopyWithImpl<$Res>
    implements $QuestLoadedCopyWith<$Res> {
  _$QuestLoadedCopyWithImpl(this._self, this._then);

  final QuestLoaded _self;
  final $Res Function(QuestLoaded) _then;

/// Create a copy of QuestState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? quests = null,}) {
  return _then(QuestLoaded(
quests: null == quests ? _self.quests : quests // ignore: cast_nullable_to_non_nullable
as DailyQuestsEntity,
  ));
}


}

/// @nodoc


class QuestError implements QuestState {
  const QuestError(this.message);
  

 final  String message;

/// Create a copy of QuestState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestErrorCopyWith<QuestError> get copyWith => _$QuestErrorCopyWithImpl<QuestError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'QuestState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $QuestErrorCopyWith<$Res> implements $QuestStateCopyWith<$Res> {
  factory $QuestErrorCopyWith(QuestError value, $Res Function(QuestError) _then) = _$QuestErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$QuestErrorCopyWithImpl<$Res>
    implements $QuestErrorCopyWith<$Res> {
  _$QuestErrorCopyWithImpl(this._self, this._then);

  final QuestError _self;
  final $Res Function(QuestError) _then;

/// Create a copy of QuestState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(QuestError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
