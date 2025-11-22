import 'dart:async';
import 'package:dio/dio.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../../../core/models/album_art_state.dart';
import '../../../../core/services/network_status_service.dart';
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
    
    // Listen to network status changes
    _networkSubscription = _networkService.networkStatusStream.listen(
      (isOnline) {
        if (isOnline && _requestQueue.isNotEmpty) {
          _processQueuedRequests();
        }
      },
    );
  }

  /// Stream of album art state changes
  Stream<AlbumArtState> get albumArtStream => _albumArtController.stream;

  /// Current album art state
  AlbumArtState get currentState => _currentState;

  /// Fetch album art and broadcast the result to all listeners
  /// Enhanced with cancellation, offline mode, and queue management
  Future<void> fetchAndBroadcast(
    String artist, 
    String title, 
    RadioEntity radioConfig
  ) async {
    // Skip if no metadata
    if (artist.isEmpty && title.isEmpty) {
      DebugLogger.log('[AlbumArtService] Artist and title are empty, skipping', tag: 'AlbumArtService');
      return;
    }

    // Create fetch key to prevent duplicate requests
    final fetchKey = '${artist}_${title}_${radioConfig.albumArtSource}';
    if (_currentFetchKey == fetchKey) {
      DebugLogger.log('[AlbumArtService] Already fetching this combination, skipping', tag: 'AlbumArtService');
      return;
    }

    // Cancel any pending request
    _currentCancelToken?.cancel();
    _currentCancelToken = CancelToken();
    _currentFetchKey = fetchKey;

    // Check if this is the same track as current state
    final newState = AlbumArtState.loading(
      artist: artist, 
      title: title,
      isOffline: !_networkService.isOnline,
    );
    if (!_currentState.isSameTrack(newState)) {
      // Different track, emit loading state
      _emitState(newState);
    }

    try {
      // Check if we should use fallback only
      if (radioConfig.albumArtSource == 4) {
        DebugLogger.log('[AlbumArtService] Using fallback only', tag: 'AlbumArtService');
        _emitState(AlbumArtState.fallback(
          artist: artist, 
          title: title,
          isOffline: !_networkService.isOnline,
        ));
        return;
      }

      // Check cache first
      final cacheService = AlbumArtCacheService.instance;
      final cachedResult = cacheService.getCachedAlbumArtWithSource(artist, title);
      if (cachedResult != null && cachedResult['url'] != null) {
        DebugLogger.log('[AlbumArtService] Using cached album art', tag: 'AlbumArtService');
        _emitState(AlbumArtState.success(
          url: cachedResult['url']!,
          artist: artist,
          title: title,
          isOffline: !_networkService.isOnline,
          cacheSource: cachedResult['source'],
        ));
        return;
      }

      // Check if offline
      if (!_networkService.isOnline) {
        DebugLogger.log('[AlbumArtService] Device is offline, queuing request', tag: 'AlbumArtService');
        _queueRequest(artist, title, radioConfig);
        _emitState(AlbumArtState.fallback(
          artist: artist, 
          title: title,
          isOffline: true,
        ));
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
        DebugLogger.log('[AlbumArtService] Request cancelled', tag: 'AlbumArtService');
        return;
      }

      if (albumArtUrl != null && albumArtUrl.isNotEmpty) {
        // Cache the result with source information
        cacheService.cacheAlbumArt(artist, title, albumArtUrl, source: 'network');
        
        // Emit success state
        _emitState(AlbumArtState.success(
          url: albumArtUrl,
          artist: artist,
          title: title,
          isOffline: false,
          cacheSource: 'network',
        ));
      } else {
        // No album art found, use fallback
        DebugLogger.log('[AlbumArtService] No album art found, using fallback', tag: 'AlbumArtService');
        _emitState(AlbumArtState.fallback(
          artist: artist, 
          title: title,
          isOffline: false,
        ));
      }
    } catch (e) {
      // Check if request was cancelled
      if (_currentCancelToken?.isCancelled == true) {
        DebugLogger.log('[AlbumArtService] Request cancelled due to error', tag: 'AlbumArtService');
        return;
      }

      DebugLogger.logError('Error fetching album art', error: e, tag: 'AlbumArtService');
      // Error occurred, use fallback
      _emitState(AlbumArtState.error(
        error: e.toString(),
        artist: artist,
        title: title,
        isOffline: !_networkService.isOnline,
        retryCount: _currentState.retryCount + 1,
      ));
    } finally {
      _currentFetchKey = null;
      _currentCancelToken = null;
    }
  }

  /// Get album art URL for the given artist and title using radio configuration
  /// Returns the album art URL or null if not found
  /// This is a convenience method that calls fetchAndBroadcast and returns the URL
  Future<String?> getAlbumArtUrl(
      String artist, String title, RadioEntity radioConfig) async {
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
    _requestQueue.removeWhere((req) => 
        req['artist'] == artist && req['title'] == title);
    
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

    DebugLogger.log('[AlbumArtService] Processing ${_requestQueue.length} queued requests', tag: 'AlbumArtService');

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
        DebugLogger.logError('Failed to process queued request', error: e, tag: 'AlbumArtService');
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
    _albumArtController.close();
    _requestQueue.clear();
    _currentFetchKey = null;
    _currentCancelToken = null;
  }
}

