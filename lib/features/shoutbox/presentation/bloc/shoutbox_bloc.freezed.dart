// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shoutbox_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShoutboxEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShoutboxEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ShoutboxEvent()';
}


}

/// @nodoc
class $ShoutboxEventCopyWith<$Res>  {
$ShoutboxEventCopyWith(ShoutboxEvent _, $Res Function(ShoutboxEvent) __);
}


/// Adds pattern-matching-related methods to [ShoutboxEvent].
extension ShoutboxEventPatterns on ShoutboxEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GetMessagesEvent value)?  getMessages,TResult Function( RefreshMessagesEvent value)?  refreshMessages,TResult Function( SendMessageEvent value)?  sendMessage,TResult Function( DeleteMessageEvent value)?  deleteMessage,TResult Function( ClearMessagesEvent value)?  clearMessages,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GetMessagesEvent() when getMessages != null:
return getMessages(_that);case RefreshMessagesEvent() when refreshMessages != null:
return refreshMessages(_that);case SendMessageEvent() when sendMessage != null:
return sendMessage(_that);case DeleteMessageEvent() when deleteMessage != null:
return deleteMessage(_that);case ClearMessagesEvent() when clearMessages != null:
return clearMessages(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GetMessagesEvent value)  getMessages,required TResult Function( RefreshMessagesEvent value)  refreshMessages,required TResult Function( SendMessageEvent value)  sendMessage,required TResult Function( DeleteMessageEvent value)  deleteMessage,required TResult Function( ClearMessagesEvent value)  clearMessages,}){
final _that = this;
switch (_that) {
case GetMessagesEvent():
return getMessages(_that);case RefreshMessagesEvent():
return refreshMessages(_that);case SendMessageEvent():
return sendMessage(_that);case DeleteMessageEvent():
return deleteMessage(_that);case ClearMessagesEvent():
return clearMessages(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GetMessagesEvent value)?  getMessages,TResult? Function( RefreshMessagesEvent value)?  refreshMessages,TResult? Function( SendMessageEvent value)?  sendMessage,TResult? Function( DeleteMessageEvent value)?  deleteMessage,TResult? Function( ClearMessagesEvent value)?  clearMessages,}){
final _that = this;
switch (_that) {
case GetMessagesEvent() when getMessages != null:
return getMessages(_that);case RefreshMessagesEvent() when refreshMessages != null:
return refreshMessages(_that);case SendMessageEvent() when sendMessage != null:
return sendMessage(_that);case DeleteMessageEvent() when deleteMessage != null:
return deleteMessage(_that);case ClearMessagesEvent() when clearMessages != null:
return clearMessages(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int limit)?  getMessages,TResult Function( int limit)?  refreshMessages,TResult Function( String username,  String message)?  sendMessage,TResult Function( int id)?  deleteMessage,TResult Function()?  clearMessages,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GetMessagesEvent() when getMessages != null:
return getMessages(_that.limit);case RefreshMessagesEvent() when refreshMessages != null:
return refreshMessages(_that.limit);case SendMessageEvent() when sendMessage != null:
return sendMessage(_that.username,_that.message);case DeleteMessageEvent() when deleteMessage != null:
return deleteMessage(_that.id);case ClearMessagesEvent() when clearMessages != null:
return clearMessages();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int limit)  getMessages,required TResult Function( int limit)  refreshMessages,required TResult Function( String username,  String message)  sendMessage,required TResult Function( int id)  deleteMessage,required TResult Function()  clearMessages,}) {final _that = this;
switch (_that) {
case GetMessagesEvent():
return getMessages(_that.limit);case RefreshMessagesEvent():
return refreshMessages(_that.limit);case SendMessageEvent():
return sendMessage(_that.username,_that.message);case DeleteMessageEvent():
return deleteMessage(_that.id);case ClearMessagesEvent():
return clearMessages();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int limit)?  getMessages,TResult? Function( int limit)?  refreshMessages,TResult? Function( String username,  String message)?  sendMessage,TResult? Function( int id)?  deleteMessage,TResult? Function()?  clearMessages,}) {final _that = this;
switch (_that) {
case GetMessagesEvent() when getMessages != null:
return getMessages(_that.limit);case RefreshMessagesEvent() when refreshMessages != null:
return refreshMessages(_that.limit);case SendMessageEvent() when sendMessage != null:
return sendMessage(_that.username,_that.message);case DeleteMessageEvent() when deleteMessage != null:
return deleteMessage(_that.id);case ClearMessagesEvent() when clearMessages != null:
return clearMessages();case _:
  return null;

}
}

}

/// @nodoc


class GetMessagesEvent implements ShoutboxEvent {
  const GetMessagesEvent({this.limit = 50});
  

@JsonKey() final  int limit;

/// Create a copy of ShoutboxEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetMessagesEventCopyWith<GetMessagesEvent> get copyWith => _$GetMessagesEventCopyWithImpl<GetMessagesEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetMessagesEvent&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode => Object.hash(runtimeType,limit);

@override
String toString() {
  return 'ShoutboxEvent.getMessages(limit: $limit)';
}


}

/// @nodoc
abstract mixin class $GetMessagesEventCopyWith<$Res> implements $ShoutboxEventCopyWith<$Res> {
  factory $GetMessagesEventCopyWith(GetMessagesEvent value, $Res Function(GetMessagesEvent) _then) = _$GetMessagesEventCopyWithImpl;
@useResult
$Res call({
 int limit
});




}
/// @nodoc
class _$GetMessagesEventCopyWithImpl<$Res>
    implements $GetMessagesEventCopyWith<$Res> {
  _$GetMessagesEventCopyWithImpl(this._self, this._then);

  final GetMessagesEvent _self;
  final $Res Function(GetMessagesEvent) _then;

/// Create a copy of ShoutboxEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? limit = null,}) {
  return _then(GetMessagesEvent(
limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class RefreshMessagesEvent implements ShoutboxEvent {
  const RefreshMessagesEvent({this.limit = 50});
  

@JsonKey() final  int limit;

/// Create a copy of ShoutboxEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RefreshMessagesEventCopyWith<RefreshMessagesEvent> get copyWith => _$RefreshMessagesEventCopyWithImpl<RefreshMessagesEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshMessagesEvent&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode => Object.hash(runtimeType,limit);

@override
String toString() {
  return 'ShoutboxEvent.refreshMessages(limit: $limit)';
}


}

/// @nodoc
abstract mixin class $RefreshMessagesEventCopyWith<$Res> implements $ShoutboxEventCopyWith<$Res> {
  factory $RefreshMessagesEventCopyWith(RefreshMessagesEvent value, $Res Function(RefreshMessagesEvent) _then) = _$RefreshMessagesEventCopyWithImpl;
@useResult
$Res call({
 int limit
});




}
/// @nodoc
class _$RefreshMessagesEventCopyWithImpl<$Res>
    implements $RefreshMessagesEventCopyWith<$Res> {
  _$RefreshMessagesEventCopyWithImpl(this._self, this._then);

  final RefreshMessagesEvent _self;
  final $Res Function(RefreshMessagesEvent) _then;

/// Create a copy of ShoutboxEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? limit = null,}) {
  return _then(RefreshMessagesEvent(
limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class SendMessageEvent implements ShoutboxEvent {
  const SendMessageEvent({required this.username, required this.message});
  

 final  String username;
 final  String message;

/// Create a copy of ShoutboxEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendMessageEventCopyWith<SendMessageEvent> get copyWith => _$SendMessageEventCopyWithImpl<SendMessageEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendMessageEvent&&(identical(other.username, username) || other.username == username)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,username,message);

@override
String toString() {
  return 'ShoutboxEvent.sendMessage(username: $username, message: $message)';
}


}

/// @nodoc
abstract mixin class $SendMessageEventCopyWith<$Res> implements $ShoutboxEventCopyWith<$Res> {
  factory $SendMessageEventCopyWith(SendMessageEvent value, $Res Function(SendMessageEvent) _then) = _$SendMessageEventCopyWithImpl;
@useResult
$Res call({
 String username, String message
});




}
/// @nodoc
class _$SendMessageEventCopyWithImpl<$Res>
    implements $SendMessageEventCopyWith<$Res> {
  _$SendMessageEventCopyWithImpl(this._self, this._then);

  final SendMessageEvent _self;
  final $Res Function(SendMessageEvent) _then;

/// Create a copy of ShoutboxEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? username = null,Object? message = null,}) {
  return _then(SendMessageEvent(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DeleteMessageEvent implements ShoutboxEvent {
  const DeleteMessageEvent(this.id);
  

 final  int id;

/// Create a copy of ShoutboxEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteMessageEventCopyWith<DeleteMessageEvent> get copyWith => _$DeleteMessageEventCopyWithImpl<DeleteMessageEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteMessageEvent&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'ShoutboxEvent.deleteMessage(id: $id)';
}


}

/// @nodoc
abstract mixin class $DeleteMessageEventCopyWith<$Res> implements $ShoutboxEventCopyWith<$Res> {
  factory $DeleteMessageEventCopyWith(DeleteMessageEvent value, $Res Function(DeleteMessageEvent) _then) = _$DeleteMessageEventCopyWithImpl;
@useResult
$Res call({
 int id
});




}
/// @nodoc
class _$DeleteMessageEventCopyWithImpl<$Res>
    implements $DeleteMessageEventCopyWith<$Res> {
  _$DeleteMessageEventCopyWithImpl(this._self, this._then);

  final DeleteMessageEvent _self;
  final $Res Function(DeleteMessageEvent) _then;

/// Create a copy of ShoutboxEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(DeleteMessageEvent(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ClearMessagesEvent implements ShoutboxEvent {
  const ClearMessagesEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearMessagesEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ShoutboxEvent.clearMessages()';
}


}




/// @nodoc
mixin _$ShoutboxState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShoutboxState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ShoutboxState()';
}


}

/// @nodoc
class $ShoutboxStateCopyWith<$Res>  {
$ShoutboxStateCopyWith(ShoutboxState _, $Res Function(ShoutboxState) __);
}


/// Adds pattern-matching-related methods to [ShoutboxState].
extension ShoutboxStatePatterns on ShoutboxState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Refreshing value)?  refreshing,TResult Function( _Sending value)?  sending,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Refreshing() when refreshing != null:
return refreshing(_that);case _Sending() when sending != null:
return sending(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Refreshing value)  refreshing,required TResult Function( _Sending value)  sending,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Refreshing():
return refreshing(_that);case _Sending():
return sending(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Refreshing value)?  refreshing,TResult? Function( _Sending value)?  sending,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Refreshing() when refreshing != null:
return refreshing(_that);case _Sending() when sending != null:
return sending(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ShoutboxMessageEntity> messages,  int lastId)?  loaded,TResult Function( List<ShoutboxMessageEntity> messages,  int lastId)?  refreshing,TResult Function( List<ShoutboxMessageEntity> messages,  int lastId)?  sending,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.messages,_that.lastId);case _Refreshing() when refreshing != null:
return refreshing(_that.messages,_that.lastId);case _Sending() when sending != null:
return sending(_that.messages,_that.lastId);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ShoutboxMessageEntity> messages,  int lastId)  loaded,required TResult Function( List<ShoutboxMessageEntity> messages,  int lastId)  refreshing,required TResult Function( List<ShoutboxMessageEntity> messages,  int lastId)  sending,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.messages,_that.lastId);case _Refreshing():
return refreshing(_that.messages,_that.lastId);case _Sending():
return sending(_that.messages,_that.lastId);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ShoutboxMessageEntity> messages,  int lastId)?  loaded,TResult? Function( List<ShoutboxMessageEntity> messages,  int lastId)?  refreshing,TResult? Function( List<ShoutboxMessageEntity> messages,  int lastId)?  sending,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.messages,_that.lastId);case _Refreshing() when refreshing != null:
return refreshing(_that.messages,_that.lastId);case _Sending() when sending != null:
return sending(_that.messages,_that.lastId);case _Error() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements ShoutboxState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ShoutboxState.initial()';
}


}




/// @nodoc


class _Loading implements ShoutboxState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ShoutboxState.loading()';
}


}




/// @nodoc


class _Loaded implements ShoutboxState {
  const _Loaded(final  List<ShoutboxMessageEntity> messages, {this.lastId = 0}): _messages = messages;
  

 final  List<ShoutboxMessageEntity> _messages;
 List<ShoutboxMessageEntity> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@JsonKey() final  int lastId;

/// Create a copy of ShoutboxState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.lastId, lastId) || other.lastId == lastId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),lastId);

@override
String toString() {
  return 'ShoutboxState.loaded(messages: $messages, lastId: $lastId)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $ShoutboxStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<ShoutboxMessageEntity> messages, int lastId
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of ShoutboxState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? lastId = null,}) {
  return _then(_Loaded(
null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ShoutboxMessageEntity>,lastId: null == lastId ? _self.lastId : lastId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _Refreshing implements ShoutboxState {
  const _Refreshing(final  List<ShoutboxMessageEntity> messages, {this.lastId = 0}): _messages = messages;
  

 final  List<ShoutboxMessageEntity> _messages;
 List<ShoutboxMessageEntity> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@JsonKey() final  int lastId;

/// Create a copy of ShoutboxState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RefreshingCopyWith<_Refreshing> get copyWith => __$RefreshingCopyWithImpl<_Refreshing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Refreshing&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.lastId, lastId) || other.lastId == lastId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),lastId);

@override
String toString() {
  return 'ShoutboxState.refreshing(messages: $messages, lastId: $lastId)';
}


}

/// @nodoc
abstract mixin class _$RefreshingCopyWith<$Res> implements $ShoutboxStateCopyWith<$Res> {
  factory _$RefreshingCopyWith(_Refreshing value, $Res Function(_Refreshing) _then) = __$RefreshingCopyWithImpl;
@useResult
$Res call({
 List<ShoutboxMessageEntity> messages, int lastId
});




}
/// @nodoc
class __$RefreshingCopyWithImpl<$Res>
    implements _$RefreshingCopyWith<$Res> {
  __$RefreshingCopyWithImpl(this._self, this._then);

  final _Refreshing _self;
  final $Res Function(_Refreshing) _then;

/// Create a copy of ShoutboxState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? lastId = null,}) {
  return _then(_Refreshing(
null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ShoutboxMessageEntity>,lastId: null == lastId ? _self.lastId : lastId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _Sending implements ShoutboxState {
  const _Sending(final  List<ShoutboxMessageEntity> messages, {this.lastId = 0}): _messages = messages;
  

 final  List<ShoutboxMessageEntity> _messages;
 List<ShoutboxMessageEntity> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@JsonKey() final  int lastId;

/// Create a copy of ShoutboxState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendingCopyWith<_Sending> get copyWith => __$SendingCopyWithImpl<_Sending>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Sending&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.lastId, lastId) || other.lastId == lastId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),lastId);

@override
String toString() {
  return 'ShoutboxState.sending(messages: $messages, lastId: $lastId)';
}


}

/// @nodoc
abstract mixin class _$SendingCopyWith<$Res> implements $ShoutboxStateCopyWith<$Res> {
  factory _$SendingCopyWith(_Sending value, $Res Function(_Sending) _then) = __$SendingCopyWithImpl;
@useResult
$Res call({
 List<ShoutboxMessageEntity> messages, int lastId
});




}
/// @nodoc
class __$SendingCopyWithImpl<$Res>
    implements _$SendingCopyWith<$Res> {
  __$SendingCopyWithImpl(this._self, this._then);

  final _Sending _self;
  final $Res Function(_Sending) _then;

/// Create a copy of ShoutboxState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? lastId = null,}) {
  return _then(_Sending(
null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ShoutboxMessageEntity>,lastId: null == lastId ? _self.lastId : lastId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _Error implements ShoutboxState {
  const _Error(this.failure);
  

 final  Failure failure;

/// Create a copy of ShoutboxState
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
  return 'ShoutboxState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ShoutboxStateCopyWith<$Res> {
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

/// Create a copy of ShoutboxState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(_Error(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
