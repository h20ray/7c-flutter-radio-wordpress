// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shoutbox_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ShoutboxEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int afterId, int limit) getMessages,
    required TResult Function(String username, String message) sendMessage,
    required TResult Function(int id) deleteMessage,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int afterId, int limit)? getMessages,
    TResult? Function(String username, String message)? sendMessage,
    TResult? Function(int id)? deleteMessage,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int afterId, int limit)? getMessages,
    TResult Function(String username, String message)? sendMessage,
    TResult Function(int id)? deleteMessage,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetMessagesEvent value) getMessages,
    required TResult Function(SendMessageEvent value) sendMessage,
    required TResult Function(DeleteMessageEvent value) deleteMessage,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetMessagesEvent value)? getMessages,
    TResult? Function(SendMessageEvent value)? sendMessage,
    TResult? Function(DeleteMessageEvent value)? deleteMessage,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetMessagesEvent value)? getMessages,
    TResult Function(SendMessageEvent value)? sendMessage,
    TResult Function(DeleteMessageEvent value)? deleteMessage,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShoutboxEventCopyWith<$Res> {
  factory $ShoutboxEventCopyWith(
    ShoutboxEvent value,
    $Res Function(ShoutboxEvent) then,
  ) = _$ShoutboxEventCopyWithImpl<$Res, ShoutboxEvent>;
}

/// @nodoc
class _$ShoutboxEventCopyWithImpl<$Res, $Val extends ShoutboxEvent>
    implements $ShoutboxEventCopyWith<$Res> {
  _$ShoutboxEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShoutboxEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$GetMessagesEventImplCopyWith<$Res> {
  factory _$$GetMessagesEventImplCopyWith(
    _$GetMessagesEventImpl value,
    $Res Function(_$GetMessagesEventImpl) then,
  ) = __$$GetMessagesEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int afterId, int limit});
}

/// @nodoc
class __$$GetMessagesEventImplCopyWithImpl<$Res>
    extends _$ShoutboxEventCopyWithImpl<$Res, _$GetMessagesEventImpl>
    implements _$$GetMessagesEventImplCopyWith<$Res> {
  __$$GetMessagesEventImplCopyWithImpl(
    _$GetMessagesEventImpl _value,
    $Res Function(_$GetMessagesEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShoutboxEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? afterId = null, Object? limit = null}) {
    return _then(
      _$GetMessagesEventImpl(
        afterId: null == afterId
            ? _value.afterId
            : afterId // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$GetMessagesEventImpl implements GetMessagesEvent {
  const _$GetMessagesEventImpl({this.afterId = 0, this.limit = 50});

  @override
  @JsonKey()
  final int afterId;
  @override
  @JsonKey()
  final int limit;

  @override
  String toString() {
    return 'ShoutboxEvent.getMessages(afterId: $afterId, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetMessagesEventImpl &&
            (identical(other.afterId, afterId) || other.afterId == afterId) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, afterId, limit);

  /// Create a copy of ShoutboxEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetMessagesEventImplCopyWith<_$GetMessagesEventImpl> get copyWith =>
      __$$GetMessagesEventImplCopyWithImpl<_$GetMessagesEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int afterId, int limit) getMessages,
    required TResult Function(String username, String message) sendMessage,
    required TResult Function(int id) deleteMessage,
  }) {
    return getMessages(afterId, limit);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int afterId, int limit)? getMessages,
    TResult? Function(String username, String message)? sendMessage,
    TResult? Function(int id)? deleteMessage,
  }) {
    return getMessages?.call(afterId, limit);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int afterId, int limit)? getMessages,
    TResult Function(String username, String message)? sendMessage,
    TResult Function(int id)? deleteMessage,
    required TResult orElse(),
  }) {
    if (getMessages != null) {
      return getMessages(afterId, limit);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetMessagesEvent value) getMessages,
    required TResult Function(SendMessageEvent value) sendMessage,
    required TResult Function(DeleteMessageEvent value) deleteMessage,
  }) {
    return getMessages(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetMessagesEvent value)? getMessages,
    TResult? Function(SendMessageEvent value)? sendMessage,
    TResult? Function(DeleteMessageEvent value)? deleteMessage,
  }) {
    return getMessages?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetMessagesEvent value)? getMessages,
    TResult Function(SendMessageEvent value)? sendMessage,
    TResult Function(DeleteMessageEvent value)? deleteMessage,
    required TResult orElse(),
  }) {
    if (getMessages != null) {
      return getMessages(this);
    }
    return orElse();
  }
}

abstract class GetMessagesEvent implements ShoutboxEvent {
  const factory GetMessagesEvent({final int afterId, final int limit}) =
      _$GetMessagesEventImpl;

  int get afterId;
  int get limit;

  /// Create a copy of ShoutboxEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetMessagesEventImplCopyWith<_$GetMessagesEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SendMessageEventImplCopyWith<$Res> {
  factory _$$SendMessageEventImplCopyWith(
    _$SendMessageEventImpl value,
    $Res Function(_$SendMessageEventImpl) then,
  ) = __$$SendMessageEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String username, String message});
}

/// @nodoc
class __$$SendMessageEventImplCopyWithImpl<$Res>
    extends _$ShoutboxEventCopyWithImpl<$Res, _$SendMessageEventImpl>
    implements _$$SendMessageEventImplCopyWith<$Res> {
  __$$SendMessageEventImplCopyWithImpl(
    _$SendMessageEventImpl _value,
    $Res Function(_$SendMessageEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShoutboxEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? username = null, Object? message = null}) {
    return _then(
      _$SendMessageEventImpl(
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SendMessageEventImpl implements SendMessageEvent {
  const _$SendMessageEventImpl({required this.username, required this.message});

  @override
  final String username;
  @override
  final String message;

  @override
  String toString() {
    return 'ShoutboxEvent.sendMessage(username: $username, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendMessageEventImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, username, message);

  /// Create a copy of ShoutboxEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SendMessageEventImplCopyWith<_$SendMessageEventImpl> get copyWith =>
      __$$SendMessageEventImplCopyWithImpl<_$SendMessageEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int afterId, int limit) getMessages,
    required TResult Function(String username, String message) sendMessage,
    required TResult Function(int id) deleteMessage,
  }) {
    return sendMessage(username, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int afterId, int limit)? getMessages,
    TResult? Function(String username, String message)? sendMessage,
    TResult? Function(int id)? deleteMessage,
  }) {
    return sendMessage?.call(username, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int afterId, int limit)? getMessages,
    TResult Function(String username, String message)? sendMessage,
    TResult Function(int id)? deleteMessage,
    required TResult orElse(),
  }) {
    if (sendMessage != null) {
      return sendMessage(username, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetMessagesEvent value) getMessages,
    required TResult Function(SendMessageEvent value) sendMessage,
    required TResult Function(DeleteMessageEvent value) deleteMessage,
  }) {
    return sendMessage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetMessagesEvent value)? getMessages,
    TResult? Function(SendMessageEvent value)? sendMessage,
    TResult? Function(DeleteMessageEvent value)? deleteMessage,
  }) {
    return sendMessage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetMessagesEvent value)? getMessages,
    TResult Function(SendMessageEvent value)? sendMessage,
    TResult Function(DeleteMessageEvent value)? deleteMessage,
    required TResult orElse(),
  }) {
    if (sendMessage != null) {
      return sendMessage(this);
    }
    return orElse();
  }
}

abstract class SendMessageEvent implements ShoutboxEvent {
  const factory SendMessageEvent({
    required final String username,
    required final String message,
  }) = _$SendMessageEventImpl;

  String get username;
  String get message;

  /// Create a copy of ShoutboxEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SendMessageEventImplCopyWith<_$SendMessageEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteMessageEventImplCopyWith<$Res> {
  factory _$$DeleteMessageEventImplCopyWith(
    _$DeleteMessageEventImpl value,
    $Res Function(_$DeleteMessageEventImpl) then,
  ) = __$$DeleteMessageEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int id});
}

/// @nodoc
class __$$DeleteMessageEventImplCopyWithImpl<$Res>
    extends _$ShoutboxEventCopyWithImpl<$Res, _$DeleteMessageEventImpl>
    implements _$$DeleteMessageEventImplCopyWith<$Res> {
  __$$DeleteMessageEventImplCopyWithImpl(
    _$DeleteMessageEventImpl _value,
    $Res Function(_$DeleteMessageEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShoutboxEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null}) {
    return _then(
      _$DeleteMessageEventImpl(
        null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$DeleteMessageEventImpl implements DeleteMessageEvent {
  const _$DeleteMessageEventImpl(this.id);

  @override
  final int id;

  @override
  String toString() {
    return 'ShoutboxEvent.deleteMessage(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteMessageEventImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  /// Create a copy of ShoutboxEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteMessageEventImplCopyWith<_$DeleteMessageEventImpl> get copyWith =>
      __$$DeleteMessageEventImplCopyWithImpl<_$DeleteMessageEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int afterId, int limit) getMessages,
    required TResult Function(String username, String message) sendMessage,
    required TResult Function(int id) deleteMessage,
  }) {
    return deleteMessage(id);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int afterId, int limit)? getMessages,
    TResult? Function(String username, String message)? sendMessage,
    TResult? Function(int id)? deleteMessage,
  }) {
    return deleteMessage?.call(id);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int afterId, int limit)? getMessages,
    TResult Function(String username, String message)? sendMessage,
    TResult Function(int id)? deleteMessage,
    required TResult orElse(),
  }) {
    if (deleteMessage != null) {
      return deleteMessage(id);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetMessagesEvent value) getMessages,
    required TResult Function(SendMessageEvent value) sendMessage,
    required TResult Function(DeleteMessageEvent value) deleteMessage,
  }) {
    return deleteMessage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetMessagesEvent value)? getMessages,
    TResult? Function(SendMessageEvent value)? sendMessage,
    TResult? Function(DeleteMessageEvent value)? deleteMessage,
  }) {
    return deleteMessage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetMessagesEvent value)? getMessages,
    TResult Function(SendMessageEvent value)? sendMessage,
    TResult Function(DeleteMessageEvent value)? deleteMessage,
    required TResult orElse(),
  }) {
    if (deleteMessage != null) {
      return deleteMessage(this);
    }
    return orElse();
  }
}

abstract class DeleteMessageEvent implements ShoutboxEvent {
  const factory DeleteMessageEvent(final int id) = _$DeleteMessageEventImpl;

  int get id;

  /// Create a copy of ShoutboxEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteMessageEventImplCopyWith<_$DeleteMessageEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ShoutboxState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ShoutboxMessageEntity> messages) loaded,
    required TResult Function(Failure failure) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ShoutboxMessageEntity> messages)? loaded,
    TResult? Function(Failure failure)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ShoutboxMessageEntity> messages)? loaded,
    TResult Function(Failure failure)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShoutboxStateCopyWith<$Res> {
  factory $ShoutboxStateCopyWith(
    ShoutboxState value,
    $Res Function(ShoutboxState) then,
  ) = _$ShoutboxStateCopyWithImpl<$Res, ShoutboxState>;
}

/// @nodoc
class _$ShoutboxStateCopyWithImpl<$Res, $Val extends ShoutboxState>
    implements $ShoutboxStateCopyWith<$Res> {
  _$ShoutboxStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShoutboxState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
    _$InitialImpl value,
    $Res Function(_$InitialImpl) then,
  ) = __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$ShoutboxStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShoutboxState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'ShoutboxState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ShoutboxMessageEntity> messages) loaded,
    required TResult Function(Failure failure) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ShoutboxMessageEntity> messages)? loaded,
    TResult? Function(Failure failure)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ShoutboxMessageEntity> messages)? loaded,
    TResult Function(Failure failure)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements ShoutboxState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
    _$LoadingImpl value,
    $Res Function(_$LoadingImpl) then,
  ) = __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$ShoutboxStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
    _$LoadingImpl _value,
    $Res Function(_$LoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShoutboxState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'ShoutboxState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ShoutboxMessageEntity> messages) loaded,
    required TResult Function(Failure failure) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ShoutboxMessageEntity> messages)? loaded,
    TResult? Function(Failure failure)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ShoutboxMessageEntity> messages)? loaded,
    TResult Function(Failure failure)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements ShoutboxState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$LoadedImplCopyWith<$Res> {
  factory _$$LoadedImplCopyWith(
    _$LoadedImpl value,
    $Res Function(_$LoadedImpl) then,
  ) = __$$LoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<ShoutboxMessageEntity> messages});
}

/// @nodoc
class __$$LoadedImplCopyWithImpl<$Res>
    extends _$ShoutboxStateCopyWithImpl<$Res, _$LoadedImpl>
    implements _$$LoadedImplCopyWith<$Res> {
  __$$LoadedImplCopyWithImpl(
    _$LoadedImpl _value,
    $Res Function(_$LoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShoutboxState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? messages = null}) {
    return _then(
      _$LoadedImpl(
        null == messages
            ? _value._messages
            : messages // ignore: cast_nullable_to_non_nullable
                  as List<ShoutboxMessageEntity>,
      ),
    );
  }
}

/// @nodoc

class _$LoadedImpl implements _Loaded {
  const _$LoadedImpl(final List<ShoutboxMessageEntity> messages)
    : _messages = messages;

  final List<ShoutboxMessageEntity> _messages;
  @override
  List<ShoutboxMessageEntity> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  String toString() {
    return 'ShoutboxState.loaded(messages: $messages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedImpl &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_messages));

  /// Create a copy of ShoutboxState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      __$$LoadedImplCopyWithImpl<_$LoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ShoutboxMessageEntity> messages) loaded,
    required TResult Function(Failure failure) error,
  }) {
    return loaded(messages);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ShoutboxMessageEntity> messages)? loaded,
    TResult? Function(Failure failure)? error,
  }) {
    return loaded?.call(messages);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ShoutboxMessageEntity> messages)? loaded,
    TResult Function(Failure failure)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(messages);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _Loaded implements ShoutboxState {
  const factory _Loaded(final List<ShoutboxMessageEntity> messages) =
      _$LoadedImpl;

  List<ShoutboxMessageEntity> get messages;

  /// Create a copy of ShoutboxState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
    _$ErrorImpl value,
    $Res Function(_$ErrorImpl) then,
  ) = __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Failure failure});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$ShoutboxStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
    _$ErrorImpl _value,
    $Res Function(_$ErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShoutboxState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? failure = null}) {
    return _then(
      _$ErrorImpl(
        null == failure
            ? _value.failure
            : failure // ignore: cast_nullable_to_non_nullable
                  as Failure,
      ),
    );
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.failure);

  @override
  final Failure failure;

  @override
  String toString() {
    return 'ShoutboxState.error(failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  /// Create a copy of ShoutboxState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ShoutboxMessageEntity> messages) loaded,
    required TResult Function(Failure failure) error,
  }) {
    return error(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ShoutboxMessageEntity> messages)? loaded,
    TResult? Function(Failure failure)? error,
  }) {
    return error?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ShoutboxMessageEntity> messages)? loaded,
    TResult Function(Failure failure)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements ShoutboxState {
  const factory _Error(final Failure failure) = _$ErrorImpl;

  Failure get failure;

  /// Create a copy of ShoutboxState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
