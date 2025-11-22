import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../config/radio_config.dart';
import '../../domain/entities/radio_entity.dart';
import '../../domain/entities/radio_player_entity.dart';
import '../../domain/repositories/radio_player_repository.dart';
import '../datasources/radio_player_remote_datasource.dart';
import '../services/album_art_service.dart';
import 'package:radio_player/radio_player.dart';
import '../../../../core/utils/debug_logger.dart';

/// Implementation of RadioPlayerRepository
class RadioPlayerRepositoryImpl implements RadioPlayerRepository {
  final RadioPlayerRemoteDataSource remoteDataSource;
  final AlbumArtService albumArtService;

  final StreamController<RadioPlayerEntity> _playerStateController =
      StreamController<RadioPlayerEntity>.broadcast();

  RadioPlayerEntity _currentState = const RadioPlayerEntity.initial();
  StreamSubscription<PlaybackState>? _playbackStateSubscription;
  StreamSubscription<Metadata>? _metadataSubscription;
  StreamSubscription<RemoteCommand>? _remoteCommandSubscription;

  // Guard against duplicate initialization
  bool _isInitializing = false;
  RadioEntity? _currentConfig;

  // Idempotent play mechanism
  Future<void>? _pendingPlayOperation;
  Timer? _debounceTimer;
  DateTime? _lastPlayRequest;

  // Track if audio has actually started playing
  bool _isAudioActuallyPlaying = false;

  // Performance tracking
  DateTime? _initializationStartTime;
  DateTime? _playStartTime;

  // Retry mechanism
  Timer? _retryTimer;
  int _currentRetryAttempt = 0;
  List<String> _availableUrls = [];
  int _currentUrlIndex = 0;

  RadioPlayerRepositoryImpl({
    required this.remoteDataSource,
    required this.albumArtService,
  }) {
    _setupStreamListeners();
  }

  /// Set up stream listeners to convert data source events to domain entities
  void _setupStreamListeners() {
    _playbackStateSubscription = remoteDataSource.playbackStateStream.listen(
      (playbackState) {
        final isPlaying = playbackState == PlaybackState.playing;
        
        // Set flag when audio actually starts playing
        if (isPlaying && !_isAudioActuallyPlaying) {
          _isAudioActuallyPlaying = true;
          if (RadioConfig.logNotificationUpdates) {
            DebugLogger.log('[RadioPlayerRepository] Audio playback started', tag: 'RadioPlayerRepository');
          }
        } else if (!isPlaying && _isAudioActuallyPlaying) {
          _isAudioActuallyPlaying = false;
          if (RadioConfig.logNotificationUpdates) {
            DebugLogger.log('[RadioPlayerRepository] Audio playback stopped', tag: 'RadioPlayerRepository');
          }
        }
        
        _updateState(_currentState.copyWith(
          isPlaying: isPlaying,
          isInitialized: true,
          errorMessage: null,
        ));
      },
      onError: (error) {
        _updateState(_currentState.copyWith(
          errorMessage: 'Playback state error: ${error.toString()}',
        ));
      },
    );

    _metadataSubscription = remoteDataSource.metadataStream.listen(
      (metadata) async {
        String? sanitizedArtist = metadata.artist;
        String? sanitizedTitle = metadata.title;

        // Sanitize metadata by removing configured phrases (case-insensitive)
        for (final phrase in RadioConfig.metadataRemovePhrases) {
          final regex = RegExp(RegExp.escape(phrase), caseSensitive: false);
          if (sanitizedArtist != null) {
            sanitizedArtist = sanitizedArtist.replaceAll(regex, '');
          }
          if (sanitizedTitle != null) {
            sanitizedTitle = sanitizedTitle.replaceAll(regex, '');
          }
        }

        // Trim and collapse spaces
        sanitizedArtist = sanitizedArtist?.replaceAll('\n', ' ').replaceAll('\t', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
        sanitizedTitle = sanitizedTitle?.replaceAll('\n', ' ').replaceAll('\t', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();

        final newArtist = (sanitizedArtist != null && sanitizedArtist.isNotEmpty)
            ? sanitizedArtist
            : RadioConfig.fallbackArtist;
        final newTitle = (sanitizedTitle != null && sanitizedTitle.isNotEmpty)
            ? sanitizedTitle
            : RadioConfig.fallbackTitle;

        _updateState(_currentState.copyWith(
          currentArtist: newArtist,
          currentTitle: newTitle,
          errorMessage: null,
        ));

        // Fetch album art for new metadata
        if ((_currentConfig?.showAlbumCover ?? false) &&
            (newArtist.isNotEmpty || newTitle.isNotEmpty) &&
            _currentConfig != null &&
            (!RadioConfig.delayMetadataUntilAudioStarts || _isAudioActuallyPlaying)) {
          final albumArtUrl = await albumArtService.getAlbumArtUrl(newArtist, newTitle, _currentConfig!);
          if (albumArtUrl != null && albumArtUrl.isNotEmpty) {
            _updateState(_currentState.copyWith(
              currentAlbumArtUrl: albumArtUrl,
            ));
          }
        }
      },
      onError: (error) {
        _updateState(_currentState.copyWith(
          errorMessage: 'Metadata error: ${error.toString()}',
        ));
      },
    );

    _remoteCommandSubscription = remoteDataSource.remoteCommandStream.listen(
      (command) {
        // Handle remote commands (play/pause from notification, etc.)
        if (command.toString().contains('play')) {
          play();
        } else if (command.toString().contains('pause')) {
          pause();
        } else if (command.toString().contains('stop')) {
          reset();
        }
      },
      onError: (error) {
        _updateState(_currentState.copyWith(
          errorMessage: 'Remote command error: ${error.toString()}',
        ));
      },
    );
  }

  /// Update the current state and emit to stream with debouncing
  void _updateState(RadioPlayerEntity newState) {
    _currentState = newState;

    // Debounce non-critical state updates
    if (_shouldDebounceState(newState)) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(
          Duration(milliseconds: RadioConfig.debounceWindowMs), () {
        _playerStateController.add(_currentState);
      });
    } else {
      // Critical states emit immediately
      _playerStateController.add(_currentState);
    }
  }

  /// Determine if state update should be debounced
  bool _shouldDebounceState(RadioPlayerEntity newState) {
    // Don't debounce critical states
    if (newState.errorMessage != null) return false;
    if (newState.isConnecting) return false;
    if (newState.isBuffering) return false;
    if (newState.isRetrying) return false;

    // Debounce metadata and album art updates
    return newState.currentArtist != _currentState.currentArtist ||
        newState.currentTitle != _currentState.currentTitle ||
        newState.currentAlbumArtUrl != _currentState.currentAlbumArtUrl;
  }

  @override
  Future<Either<Failure, Unit>> initialize(RadioEntity config) async {
    if (RadioConfig.enableVerboseLogging) {
      DebugLogger.log('[RadioPlayerRepository] Initialize called - Stream URL: ${config.streamUrl}', tag: 'RadioPlayerRepository');
    }

    // Performance tracking
    _initializationStartTime = DateTime.now();

    // Check if already initialized with the same config
    if (_currentState.isInitialized &&
        _currentConfig != null &&
        _currentConfig!.streamUrl == config.streamUrl) {
      if (RadioConfig.enableVerboseLogging) {
        DebugLogger.log('[RadioPlayerRepository] Already initialized with same config', tag: 'RadioPlayerRepository');
      }
      return const Right(unit);
    }

    // Prevent concurrent initialization
    if (_isInitializing) {
      if (RadioConfig.enableVerboseLogging) {
        DebugLogger.log('[RadioPlayerRepository] Initialization already in progress', tag: 'RadioPlayerRepository');
      }
      return Left(ServerFailure('Initialization already in progress'));
    }

    _isInitializing = true;
    _currentConfig = config;

    try {
      if (RadioConfig.enableVerboseLogging) {
        DebugLogger.log('[RadioPlayerRepository] Calling remoteDataSource.initialize', tag: 'RadioPlayerRepository');
      }
      await remoteDataSource.initialize(config);

      // Performance tracking
      final initTime =
          DateTime.now().difference(_initializationStartTime!).inMilliseconds;
      
      if (RadioConfig.enablePerformanceMonitoring) {
        DebugLogger.log('[RadioPlayerRepository] Initialization completed in ${initTime}ms', tag: 'RadioPlayerRepository');
      }

      _updateState(_currentState.copyWith(
        isInitialized: true,
        currentUrl: config.streamUrl,
        errorMessage: null,
        connectionTimeMs: initTime,
      ));
      return const Right(unit);
    } catch (e) {
      if (RadioConfig.enableVerboseLogging) {
        DebugLogger.logError('Initialize failed', error: e, tag: 'RadioPlayerRepository');
      }
      final failure =
          ServerFailure('Failed to initialize radio player: ${e.toString()}');
      _updateState(_currentState.copyWith(
        errorMessage: failure.message,
        lastErrorTimestamp: DateTime.now(),
      ));
      return Left(failure);
    } finally {
      _isInitializing = false;
    }
  }

  @override
  Future<Either<Failure, Unit>> play() async {
    // Idempotent play with debouncing
    final now = DateTime.now();

    // Check if we have a pending play operation
    if (_pendingPlayOperation != null) {
      if (RadioConfig.enableVerboseLogging) {
        DebugLogger.log('[RadioPlayerRepository] Play already in progress', tag: 'RadioPlayerRepository');
      }
      try {
        await _pendingPlayOperation!;
        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure('Play operation failed: ${e.toString()}'));
      }
    }

    // Debounce rapid play requests
    if (_lastPlayRequest != null &&
        now.difference(_lastPlayRequest!).inMilliseconds < 500) {
      if (RadioConfig.enableVerboseLogging) {
        DebugLogger.log('[RadioPlayerRepository] Play request debounced', tag: 'RadioPlayerRepository');
      }
      return const Right(unit);
    }

    _lastPlayRequest = now;
    _playStartTime = now;

    // Immediately emit connecting to provide instant UI feedback
    _updateState(_currentState.copyWith(
      isConnecting: true,
      isBuffering: false,
      errorMessage: null,
    ));

    // Create the play operation
    _pendingPlayOperation = _performPlay();

    try {
      await _pendingPlayOperation!;
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure('Play operation failed: ${e.toString()}'));
    } finally {
      _pendingPlayOperation = null;
    }
  }

  /// Internal play implementation with retry logic and pre-buffering
  Future<void> _performPlay() async {
    if (_currentConfig == null) {
      throw Exception('No radio configuration available');
    }

    // For live radio streams, always reset before playing
    DebugLogger.log('[RadioPlayerRepository] Resetting before play', tag: 'RadioPlayerRepository');
    await remoteDataSource.reset();

    // Pre-buffer strategy
    DebugLogger.log('[RadioPlayerRepository] Starting pre-buffering', tag: 'RadioPlayerRepository');
    await _preBufferStream();

    // Check if radioCoreV2 is enabled
    if (_currentConfig!.radioCoreV2Enabled) {
      await _performPlayV2();
    } else {
      await _performPlayLegacy();
    }
  }

  /// Pre-buffer the stream to prevent AudioTrack underruns
  Future<void> _preBufferStream() async {
    try {
      // Initialize the stream first
      await remoteDataSource.initialize(_currentConfig!);

      // Get buffer time from config
      final bufferTimeMs = RadioConfig.preBufferTimeMs;

      // Update state to show buffering
      _updateState(_currentState.copyWith(
        isBuffering: true,
        isConnecting: false,
      ));

      // Wait for the stream to buffer
      DebugLogger.log('[RadioPlayerRepository] Pre-buffering stream for ${bufferTimeMs}ms', tag: 'RadioPlayerRepository');
      await Future.delayed(Duration(milliseconds: bufferTimeMs));

      // Clear buffering state
      _updateState(_currentState.copyWith(
        isBuffering: false,
      ));

      DebugLogger.log('[RadioPlayerRepository] Pre-buffering completed', tag: 'RadioPlayerRepository');
    } catch (e) {
      DebugLogger.logError('Pre-buffering failed', error: e, tag: 'RadioPlayerRepository');
      // Clear buffering state on error
      _updateState(_currentState.copyWith(
        isBuffering: false,
      ));
      // Continue anyway - not critical
    }
  }

  /// Enhanced play with retry and backup URLs
  Future<void> _performPlayV2() async {
    DebugLogger.log('[RadioPlayerRepository] Using radioCoreV2 play logic', tag: 'RadioPlayerRepository');

    // Prepare available URLs (primary + backups)
    _availableUrls = [_currentConfig!.streamUrl];
    _availableUrls.addAll(_currentConfig!.backupStreamUrls);
    _currentUrlIndex = 0;
    _currentRetryAttempt = 0;

    await _attemptPlayWithRetry();
  }

  /// Legacy play implementation
  Future<void> _performPlayLegacy() async {
    DebugLogger.log('[RadioPlayerRepository] Using legacy play logic', tag: 'RadioPlayerRepository');
    
    // Update state to show connecting
    _updateState(_currentState.copyWith(
      isConnecting: true,
      isBuffering: false,
    ));
    
    try {
      // Reinitialize after reset to ensure fresh connection
      await remoteDataSource.initialize(_currentConfig!);
      await remoteDataSource.play();
      
      // Clear connecting state on success
      _updateState(_currentState.copyWith(
        isConnecting: false,
      ));
    } catch (e) {
      // Clear connecting state on error
      _updateState(_currentState.copyWith(
        isConnecting: false,
      ));
      rethrow;
    }
  }

  /// Attempt play with retry logic
  Future<void> _attemptPlayWithRetry() async {
    if (_currentUrlIndex >= _availableUrls.length) {
      throw Exception('All stream URLs exhausted');
    }

    final currentUrl = _availableUrls[_currentUrlIndex];
    DebugLogger.log('[RadioPlayerRepository] Attempting play with URL: $currentUrl (attempt ${_currentRetryAttempt + 1})', tag: 'RadioPlayerRepository');

    // Update state to show connecting
    _updateState(_currentState.copyWith(
      isConnecting: true,
      isBuffering: false,
      isRetrying: _currentRetryAttempt > 0,
      retryAttempt: _currentRetryAttempt,
      currentBackupUrlIndex: _currentUrlIndex,
    ));

    try {
      // Always reinitialize after reset to ensure fresh connection
      final configWithNewUrl = RadioEntity(
        enabled: _currentConfig!.enabled,
        streamUrl: currentUrl,
        autoplay: _currentConfig!.autoplay,
        showAlbumCover: _currentConfig!.showAlbumCover,
        textScrolling: _currentConfig!.textScrolling,
        metadataUrl: _currentConfig!.metadataUrl,
        logoNetworkUrl: _currentConfig!.logoNetworkUrl,
        albumArtSource: _currentConfig!.albumArtSource,
        lastUpdated: _currentConfig!.lastUpdated,
        backupStreamUrls: _currentConfig!.backupStreamUrls,
        radioCoreV2Enabled: _currentConfig!.radioCoreV2Enabled,
        banners: _currentConfig!.banners,
      );

      await remoteDataSource.initialize(configWithNewUrl);
      await remoteDataSource.play();

      // Success - reset retry state
      _currentRetryAttempt = 0;

      // Performance tracking
      int? connectionTimeMs;
      if (_playStartTime != null) {
        connectionTimeMs =
            DateTime.now().difference(_playStartTime!).inMilliseconds;
        DebugLogger.log('[RadioPlayerRepository] Connection completed in ${connectionTimeMs}ms', tag: 'RadioPlayerRepository');
      }

      _updateState(_currentState.copyWith(
        isConnecting: false,
        isBuffering: false,
        isRetrying: false,
        retryAttempt: 0,
        currentUrl: currentUrl,
        errorMessage: null,
        lastErrorTimestamp: null,
        resumeTimeMs: connectionTimeMs,
      ));
    } catch (e) {
      DebugLogger.logError('Play attempt failed', error: e, tag: 'RadioPlayerRepository');

      // Update error state
      _updateState(_currentState.copyWith(
        isConnecting: false,
        isBuffering: false,
        errorMessage: e.toString(),
        lastErrorTimestamp: DateTime.now(),
      ));

      // Schedule retry if we haven't exceeded max attempts
      if (_currentRetryAttempt < RadioConfig.maxRetryAttempts - 1) {
        _scheduleRetry();
      } else {
        // Try next URL if available
        if (_currentUrlIndex < _availableUrls.length - 1) {
          _currentUrlIndex++;
          _currentRetryAttempt = 0;
          _scheduleRetry();
        } else {
          throw Exception('All retry attempts and backup URLs exhausted');
        }
      }
    }
  }

  /// Schedule retry with exponential backoff
  void _scheduleRetry() {
    if (_currentRetryAttempt >= RadioConfig.retryBackoffDelays.length) {
      return;
    }

    final delayMs = RadioConfig.retryBackoffDelays[_currentRetryAttempt];
    _currentRetryAttempt++;

    DebugLogger.log('[RadioPlayerRepository] Scheduling retry in ${delayMs}ms (attempt $_currentRetryAttempt)', tag: 'RadioPlayerRepository');

    _retryTimer?.cancel();
    _retryTimer = Timer(Duration(milliseconds: delayMs), () {
      _attemptPlayWithRetry();
    });
  }

  @override
  Future<Either<Failure, Unit>> pause() async {
    try {
      await remoteDataSource.pause();
      return const Right(unit);
    } catch (e) {
      final failure = ServerFailure('Failed to pause radio: ${e.toString()}');
      _updateState(_currentState.copyWith(
        errorMessage: failure.message,
      ));
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> reset() async {
    try {
      await remoteDataSource.reset();
      _isInitializing = false;
      _currentConfig = null;
      _updateState(const RadioPlayerEntity.initial());
      return const Right(unit);
    } catch (e) {
      final failure =
          ServerFailure('Failed to reset radio player: ${e.toString()}');
      _updateState(_currentState.copyWith(
        errorMessage: failure.message,
      ));
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, String>> getAlbumArt(
    String artist,
    String title,
    RadioEntity config,
  ) async {
    try {
      final albumArtUrl = await albumArtService.getAlbumArtUrl(artist, title, config);
      if (albumArtUrl != null && albumArtUrl.isNotEmpty) {
        return Right(albumArtUrl);
      } else {
        return Left(ServerFailure('Album art not found'));
      }
    } catch (e) {
      return Left(ServerFailure('Failed to get album art: ${e.toString()}'));
    }
  }

  @override
  Stream<RadioPlayerEntity> watchPlayerState() {
    return _playerStateController.stream;
  }

  @override
  Future<Either<Failure, Unit>> setCustomMetadata({
    required String artist,
    required String title,
    String? artworkUrl,
  }) async {
    try {
      await remoteDataSource.setCustomMetadata(
        artist: artist,
        title: title,
        artworkUrl: artworkUrl,
      );
      return const Right(unit);
    } catch (e) {
      final failure =
          ServerFailure('Failed to set custom metadata: ${e.toString()}');
      _updateState(_currentState.copyWith(
        errorMessage: failure.message,
      ));
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> updateStation({
    required String title,
    required String url,
    required bool parseStreamMetadata,
    required bool lookupOnlineArtwork,
    String? logoAssetPath,
    String? logoNetworkUrl,
  }) async {
    try {
      await remoteDataSource.updateStation(
        title: title,
        url: url,
        parseStreamMetadata: parseStreamMetadata,
        lookupOnlineArtwork: lookupOnlineArtwork,
        logoAssetPath: logoAssetPath,
        logoNetworkUrl: logoNetworkUrl,
      );
      return const Right(unit);
    } catch (e) {
      final failure =
          ServerFailure('Failed to update station: ${e.toString()}');
      _updateState(_currentState.copyWith(
        errorMessage: failure.message,
      ));
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> setNavigationControls({
    required bool showNextButton,
    required bool showPreviousButton,
  }) async {
    try {
      await remoteDataSource.setNavigationControls(
        showNextButton: showNextButton,
        showPreviousButton: showPreviousButton,
      );
      return const Right(unit);
    } catch (e) {
      final failure =
          ServerFailure('Failed to set navigation controls: ${e.toString()}');
      _updateState(_currentState.copyWith(
        errorMessage: failure.message,
      ));
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> setVolume(double volume) async {
    try {
      await remoteDataSource.setVolume(volume);
      return const Right(unit);
    } catch (e) {
      final failure =
          ServerFailure('Failed to set volume: ${e.toString()}');
      _updateState(_currentState.copyWith(
        errorMessage: failure.message,
      ));
      return Left(failure);
    }
  }

  /// Dispose resources
  void dispose() {
    _retryTimer?.cancel();
    _debounceTimer?.cancel();
    _playbackStateSubscription?.cancel();
    _metadataSubscription?.cancel();
    _remoteCommandSubscription?.cancel();
    _playerStateController.close();
  }
}

