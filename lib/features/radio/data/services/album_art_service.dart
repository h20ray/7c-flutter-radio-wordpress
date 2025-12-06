import 'dart:async';
import 'package:dio/dio.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../../../core/models/album_art_state.dart';
import '../../../../core/services/network_status_service.dart';
import '../../../../config/radio_config.dart';
import '../../domain/entities/radio_entity.dart';
import '../repositories/album_art_repository_impl.dart';
import 'album_art_cache_service.dart';

/// Reactive service to manage album art operations
/// Enhanced with cancellation, offline mode, and queue management
/// Acts as single source of truth for album art state across the app
class AlbumArtService {
  static AlbumArtService? _instance;
  final Dio _dio;
  final NetworkStatusService _networkService;

  // Stream controller for broadcasting album art state changes
  final StreamController<AlbumArtState> _albumArtController =
      StreamController<AlbumArtState>.broadcast();

  // Current state
  AlbumArtState _currentState = AlbumArtState.initial();

  // Track current fetch to prevent duplicate requests
  String? _currentFetchKey;

  // Request cancellation token
  CancelToken? _currentCancelToken;

  // Network status subscription
  StreamSubscription<bool>? _networkSubscription;

  // Request queue for offline scenarios
  final List<Map<String, dynamic>> _requestQueue = [];

  // Track fallback display timing for smooth transitions
  DateTime? _fallbackDisplayStartTime;
  Timer? _fallbackDisplayTimer;
  AlbumArtState? _pendingSuccessState;

  AlbumArtService._internal()
    : _dio = Dio(),
      _networkService = NetworkStatusService.instance;

  static AlbumArtService get instance {
    _instance ??= AlbumArtService._internal();
    return _instance!;
  }

  /// Initialize the service
  Future<void> initialize() async {
    await _networkService.initialize();

    // Initialize the cache service to load persisted entries
    await AlbumArtCacheService.instance.initialize();

    // Listen to network status changes
    _networkSubscription = _networkService.networkStatusStream.listen((
      isOnline,
    ) {
      if (isOnline && _requestQueue.isNotEmpty) {
        _processQueuedRequests();
      }
    });
  }

  /// Restore cached album art state for given metadata
  /// Useful when app resumes or service initializes with known metadata
  Future<bool> restoreCachedState(String artist, String title) async {
    if (artist.isEmpty && title.isEmpty) {
      return false;
    }

    try {
      final cacheService = AlbumArtCacheService.instance;
      final cachedResult = await cacheService.getCachedAlbumArtWithSource(
        artist,
        title,
      );

      if (cachedResult != null && cachedResult['url'] != null) {
        DebugLogger.log(
          '[AlbumArtService] Restoring cached album art state: $artist - $title',
          tag: 'AlbumArtService',
        );
        _emitState(
          AlbumArtState.success(
            url: cachedResult['url']!,
            artist: artist,
            title: title,
            isOffline: !_networkService.isOnline,
            cacheSource: cachedResult['source'],
          ),
        );
        return true;
      }
    } catch (e) {
      DebugLogger.logError(
        '[AlbumArtService] Error restoring cached state',
        error: e,
        tag: 'AlbumArtService',
      );
    }

    return false;
  }

  /// Stream of album art state changes
  Stream<AlbumArtState> get albumArtStream => _albumArtController.stream;

  /// Current album art state
  AlbumArtState get currentState => _currentState;

  /// Clear stale state - useful when app resumes or playback starts
  /// Smart clearing: preserves cached album art for current track, only clears if track changed or cache expired
  Future<void> clearStaleState({
    String? currentArtist,
    String? currentTitle,
  }) async {
    // If we have pending success state (cached album art ready), emit it immediately
    if (_pendingSuccessState != null && _pendingSuccessState!.hasUrl) {
      DebugLogger.log(
        '[AlbumArtService] Clearing stale state but preserving pending cached album art',
        tag: 'AlbumArtService',
      );
      _fallbackDisplayTimer?.cancel();
      _fallbackDisplayStartTime = null;
      _emitSuccessState();
      // Continue clearing other stale state
      _currentFetchKey = null;
      _currentCancelToken?.cancel();
      _currentCancelToken = null;
      return;
    }

    // Smart cache preservation: if we have current metadata, check cache before clearing
    if (currentArtist != null &&
        currentTitle != null &&
        currentArtist.isNotEmpty &&
        currentTitle.isNotEmpty) {
      try {
        final cacheService = AlbumArtCacheService.instance;
        final cachedResult = await cacheService.getCachedAlbumArtWithSource(
          currentArtist,
          currentTitle,
        );

        if (cachedResult != null && cachedResult['url'] != null) {
          // We have cached art for current track - preserve it instead of clearing
          DebugLogger.log(
            '[AlbumArtService] Preserving cached album art for current track: $currentArtist - $currentTitle',
            tag: 'AlbumArtService',
          );
          _emitState(
            AlbumArtState.success(
              url: cachedResult['url']!,
              artist: currentArtist,
              title: currentTitle,
              isOffline: !_networkService.isOnline,
              cacheSource: cachedResult['source'],
            ),
          );
          // Only clear fetch-related state, keep the cached state
          _currentFetchKey = null;
          _currentCancelToken?.cancel();
          _currentCancelToken = null;
          _fallbackDisplayTimer?.cancel();
          _fallbackDisplayStartTime = null;
          _pendingSuccessState = null;
          return;
        }
      } catch (e) {
        DebugLogger.logError(
          '[AlbumArtService] Error checking cache during state clear',
          error: e,
          tag: 'AlbumArtService',
        );
        // Continue with normal clearing on error
      }
    }

    // Check if current state has valid cached art for same track
    if (_currentState.hasUrl &&
        _currentState.isCached &&
        currentArtist != null &&
        currentTitle != null &&
        _currentState.artist == currentArtist &&
        _currentState.title == currentTitle) {
      DebugLogger.log(
        '[AlbumArtService] Preserving current cached state for same track',
        tag: 'AlbumArtService',
      );
      // Keep current state, only clear fetch-related state
      _currentFetchKey = null;
      _currentCancelToken?.cancel();
      _currentCancelToken = null;
      _fallbackDisplayTimer?.cancel();
      _fallbackDisplayStartTime = null;
      _pendingSuccessState = null;
      return;
    }

    // No cached album art to preserve, clear everything
    _currentFetchKey = null;
    _currentCancelToken?.cancel();
    _currentCancelToken = null;
    _fallbackDisplayTimer?.cancel();
    _fallbackDisplayStartTime = null;
    _pendingSuccessState = null;
    DebugLogger.log(
      '[AlbumArtService] Cleared stale state (no cache to preserve)',
      tag: 'AlbumArtService',
    );
  }

  /// Fetch album art and broadcast the result to all listeners
  /// Enhanced with cancellation, offline mode, and queue management
  Future<void> fetchAndBroadcast(
    String artist,
    String title,
    RadioEntity radioConfig, {
    bool forceRefresh = false,
  }) async {
    // Skip if no metadata
    if (artist.isEmpty && title.isEmpty) {
      DebugLogger.log(
        '[AlbumArtService] Artist and title are empty, skipping',
        tag: 'AlbumArtService',
      );
      return;
    }

    // Create fetch key to prevent duplicate requests
    final fetchKey = '${artist}_${title}_${radioConfig.albumArtSource}';

    // Check if this is a different track than current state
    final isDifferentTrack = !_currentState.isSameTrack(
      AlbumArtState.loading(artist: artist, title: title),
    );

    // If force refresh or different track, clear fetch key to allow fetching
    if (forceRefresh || isDifferentTrack) {
      _currentFetchKey = null;
    }

    // Skip only if same fetch key AND not forcing refresh AND same track
    if (_currentFetchKey == fetchKey && !forceRefresh && !isDifferentTrack) {
      DebugLogger.log(
        '[AlbumArtService] Already fetching this combination, skipping',
        tag: 'AlbumArtService',
      );
      return;
    }

    // Cancel any pending request
    _currentCancelToken?.cancel();
    _currentCancelToken = CancelToken();
    _currentFetchKey = fetchKey;

    try {
      // Check if we should use fallback only
      if (radioConfig.albumArtSource == 4) {
        DebugLogger.log(
          '[AlbumArtService] Using fallback only',
          tag: 'AlbumArtService',
        );
        _startFallbackDisplay(artist, title, !_networkService.isOnline);
        return;
      }

      // CRITICAL FIX: Check cache FIRST before showing fallback
      // This ensures cached album art displays immediately on app reopen
      // Optimized: Check in-memory cache first (synchronous), then Hive if needed
      final cacheService = AlbumArtCacheService.instance;

      // Fast synchronous check for in-memory cache
      final cachedUrlSync = cacheService.getCachedAlbumArtSync(artist, title);
      if (cachedUrlSync != null) {
        DebugLogger.log(
          '[AlbumArtService] Using in-memory cached album art (fast path)',
          tag: 'AlbumArtService',
        );
        _emitState(
          AlbumArtState.success(
            url: cachedUrlSync,
            artist: artist,
            title: title,
            isOffline: !_networkService.isOnline,
            cacheSource: 'memory',
          ),
        );
        return;
      }

      // Check Hive for persisted cache (async)
      final cachedResult = await cacheService.getCachedAlbumArtWithSource(
        artist,
        title,
      );
      if (cachedResult != null && cachedResult['url'] != null) {
        DebugLogger.log(
          '[AlbumArtService] Using persisted cached album art (cache-first strategy)',
          tag: 'AlbumArtService',
        );
        // If we have cached art, emit it immediately without showing fallback
        _emitState(
          AlbumArtState.success(
            url: cachedResult['url']!,
            artist: artist,
            title: title,
            isOffline: !_networkService.isOnline,
            cacheSource: cachedResult['source'],
          ),
        );
        return;
      }

      // No cache found - show fallback only if different track
      if (isDifferentTrack) {
        // Different track and no cache - show fallback for smooth transition
        _startFallbackDisplay(artist, title, !_networkService.isOnline);
      }

      // Check if offline
      if (!_networkService.isOnline) {
        DebugLogger.log(
          '[AlbumArtService] Device is offline, queuing request for when network becomes available',
          tag: 'AlbumArtService',
        );
        _queueRequest(artist, title, radioConfig);
        // Show fallback with offline indicator
        _startFallbackDisplay(artist, title, true);
        return;
      }

      // Fetch from repository with cancellation support
      final repository = AlbumArtRepositoryImpl(
        dio: _dio,
        azuracastBaseUrl: null,
        azuracastStationId: null,
      );

      final albumArtUrl = await repository.getAlbumArtUrlWithStream(
        artist,
        title,
        radioConfig.albumArtSource,
        radioConfig.streamUrl,
      );

      // Check if request was cancelled
      if (_currentCancelToken?.isCancelled == true) {
        DebugLogger.log(
          '[AlbumArtService] Request cancelled',
          tag: 'AlbumArtService',
        );
        return;
      }

      if (albumArtUrl != null && albumArtUrl.isNotEmpty) {
        // Cache the result with source information
        cacheService.cacheAlbumArt(
          artist,
          title,
          albumArtUrl,
          source: 'network',
        );

        // If fallback is already showing, schedule transition; otherwise emit immediately
        if (_currentState.isFallback) {
          _scheduleSuccessState(
            AlbumArtState.success(
              url: albumArtUrl,
              artist: artist,
              title: title,
              isOffline: false,
              cacheSource: 'network',
            ),
          );
        } else {
          // No fallback showing, emit immediately
          _emitState(
            AlbumArtState.success(
              url: albumArtUrl,
              artist: artist,
              title: title,
              isOffline: false,
              cacheSource: 'network',
            ),
          );
        }
      } else {
        // No album art found, use fallback
        DebugLogger.log(
          '[AlbumArtService] No album art found, using fallback',
          tag: 'AlbumArtService',
        );
        _startFallbackDisplay(artist, title, false);
      }
    } catch (e) {
      // Check if request was cancelled
      if (_currentCancelToken?.isCancelled == true) {
        DebugLogger.log(
          '[AlbumArtService] Request cancelled due to error',
          tag: 'AlbumArtService',
        );
        return;
      }

      // Enhanced error handling with better categorization
      final isNetworkError =
          e.toString().contains('timeout') ||
          e.toString().contains('network') ||
          e.toString().contains('connection') ||
          e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup');

      if (isNetworkError) {
        DebugLogger.logError(
          'Network error fetching album art - will retry when online',
          error: e,
          tag: 'AlbumArtService',
        );
        // Queue request for retry when network is available
        if (_networkService.isOnline) {
          // Network was online but request failed - might be temporary, queue for retry
          _queueRequest(artist, title, radioConfig);
        }
      } else {
        DebugLogger.logError(
          'Error fetching album art (non-network)',
          error: e,
          tag: 'AlbumArtService',
        );
      }

      // Error occurred, use fallback
      _startFallbackDisplay(
        artist,
        title,
        !_networkService.isOnline || isNetworkError,
      );
    } finally {
      _currentFetchKey = null;
      _currentCancelToken = null;
    }
  }

  /// Start showing fallback image
  void _startFallbackDisplay(String artist, String title, bool isOffline) {
    _fallbackDisplayTimer?.cancel();
    _pendingSuccessState = null;
    _fallbackDisplayStartTime = DateTime.now();
    _emitState(
      AlbumArtState.fallback(
        artist: artist,
        title: title,
        isOffline: isOffline,
      ),
    );
  }

  /// Schedule success state to be shown after minimum fallback display duration
  void _scheduleSuccessState(AlbumArtState successState) {
    _pendingSuccessState = successState;

    // If fallback is already showing, calculate remaining time
    if (_fallbackDisplayStartTime != null) {
      final elapsed = DateTime.now().difference(_fallbackDisplayStartTime!);
      final minDuration = Duration(
        milliseconds: RadioConfig.minFallbackDisplayDuration,
      );
      final remaining = minDuration - elapsed;

      if (remaining.isNegative || remaining.inMilliseconds <= 0) {
        // Minimum duration already passed, show immediately
        _emitSuccessState();
      } else {
        // Wait for remaining time
        _fallbackDisplayTimer?.cancel();
        _fallbackDisplayTimer = Timer(remaining, _emitSuccessState);
        DebugLogger.log(
          '[AlbumArtService] Scheduling album art transition in ${remaining.inMilliseconds}ms',
          tag: 'AlbumArtService',
        );
      }
    } else {
      // Fallback not showing yet, show it first then schedule transition
      _startFallbackDisplay(
        successState.artist ?? '',
        successState.title ?? '',
        successState.isOffline,
      );
      _fallbackDisplayTimer?.cancel();
      _fallbackDisplayTimer = Timer(
        Duration(milliseconds: RadioConfig.minFallbackDisplayDuration),
        _emitSuccessState,
      );
      DebugLogger.log(
        '[AlbumArtService] Showing fallback first, will transition in ${RadioConfig.minFallbackDisplayDuration}ms',
        tag: 'AlbumArtService',
      );
    }
  }

  /// Emit the pending success state
  void _emitSuccessState() {
    if (_pendingSuccessState != null) {
      _fallbackDisplayStartTime = null;
      final state = _pendingSuccessState!;
      _pendingSuccessState = null;
      _emitState(state);
      DebugLogger.log(
        '[AlbumArtService] Transitioning to album art',
        tag: 'AlbumArtService',
      );
    }
  }

  /// Get album art URL for the given artist and title using radio configuration
  /// Returns the album art URL or null if not found
  /// This is a convenience method that calls fetchAndBroadcast and returns the URL
  Future<String?> getAlbumArtUrl(
    String artist,
    String title,
    RadioEntity radioConfig,
  ) async {
    await fetchAndBroadcast(artist, title, radioConfig);
    return _currentState.hasUrl ? _currentState.url : null;
  }

  /// Emit state to all listeners
  void _emitState(AlbumArtState state) {
    _currentState = state;
    if (!_albumArtController.isClosed) {
      _albumArtController.add(state);
    }
  }

  /// Queue request for when network becomes available
  void _queueRequest(String artist, String title, RadioEntity radioConfig) {
    final request = {
      'artist': artist,
      'title': title,
      'radioConfig': radioConfig,
      'timestamp': DateTime.now(),
    };

    // Remove any existing request for the same track
    _requestQueue.removeWhere(
      (req) => req['artist'] == artist && req['title'] == title,
    );

    // Add new request
    _requestQueue.add(request);

    // Limit queue size
    if (_requestQueue.length > 10) {
      _requestQueue.removeAt(0);
    }
  }

  /// Process queued requests when network becomes available
  Future<void> _processQueuedRequests() async {
    if (_requestQueue.isEmpty) return;

    DebugLogger.log(
      '[AlbumArtService] Processing ${_requestQueue.length} queued requests',
      tag: 'AlbumArtService',
    );

    final requests = List<Map<String, dynamic>>.from(_requestQueue);
    _requestQueue.clear();

    for (final request in requests) {
      try {
        await fetchAndBroadcast(
          request['artist'] as String,
          request['title'] as String,
          request['radioConfig'] as RadioEntity,
        );
      } catch (e) {
        DebugLogger.logError(
          'Failed to process queued request',
          error: e,
          tag: 'AlbumArtService',
        );
        // Re-queue failed requests
        _queueRequest(
          request['artist'] as String,
          request['title'] as String,
          request['radioConfig'] as RadioEntity,
        );
      }
    }
  }

  /// Get current album art URL (for backward compatibility)
  String? getCurrentAlbumArtUrl() {
    return _currentState.hasUrl ? _currentState.url : null;
  }

  /// Cancel current album art fetch
  void cancelCurrentFetch() {
    _currentCancelToken?.cancel();
    _currentFetchKey = null;
    _currentCancelToken = null;
  }

  void dispose() {
    _currentCancelToken?.cancel();
    _networkSubscription?.cancel();
    _fallbackDisplayTimer?.cancel();
    _albumArtController.close();
    _requestQueue.clear();
    _currentFetchKey = null;
    _currentCancelToken = null;
    _fallbackDisplayStartTime = null;
    _pendingSuccessState = null;
  }
}
