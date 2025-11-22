// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'radio_player_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RadioPlayerEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(RadioEntity config, bool autoPlay) initialize,
    required TResult Function() play,
    required TResult Function() pause,
    required TResult Function() togglePlayPause,
    required TResult Function() reset,
    required TResult Function(bool isPlaying) playbackStateChanged,
    required TResult Function(String? artist, String? title) metadataUpdated,
    required TResult Function(String albumArtUrl) albumArtFetched,
    required TResult Function(String message) errorOccurred,
    required TResult Function(String state) stateChanged,
    required TResult Function(int attempt, String reason) retrying,
    required TResult Function(String artist, String title, String? artworkUrl)
    setCustomMetadata,
    required TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )
    updateStation,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(RadioEntity config, bool autoPlay)? initialize,
    TResult? Function()? play,
    TResult? Function()? pause,
    TResult? Function()? togglePlayPause,
    TResult? Function()? reset,
    TResult? Function(bool isPlaying)? playbackStateChanged,
    TResult? Function(String? artist, String? title)? metadataUpdated,
    TResult? Function(String albumArtUrl)? albumArtFetched,
    TResult? Function(String message)? errorOccurred,
    TResult? Function(String state)? stateChanged,
    TResult? Function(int attempt, String reason)? retrying,
    TResult? Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult? Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(RadioEntity config, bool autoPlay)? initialize,
    TResult Function()? play,
    TResult Function()? pause,
    TResult Function()? togglePlayPause,
    TResult Function()? reset,
    TResult Function(bool isPlaying)? playbackStateChanged,
    TResult Function(String? artist, String? title)? metadataUpdated,
    TResult Function(String albumArtUrl)? albumArtFetched,
    TResult Function(String message)? errorOccurred,
    TResult Function(String state)? stateChanged,
    TResult Function(int attempt, String reason)? retrying,
    TResult Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_Play value) play,
    required TResult Function(_Pause value) pause,
    required TResult Function(_TogglePlayPause value) togglePlayPause,
    required TResult Function(_Reset value) reset,
    required TResult Function(_PlaybackStateChanged value) playbackStateChanged,
    required TResult Function(_MetadataUpdated value) metadataUpdated,
    required TResult Function(_AlbumArtFetched value) albumArtFetched,
    required TResult Function(_ErrorOccurred value) errorOccurred,
    required TResult Function(_StateChanged value) stateChanged,
    required TResult Function(_Retrying value) retrying,
    required TResult Function(_SetCustomMetadata value) setCustomMetadata,
    required TResult Function(_UpdateStation value) updateStation,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_Play value)? play,
    TResult? Function(_Pause value)? pause,
    TResult? Function(_TogglePlayPause value)? togglePlayPause,
    TResult? Function(_Reset value)? reset,
    TResult? Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult? Function(_MetadataUpdated value)? metadataUpdated,
    TResult? Function(_AlbumArtFetched value)? albumArtFetched,
    TResult? Function(_ErrorOccurred value)? errorOccurred,
    TResult? Function(_StateChanged value)? stateChanged,
    TResult? Function(_Retrying value)? retrying,
    TResult? Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult? Function(_UpdateStation value)? updateStation,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_Play value)? play,
    TResult Function(_Pause value)? pause,
    TResult Function(_TogglePlayPause value)? togglePlayPause,
    TResult Function(_Reset value)? reset,
    TResult Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult Function(_MetadataUpdated value)? metadataUpdated,
    TResult Function(_AlbumArtFetched value)? albumArtFetched,
    TResult Function(_ErrorOccurred value)? errorOccurred,
    TResult Function(_StateChanged value)? stateChanged,
    TResult Function(_Retrying value)? retrying,
    TResult Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult Function(_UpdateStation value)? updateStation,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RadioPlayerEventCopyWith<$Res> {
  factory $RadioPlayerEventCopyWith(
    RadioPlayerEvent value,
    $Res Function(RadioPlayerEvent) then,
  ) = _$RadioPlayerEventCopyWithImpl<$Res, RadioPlayerEvent>;
}

/// @nodoc
class _$RadioPlayerEventCopyWithImpl<$Res, $Val extends RadioPlayerEvent>
    implements $RadioPlayerEventCopyWith<$Res> {
  _$RadioPlayerEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitializeImplCopyWith<$Res> {
  factory _$$InitializeImplCopyWith(
    _$InitializeImpl value,
    $Res Function(_$InitializeImpl) then,
  ) = __$$InitializeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({RadioEntity config, bool autoPlay});
}

/// @nodoc
class __$$InitializeImplCopyWithImpl<$Res>
    extends _$RadioPlayerEventCopyWithImpl<$Res, _$InitializeImpl>
    implements _$$InitializeImplCopyWith<$Res> {
  __$$InitializeImplCopyWithImpl(
    _$InitializeImpl _value,
    $Res Function(_$InitializeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? config = null, Object? autoPlay = null}) {
    return _then(
      _$InitializeImpl(
        null == config
            ? _value.config
            : config // ignore: cast_nullable_to_non_nullable
                  as RadioEntity,
        autoPlay: null == autoPlay
            ? _value.autoPlay
            : autoPlay // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$InitializeImpl implements _Initialize {
  const _$InitializeImpl(this.config, {this.autoPlay = false});

  @override
  final RadioEntity config;
  @override
  @JsonKey()
  final bool autoPlay;

  @override
  String toString() {
    return 'RadioPlayerEvent.initialize(config: $config, autoPlay: $autoPlay)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitializeImpl &&
            (identical(other.config, config) || other.config == config) &&
            (identical(other.autoPlay, autoPlay) ||
                other.autoPlay == autoPlay));
  }

  @override
  int get hashCode => Object.hash(runtimeType, config, autoPlay);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InitializeImplCopyWith<_$InitializeImpl> get copyWith =>
      __$$InitializeImplCopyWithImpl<_$InitializeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(RadioEntity config, bool autoPlay) initialize,
    required TResult Function() play,
    required TResult Function() pause,
    required TResult Function() togglePlayPause,
    required TResult Function() reset,
    required TResult Function(bool isPlaying) playbackStateChanged,
    required TResult Function(String? artist, String? title) metadataUpdated,
    required TResult Function(String albumArtUrl) albumArtFetched,
    required TResult Function(String message) errorOccurred,
    required TResult Function(String state) stateChanged,
    required TResult Function(int attempt, String reason) retrying,
    required TResult Function(String artist, String title, String? artworkUrl)
    setCustomMetadata,
    required TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )
    updateStation,
  }) {
    return initialize(config, autoPlay);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(RadioEntity config, bool autoPlay)? initialize,
    TResult? Function()? play,
    TResult? Function()? pause,
    TResult? Function()? togglePlayPause,
    TResult? Function()? reset,
    TResult? Function(bool isPlaying)? playbackStateChanged,
    TResult? Function(String? artist, String? title)? metadataUpdated,
    TResult? Function(String albumArtUrl)? albumArtFetched,
    TResult? Function(String message)? errorOccurred,
    TResult? Function(String state)? stateChanged,
    TResult? Function(int attempt, String reason)? retrying,
    TResult? Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult? Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
  }) {
    return initialize?.call(config, autoPlay);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(RadioEntity config, bool autoPlay)? initialize,
    TResult Function()? play,
    TResult Function()? pause,
    TResult Function()? togglePlayPause,
    TResult Function()? reset,
    TResult Function(bool isPlaying)? playbackStateChanged,
    TResult Function(String? artist, String? title)? metadataUpdated,
    TResult Function(String albumArtUrl)? albumArtFetched,
    TResult Function(String message)? errorOccurred,
    TResult Function(String state)? stateChanged,
    TResult Function(int attempt, String reason)? retrying,
    TResult Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
    required TResult orElse(),
  }) {
    if (initialize != null) {
      return initialize(config, autoPlay);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_Play value) play,
    required TResult Function(_Pause value) pause,
    required TResult Function(_TogglePlayPause value) togglePlayPause,
    required TResult Function(_Reset value) reset,
    required TResult Function(_PlaybackStateChanged value) playbackStateChanged,
    required TResult Function(_MetadataUpdated value) metadataUpdated,
    required TResult Function(_AlbumArtFetched value) albumArtFetched,
    required TResult Function(_ErrorOccurred value) errorOccurred,
    required TResult Function(_StateChanged value) stateChanged,
    required TResult Function(_Retrying value) retrying,
    required TResult Function(_SetCustomMetadata value) setCustomMetadata,
    required TResult Function(_UpdateStation value) updateStation,
  }) {
    return initialize(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_Play value)? play,
    TResult? Function(_Pause value)? pause,
    TResult? Function(_TogglePlayPause value)? togglePlayPause,
    TResult? Function(_Reset value)? reset,
    TResult? Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult? Function(_MetadataUpdated value)? metadataUpdated,
    TResult? Function(_AlbumArtFetched value)? albumArtFetched,
    TResult? Function(_ErrorOccurred value)? errorOccurred,
    TResult? Function(_StateChanged value)? stateChanged,
    TResult? Function(_Retrying value)? retrying,
    TResult? Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult? Function(_UpdateStation value)? updateStation,
  }) {
    return initialize?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_Play value)? play,
    TResult Function(_Pause value)? pause,
    TResult Function(_TogglePlayPause value)? togglePlayPause,
    TResult Function(_Reset value)? reset,
    TResult Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult Function(_MetadataUpdated value)? metadataUpdated,
    TResult Function(_AlbumArtFetched value)? albumArtFetched,
    TResult Function(_ErrorOccurred value)? errorOccurred,
    TResult Function(_StateChanged value)? stateChanged,
    TResult Function(_Retrying value)? retrying,
    TResult Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult Function(_UpdateStation value)? updateStation,
    required TResult orElse(),
  }) {
    if (initialize != null) {
      return initialize(this);
    }
    return orElse();
  }
}

abstract class _Initialize implements RadioPlayerEvent {
  const factory _Initialize(final RadioEntity config, {final bool autoPlay}) =
      _$InitializeImpl;

  RadioEntity get config;
  bool get autoPlay;

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InitializeImplCopyWith<_$InitializeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PlayImplCopyWith<$Res> {
  factory _$$PlayImplCopyWith(
    _$PlayImpl value,
    $Res Function(_$PlayImpl) then,
  ) = __$$PlayImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PlayImplCopyWithImpl<$Res>
    extends _$RadioPlayerEventCopyWithImpl<$Res, _$PlayImpl>
    implements _$$PlayImplCopyWith<$Res> {
  __$$PlayImplCopyWithImpl(_$PlayImpl _value, $Res Function(_$PlayImpl) _then)
    : super(_value, _then);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PlayImpl implements _Play {
  const _$PlayImpl();

  @override
  String toString() {
    return 'RadioPlayerEvent.play()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PlayImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(RadioEntity config, bool autoPlay) initialize,
    required TResult Function() play,
    required TResult Function() pause,
    required TResult Function() togglePlayPause,
    required TResult Function() reset,
    required TResult Function(bool isPlaying) playbackStateChanged,
    required TResult Function(String? artist, String? title) metadataUpdated,
    required TResult Function(String albumArtUrl) albumArtFetched,
    required TResult Function(String message) errorOccurred,
    required TResult Function(String state) stateChanged,
    required TResult Function(int attempt, String reason) retrying,
    required TResult Function(String artist, String title, String? artworkUrl)
    setCustomMetadata,
    required TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )
    updateStation,
  }) {
    return play();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(RadioEntity config, bool autoPlay)? initialize,
    TResult? Function()? play,
    TResult? Function()? pause,
    TResult? Function()? togglePlayPause,
    TResult? Function()? reset,
    TResult? Function(bool isPlaying)? playbackStateChanged,
    TResult? Function(String? artist, String? title)? metadataUpdated,
    TResult? Function(String albumArtUrl)? albumArtFetched,
    TResult? Function(String message)? errorOccurred,
    TResult? Function(String state)? stateChanged,
    TResult? Function(int attempt, String reason)? retrying,
    TResult? Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult? Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
  }) {
    return play?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(RadioEntity config, bool autoPlay)? initialize,
    TResult Function()? play,
    TResult Function()? pause,
    TResult Function()? togglePlayPause,
    TResult Function()? reset,
    TResult Function(bool isPlaying)? playbackStateChanged,
    TResult Function(String? artist, String? title)? metadataUpdated,
    TResult Function(String albumArtUrl)? albumArtFetched,
    TResult Function(String message)? errorOccurred,
    TResult Function(String state)? stateChanged,
    TResult Function(int attempt, String reason)? retrying,
    TResult Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
    required TResult orElse(),
  }) {
    if (play != null) {
      return play();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_Play value) play,
    required TResult Function(_Pause value) pause,
    required TResult Function(_TogglePlayPause value) togglePlayPause,
    required TResult Function(_Reset value) reset,
    required TResult Function(_PlaybackStateChanged value) playbackStateChanged,
    required TResult Function(_MetadataUpdated value) metadataUpdated,
    required TResult Function(_AlbumArtFetched value) albumArtFetched,
    required TResult Function(_ErrorOccurred value) errorOccurred,
    required TResult Function(_StateChanged value) stateChanged,
    required TResult Function(_Retrying value) retrying,
    required TResult Function(_SetCustomMetadata value) setCustomMetadata,
    required TResult Function(_UpdateStation value) updateStation,
  }) {
    return play(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_Play value)? play,
    TResult? Function(_Pause value)? pause,
    TResult? Function(_TogglePlayPause value)? togglePlayPause,
    TResult? Function(_Reset value)? reset,
    TResult? Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult? Function(_MetadataUpdated value)? metadataUpdated,
    TResult? Function(_AlbumArtFetched value)? albumArtFetched,
    TResult? Function(_ErrorOccurred value)? errorOccurred,
    TResult? Function(_StateChanged value)? stateChanged,
    TResult? Function(_Retrying value)? retrying,
    TResult? Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult? Function(_UpdateStation value)? updateStation,
  }) {
    return play?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_Play value)? play,
    TResult Function(_Pause value)? pause,
    TResult Function(_TogglePlayPause value)? togglePlayPause,
    TResult Function(_Reset value)? reset,
    TResult Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult Function(_MetadataUpdated value)? metadataUpdated,
    TResult Function(_AlbumArtFetched value)? albumArtFetched,
    TResult Function(_ErrorOccurred value)? errorOccurred,
    TResult Function(_StateChanged value)? stateChanged,
    TResult Function(_Retrying value)? retrying,
    TResult Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult Function(_UpdateStation value)? updateStation,
    required TResult orElse(),
  }) {
    if (play != null) {
      return play(this);
    }
    return orElse();
  }
}

abstract class _Play implements RadioPlayerEvent {
  const factory _Play() = _$PlayImpl;
}

/// @nodoc
abstract class _$$PauseImplCopyWith<$Res> {
  factory _$$PauseImplCopyWith(
    _$PauseImpl value,
    $Res Function(_$PauseImpl) then,
  ) = __$$PauseImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PauseImplCopyWithImpl<$Res>
    extends _$RadioPlayerEventCopyWithImpl<$Res, _$PauseImpl>
    implements _$$PauseImplCopyWith<$Res> {
  __$$PauseImplCopyWithImpl(
    _$PauseImpl _value,
    $Res Function(_$PauseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PauseImpl implements _Pause {
  const _$PauseImpl();

  @override
  String toString() {
    return 'RadioPlayerEvent.pause()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PauseImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(RadioEntity config, bool autoPlay) initialize,
    required TResult Function() play,
    required TResult Function() pause,
    required TResult Function() togglePlayPause,
    required TResult Function() reset,
    required TResult Function(bool isPlaying) playbackStateChanged,
    required TResult Function(String? artist, String? title) metadataUpdated,
    required TResult Function(String albumArtUrl) albumArtFetched,
    required TResult Function(String message) errorOccurred,
    required TResult Function(String state) stateChanged,
    required TResult Function(int attempt, String reason) retrying,
    required TResult Function(String artist, String title, String? artworkUrl)
    setCustomMetadata,
    required TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )
    updateStation,
  }) {
    return pause();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(RadioEntity config, bool autoPlay)? initialize,
    TResult? Function()? play,
    TResult? Function()? pause,
    TResult? Function()? togglePlayPause,
    TResult? Function()? reset,
    TResult? Function(bool isPlaying)? playbackStateChanged,
    TResult? Function(String? artist, String? title)? metadataUpdated,
    TResult? Function(String albumArtUrl)? albumArtFetched,
    TResult? Function(String message)? errorOccurred,
    TResult? Function(String state)? stateChanged,
    TResult? Function(int attempt, String reason)? retrying,
    TResult? Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult? Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
  }) {
    return pause?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(RadioEntity config, bool autoPlay)? initialize,
    TResult Function()? play,
    TResult Function()? pause,
    TResult Function()? togglePlayPause,
    TResult Function()? reset,
    TResult Function(bool isPlaying)? playbackStateChanged,
    TResult Function(String? artist, String? title)? metadataUpdated,
    TResult Function(String albumArtUrl)? albumArtFetched,
    TResult Function(String message)? errorOccurred,
    TResult Function(String state)? stateChanged,
    TResult Function(int attempt, String reason)? retrying,
    TResult Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
    required TResult orElse(),
  }) {
    if (pause != null) {
      return pause();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_Play value) play,
    required TResult Function(_Pause value) pause,
    required TResult Function(_TogglePlayPause value) togglePlayPause,
    required TResult Function(_Reset value) reset,
    required TResult Function(_PlaybackStateChanged value) playbackStateChanged,
    required TResult Function(_MetadataUpdated value) metadataUpdated,
    required TResult Function(_AlbumArtFetched value) albumArtFetched,
    required TResult Function(_ErrorOccurred value) errorOccurred,
    required TResult Function(_StateChanged value) stateChanged,
    required TResult Function(_Retrying value) retrying,
    required TResult Function(_SetCustomMetadata value) setCustomMetadata,
    required TResult Function(_UpdateStation value) updateStation,
  }) {
    return pause(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_Play value)? play,
    TResult? Function(_Pause value)? pause,
    TResult? Function(_TogglePlayPause value)? togglePlayPause,
    TResult? Function(_Reset value)? reset,
    TResult? Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult? Function(_MetadataUpdated value)? metadataUpdated,
    TResult? Function(_AlbumArtFetched value)? albumArtFetched,
    TResult? Function(_ErrorOccurred value)? errorOccurred,
    TResult? Function(_StateChanged value)? stateChanged,
    TResult? Function(_Retrying value)? retrying,
    TResult? Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult? Function(_UpdateStation value)? updateStation,
  }) {
    return pause?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_Play value)? play,
    TResult Function(_Pause value)? pause,
    TResult Function(_TogglePlayPause value)? togglePlayPause,
    TResult Function(_Reset value)? reset,
    TResult Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult Function(_MetadataUpdated value)? metadataUpdated,
    TResult Function(_AlbumArtFetched value)? albumArtFetched,
    TResult Function(_ErrorOccurred value)? errorOccurred,
    TResult Function(_StateChanged value)? stateChanged,
    TResult Function(_Retrying value)? retrying,
    TResult Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult Function(_UpdateStation value)? updateStation,
    required TResult orElse(),
  }) {
    if (pause != null) {
      return pause(this);
    }
    return orElse();
  }
}

abstract class _Pause implements RadioPlayerEvent {
  const factory _Pause() = _$PauseImpl;
}

/// @nodoc
abstract class _$$TogglePlayPauseImplCopyWith<$Res> {
  factory _$$TogglePlayPauseImplCopyWith(
    _$TogglePlayPauseImpl value,
    $Res Function(_$TogglePlayPauseImpl) then,
  ) = __$$TogglePlayPauseImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TogglePlayPauseImplCopyWithImpl<$Res>
    extends _$RadioPlayerEventCopyWithImpl<$Res, _$TogglePlayPauseImpl>
    implements _$$TogglePlayPauseImplCopyWith<$Res> {
  __$$TogglePlayPauseImplCopyWithImpl(
    _$TogglePlayPauseImpl _value,
    $Res Function(_$TogglePlayPauseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$TogglePlayPauseImpl implements _TogglePlayPause {
  const _$TogglePlayPauseImpl();

  @override
  String toString() {
    return 'RadioPlayerEvent.togglePlayPause()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TogglePlayPauseImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(RadioEntity config, bool autoPlay) initialize,
    required TResult Function() play,
    required TResult Function() pause,
    required TResult Function() togglePlayPause,
    required TResult Function() reset,
    required TResult Function(bool isPlaying) playbackStateChanged,
    required TResult Function(String? artist, String? title) metadataUpdated,
    required TResult Function(String albumArtUrl) albumArtFetched,
    required TResult Function(String message) errorOccurred,
    required TResult Function(String state) stateChanged,
    required TResult Function(int attempt, String reason) retrying,
    required TResult Function(String artist, String title, String? artworkUrl)
    setCustomMetadata,
    required TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )
    updateStation,
  }) {
    return togglePlayPause();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(RadioEntity config, bool autoPlay)? initialize,
    TResult? Function()? play,
    TResult? Function()? pause,
    TResult? Function()? togglePlayPause,
    TResult? Function()? reset,
    TResult? Function(bool isPlaying)? playbackStateChanged,
    TResult? Function(String? artist, String? title)? metadataUpdated,
    TResult? Function(String albumArtUrl)? albumArtFetched,
    TResult? Function(String message)? errorOccurred,
    TResult? Function(String state)? stateChanged,
    TResult? Function(int attempt, String reason)? retrying,
    TResult? Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult? Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
  }) {
    return togglePlayPause?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(RadioEntity config, bool autoPlay)? initialize,
    TResult Function()? play,
    TResult Function()? pause,
    TResult Function()? togglePlayPause,
    TResult Function()? reset,
    TResult Function(bool isPlaying)? playbackStateChanged,
    TResult Function(String? artist, String? title)? metadataUpdated,
    TResult Function(String albumArtUrl)? albumArtFetched,
    TResult Function(String message)? errorOccurred,
    TResult Function(String state)? stateChanged,
    TResult Function(int attempt, String reason)? retrying,
    TResult Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
    required TResult orElse(),
  }) {
    if (togglePlayPause != null) {
      return togglePlayPause();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_Play value) play,
    required TResult Function(_Pause value) pause,
    required TResult Function(_TogglePlayPause value) togglePlayPause,
    required TResult Function(_Reset value) reset,
    required TResult Function(_PlaybackStateChanged value) playbackStateChanged,
    required TResult Function(_MetadataUpdated value) metadataUpdated,
    required TResult Function(_AlbumArtFetched value) albumArtFetched,
    required TResult Function(_ErrorOccurred value) errorOccurred,
    required TResult Function(_StateChanged value) stateChanged,
    required TResult Function(_Retrying value) retrying,
    required TResult Function(_SetCustomMetadata value) setCustomMetadata,
    required TResult Function(_UpdateStation value) updateStation,
  }) {
    return togglePlayPause(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_Play value)? play,
    TResult? Function(_Pause value)? pause,
    TResult? Function(_TogglePlayPause value)? togglePlayPause,
    TResult? Function(_Reset value)? reset,
    TResult? Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult? Function(_MetadataUpdated value)? metadataUpdated,
    TResult? Function(_AlbumArtFetched value)? albumArtFetched,
    TResult? Function(_ErrorOccurred value)? errorOccurred,
    TResult? Function(_StateChanged value)? stateChanged,
    TResult? Function(_Retrying value)? retrying,
    TResult? Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult? Function(_UpdateStation value)? updateStation,
  }) {
    return togglePlayPause?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_Play value)? play,
    TResult Function(_Pause value)? pause,
    TResult Function(_TogglePlayPause value)? togglePlayPause,
    TResult Function(_Reset value)? reset,
    TResult Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult Function(_MetadataUpdated value)? metadataUpdated,
    TResult Function(_AlbumArtFetched value)? albumArtFetched,
    TResult Function(_ErrorOccurred value)? errorOccurred,
    TResult Function(_StateChanged value)? stateChanged,
    TResult Function(_Retrying value)? retrying,
    TResult Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult Function(_UpdateStation value)? updateStation,
    required TResult orElse(),
  }) {
    if (togglePlayPause != null) {
      return togglePlayPause(this);
    }
    return orElse();
  }
}

abstract class _TogglePlayPause implements RadioPlayerEvent {
  const factory _TogglePlayPause() = _$TogglePlayPauseImpl;
}

/// @nodoc
abstract class _$$ResetImplCopyWith<$Res> {
  factory _$$ResetImplCopyWith(
    _$ResetImpl value,
    $Res Function(_$ResetImpl) then,
  ) = __$$ResetImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ResetImplCopyWithImpl<$Res>
    extends _$RadioPlayerEventCopyWithImpl<$Res, _$ResetImpl>
    implements _$$ResetImplCopyWith<$Res> {
  __$$ResetImplCopyWithImpl(
    _$ResetImpl _value,
    $Res Function(_$ResetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ResetImpl implements _Reset {
  const _$ResetImpl();

  @override
  String toString() {
    return 'RadioPlayerEvent.reset()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ResetImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(RadioEntity config, bool autoPlay) initialize,
    required TResult Function() play,
    required TResult Function() pause,
    required TResult Function() togglePlayPause,
    required TResult Function() reset,
    required TResult Function(bool isPlaying) playbackStateChanged,
    required TResult Function(String? artist, String? title) metadataUpdated,
    required TResult Function(String albumArtUrl) albumArtFetched,
    required TResult Function(String message) errorOccurred,
    required TResult Function(String state) stateChanged,
    required TResult Function(int attempt, String reason) retrying,
    required TResult Function(String artist, String title, String? artworkUrl)
    setCustomMetadata,
    required TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )
    updateStation,
  }) {
    return reset();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(RadioEntity config, bool autoPlay)? initialize,
    TResult? Function()? play,
    TResult? Function()? pause,
    TResult? Function()? togglePlayPause,
    TResult? Function()? reset,
    TResult? Function(bool isPlaying)? playbackStateChanged,
    TResult? Function(String? artist, String? title)? metadataUpdated,
    TResult? Function(String albumArtUrl)? albumArtFetched,
    TResult? Function(String message)? errorOccurred,
    TResult? Function(String state)? stateChanged,
    TResult? Function(int attempt, String reason)? retrying,
    TResult? Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult? Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
  }) {
    return reset?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(RadioEntity config, bool autoPlay)? initialize,
    TResult Function()? play,
    TResult Function()? pause,
    TResult Function()? togglePlayPause,
    TResult Function()? reset,
    TResult Function(bool isPlaying)? playbackStateChanged,
    TResult Function(String? artist, String? title)? metadataUpdated,
    TResult Function(String albumArtUrl)? albumArtFetched,
    TResult Function(String message)? errorOccurred,
    TResult Function(String state)? stateChanged,
    TResult Function(int attempt, String reason)? retrying,
    TResult Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_Play value) play,
    required TResult Function(_Pause value) pause,
    required TResult Function(_TogglePlayPause value) togglePlayPause,
    required TResult Function(_Reset value) reset,
    required TResult Function(_PlaybackStateChanged value) playbackStateChanged,
    required TResult Function(_MetadataUpdated value) metadataUpdated,
    required TResult Function(_AlbumArtFetched value) albumArtFetched,
    required TResult Function(_ErrorOccurred value) errorOccurred,
    required TResult Function(_StateChanged value) stateChanged,
    required TResult Function(_Retrying value) retrying,
    required TResult Function(_SetCustomMetadata value) setCustomMetadata,
    required TResult Function(_UpdateStation value) updateStation,
  }) {
    return reset(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_Play value)? play,
    TResult? Function(_Pause value)? pause,
    TResult? Function(_TogglePlayPause value)? togglePlayPause,
    TResult? Function(_Reset value)? reset,
    TResult? Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult? Function(_MetadataUpdated value)? metadataUpdated,
    TResult? Function(_AlbumArtFetched value)? albumArtFetched,
    TResult? Function(_ErrorOccurred value)? errorOccurred,
    TResult? Function(_StateChanged value)? stateChanged,
    TResult? Function(_Retrying value)? retrying,
    TResult? Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult? Function(_UpdateStation value)? updateStation,
  }) {
    return reset?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_Play value)? play,
    TResult Function(_Pause value)? pause,
    TResult Function(_TogglePlayPause value)? togglePlayPause,
    TResult Function(_Reset value)? reset,
    TResult Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult Function(_MetadataUpdated value)? metadataUpdated,
    TResult Function(_AlbumArtFetched value)? albumArtFetched,
    TResult Function(_ErrorOccurred value)? errorOccurred,
    TResult Function(_StateChanged value)? stateChanged,
    TResult Function(_Retrying value)? retrying,
    TResult Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult Function(_UpdateStation value)? updateStation,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset(this);
    }
    return orElse();
  }
}

abstract class _Reset implements RadioPlayerEvent {
  const factory _Reset() = _$ResetImpl;
}

/// @nodoc
abstract class _$$PlaybackStateChangedImplCopyWith<$Res> {
  factory _$$PlaybackStateChangedImplCopyWith(
    _$PlaybackStateChangedImpl value,
    $Res Function(_$PlaybackStateChangedImpl) then,
  ) = __$$PlaybackStateChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isPlaying});
}

/// @nodoc
class __$$PlaybackStateChangedImplCopyWithImpl<$Res>
    extends _$RadioPlayerEventCopyWithImpl<$Res, _$PlaybackStateChangedImpl>
    implements _$$PlaybackStateChangedImplCopyWith<$Res> {
  __$$PlaybackStateChangedImplCopyWithImpl(
    _$PlaybackStateChangedImpl _value,
    $Res Function(_$PlaybackStateChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isPlaying = null}) {
    return _then(
      _$PlaybackStateChangedImpl(
        null == isPlaying
            ? _value.isPlaying
            : isPlaying // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$PlaybackStateChangedImpl implements _PlaybackStateChanged {
  const _$PlaybackStateChangedImpl(this.isPlaying);

  @override
  final bool isPlaying;

  @override
  String toString() {
    return 'RadioPlayerEvent.playbackStateChanged(isPlaying: $isPlaying)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaybackStateChangedImpl &&
            (identical(other.isPlaying, isPlaying) ||
                other.isPlaying == isPlaying));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isPlaying);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaybackStateChangedImplCopyWith<_$PlaybackStateChangedImpl>
  get copyWith =>
      __$$PlaybackStateChangedImplCopyWithImpl<_$PlaybackStateChangedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(RadioEntity config, bool autoPlay) initialize,
    required TResult Function() play,
    required TResult Function() pause,
    required TResult Function() togglePlayPause,
    required TResult Function() reset,
    required TResult Function(bool isPlaying) playbackStateChanged,
    required TResult Function(String? artist, String? title) metadataUpdated,
    required TResult Function(String albumArtUrl) albumArtFetched,
    required TResult Function(String message) errorOccurred,
    required TResult Function(String state) stateChanged,
    required TResult Function(int attempt, String reason) retrying,
    required TResult Function(String artist, String title, String? artworkUrl)
    setCustomMetadata,
    required TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )
    updateStation,
  }) {
    return playbackStateChanged(isPlaying);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(RadioEntity config, bool autoPlay)? initialize,
    TResult? Function()? play,
    TResult? Function()? pause,
    TResult? Function()? togglePlayPause,
    TResult? Function()? reset,
    TResult? Function(bool isPlaying)? playbackStateChanged,
    TResult? Function(String? artist, String? title)? metadataUpdated,
    TResult? Function(String albumArtUrl)? albumArtFetched,
    TResult? Function(String message)? errorOccurred,
    TResult? Function(String state)? stateChanged,
    TResult? Function(int attempt, String reason)? retrying,
    TResult? Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult? Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
  }) {
    return playbackStateChanged?.call(isPlaying);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(RadioEntity config, bool autoPlay)? initialize,
    TResult Function()? play,
    TResult Function()? pause,
    TResult Function()? togglePlayPause,
    TResult Function()? reset,
    TResult Function(bool isPlaying)? playbackStateChanged,
    TResult Function(String? artist, String? title)? metadataUpdated,
    TResult Function(String albumArtUrl)? albumArtFetched,
    TResult Function(String message)? errorOccurred,
    TResult Function(String state)? stateChanged,
    TResult Function(int attempt, String reason)? retrying,
    TResult Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
    required TResult orElse(),
  }) {
    if (playbackStateChanged != null) {
      return playbackStateChanged(isPlaying);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_Play value) play,
    required TResult Function(_Pause value) pause,
    required TResult Function(_TogglePlayPause value) togglePlayPause,
    required TResult Function(_Reset value) reset,
    required TResult Function(_PlaybackStateChanged value) playbackStateChanged,
    required TResult Function(_MetadataUpdated value) metadataUpdated,
    required TResult Function(_AlbumArtFetched value) albumArtFetched,
    required TResult Function(_ErrorOccurred value) errorOccurred,
    required TResult Function(_StateChanged value) stateChanged,
    required TResult Function(_Retrying value) retrying,
    required TResult Function(_SetCustomMetadata value) setCustomMetadata,
    required TResult Function(_UpdateStation value) updateStation,
  }) {
    return playbackStateChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_Play value)? play,
    TResult? Function(_Pause value)? pause,
    TResult? Function(_TogglePlayPause value)? togglePlayPause,
    TResult? Function(_Reset value)? reset,
    TResult? Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult? Function(_MetadataUpdated value)? metadataUpdated,
    TResult? Function(_AlbumArtFetched value)? albumArtFetched,
    TResult? Function(_ErrorOccurred value)? errorOccurred,
    TResult? Function(_StateChanged value)? stateChanged,
    TResult? Function(_Retrying value)? retrying,
    TResult? Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult? Function(_UpdateStation value)? updateStation,
  }) {
    return playbackStateChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_Play value)? play,
    TResult Function(_Pause value)? pause,
    TResult Function(_TogglePlayPause value)? togglePlayPause,
    TResult Function(_Reset value)? reset,
    TResult Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult Function(_MetadataUpdated value)? metadataUpdated,
    TResult Function(_AlbumArtFetched value)? albumArtFetched,
    TResult Function(_ErrorOccurred value)? errorOccurred,
    TResult Function(_StateChanged value)? stateChanged,
    TResult Function(_Retrying value)? retrying,
    TResult Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult Function(_UpdateStation value)? updateStation,
    required TResult orElse(),
  }) {
    if (playbackStateChanged != null) {
      return playbackStateChanged(this);
    }
    return orElse();
  }
}

abstract class _PlaybackStateChanged implements RadioPlayerEvent {
  const factory _PlaybackStateChanged(final bool isPlaying) =
      _$PlaybackStateChangedImpl;

  bool get isPlaying;

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaybackStateChangedImplCopyWith<_$PlaybackStateChangedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataUpdatedImplCopyWith<$Res> {
  factory _$$MetadataUpdatedImplCopyWith(
    _$MetadataUpdatedImpl value,
    $Res Function(_$MetadataUpdatedImpl) then,
  ) = __$$MetadataUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? artist, String? title});
}

/// @nodoc
class __$$MetadataUpdatedImplCopyWithImpl<$Res>
    extends _$RadioPlayerEventCopyWithImpl<$Res, _$MetadataUpdatedImpl>
    implements _$$MetadataUpdatedImplCopyWith<$Res> {
  __$$MetadataUpdatedImplCopyWithImpl(
    _$MetadataUpdatedImpl _value,
    $Res Function(_$MetadataUpdatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? artist = freezed, Object? title = freezed}) {
    return _then(
      _$MetadataUpdatedImpl(
        freezed == artist
            ? _value.artist
            : artist // ignore: cast_nullable_to_non_nullable
                  as String?,
        freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$MetadataUpdatedImpl implements _MetadataUpdated {
  const _$MetadataUpdatedImpl(this.artist, this.title);

  @override
  final String? artist;
  @override
  final String? title;

  @override
  String toString() {
    return 'RadioPlayerEvent.metadataUpdated(artist: $artist, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataUpdatedImpl &&
            (identical(other.artist, artist) || other.artist == artist) &&
            (identical(other.title, title) || other.title == title));
  }

  @override
  int get hashCode => Object.hash(runtimeType, artist, title);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataUpdatedImplCopyWith<_$MetadataUpdatedImpl> get copyWith =>
      __$$MetadataUpdatedImplCopyWithImpl<_$MetadataUpdatedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(RadioEntity config, bool autoPlay) initialize,
    required TResult Function() play,
    required TResult Function() pause,
    required TResult Function() togglePlayPause,
    required TResult Function() reset,
    required TResult Function(bool isPlaying) playbackStateChanged,
    required TResult Function(String? artist, String? title) metadataUpdated,
    required TResult Function(String albumArtUrl) albumArtFetched,
    required TResult Function(String message) errorOccurred,
    required TResult Function(String state) stateChanged,
    required TResult Function(int attempt, String reason) retrying,
    required TResult Function(String artist, String title, String? artworkUrl)
    setCustomMetadata,
    required TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )
    updateStation,
  }) {
    return metadataUpdated(artist, title);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(RadioEntity config, bool autoPlay)? initialize,
    TResult? Function()? play,
    TResult? Function()? pause,
    TResult? Function()? togglePlayPause,
    TResult? Function()? reset,
    TResult? Function(bool isPlaying)? playbackStateChanged,
    TResult? Function(String? artist, String? title)? metadataUpdated,
    TResult? Function(String albumArtUrl)? albumArtFetched,
    TResult? Function(String message)? errorOccurred,
    TResult? Function(String state)? stateChanged,
    TResult? Function(int attempt, String reason)? retrying,
    TResult? Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult? Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
  }) {
    return metadataUpdated?.call(artist, title);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(RadioEntity config, bool autoPlay)? initialize,
    TResult Function()? play,
    TResult Function()? pause,
    TResult Function()? togglePlayPause,
    TResult Function()? reset,
    TResult Function(bool isPlaying)? playbackStateChanged,
    TResult Function(String? artist, String? title)? metadataUpdated,
    TResult Function(String albumArtUrl)? albumArtFetched,
    TResult Function(String message)? errorOccurred,
    TResult Function(String state)? stateChanged,
    TResult Function(int attempt, String reason)? retrying,
    TResult Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
    required TResult orElse(),
  }) {
    if (metadataUpdated != null) {
      return metadataUpdated(artist, title);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_Play value) play,
    required TResult Function(_Pause value) pause,
    required TResult Function(_TogglePlayPause value) togglePlayPause,
    required TResult Function(_Reset value) reset,
    required TResult Function(_PlaybackStateChanged value) playbackStateChanged,
    required TResult Function(_MetadataUpdated value) metadataUpdated,
    required TResult Function(_AlbumArtFetched value) albumArtFetched,
    required TResult Function(_ErrorOccurred value) errorOccurred,
    required TResult Function(_StateChanged value) stateChanged,
    required TResult Function(_Retrying value) retrying,
    required TResult Function(_SetCustomMetadata value) setCustomMetadata,
    required TResult Function(_UpdateStation value) updateStation,
  }) {
    return metadataUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_Play value)? play,
    TResult? Function(_Pause value)? pause,
    TResult? Function(_TogglePlayPause value)? togglePlayPause,
    TResult? Function(_Reset value)? reset,
    TResult? Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult? Function(_MetadataUpdated value)? metadataUpdated,
    TResult? Function(_AlbumArtFetched value)? albumArtFetched,
    TResult? Function(_ErrorOccurred value)? errorOccurred,
    TResult? Function(_StateChanged value)? stateChanged,
    TResult? Function(_Retrying value)? retrying,
    TResult? Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult? Function(_UpdateStation value)? updateStation,
  }) {
    return metadataUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_Play value)? play,
    TResult Function(_Pause value)? pause,
    TResult Function(_TogglePlayPause value)? togglePlayPause,
    TResult Function(_Reset value)? reset,
    TResult Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult Function(_MetadataUpdated value)? metadataUpdated,
    TResult Function(_AlbumArtFetched value)? albumArtFetched,
    TResult Function(_ErrorOccurred value)? errorOccurred,
    TResult Function(_StateChanged value)? stateChanged,
    TResult Function(_Retrying value)? retrying,
    TResult Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult Function(_UpdateStation value)? updateStation,
    required TResult orElse(),
  }) {
    if (metadataUpdated != null) {
      return metadataUpdated(this);
    }
    return orElse();
  }
}

abstract class _MetadataUpdated implements RadioPlayerEvent {
  const factory _MetadataUpdated(final String? artist, final String? title) =
      _$MetadataUpdatedImpl;

  String? get artist;
  String? get title;

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataUpdatedImplCopyWith<_$MetadataUpdatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AlbumArtFetchedImplCopyWith<$Res> {
  factory _$$AlbumArtFetchedImplCopyWith(
    _$AlbumArtFetchedImpl value,
    $Res Function(_$AlbumArtFetchedImpl) then,
  ) = __$$AlbumArtFetchedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String albumArtUrl});
}

/// @nodoc
class __$$AlbumArtFetchedImplCopyWithImpl<$Res>
    extends _$RadioPlayerEventCopyWithImpl<$Res, _$AlbumArtFetchedImpl>
    implements _$$AlbumArtFetchedImplCopyWith<$Res> {
  __$$AlbumArtFetchedImplCopyWithImpl(
    _$AlbumArtFetchedImpl _value,
    $Res Function(_$AlbumArtFetchedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? albumArtUrl = null}) {
    return _then(
      _$AlbumArtFetchedImpl(
        null == albumArtUrl
            ? _value.albumArtUrl
            : albumArtUrl // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AlbumArtFetchedImpl implements _AlbumArtFetched {
  const _$AlbumArtFetchedImpl(this.albumArtUrl);

  @override
  final String albumArtUrl;

  @override
  String toString() {
    return 'RadioPlayerEvent.albumArtFetched(albumArtUrl: $albumArtUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlbumArtFetchedImpl &&
            (identical(other.albumArtUrl, albumArtUrl) ||
                other.albumArtUrl == albumArtUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, albumArtUrl);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlbumArtFetchedImplCopyWith<_$AlbumArtFetchedImpl> get copyWith =>
      __$$AlbumArtFetchedImplCopyWithImpl<_$AlbumArtFetchedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(RadioEntity config, bool autoPlay) initialize,
    required TResult Function() play,
    required TResult Function() pause,
    required TResult Function() togglePlayPause,
    required TResult Function() reset,
    required TResult Function(bool isPlaying) playbackStateChanged,
    required TResult Function(String? artist, String? title) metadataUpdated,
    required TResult Function(String albumArtUrl) albumArtFetched,
    required TResult Function(String message) errorOccurred,
    required TResult Function(String state) stateChanged,
    required TResult Function(int attempt, String reason) retrying,
    required TResult Function(String artist, String title, String? artworkUrl)
    setCustomMetadata,
    required TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )
    updateStation,
  }) {
    return albumArtFetched(albumArtUrl);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(RadioEntity config, bool autoPlay)? initialize,
    TResult? Function()? play,
    TResult? Function()? pause,
    TResult? Function()? togglePlayPause,
    TResult? Function()? reset,
    TResult? Function(bool isPlaying)? playbackStateChanged,
    TResult? Function(String? artist, String? title)? metadataUpdated,
    TResult? Function(String albumArtUrl)? albumArtFetched,
    TResult? Function(String message)? errorOccurred,
    TResult? Function(String state)? stateChanged,
    TResult? Function(int attempt, String reason)? retrying,
    TResult? Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult? Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
  }) {
    return albumArtFetched?.call(albumArtUrl);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(RadioEntity config, bool autoPlay)? initialize,
    TResult Function()? play,
    TResult Function()? pause,
    TResult Function()? togglePlayPause,
    TResult Function()? reset,
    TResult Function(bool isPlaying)? playbackStateChanged,
    TResult Function(String? artist, String? title)? metadataUpdated,
    TResult Function(String albumArtUrl)? albumArtFetched,
    TResult Function(String message)? errorOccurred,
    TResult Function(String state)? stateChanged,
    TResult Function(int attempt, String reason)? retrying,
    TResult Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
    required TResult orElse(),
  }) {
    if (albumArtFetched != null) {
      return albumArtFetched(albumArtUrl);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_Play value) play,
    required TResult Function(_Pause value) pause,
    required TResult Function(_TogglePlayPause value) togglePlayPause,
    required TResult Function(_Reset value) reset,
    required TResult Function(_PlaybackStateChanged value) playbackStateChanged,
    required TResult Function(_MetadataUpdated value) metadataUpdated,
    required TResult Function(_AlbumArtFetched value) albumArtFetched,
    required TResult Function(_ErrorOccurred value) errorOccurred,
    required TResult Function(_StateChanged value) stateChanged,
    required TResult Function(_Retrying value) retrying,
    required TResult Function(_SetCustomMetadata value) setCustomMetadata,
    required TResult Function(_UpdateStation value) updateStation,
  }) {
    return albumArtFetched(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_Play value)? play,
    TResult? Function(_Pause value)? pause,
    TResult? Function(_TogglePlayPause value)? togglePlayPause,
    TResult? Function(_Reset value)? reset,
    TResult? Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult? Function(_MetadataUpdated value)? metadataUpdated,
    TResult? Function(_AlbumArtFetched value)? albumArtFetched,
    TResult? Function(_ErrorOccurred value)? errorOccurred,
    TResult? Function(_StateChanged value)? stateChanged,
    TResult? Function(_Retrying value)? retrying,
    TResult? Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult? Function(_UpdateStation value)? updateStation,
  }) {
    return albumArtFetched?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_Play value)? play,
    TResult Function(_Pause value)? pause,
    TResult Function(_TogglePlayPause value)? togglePlayPause,
    TResult Function(_Reset value)? reset,
    TResult Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult Function(_MetadataUpdated value)? metadataUpdated,
    TResult Function(_AlbumArtFetched value)? albumArtFetched,
    TResult Function(_ErrorOccurred value)? errorOccurred,
    TResult Function(_StateChanged value)? stateChanged,
    TResult Function(_Retrying value)? retrying,
    TResult Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult Function(_UpdateStation value)? updateStation,
    required TResult orElse(),
  }) {
    if (albumArtFetched != null) {
      return albumArtFetched(this);
    }
    return orElse();
  }
}

abstract class _AlbumArtFetched implements RadioPlayerEvent {
  const factory _AlbumArtFetched(final String albumArtUrl) =
      _$AlbumArtFetchedImpl;

  String get albumArtUrl;

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlbumArtFetchedImplCopyWith<_$AlbumArtFetchedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorOccurredImplCopyWith<$Res> {
  factory _$$ErrorOccurredImplCopyWith(
    _$ErrorOccurredImpl value,
    $Res Function(_$ErrorOccurredImpl) then,
  ) = __$$ErrorOccurredImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorOccurredImplCopyWithImpl<$Res>
    extends _$RadioPlayerEventCopyWithImpl<$Res, _$ErrorOccurredImpl>
    implements _$$ErrorOccurredImplCopyWith<$Res> {
  __$$ErrorOccurredImplCopyWithImpl(
    _$ErrorOccurredImpl _value,
    $Res Function(_$ErrorOccurredImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ErrorOccurredImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ErrorOccurredImpl implements _ErrorOccurred {
  const _$ErrorOccurredImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'RadioPlayerEvent.errorOccurred(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorOccurredImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorOccurredImplCopyWith<_$ErrorOccurredImpl> get copyWith =>
      __$$ErrorOccurredImplCopyWithImpl<_$ErrorOccurredImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(RadioEntity config, bool autoPlay) initialize,
    required TResult Function() play,
    required TResult Function() pause,
    required TResult Function() togglePlayPause,
    required TResult Function() reset,
    required TResult Function(bool isPlaying) playbackStateChanged,
    required TResult Function(String? artist, String? title) metadataUpdated,
    required TResult Function(String albumArtUrl) albumArtFetched,
    required TResult Function(String message) errorOccurred,
    required TResult Function(String state) stateChanged,
    required TResult Function(int attempt, String reason) retrying,
    required TResult Function(String artist, String title, String? artworkUrl)
    setCustomMetadata,
    required TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )
    updateStation,
  }) {
    return errorOccurred(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(RadioEntity config, bool autoPlay)? initialize,
    TResult? Function()? play,
    TResult? Function()? pause,
    TResult? Function()? togglePlayPause,
    TResult? Function()? reset,
    TResult? Function(bool isPlaying)? playbackStateChanged,
    TResult? Function(String? artist, String? title)? metadataUpdated,
    TResult? Function(String albumArtUrl)? albumArtFetched,
    TResult? Function(String message)? errorOccurred,
    TResult? Function(String state)? stateChanged,
    TResult? Function(int attempt, String reason)? retrying,
    TResult? Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult? Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
  }) {
    return errorOccurred?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(RadioEntity config, bool autoPlay)? initialize,
    TResult Function()? play,
    TResult Function()? pause,
    TResult Function()? togglePlayPause,
    TResult Function()? reset,
    TResult Function(bool isPlaying)? playbackStateChanged,
    TResult Function(String? artist, String? title)? metadataUpdated,
    TResult Function(String albumArtUrl)? albumArtFetched,
    TResult Function(String message)? errorOccurred,
    TResult Function(String state)? stateChanged,
    TResult Function(int attempt, String reason)? retrying,
    TResult Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
    required TResult orElse(),
  }) {
    if (errorOccurred != null) {
      return errorOccurred(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_Play value) play,
    required TResult Function(_Pause value) pause,
    required TResult Function(_TogglePlayPause value) togglePlayPause,
    required TResult Function(_Reset value) reset,
    required TResult Function(_PlaybackStateChanged value) playbackStateChanged,
    required TResult Function(_MetadataUpdated value) metadataUpdated,
    required TResult Function(_AlbumArtFetched value) albumArtFetched,
    required TResult Function(_ErrorOccurred value) errorOccurred,
    required TResult Function(_StateChanged value) stateChanged,
    required TResult Function(_Retrying value) retrying,
    required TResult Function(_SetCustomMetadata value) setCustomMetadata,
    required TResult Function(_UpdateStation value) updateStation,
  }) {
    return errorOccurred(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_Play value)? play,
    TResult? Function(_Pause value)? pause,
    TResult? Function(_TogglePlayPause value)? togglePlayPause,
    TResult? Function(_Reset value)? reset,
    TResult? Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult? Function(_MetadataUpdated value)? metadataUpdated,
    TResult? Function(_AlbumArtFetched value)? albumArtFetched,
    TResult? Function(_ErrorOccurred value)? errorOccurred,
    TResult? Function(_StateChanged value)? stateChanged,
    TResult? Function(_Retrying value)? retrying,
    TResult? Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult? Function(_UpdateStation value)? updateStation,
  }) {
    return errorOccurred?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_Play value)? play,
    TResult Function(_Pause value)? pause,
    TResult Function(_TogglePlayPause value)? togglePlayPause,
    TResult Function(_Reset value)? reset,
    TResult Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult Function(_MetadataUpdated value)? metadataUpdated,
    TResult Function(_AlbumArtFetched value)? albumArtFetched,
    TResult Function(_ErrorOccurred value)? errorOccurred,
    TResult Function(_StateChanged value)? stateChanged,
    TResult Function(_Retrying value)? retrying,
    TResult Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult Function(_UpdateStation value)? updateStation,
    required TResult orElse(),
  }) {
    if (errorOccurred != null) {
      return errorOccurred(this);
    }
    return orElse();
  }
}

abstract class _ErrorOccurred implements RadioPlayerEvent {
  const factory _ErrorOccurred(final String message) = _$ErrorOccurredImpl;

  String get message;

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorOccurredImplCopyWith<_$ErrorOccurredImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StateChangedImplCopyWith<$Res> {
  factory _$$StateChangedImplCopyWith(
    _$StateChangedImpl value,
    $Res Function(_$StateChangedImpl) then,
  ) = __$$StateChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String state});
}

/// @nodoc
class __$$StateChangedImplCopyWithImpl<$Res>
    extends _$RadioPlayerEventCopyWithImpl<$Res, _$StateChangedImpl>
    implements _$$StateChangedImplCopyWith<$Res> {
  __$$StateChangedImplCopyWithImpl(
    _$StateChangedImpl _value,
    $Res Function(_$StateChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? state = null}) {
    return _then(
      _$StateChangedImpl(
        null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$StateChangedImpl implements _StateChanged {
  const _$StateChangedImpl(this.state);

  @override
  final String state;

  @override
  String toString() {
    return 'RadioPlayerEvent.stateChanged(state: $state)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StateChangedImpl &&
            (identical(other.state, state) || other.state == state));
  }

  @override
  int get hashCode => Object.hash(runtimeType, state);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StateChangedImplCopyWith<_$StateChangedImpl> get copyWith =>
      __$$StateChangedImplCopyWithImpl<_$StateChangedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(RadioEntity config, bool autoPlay) initialize,
    required TResult Function() play,
    required TResult Function() pause,
    required TResult Function() togglePlayPause,
    required TResult Function() reset,
    required TResult Function(bool isPlaying) playbackStateChanged,
    required TResult Function(String? artist, String? title) metadataUpdated,
    required TResult Function(String albumArtUrl) albumArtFetched,
    required TResult Function(String message) errorOccurred,
    required TResult Function(String state) stateChanged,
    required TResult Function(int attempt, String reason) retrying,
    required TResult Function(String artist, String title, String? artworkUrl)
    setCustomMetadata,
    required TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )
    updateStation,
  }) {
    return stateChanged(state);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(RadioEntity config, bool autoPlay)? initialize,
    TResult? Function()? play,
    TResult? Function()? pause,
    TResult? Function()? togglePlayPause,
    TResult? Function()? reset,
    TResult? Function(bool isPlaying)? playbackStateChanged,
    TResult? Function(String? artist, String? title)? metadataUpdated,
    TResult? Function(String albumArtUrl)? albumArtFetched,
    TResult? Function(String message)? errorOccurred,
    TResult? Function(String state)? stateChanged,
    TResult? Function(int attempt, String reason)? retrying,
    TResult? Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult? Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
  }) {
    return stateChanged?.call(state);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(RadioEntity config, bool autoPlay)? initialize,
    TResult Function()? play,
    TResult Function()? pause,
    TResult Function()? togglePlayPause,
    TResult Function()? reset,
    TResult Function(bool isPlaying)? playbackStateChanged,
    TResult Function(String? artist, String? title)? metadataUpdated,
    TResult Function(String albumArtUrl)? albumArtFetched,
    TResult Function(String message)? errorOccurred,
    TResult Function(String state)? stateChanged,
    TResult Function(int attempt, String reason)? retrying,
    TResult Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
    required TResult orElse(),
  }) {
    if (stateChanged != null) {
      return stateChanged(state);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_Play value) play,
    required TResult Function(_Pause value) pause,
    required TResult Function(_TogglePlayPause value) togglePlayPause,
    required TResult Function(_Reset value) reset,
    required TResult Function(_PlaybackStateChanged value) playbackStateChanged,
    required TResult Function(_MetadataUpdated value) metadataUpdated,
    required TResult Function(_AlbumArtFetched value) albumArtFetched,
    required TResult Function(_ErrorOccurred value) errorOccurred,
    required TResult Function(_StateChanged value) stateChanged,
    required TResult Function(_Retrying value) retrying,
    required TResult Function(_SetCustomMetadata value) setCustomMetadata,
    required TResult Function(_UpdateStation value) updateStation,
  }) {
    return stateChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_Play value)? play,
    TResult? Function(_Pause value)? pause,
    TResult? Function(_TogglePlayPause value)? togglePlayPause,
    TResult? Function(_Reset value)? reset,
    TResult? Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult? Function(_MetadataUpdated value)? metadataUpdated,
    TResult? Function(_AlbumArtFetched value)? albumArtFetched,
    TResult? Function(_ErrorOccurred value)? errorOccurred,
    TResult? Function(_StateChanged value)? stateChanged,
    TResult? Function(_Retrying value)? retrying,
    TResult? Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult? Function(_UpdateStation value)? updateStation,
  }) {
    return stateChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_Play value)? play,
    TResult Function(_Pause value)? pause,
    TResult Function(_TogglePlayPause value)? togglePlayPause,
    TResult Function(_Reset value)? reset,
    TResult Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult Function(_MetadataUpdated value)? metadataUpdated,
    TResult Function(_AlbumArtFetched value)? albumArtFetched,
    TResult Function(_ErrorOccurred value)? errorOccurred,
    TResult Function(_StateChanged value)? stateChanged,
    TResult Function(_Retrying value)? retrying,
    TResult Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult Function(_UpdateStation value)? updateStation,
    required TResult orElse(),
  }) {
    if (stateChanged != null) {
      return stateChanged(this);
    }
    return orElse();
  }
}

abstract class _StateChanged implements RadioPlayerEvent {
  const factory _StateChanged(final String state) = _$StateChangedImpl;

  String get state;

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StateChangedImplCopyWith<_$StateChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RetryingImplCopyWith<$Res> {
  factory _$$RetryingImplCopyWith(
    _$RetryingImpl value,
    $Res Function(_$RetryingImpl) then,
  ) = __$$RetryingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int attempt, String reason});
}

/// @nodoc
class __$$RetryingImplCopyWithImpl<$Res>
    extends _$RadioPlayerEventCopyWithImpl<$Res, _$RetryingImpl>
    implements _$$RetryingImplCopyWith<$Res> {
  __$$RetryingImplCopyWithImpl(
    _$RetryingImpl _value,
    $Res Function(_$RetryingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? attempt = null, Object? reason = null}) {
    return _then(
      _$RetryingImpl(
        null == attempt
            ? _value.attempt
            : attempt // ignore: cast_nullable_to_non_nullable
                  as int,
        null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$RetryingImpl implements _Retrying {
  const _$RetryingImpl(this.attempt, this.reason);

  @override
  final int attempt;
  @override
  final String reason;

  @override
  String toString() {
    return 'RadioPlayerEvent.retrying(attempt: $attempt, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RetryingImpl &&
            (identical(other.attempt, attempt) || other.attempt == attempt) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, attempt, reason);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RetryingImplCopyWith<_$RetryingImpl> get copyWith =>
      __$$RetryingImplCopyWithImpl<_$RetryingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(RadioEntity config, bool autoPlay) initialize,
    required TResult Function() play,
    required TResult Function() pause,
    required TResult Function() togglePlayPause,
    required TResult Function() reset,
    required TResult Function(bool isPlaying) playbackStateChanged,
    required TResult Function(String? artist, String? title) metadataUpdated,
    required TResult Function(String albumArtUrl) albumArtFetched,
    required TResult Function(String message) errorOccurred,
    required TResult Function(String state) stateChanged,
    required TResult Function(int attempt, String reason) retrying,
    required TResult Function(String artist, String title, String? artworkUrl)
    setCustomMetadata,
    required TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )
    updateStation,
  }) {
    return retrying(attempt, reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(RadioEntity config, bool autoPlay)? initialize,
    TResult? Function()? play,
    TResult? Function()? pause,
    TResult? Function()? togglePlayPause,
    TResult? Function()? reset,
    TResult? Function(bool isPlaying)? playbackStateChanged,
    TResult? Function(String? artist, String? title)? metadataUpdated,
    TResult? Function(String albumArtUrl)? albumArtFetched,
    TResult? Function(String message)? errorOccurred,
    TResult? Function(String state)? stateChanged,
    TResult? Function(int attempt, String reason)? retrying,
    TResult? Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult? Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
  }) {
    return retrying?.call(attempt, reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(RadioEntity config, bool autoPlay)? initialize,
    TResult Function()? play,
    TResult Function()? pause,
    TResult Function()? togglePlayPause,
    TResult Function()? reset,
    TResult Function(bool isPlaying)? playbackStateChanged,
    TResult Function(String? artist, String? title)? metadataUpdated,
    TResult Function(String albumArtUrl)? albumArtFetched,
    TResult Function(String message)? errorOccurred,
    TResult Function(String state)? stateChanged,
    TResult Function(int attempt, String reason)? retrying,
    TResult Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
    required TResult orElse(),
  }) {
    if (retrying != null) {
      return retrying(attempt, reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_Play value) play,
    required TResult Function(_Pause value) pause,
    required TResult Function(_TogglePlayPause value) togglePlayPause,
    required TResult Function(_Reset value) reset,
    required TResult Function(_PlaybackStateChanged value) playbackStateChanged,
    required TResult Function(_MetadataUpdated value) metadataUpdated,
    required TResult Function(_AlbumArtFetched value) albumArtFetched,
    required TResult Function(_ErrorOccurred value) errorOccurred,
    required TResult Function(_StateChanged value) stateChanged,
    required TResult Function(_Retrying value) retrying,
    required TResult Function(_SetCustomMetadata value) setCustomMetadata,
    required TResult Function(_UpdateStation value) updateStation,
  }) {
    return retrying(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_Play value)? play,
    TResult? Function(_Pause value)? pause,
    TResult? Function(_TogglePlayPause value)? togglePlayPause,
    TResult? Function(_Reset value)? reset,
    TResult? Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult? Function(_MetadataUpdated value)? metadataUpdated,
    TResult? Function(_AlbumArtFetched value)? albumArtFetched,
    TResult? Function(_ErrorOccurred value)? errorOccurred,
    TResult? Function(_StateChanged value)? stateChanged,
    TResult? Function(_Retrying value)? retrying,
    TResult? Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult? Function(_UpdateStation value)? updateStation,
  }) {
    return retrying?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_Play value)? play,
    TResult Function(_Pause value)? pause,
    TResult Function(_TogglePlayPause value)? togglePlayPause,
    TResult Function(_Reset value)? reset,
    TResult Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult Function(_MetadataUpdated value)? metadataUpdated,
    TResult Function(_AlbumArtFetched value)? albumArtFetched,
    TResult Function(_ErrorOccurred value)? errorOccurred,
    TResult Function(_StateChanged value)? stateChanged,
    TResult Function(_Retrying value)? retrying,
    TResult Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult Function(_UpdateStation value)? updateStation,
    required TResult orElse(),
  }) {
    if (retrying != null) {
      return retrying(this);
    }
    return orElse();
  }
}

abstract class _Retrying implements RadioPlayerEvent {
  const factory _Retrying(final int attempt, final String reason) =
      _$RetryingImpl;

  int get attempt;
  String get reason;

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RetryingImplCopyWith<_$RetryingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SetCustomMetadataImplCopyWith<$Res> {
  factory _$$SetCustomMetadataImplCopyWith(
    _$SetCustomMetadataImpl value,
    $Res Function(_$SetCustomMetadataImpl) then,
  ) = __$$SetCustomMetadataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String artist, String title, String? artworkUrl});
}

/// @nodoc
class __$$SetCustomMetadataImplCopyWithImpl<$Res>
    extends _$RadioPlayerEventCopyWithImpl<$Res, _$SetCustomMetadataImpl>
    implements _$$SetCustomMetadataImplCopyWith<$Res> {
  __$$SetCustomMetadataImplCopyWithImpl(
    _$SetCustomMetadataImpl _value,
    $Res Function(_$SetCustomMetadataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? artist = null,
    Object? title = null,
    Object? artworkUrl = freezed,
  }) {
    return _then(
      _$SetCustomMetadataImpl(
        artist: null == artist
            ? _value.artist
            : artist // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        artworkUrl: freezed == artworkUrl
            ? _value.artworkUrl
            : artworkUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$SetCustomMetadataImpl implements _SetCustomMetadata {
  const _$SetCustomMetadataImpl({
    required this.artist,
    required this.title,
    this.artworkUrl,
  });

  @override
  final String artist;
  @override
  final String title;
  @override
  final String? artworkUrl;

  @override
  String toString() {
    return 'RadioPlayerEvent.setCustomMetadata(artist: $artist, title: $title, artworkUrl: $artworkUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetCustomMetadataImpl &&
            (identical(other.artist, artist) || other.artist == artist) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.artworkUrl, artworkUrl) ||
                other.artworkUrl == artworkUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, artist, title, artworkUrl);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetCustomMetadataImplCopyWith<_$SetCustomMetadataImpl> get copyWith =>
      __$$SetCustomMetadataImplCopyWithImpl<_$SetCustomMetadataImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(RadioEntity config, bool autoPlay) initialize,
    required TResult Function() play,
    required TResult Function() pause,
    required TResult Function() togglePlayPause,
    required TResult Function() reset,
    required TResult Function(bool isPlaying) playbackStateChanged,
    required TResult Function(String? artist, String? title) metadataUpdated,
    required TResult Function(String albumArtUrl) albumArtFetched,
    required TResult Function(String message) errorOccurred,
    required TResult Function(String state) stateChanged,
    required TResult Function(int attempt, String reason) retrying,
    required TResult Function(String artist, String title, String? artworkUrl)
    setCustomMetadata,
    required TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )
    updateStation,
  }) {
    return setCustomMetadata(artist, title, artworkUrl);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(RadioEntity config, bool autoPlay)? initialize,
    TResult? Function()? play,
    TResult? Function()? pause,
    TResult? Function()? togglePlayPause,
    TResult? Function()? reset,
    TResult? Function(bool isPlaying)? playbackStateChanged,
    TResult? Function(String? artist, String? title)? metadataUpdated,
    TResult? Function(String albumArtUrl)? albumArtFetched,
    TResult? Function(String message)? errorOccurred,
    TResult? Function(String state)? stateChanged,
    TResult? Function(int attempt, String reason)? retrying,
    TResult? Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult? Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
  }) {
    return setCustomMetadata?.call(artist, title, artworkUrl);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(RadioEntity config, bool autoPlay)? initialize,
    TResult Function()? play,
    TResult Function()? pause,
    TResult Function()? togglePlayPause,
    TResult Function()? reset,
    TResult Function(bool isPlaying)? playbackStateChanged,
    TResult Function(String? artist, String? title)? metadataUpdated,
    TResult Function(String albumArtUrl)? albumArtFetched,
    TResult Function(String message)? errorOccurred,
    TResult Function(String state)? stateChanged,
    TResult Function(int attempt, String reason)? retrying,
    TResult Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
    required TResult orElse(),
  }) {
    if (setCustomMetadata != null) {
      return setCustomMetadata(artist, title, artworkUrl);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_Play value) play,
    required TResult Function(_Pause value) pause,
    required TResult Function(_TogglePlayPause value) togglePlayPause,
    required TResult Function(_Reset value) reset,
    required TResult Function(_PlaybackStateChanged value) playbackStateChanged,
    required TResult Function(_MetadataUpdated value) metadataUpdated,
    required TResult Function(_AlbumArtFetched value) albumArtFetched,
    required TResult Function(_ErrorOccurred value) errorOccurred,
    required TResult Function(_StateChanged value) stateChanged,
    required TResult Function(_Retrying value) retrying,
    required TResult Function(_SetCustomMetadata value) setCustomMetadata,
    required TResult Function(_UpdateStation value) updateStation,
  }) {
    return setCustomMetadata(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_Play value)? play,
    TResult? Function(_Pause value)? pause,
    TResult? Function(_TogglePlayPause value)? togglePlayPause,
    TResult? Function(_Reset value)? reset,
    TResult? Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult? Function(_MetadataUpdated value)? metadataUpdated,
    TResult? Function(_AlbumArtFetched value)? albumArtFetched,
    TResult? Function(_ErrorOccurred value)? errorOccurred,
    TResult? Function(_StateChanged value)? stateChanged,
    TResult? Function(_Retrying value)? retrying,
    TResult? Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult? Function(_UpdateStation value)? updateStation,
  }) {
    return setCustomMetadata?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_Play value)? play,
    TResult Function(_Pause value)? pause,
    TResult Function(_TogglePlayPause value)? togglePlayPause,
    TResult Function(_Reset value)? reset,
    TResult Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult Function(_MetadataUpdated value)? metadataUpdated,
    TResult Function(_AlbumArtFetched value)? albumArtFetched,
    TResult Function(_ErrorOccurred value)? errorOccurred,
    TResult Function(_StateChanged value)? stateChanged,
    TResult Function(_Retrying value)? retrying,
    TResult Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult Function(_UpdateStation value)? updateStation,
    required TResult orElse(),
  }) {
    if (setCustomMetadata != null) {
      return setCustomMetadata(this);
    }
    return orElse();
  }
}

abstract class _SetCustomMetadata implements RadioPlayerEvent {
  const factory _SetCustomMetadata({
    required final String artist,
    required final String title,
    final String? artworkUrl,
  }) = _$SetCustomMetadataImpl;

  String get artist;
  String get title;
  String? get artworkUrl;

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetCustomMetadataImplCopyWith<_$SetCustomMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateStationImplCopyWith<$Res> {
  factory _$$UpdateStationImplCopyWith(
    _$UpdateStationImpl value,
    $Res Function(_$UpdateStationImpl) then,
  ) = __$$UpdateStationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String title,
    String url,
    bool parseStreamMetadata,
    bool lookupOnlineArtwork,
    String? logoAssetPath,
    String? logoNetworkUrl,
  });
}

/// @nodoc
class __$$UpdateStationImplCopyWithImpl<$Res>
    extends _$RadioPlayerEventCopyWithImpl<$Res, _$UpdateStationImpl>
    implements _$$UpdateStationImplCopyWith<$Res> {
  __$$UpdateStationImplCopyWithImpl(
    _$UpdateStationImpl _value,
    $Res Function(_$UpdateStationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? url = null,
    Object? parseStreamMetadata = null,
    Object? lookupOnlineArtwork = null,
    Object? logoAssetPath = freezed,
    Object? logoNetworkUrl = freezed,
  }) {
    return _then(
      _$UpdateStationImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        parseStreamMetadata: null == parseStreamMetadata
            ? _value.parseStreamMetadata
            : parseStreamMetadata // ignore: cast_nullable_to_non_nullable
                  as bool,
        lookupOnlineArtwork: null == lookupOnlineArtwork
            ? _value.lookupOnlineArtwork
            : lookupOnlineArtwork // ignore: cast_nullable_to_non_nullable
                  as bool,
        logoAssetPath: freezed == logoAssetPath
            ? _value.logoAssetPath
            : logoAssetPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        logoNetworkUrl: freezed == logoNetworkUrl
            ? _value.logoNetworkUrl
            : logoNetworkUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$UpdateStationImpl implements _UpdateStation {
  const _$UpdateStationImpl({
    required this.title,
    required this.url,
    required this.parseStreamMetadata,
    required this.lookupOnlineArtwork,
    this.logoAssetPath,
    this.logoNetworkUrl,
  });

  @override
  final String title;
  @override
  final String url;
  @override
  final bool parseStreamMetadata;
  @override
  final bool lookupOnlineArtwork;
  @override
  final String? logoAssetPath;
  @override
  final String? logoNetworkUrl;

  @override
  String toString() {
    return 'RadioPlayerEvent.updateStation(title: $title, url: $url, parseStreamMetadata: $parseStreamMetadata, lookupOnlineArtwork: $lookupOnlineArtwork, logoAssetPath: $logoAssetPath, logoNetworkUrl: $logoNetworkUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateStationImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.parseStreamMetadata, parseStreamMetadata) ||
                other.parseStreamMetadata == parseStreamMetadata) &&
            (identical(other.lookupOnlineArtwork, lookupOnlineArtwork) ||
                other.lookupOnlineArtwork == lookupOnlineArtwork) &&
            (identical(other.logoAssetPath, logoAssetPath) ||
                other.logoAssetPath == logoAssetPath) &&
            (identical(other.logoNetworkUrl, logoNetworkUrl) ||
                other.logoNetworkUrl == logoNetworkUrl));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    url,
    parseStreamMetadata,
    lookupOnlineArtwork,
    logoAssetPath,
    logoNetworkUrl,
  );

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateStationImplCopyWith<_$UpdateStationImpl> get copyWith =>
      __$$UpdateStationImplCopyWithImpl<_$UpdateStationImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(RadioEntity config, bool autoPlay) initialize,
    required TResult Function() play,
    required TResult Function() pause,
    required TResult Function() togglePlayPause,
    required TResult Function() reset,
    required TResult Function(bool isPlaying) playbackStateChanged,
    required TResult Function(String? artist, String? title) metadataUpdated,
    required TResult Function(String albumArtUrl) albumArtFetched,
    required TResult Function(String message) errorOccurred,
    required TResult Function(String state) stateChanged,
    required TResult Function(int attempt, String reason) retrying,
    required TResult Function(String artist, String title, String? artworkUrl)
    setCustomMetadata,
    required TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )
    updateStation,
  }) {
    return updateStation(
      title,
      url,
      parseStreamMetadata,
      lookupOnlineArtwork,
      logoAssetPath,
      logoNetworkUrl,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(RadioEntity config, bool autoPlay)? initialize,
    TResult? Function()? play,
    TResult? Function()? pause,
    TResult? Function()? togglePlayPause,
    TResult? Function()? reset,
    TResult? Function(bool isPlaying)? playbackStateChanged,
    TResult? Function(String? artist, String? title)? metadataUpdated,
    TResult? Function(String albumArtUrl)? albumArtFetched,
    TResult? Function(String message)? errorOccurred,
    TResult? Function(String state)? stateChanged,
    TResult? Function(int attempt, String reason)? retrying,
    TResult? Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult? Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
  }) {
    return updateStation?.call(
      title,
      url,
      parseStreamMetadata,
      lookupOnlineArtwork,
      logoAssetPath,
      logoNetworkUrl,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(RadioEntity config, bool autoPlay)? initialize,
    TResult Function()? play,
    TResult Function()? pause,
    TResult Function()? togglePlayPause,
    TResult Function()? reset,
    TResult Function(bool isPlaying)? playbackStateChanged,
    TResult Function(String? artist, String? title)? metadataUpdated,
    TResult Function(String albumArtUrl)? albumArtFetched,
    TResult Function(String message)? errorOccurred,
    TResult Function(String state)? stateChanged,
    TResult Function(int attempt, String reason)? retrying,
    TResult Function(String artist, String title, String? artworkUrl)?
    setCustomMetadata,
    TResult Function(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
    )?
    updateStation,
    required TResult orElse(),
  }) {
    if (updateStation != null) {
      return updateStation(
        title,
        url,
        parseStreamMetadata,
        lookupOnlineArtwork,
        logoAssetPath,
        logoNetworkUrl,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_Play value) play,
    required TResult Function(_Pause value) pause,
    required TResult Function(_TogglePlayPause value) togglePlayPause,
    required TResult Function(_Reset value) reset,
    required TResult Function(_PlaybackStateChanged value) playbackStateChanged,
    required TResult Function(_MetadataUpdated value) metadataUpdated,
    required TResult Function(_AlbumArtFetched value) albumArtFetched,
    required TResult Function(_ErrorOccurred value) errorOccurred,
    required TResult Function(_StateChanged value) stateChanged,
    required TResult Function(_Retrying value) retrying,
    required TResult Function(_SetCustomMetadata value) setCustomMetadata,
    required TResult Function(_UpdateStation value) updateStation,
  }) {
    return updateStation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_Play value)? play,
    TResult? Function(_Pause value)? pause,
    TResult? Function(_TogglePlayPause value)? togglePlayPause,
    TResult? Function(_Reset value)? reset,
    TResult? Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult? Function(_MetadataUpdated value)? metadataUpdated,
    TResult? Function(_AlbumArtFetched value)? albumArtFetched,
    TResult? Function(_ErrorOccurred value)? errorOccurred,
    TResult? Function(_StateChanged value)? stateChanged,
    TResult? Function(_Retrying value)? retrying,
    TResult? Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult? Function(_UpdateStation value)? updateStation,
  }) {
    return updateStation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_Play value)? play,
    TResult Function(_Pause value)? pause,
    TResult Function(_TogglePlayPause value)? togglePlayPause,
    TResult Function(_Reset value)? reset,
    TResult Function(_PlaybackStateChanged value)? playbackStateChanged,
    TResult Function(_MetadataUpdated value)? metadataUpdated,
    TResult Function(_AlbumArtFetched value)? albumArtFetched,
    TResult Function(_ErrorOccurred value)? errorOccurred,
    TResult Function(_StateChanged value)? stateChanged,
    TResult Function(_Retrying value)? retrying,
    TResult Function(_SetCustomMetadata value)? setCustomMetadata,
    TResult Function(_UpdateStation value)? updateStation,
    required TResult orElse(),
  }) {
    if (updateStation != null) {
      return updateStation(this);
    }
    return orElse();
  }
}

abstract class _UpdateStation implements RadioPlayerEvent {
  const factory _UpdateStation({
    required final String title,
    required final String url,
    required final bool parseStreamMetadata,
    required final bool lookupOnlineArtwork,
    final String? logoAssetPath,
    final String? logoNetworkUrl,
  }) = _$UpdateStationImpl;

  String get title;
  String get url;
  bool get parseStreamMetadata;
  bool get lookupOnlineArtwork;
  String? get logoAssetPath;
  String? get logoNetworkUrl;

  /// Create a copy of RadioPlayerEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateStationImplCopyWith<_$UpdateStationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
