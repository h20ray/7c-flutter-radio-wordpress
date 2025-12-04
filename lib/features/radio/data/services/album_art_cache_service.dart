import '../../../../config/radio_config.dart';
import '../../../../core/utils/debug_logger.dart';

/// Service to cache album art URLs to avoid repeated network requests
/// Enhanced with TTL support, cache statistics, and manual invalidation
class AlbumArtCacheService {
  static AlbumArtCacheService? _instance;
  static AlbumArtCacheService get instance {
    _instance ??= AlbumArtCacheService._internal();
    return _instance!;
  }

  AlbumArtCacheService._internal();

  // Cache to store album art URLs by artist+title key
  final Map<String, String> _cache = {};

  // Cache to store timestamps for cache expiration
  final Map<String, DateTime> _cacheTimestamps = {};

  // Cache to store cache source information
  final Map<String, String> _cacheSources = {};

  // Cache duration from configuration (default: 1 hour)
  Duration get _cacheDuration => Duration(hours: RadioConfig.albumArtCacheTTLHours);

  // Maximum cache size to prevent memory leaks
  // Increased to 512 for better coverage of frequently played tracks
  static const int _maxCacheSize = 512;

  /// Generate cache key from artist and title
  String _generateCacheKey(String artist, String title) {
    return '${artist.trim().toLowerCase()}_${title.trim().toLowerCase()}';
  }

  /// Get cached album art URL if available and not expired
  String? getCachedAlbumArt(String artist, String title) {
    final key = _generateCacheKey(artist, title);
    final timestamp = _cacheTimestamps[key];

    if (timestamp == null) return null;

    // Check if cache is expired
    if (DateTime.now().difference(timestamp) > _cacheDuration) {
      _removeFromCache(key);
      return null;
    }

    return _cache[key];
  }

  /// Get cached album art URL with source information
  Map<String, String?>? getCachedAlbumArtWithSource(String artist, String title) {
    final key = _generateCacheKey(artist, title);
    final timestamp = _cacheTimestamps[key];

    if (timestamp == null) return null;

    // Check if cache is expired
    if (DateTime.now().difference(timestamp) > _cacheDuration) {
      _removeFromCache(key);
      return null;
    }

    return {
      'url': _cache[key],
      'source': _cacheSources[key],
    };
  }

  /// Cache album art URL with timestamp
  void cacheAlbumArt(String artist, String title, String albumArtUrl, {String? source}) {
    final key = _generateCacheKey(artist, title);

    // Clean up old entries if cache is getting too large
    if (_cache.length >= _maxCacheSize) {
      _cleanupOldEntries();
    }

    _cache[key] = albumArtUrl;
    _cacheTimestamps[key] = DateTime.now();
    if (source != null) {
      _cacheSources[key] = source;
    }

    DebugLogger.log('[AlbumArtCacheService] Cached album art for $artist - $title', tag: 'AlbumArtCache');
  }

  /// Remove specific entry from cache
  void _removeFromCache(String key) {
    _cache.remove(key);
    _cacheTimestamps.remove(key);
    _cacheSources.remove(key);
  }

  /// Clean up old entries to prevent memory leaks
  void _cleanupOldEntries() {
    final now = DateTime.now();
    final keysToRemove = <String>[];

    for (final entry in _cacheTimestamps.entries) {
      if (now.difference(entry.value) > _cacheDuration) {
        keysToRemove.add(entry.key);
      }
    }

    for (final key in keysToRemove) {
      _removeFromCache(key);
    }

    // If still too large, remove oldest entries
    if (_cache.length >= _maxCacheSize) {
      final sortedEntries = _cacheTimestamps.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));

      final entriesToRemove =
          sortedEntries.take(_cache.length - _maxCacheSize + 10);
      for (final entry in entriesToRemove) {
        _removeFromCache(entry.key);
      }
    }

    DebugLogger.log('[AlbumArtCacheService] Cache cleaned up', tag: 'AlbumArtCache');
  }

  /// Clear all cache (useful for testing or memory management)
  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
    _cacheSources.clear();
    DebugLogger.log('[AlbumArtCacheService] Cache cleared', tag: 'AlbumArtCache');
  }

  /// Manually invalidate cache for specific artist/title
  void invalidateCache(String artist, String title) {
    final key = _generateCacheKey(artist, title);
    _removeFromCache(key);
  }

  /// Manually invalidate all expired entries
  void invalidateExpiredEntries() {
    final now = DateTime.now();
    final keysToRemove = <String>[];

    for (final entry in _cacheTimestamps.entries) {
      if (now.difference(entry.value) > _cacheDuration) {
        keysToRemove.add(entry.key);
      }
    }

    for (final key in keysToRemove) {
      _removeFromCache(key);
    }
  }

  /// Get cache statistics for debugging
  Map<String, dynamic> getCacheStats() {
    final now = DateTime.now();
    int expiredCount = 0;
    int validCount = 0;

    for (final timestamp in _cacheTimestamps.values) {
      if (now.difference(timestamp) > _cacheDuration) {
        expiredCount++;
      } else {
        validCount++;
      }
    }

    return {
      'size': _cache.length,
      'validEntries': validCount,
      'expiredEntries': expiredCount,
      'maxSize': _maxCacheSize,
      'cacheDurationHours': _cacheDuration.inHours,
      'cacheDurationMinutes': _cacheDuration.inMinutes,
    };
  }
}

