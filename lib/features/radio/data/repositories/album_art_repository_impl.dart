import 'package:dio/dio.dart';
import '../../../../config/radio_config.dart';
import '../../../../core/services/network_status_service.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/album_art_repository.dart';
import '../datasources/album_art_remote_datasource.dart';
import '../services/azuracast_detection_service.dart';
import '../services/album_art_cache_service.dart';
import '../../../../core/utils/debug_logger.dart';

/// Implementation of album art repository
/// Enhanced with offline support and timeout handling
class AlbumArtRepositoryImpl implements AlbumArtRepository {
  final Dio dio;
  final String? azuracastBaseUrl;
  final String? azuracastStationId;
  final NetworkStatusService _networkService;
  final AlbumArtCacheService _cacheService;

  AlbumArtRepositoryImpl({
    required this.dio,
    this.azuracastBaseUrl,
    this.azuracastStationId,
  }) : _networkService = NetworkStatusService.instance,
       _cacheService = AlbumArtCacheService.instance;

  @override
  Future<String?> getAlbumArtUrl(String artist, String title) async {
    // Use static configuration for backward compatibility
    final source = AlbumArtSource.fromValue(RadioConfig.albumArtSource);

    String? result;
    switch (source) {
      case AlbumArtSource.auto:
        result = await _getAlbumArtAuto(artist, title);
        break;
      case AlbumArtSource.azuracast:
        result = await _getAlbumArtFromAzuraCast(artist, title);
        break;
      case AlbumArtSource.appleMusic:
        result = await _getAlbumArtFromAppleMusic(artist, title);
        break;
      case AlbumArtSource.fallback:
        result = null; // Will use fallback asset in UI
        break;
    }

    return result;
  }

  @override
  Future<String?> getAlbumArtUrlWithStream(
    String artist,
    String title,
    int albumArtSource,
    String streamUrl,
  ) async {
    // Check cache first
    final cachedResult = _cacheService.getCachedAlbumArtWithSource(artist, title);
    if (cachedResult != null && cachedResult['url'] != null) {
      DebugLogger.log('[AlbumArtRepository] Using cached album art', tag: 'AlbumArtRepository');
      return cachedResult['url'];
    }

    // Check if offline
    if (!_networkService.isOnline) {
      throw const OfflineFailure('Device is offline - cannot fetch album art');
    }

    final source = AlbumArtSource.fromValue(albumArtSource);

    // Detect AzuraCast configuration from stream URL if needed
    String? detectedBaseUrl;
    String? detectedStationId;

    if (source == AlbumArtSource.auto || source == AlbumArtSource.azuracast) {
      final detectionService = AzuraCastDetectionService.instance;
      if (detectionService.isLikelyAzuraCastUrl(streamUrl)) {
        final config = await detectionService.detectFromStreamUrl(streamUrl);
        detectedBaseUrl = config['base_url'];
        detectedStationId = config['station_id'];
      }
    }

    String? result;
    try {
      switch (source) {
        case AlbumArtSource.auto:
          result = await _getAlbumArtAutoWithConfig(
              artist, title, detectedBaseUrl, detectedStationId);
          break;
        case AlbumArtSource.azuracast:
          result = await _getAlbumArtFromAzuraCastWithConfig(
              artist, title, detectedBaseUrl, detectedStationId);
          break;
        case AlbumArtSource.appleMusic:
          result = await _getAlbumArtFromAppleMusic(artist, title);
          break;
        case AlbumArtSource.fallback:
          result = null; // Will use fallback asset in UI
          break;
      }

      // Cache successful result
      if (result != null && result.isNotEmpty) {
        _cacheService.cacheAlbumArt(artist, title, result, source: source.displayName);
      }

      return result;
    } catch (e) {
      // Check if it's a network error
      if (e.toString().contains('timeout') || 
          e.toString().contains('network') || 
          e.toString().contains('connection')) {
        throw NetworkFailure('Network error while fetching album art: ${e.toString()}');
      }
      
      // Re-throw other errors
      rethrow;
    }
  }

  /// Auto mode: Try AzuraCast first, then Apple Music, then fallback
  Future<String?> _getAlbumArtAuto(String artist, String title) async {
    // Try AzuraCast first if configured
    if (azuracastBaseUrl != null && azuracastStationId != null) {
      final azuracastDataSource = AzuraCastAlbumArtDataSource(
        dio: dio,
        baseUrl: azuracastBaseUrl!,
        stationId: azuracastStationId!,
      );

      final azuracastArt =
          await azuracastDataSource.getAlbumArtUrl(artist, title);
      if (azuracastArt != null) {
        return azuracastArt;
      }
    }

    // Try Apple Music if enabled
    if (RadioConfig.enableAppleMusicFallback) {
      final appleMusicDataSource = AppleMusicAlbumArtDataSource(dio: dio);
      final appleMusicArt =
          await appleMusicDataSource.getAlbumArtUrl(artist, title);
      if (appleMusicArt != null) {
        return appleMusicArt;
      }
    }

    // Fallback to asset
    return null;
  }

  /// Get album art from AzuraCast only
  Future<String?> _getAlbumArtFromAzuraCast(String artist, String title) async {
    if (azuracastBaseUrl == null || azuracastStationId == null) {
      return null;
    }

    final azuracastDataSource = AzuraCastAlbumArtDataSource(
      dio: dio,
      baseUrl: azuracastBaseUrl!,
      stationId: azuracastStationId!,
    );

    return await azuracastDataSource.getAlbumArtUrl(artist, title);
  }

  /// Get album art from Apple Music only
  Future<String?> _getAlbumArtFromAppleMusic(
      String artist, String title) async {
    final appleMusicDataSource = AppleMusicAlbumArtDataSource(dio: dio);
    final result = await appleMusicDataSource.getAlbumArtUrl(artist, title);
    return result;
  }

  /// Auto mode with specific configuration: Try AzuraCast first, then Apple Music, then fallback
  Future<String?> _getAlbumArtAutoWithConfig(String artist, String title,
      String? azuracastBaseUrl, String? azuracastStationId) async {
    // Try AzuraCast first if configured
    if (azuracastBaseUrl != null && azuracastStationId != null) {
      final azuracastDataSource = AzuraCastAlbumArtDataSource(
        dio: dio,
        baseUrl: azuracastBaseUrl,
        stationId: azuracastStationId,
      );

      final azuracastArt =
          await azuracastDataSource.getAlbumArtUrl(artist, title);
      if (azuracastArt != null) {
        return azuracastArt;
      }
    }

    // Try Apple Music if enabled
    if (RadioConfig.enableAppleMusicFallback) {
      final appleMusicDataSource = AppleMusicAlbumArtDataSource(dio: dio);
      final appleMusicArt =
          await appleMusicDataSource.getAlbumArtUrl(artist, title);
      if (appleMusicArt != null) {
        return appleMusicArt;
      }
    }

    // Fallback to asset
    return null;
  }

  /// Get album art from AzuraCast only with specific configuration
  Future<String?> _getAlbumArtFromAzuraCastWithConfig(
      String artist,
      String title,
      String? azuracastBaseUrl,
      String? azuracastStationId) async {
    if (azuracastBaseUrl == null || azuracastStationId == null) {
      return null;
    }

    final azuracastDataSource = AzuraCastAlbumArtDataSource(
      dio: dio,
      baseUrl: azuracastBaseUrl,
      stationId: azuracastStationId,
    );

    return await azuracastDataSource.getAlbumArtUrl(artist, title);
  }
}

