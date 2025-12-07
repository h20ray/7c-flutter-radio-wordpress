import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/app_config.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/audio/audio_focus_manager.dart';
import '../../../../config/radio_config.dart';
import '../../domain/entities/radio_entity.dart';
import '../../domain/entities/radio_player_entity.dart';
import '../../domain/repositories/radio_player_repository.dart';
import '../../domain/usecases/initialize_radio_player.dart';
import '../../domain/usecases/play_radio.dart';
import '../../domain/usecases/pause_radio.dart';
import '../../domain/usecases/reset_radio_player.dart';
import '../../../gamification/domain/usecases/record_listening_session.dart';
import '../../domain/repositories/song_history_repository.dart';
import '../bloc/radio_bloc.dart';
import 'radio_player_event.dart';
import '../../../../core/utils/debug_logger.dart';
import 'radio_player_state.dart';

/// BLoC for managing radio player state and operations
/// This is the single source of truth for radio player state across the app
class RadioPlayerBloc extends Bloc<RadioPlayerEvent, RadioPlayerState> {
  final InitializeRadioPlayer initializeRadioPlayer;
  final PlayRadio playRadio;
  final PauseRadio pauseRadio;
  final ResetRadioPlayer resetRadioPlayer;
  final RadioPlayerRepository repository;
  final RadioBloc radioConfigBloc;
  final RecordListeningSession recordListeningSession;
  final SongHistoryRepository? songHistoryRepository;

  StreamSubscription<RadioPlayerEntity>? _playerStateSubscription;
  StreamSubscription<RadioState>? _radioConfigSubscription;
  StreamSubscription<bool>? _audioFocusSubscription;
  StreamSubscription<AudioFocusEventData>? _audioFocusEventSubscription;

  // Store current radio config for initialization
  RadioEntity? _currentConfig;

  // Guard against duplicate initialization
  bool _initSent = false;

  // Pending autoplay flag
  bool _autoPlayPending = false;

  // Guard against rapid state changes
  bool? _lastKnownPlayingState;

  // Guard against rapid toggling (separate from play/pause debouncing)
  DateTime? _lastToggleTime;

  // Separate guards for direct play/pause calls
  DateTime? _lastPlayTime;
  DateTime? _lastPauseTime;

  // Audio focus state management
  bool _wasPlayingBeforeFocusLoss = false;
  bool _canAutoResume = false;
  DateTime? _sessionStart;
  Timer? _listeningFlushTimer;
  bool _isFlushingListeningSession = false;
  
  // Metadata change tracking for optimized flush
  String? _lastMetadataArtist;
  String? _lastMetadataTitle;
  Timer? _metadataFlushDebounceTimer;
  static const Duration _metadataFlushDebounceDelay = Duration(seconds: 2);

  RadioPlayerBloc({
    required this.initializeRadioPlayer,
    required this.playRadio,
    required this.pauseRadio,
    required this.resetRadioPlayer,
    required this.repository,
    required this.radioConfigBloc,
    required this.recordListeningSession,
    this.songHistoryRepository,
  }) : super(const RadioPlayerState.initial()) {
    // 1) Register event handlers FIRST
    on<RadioPlayerEvent>(_onRadioPlayerEvent);

    // 2) Then set up listeners that might call add()
    _setupStreamListeners();
    _setupRadioConfigListener();
    _setupAudioFocusListener();
    _setupAudioFocusEventListener();
  }

  /// Set up stream listener to repository state changes
  void _setupStreamListeners() {
    _playerStateSubscription = repository.watchPlayerState().listen(
      (playerEntity) {
        // Enhanced state mapping
        if (playerEntity.errorMessage != null) {
          add(RadioPlayerEvent.errorOccurred(playerEntity.errorMessage!));
        } else if (playerEntity.isConnecting) {
          add(const RadioPlayerEvent.stateChanged('connecting'));
        } else if (playerEntity.isBuffering) {
          add(const RadioPlayerEvent.stateChanged('buffering'));
        } else if (playerEntity.isRetrying) {
          add(RadioPlayerEvent.retrying(
            playerEntity.retryAttempt,
            playerEntity.errorMessage ?? 'Retrying connection',
          ));
        } else if (playerEntity.isInitialized) {
          // Only emit playback state changes if the state actually changed
          if (_lastKnownPlayingState != playerEntity.isPlaying) {
            _lastKnownPlayingState = playerEntity.isPlaying;
            add(RadioPlayerEvent.playbackStateChanged(playerEntity.isPlaying));
          }

          if (playerEntity.hasMetadata) {
            add(RadioPlayerEvent.metadataUpdated(
              playerEntity.currentArtist,
              playerEntity.currentTitle,
            ));
          }
          if (playerEntity.hasAlbumArt) {
            add(RadioPlayerEvent.albumArtFetched(
                playerEntity.currentAlbumArtUrl!));
          }
        }
      },
      onError: (error) {
        add(RadioPlayerEvent.errorOccurred(
            'Stream error: ${error.toString()}'));
      },
    );
  }

  /// Set up listener to radio config changes
  void _setupRadioConfigListener() {
    DebugLogger.log('[RadioPlayerBloc] Setting up radio config listener', tag: 'RadioPlayerBloc');
    _radioConfigSubscription?.cancel();
    _radioConfigSubscription = radioConfigBloc.stream.listen(
      (radioState) {
        DebugLogger.log('[RadioPlayerBloc] Radio config state changed: ${radioState.runtimeType}', tag: 'RadioPlayerBloc');
        radioState.maybeWhen(
          loaded: (radioConfig) {
            DebugLogger.log('[RadioPlayerBloc] Radio config loaded: ${radioConfig.streamUrl}', tag: 'RadioPlayerBloc');
            _currentConfig = radioConfig;

            // Auto-initialize with autoplay if enabled (guard against duplicates)
            if (radioConfig.enabled && radioConfig.autoplay && !_initSent) {
              DebugLogger.log('[RadioPlayerBloc] Auto-initializing with autoplay enabled', tag: 'RadioPlayerBloc');
              _initSent = true;
              add(RadioPlayerEvent.initialize(radioConfig, autoPlay: true));
            } else if (radioConfig.enabled && !_initSent) {
              DebugLogger.log('[RadioPlayerBloc] Auto-initializing without autoplay', tag: 'RadioPlayerBloc');
              _initSent = true;
              add(RadioPlayerEvent.initialize(radioConfig, autoPlay: false));
            }
          },
          orElse: () {
            DebugLogger.log('[RadioPlayerBloc] Radio config not loaded yet', tag: 'RadioPlayerBloc');
          },
        );
      },
    );

    // Also check current state immediately
    final currentRadioState = radioConfigBloc.state;
    DebugLogger.log('[RadioPlayerBloc] Current radio config state: ${currentRadioState.runtimeType}', tag: 'RadioPlayerBloc');
    currentRadioState.maybeWhen(
      loaded: (radioConfig) {
        DebugLogger.log('[RadioPlayerBloc] Radio config already loaded: ${radioConfig.streamUrl}', tag: 'RadioPlayerBloc');
        _currentConfig = radioConfig;

        // Auto-initialize with autoplay if enabled (guard against duplicates)
        if (radioConfig.enabled && radioConfig.autoplay && !_initSent) {
          DebugLogger.log('[RadioPlayerBloc] Auto-initializing with autoplay enabled (immediate)', tag: 'RadioPlayerBloc');
          _initSent = true;
          add(RadioPlayerEvent.initialize(radioConfig, autoPlay: true));
        } else if (radioConfig.enabled && !_initSent) {
          DebugLogger.log('[RadioPlayerBloc] Auto-initializing without autoplay (immediate)', tag: 'RadioPlayerBloc');
          _initSent = true;
          add(RadioPlayerEvent.initialize(radioConfig, autoPlay: false));
        }
      },
      orElse: () {
        DebugLogger.log('[RadioPlayerBloc] Radio config not loaded in current state', tag: 'RadioPlayerBloc');
      },
    );
  }

  /// Set up audio focus listener
  void _setupAudioFocusListener() {
    try {
      _audioFocusSubscription = AudioFocusManager.instance.focusStream.listen(
        (hasFocus) {
          if (!hasFocus) {
            // Lost audio focus - only pause if we're actually playing
            final currentState = state;
            currentState.maybeWhen(
              ready: (isPlaying, currentUrl, currentArtist, currentTitle,
                  currentAlbumArtUrl, isDucking, canAutoResume) {
                if (isPlaying) {
                  DebugLogger.log('[RadioPlayerBloc] Lost audio focus, pausing playback', tag: 'RadioPlayerBloc');
                  add(const RadioPlayerEvent.pause());
                }
              },
              orElse: () {
                // Don't pause if not in ready state
              },
            );
          }
        },
      );
    } catch (e) {
      DebugLogger.logError('Audio focus listener setup failed', error: e, tag: 'RadioPlayerBloc');
      // Continue without audio focus monitoring
    }
  }

  /// Set up enhanced audio focus event listener
  void _setupAudioFocusEventListener() {
    try {
      _audioFocusEventSubscription =
          AudioFocusManager.instance.focusEventStream.listen(
        (focusEvent) {
          _handleAudioFocusEvent(focusEvent);
        },
      );
    } catch (e) {
      DebugLogger.logError('Audio focus event listener setup failed', error: e, tag: 'RadioPlayerBloc');
      // Continue without audio focus monitoring
    }
  }

  /// Handle audio focus events with smart behavior
  void _handleAudioFocusEvent(AudioFocusEventData focusEvent) {
    DebugLogger.log('[RadioPlayerBloc] Audio focus event: ${focusEvent.event}, hasFocus: ${focusEvent.hasFocus}', tag: 'RadioPlayerBloc');

    // Only handle focus events if we're in a ready state
    final currentState = state;
    currentState.maybeWhen(
      ready: (isPlaying, currentUrl, currentArtist, currentTitle,
          currentAlbumArtUrl, isDucking, canAutoResume) {
        switch (focusEvent.event) {
          case AudioFocusEvent.gain:
            _handleFocusGain();
            break;
          case AudioFocusEvent.loss:
            _handleFocusLoss();
            break;
          case AudioFocusEvent.lossTransient:
            _handleFocusLossTransient();
            break;
          case AudioFocusEvent.lossTransientCanDuck:
            _handleFocusLossTransientCanDuck();
            break;
        }
      },
      orElse: () {
        // Don't handle focus events if not in ready state
        DebugLogger.log('[RadioPlayerBloc] Ignoring audio focus event - not in ready state', tag: 'RadioPlayerBloc');
      },
    );
  }

  /// Handle focus gain - resume if we were playing before
  void _handleFocusGain() {
    if (_canAutoResume && _wasPlayingBeforeFocusLoss) {
      DebugLogger.log('[RadioPlayerBloc] Auto-resuming playback after focus gain', tag: 'RadioPlayerBloc');
      add(const RadioPlayerEvent.play());
    }
    _canAutoResume = false;
    _wasPlayingBeforeFocusLoss = false;
  }

  /// Handle permanent focus loss - pause and don't auto-resume
  void _handleFocusLoss() {
    final currentState = state;
    currentState.maybeWhen(
      ready: (isPlaying, currentUrl, currentArtist, currentTitle,
          currentAlbumArtUrl, isDucking, canAutoResume) {
        if (isPlaying) {
          _wasPlayingBeforeFocusLoss = true;
          _canAutoResume = false; // Permanent loss, don't auto-resume
          DebugLogger.log('[RadioPlayerBloc] Permanent focus loss, pausing playback', tag: 'RadioPlayerBloc');
          add(const RadioPlayerEvent.pause());
        }
      },
      orElse: () {},
    );
  }

  /// Handle transient focus loss - pause but be ready to resume
  void _handleFocusLossTransient() {
    final currentState = state;
    currentState.maybeWhen(
      ready: (isPlaying, currentUrl, currentArtist, currentTitle,
          currentAlbumArtUrl, isDucking, canAutoResume) {
        if (isPlaying) {
          _wasPlayingBeforeFocusLoss = true;
          _canAutoResume = true; // Transient loss, can auto-resume
          DebugLogger.log('[RadioPlayerBloc] Transient focus loss, pausing playback (will auto-resume)', tag: 'RadioPlayerBloc');
          add(const RadioPlayerEvent.pause());
        }
      },
      orElse: () {},
    );
  }

  /// Handle transient focus loss with ducking - reduce volume but keep playing
  void _handleFocusLossTransientCanDuck() {
    final currentState = state;
    currentState.maybeWhen(
      ready: (isPlaying, currentUrl, currentArtist, currentTitle,
          currentAlbumArtUrl, isDucking, canAutoResume) {
        if (isPlaying) {
          DebugLogger.log('[RadioPlayerBloc] Transient focus loss with ducking, reducing volume', tag: 'RadioPlayerBloc');
          // Update state to show ducking without pausing
          add(RadioPlayerEvent.playbackStateChanged(true)); // Keep playing but with ducking
        }
      },
      orElse: () {},
    );
  }

  /// Handle all radio player events
  Future<void> _onRadioPlayerEvent(
    RadioPlayerEvent event,
    Emitter<RadioPlayerState> emit,
  ) async {
    event.when(
      initialize: (config, autoPlay) =>
          _onInitialize(config, emit, autoPlay: autoPlay),
      play: () => _onPlay(emit),
      pause: () => _onPause(emit),
      togglePlayPause: () async => _onTogglePlayPause(emit),
      reset: () => _onReset(emit),
      playbackStateChanged: (isPlaying) =>
          _onPlaybackStateChanged(isPlaying, emit),
      metadataUpdated: (artist, title) =>
          _onMetadataUpdated(artist, title, emit),
      albumArtFetched: (albumArtUrl) => _onAlbumArtFetched(albumArtUrl, emit),
      errorOccurred: (message) => _onErrorOccurred(message, emit),
      stateChanged: (state) => _onStateChanged(state, emit),
      retrying: (attempt, reason) => _onRetrying(attempt, reason, emit),
      setCustomMetadata: (artist, title, artworkUrl) =>
          _onSetCustomMetadata(artist, title, artworkUrl, emit),
      updateStation: (title, url, parseStreamMetadata, lookupOnlineArtwork,
              logoAssetPath, logoNetworkUrl) =>
          _onUpdateStation(title, url, parseStreamMetadata, lookupOnlineArtwork,
              logoAssetPath, logoNetworkUrl, emit),
    );
  }

  /// Handle initialize event
  Future<void> _onInitialize(RadioEntity config, Emitter<RadioPlayerState> emit,
      {bool autoPlay = false}) async {
    DebugLogger.log('[RadioPlayerBloc] Initialize called - Stream URL: ${config.streamUrl}, AutoPlay: $autoPlay', tag: 'RadioPlayerBloc');
    emit(const RadioPlayerState.initializing());

    // Store config for later use
    _currentConfig = config;

    DebugLogger.log('[RadioPlayerBloc] Calling initializeRadioPlayer use case', tag: 'RadioPlayerBloc');
    final result = await initializeRadioPlayer(config);
    await result.fold(
      (failure) async {
        DebugLogger.logError('Initialize failed', error: failure, tag: 'RadioPlayerBloc');
        emit(RadioPlayerState.error(failure: failure, message: failure.message));
      },
      (unit) async {
        DebugLogger.log('[RadioPlayerBloc] Initialize succeeded', tag: 'RadioPlayerBloc');
        // Success - state will be updated via stream listener
        // If autoPlay is true, set flag and wait for ready state
        if (autoPlay) {
          DebugLogger.log('[RadioPlayerBloc] AutoPlay enabled - waiting for ready state', tag: 'RadioPlayerBloc');
          _autoPlayPending = true;
        }
      },
    );
  }

  /// Handle play event
  Future<void> _onPlay(Emitter<RadioPlayerState> emit) async {
    // Prevent rapid play calls
    final now = DateTime.now();
    if (_lastPlayTime != null &&
        now.difference(_lastPlayTime!).inMilliseconds < 300) {
      DebugLogger.log('[RadioPlayerBloc] Play request debounced (too rapid)', tag: 'RadioPlayerBloc');
      return;
    }
    _lastPlayTime = now;

    // Optimize audio session and request audio focus
    try {
      await AudioFocusManager.instance.optimizeAudioSession();
      final audioSessionDelay = RadioConfig.audioSessionOptimizationDelayMs;
      await Future.delayed(Duration(milliseconds: audioSessionDelay));
      final hasFocus = await AudioFocusManager.instance.requestAudioFocus();
      if (!hasFocus) {
        DebugLogger.log('[RadioPlayerBloc] Audio focus denied, but continuing playback', tag: 'RadioPlayerBloc');
      } else {
        DebugLogger.log('[RadioPlayerBloc] Audio focus granted successfully', tag: 'RadioPlayerBloc');
      }
    } catch (e) {
      DebugLogger.log('[RadioPlayerBloc] Audio focus not available: $e', tag: 'RadioPlayerBloc');
      // Continue without audio focus - not critical
    }

    DebugLogger.log('[RadioPlayerBloc] Starting playback', tag: 'RadioPlayerBloc');
    final audioFocusDelay = RadioConfig.audioFocusDelayMs;
    await Future.delayed(Duration(milliseconds: audioFocusDelay));
    final result = await playRadio();
    result.fold(
      (failure) => emit(
          RadioPlayerState.error(failure: failure, message: failure.message)),
      (unit) {
        // Success - state will be updated via stream listener
      },
    );
  }

  /// Handle pause event
  Future<void> _onPause(Emitter<RadioPlayerState> emit) async {
    // Prevent rapid pause calls
    final now = DateTime.now();
    if (_lastPauseTime != null &&
        now.difference(_lastPauseTime!).inMilliseconds < 300) {
      DebugLogger.log('[RadioPlayerBloc] Pause request debounced (too rapid)', tag: 'RadioPlayerBloc');
      return;
    }
    _lastPauseTime = now;

    // Try to release audio focus
    try {
      await AudioFocusManager.instance.releaseAudioFocus();
    } catch (e) {
      DebugLogger.log('[RadioPlayerBloc] Audio focus release failed: $e', tag: 'RadioPlayerBloc');
      // Continue - not critical
    }

    DebugLogger.log('[RadioPlayerBloc] Pausing playback', tag: 'RadioPlayerBloc');
    final result = await pauseRadio();
    result.fold(
      (failure) => emit(
          RadioPlayerState.error(failure: failure, message: failure.message)),
      (unit) {
        // Success - state will be updated via stream listener
      },
    );
  }

  /// Handle toggle play/pause event
  Future<void> _onTogglePlayPause(Emitter<RadioPlayerState> emit) async {
    // Prevent rapid toggling
    final now = DateTime.now();
    if (_lastToggleTime != null &&
        now.difference(_lastToggleTime!).inMilliseconds < 500) {
      DebugLogger.log('[RadioPlayerBloc] Toggle request debounced (too rapid)', tag: 'RadioPlayerBloc');
      return;
    }
    _lastToggleTime = now;

    final currentState = state;
    currentState.maybeWhen(
      initial: () {
        // Initialize and play if we have config
        if (_currentConfig != null) {
          DebugLogger.log('[RadioPlayerBloc] Initializing with config: ${_currentConfig!.streamUrl}', tag: 'RadioPlayerBloc');
          add(RadioPlayerEvent.initialize(_currentConfig!, autoPlay: true));
        } else {
          DebugLogger.logError('No config available for initialization', tag: 'RadioPlayerBloc');
        }
      },
      initializing: () {
        // Do nothing - wait for initialization to complete
      },
      ready: (isPlaying, currentUrl, currentArtist, currentTitle,
          currentAlbumArtUrl, isDucking, canAutoResume) {
        if (isPlaying) {
          _onPause(emit);
        } else {
          _onPlay(emit);
        }
      },
      error: (failure, message) {
        // Retry initialization on error
        if (_currentConfig != null) {
          DebugLogger.log('[RadioPlayerBloc] Retrying initialization after error', tag: 'RadioPlayerBloc');
          add(RadioPlayerEvent.initialize(_currentConfig!, autoPlay: true));
        }
      },
      orElse: () {
        // Do nothing for other states
      },
    );
  }

  /// Handle reset event
  Future<void> _onReset(Emitter<RadioPlayerState> emit) async {
    final result = await resetRadioPlayer();
    result.fold(
      (failure) => emit(
          RadioPlayerState.error(failure: failure, message: failure.message)),
      (unit) => emit(const RadioPlayerState.initial()),
    );
  }

  /// Handle playback state changed event
  void _onPlaybackStateChanged(bool isPlaying, Emitter<RadioPlayerState> emit) {
    _handleListeningSession(isPlaying);
    final currentState = state;
    currentState.maybeWhen(
      ready: (currentIsPlaying, currentUrl, currentArtist, currentTitle,
          currentAlbumArtUrl, isDucking, canAutoResume) {
        emit(RadioPlayerState.ready(
          isPlaying: isPlaying,
          currentUrl: currentUrl,
          currentArtist: currentArtist,
          currentTitle: currentTitle,
          currentAlbumArtUrl: currentAlbumArtUrl,
          isDucking: isDucking,
          canAutoResume: canAutoResume,
        ));
      },
      orElse: () {
        // First playback state change after initialization
        emit(RadioPlayerState.ready(
          isPlaying: isPlaying,
          currentUrl: _currentConfig?.streamUrl,
          isDucking: false,
          canAutoResume: false,
        ));
        
        // Trigger autoplay if pending
        if (_autoPlayPending && !isPlaying) {
          DebugLogger.log('[RadioPlayerBloc] Player ready - triggering pending autoplay', tag: 'RadioPlayerBloc');
          _autoPlayPending = false;
          add(const RadioPlayerEvent.togglePlayPause());
        }
      },
    );
  }

  /// Handle metadata updated event
  void _onMetadataUpdated(
      String? artist, String? title, Emitter<RadioPlayerState> emit) {
    final currentState = state;
    currentState.maybeWhen(
      ready: (isPlaying, currentUrl, currentArtist, currentTitle,
          currentAlbumArtUrl, isDucking, canAutoResume) {
        // Only emit if metadata actually changed
        if (currentArtist != artist || currentTitle != title) {
          emit(RadioPlayerState.ready(
            isPlaying: isPlaying,
            currentUrl: currentUrl,
            currentArtist: artist,
            currentTitle: title,
            currentAlbumArtUrl: currentAlbumArtUrl,
            isDucking: isDucking,
            canAutoResume: canAutoResume,
          ));

          // Track song in history if we have valid metadata
          // Skip tracking in Azuracast mode - history comes from API
          if (artist != null &&
              title != null &&
              artist.isNotEmpty &&
              title.isNotEmpty &&
              songHistoryRepository != null &&
              RadioConfig.songHistoryMode != 'azuracast') {
            _trackSong(artist, title, currentAlbumArtUrl);
          }
          
          // Flush listening session on metadata change (optimized with debounce)
          _handleMetadataChangeFlush(artist, title, isPlaying);
        }
      },
      orElse: () {},
    );
  }
  
  /// Handle flush on metadata change with debouncing to optimize battery usage
  void _handleMetadataChangeFlush(String? artist, String? title, bool isPlaying) {
    // Only flush if actually playing and we have an active session
    if (!isPlaying || _sessionStart == null) {
      return;
    }
    
    // Check if metadata actually changed (not just a duplicate update)
    if (_lastMetadataArtist == artist && _lastMetadataTitle == title) {
      return;
    }
    
    // Update last known metadata
    _lastMetadataArtist = artist;
    _lastMetadataTitle = title;
    
    // Cancel existing debounce timer
    _metadataFlushDebounceTimer?.cancel();
    
    // Debounce the flush to avoid rapid metadata changes causing excessive flushes
    // This is especially important for radio streams that might send metadata updates frequently
    _metadataFlushDebounceTimer = Timer(_metadataFlushDebounceDelay, () {
      unawaited(_flushListeningSession(keepSessionActive: true));
    });
  }

  /// Track song in history
  void _trackSong(String artist, String title, String? albumArtUrl) {
    if (songHistoryRepository == null) return;

    songHistoryRepository!.addSong(
      artist: artist,
      title: title,
      albumArtUrl: albumArtUrl,
    ).then((result) {
      result.fold(
        (failure) {
          DebugLogger.logError(
            'Failed to track song in history',
            error: failure,
            tag: 'RadioPlayerBloc',
          );
        },
        (_) {
          DebugLogger.log(
            'Tracked song in history: $artist - $title',
            tag: 'RadioPlayerBloc',
          );
        },
      );
    });
  }

  /// Handle album art fetched event
  void _onAlbumArtFetched(String albumArtUrl, Emitter<RadioPlayerState> emit) {
    final currentState = state;
    currentState.maybeWhen(
      ready: (isPlaying, currentUrl, currentArtist, currentTitle,
          currentAlbumArtUrl, isDucking, canAutoResume) {
        // Update album art in state
        if (currentAlbumArtUrl != albumArtUrl) {
          emit(RadioPlayerState.ready(
            isPlaying: isPlaying,
            currentUrl: currentUrl,
            currentArtist: currentArtist,
            currentTitle: currentTitle,
            currentAlbumArtUrl: albumArtUrl,
            isDucking: isDucking,
            canAutoResume: canAutoResume,
          ));

          // Update album art in history if we have current song
          // Skip in Azuracast mode - history comes from API
          if (currentArtist != null &&
              currentTitle != null &&
              currentArtist.isNotEmpty &&
              currentTitle.isNotEmpty &&
              songHistoryRepository != null &&
              RadioConfig.songHistoryMode != 'azuracast') {
            _updateAlbumArtInHistory(currentArtist, currentTitle, albumArtUrl);
          }
        }
      },
      orElse: () {},
    );
  }

  /// Update album art for existing song in history
  void _updateAlbumArtInHistory(String artist, String title, String albumArtUrl) {
    if (songHistoryRepository == null) return;

    songHistoryRepository!.updateAlbumArt(
      artist: artist,
      title: title,
      albumArtUrl: albumArtUrl,
    ).then((result) {
      result.fold(
        (failure) {
          DebugLogger.logError(
            'Failed to update album art in history',
            error: failure,
            tag: 'RadioPlayerBloc',
          );
        },
        (_) {
          DebugLogger.log(
            'Updated album art in history: $artist - $title',
            tag: 'RadioPlayerBloc',
          );
        },
      );
    });
  }

  /// Handle error occurred event
  void _onErrorOccurred(String message, Emitter<RadioPlayerState> emit) {
    final failure = ServerFailure(message);
    emit(RadioPlayerState.error(failure: failure, message: message));
  }

  /// Handle state changed event
  void _onStateChanged(String state, Emitter<RadioPlayerState> emit) {
    switch (state) {
      case 'connecting':
        emit(const RadioPlayerState.connecting());
        break;
      case 'buffering':
        emit(const RadioPlayerState.buffering());
        break;
      default:
        DebugLogger.log('[RadioPlayerBloc] Unknown state: $state', tag: 'RadioPlayerBloc');
    }
  }

  /// Handle retrying event
  void _onRetrying(int attempt, String reason, Emitter<RadioPlayerState> emit) {
    emit(RadioPlayerState.retrying(attempt: attempt, reason: reason));
  }

  /// Handle set custom metadata event
  Future<void> _onSetCustomMetadata(String artist, String title,
      String? artworkUrl, Emitter<RadioPlayerState> emit) async {
    final result = await repository.setCustomMetadata(
      artist: artist,
      title: title,
      artworkUrl: artworkUrl,
    );
    result.fold(
      (failure) => emit(
          RadioPlayerState.error(failure: failure, message: failure.message)),
      (unit) {
        // Success - no state change needed
      },
    );
  }

  /// Handle update station event
  Future<void> _onUpdateStation(
      String title,
      String url,
      bool parseStreamMetadata,
      bool lookupOnlineArtwork,
      String? logoAssetPath,
      String? logoNetworkUrl,
      Emitter<RadioPlayerState> emit) async {
    final result = await repository.updateStation(
      title: title,
      url: url,
      parseStreamMetadata: parseStreamMetadata,
      lookupOnlineArtwork: lookupOnlineArtwork,
      logoAssetPath: logoAssetPath,
      logoNetworkUrl: logoNetworkUrl,
    );
    result.fold(
      (failure) => emit(
          RadioPlayerState.error(failure: failure, message: failure.message)),
      (unit) {
        // Success - no state change needed
      },
    );
  }

  @override
  Future<void> close() async {
    _stopListeningFlushTimer();
    _metadataFlushDebounceTimer?.cancel();
    await _flushListeningSession();
    unawaited(_playerStateSubscription?.cancel());
    unawaited(_radioConfigSubscription?.cancel());
    unawaited(_audioFocusSubscription?.cancel());
    unawaited(_audioFocusEventSubscription?.cancel());
    return super.close();
  }

  void _handleListeningSession(bool isPlaying) {
    if (isPlaying) {
      final hadSession = _sessionStart != null;
      _sessionStart ??= DateTime.now();
      if (!hadSession) {
        _startListeningFlushTimer();
      }
    } else {
      _stopListeningFlushTimer();
      _metadataFlushDebounceTimer?.cancel();
      _lastMetadataArtist = null;
      _lastMetadataTitle = null;
      unawaited(_flushListeningSession());
    }
  }

  void _startListeningFlushTimer() {
    _listeningFlushTimer?.cancel();
    _listeningFlushTimer = Timer.periodic(
      AppConfig.listeningFlushInterval,
      (timer) => unawaited(_flushListeningSession(keepSessionActive: true)),
    );
  }

  void _stopListeningFlushTimer() {
    _listeningFlushTimer?.cancel();
    _listeningFlushTimer = null;
  }

  Future<void> _flushListeningSession({bool keepSessionActive = false}) async {
    if (_isFlushingListeningSession) {
      return;
    }
    final start = _sessionStart;
    if (start == null) {
      return;
    }
    final now = DateTime.now();
    final duration = now.difference(start);
    if (keepSessionActive && duration < _minListeningFlushDelta) {
      return;
    }
    _isFlushingListeningSession = true;
    try {
      if (duration.inSeconds <= 0) {
        if (!keepSessionActive) {
          _sessionStart = null;
        }
        return;
      }
      await recordListeningSession(duration);
      _sessionStart = keepSessionActive ? now : null;
    } finally {
      _isFlushingListeningSession = false;
    }
  }

  static const Duration _minListeningFlushDelta = Duration(seconds: 5);
}

