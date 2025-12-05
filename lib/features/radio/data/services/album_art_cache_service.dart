import 'package:hive/hive.dart';
import '../../../../config/radio_config.dart';
import '../../../../core/utils/debug_logger.dart';

/// Service to cache album art URLs to avoid repeated network requests
/// Enhanced with TTL support, cache statistics, manual invalidation,
/// and Hive-based persistence across app restarts
class AlbumArtCacheService {
  static AlbumArtCacheService? _instance;
  static AlbumArtCacheService get instance {
    _instance ??= AlbumArtCacheService._internal();
    return _instance!;
  }

  AlbumArtCacheService._internal();

  static const String _boxName = 'album_art_cache_box';
  static const String _entriesKey = 'entries';
  
  // In-memory cache for fast access (backed by Hive for persistence)
  final Map<String, String> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  final Map<String, String> _cacheSources = {};
  
  bool _isInitialized = false;

  // Cache duration from configuration (default: 1 hour)
  Duration get _cacheDuration => Duration(hours: RadioConfig.albumArtCacheTTLHours);

  // Maximum cache size to prevent memory leaks
  static const int _maxCacheSize = 512;

  /// Initialize the cache service and load persisted entries from Hive
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final box = await _openBox();
      final raw = box.get(_entriesKey);
      
      if (raw != null && raw is List) {
        final now = DateTime.now();
        int loadedCount = 0;
        int expiredCount = 0;
        
        for (final item in raw) {
          if (item is Map) {
            final entry = Map<String, dynamic>.from(item);
            final key = entry['key'] as String?;
            final url = entry['url'] as String?;
            final timestampMs = entry['timestamp'] as int?;
            final source = entry['source'] as String?;
            
            if (key != null && url != null && timestampMs != null) {
              final timestamp = DateTime.fromMillisecondsSinceEpoch(timestampMs);
              
              // Only restore non-expired entries
              if (now.difference(timestamp) <= _cacheDuration) {
                _cache[key] = url;
                _cacheTimestamps[key] = timestamp;
                if (source != null) {
                  _cacheSources[key] = source;
                }
                loadedCount++;
              } else {
                expiredCount++;
              }
            }
          }
        }
        
        DebugLogger.log(
          '[AlbumArtCacheService] Loaded $loadedCount entries from persistent storage ($expiredCount expired entries skipped)',
          tag: 'AlbumArtCache',
        );
        
        // If we skipped expired entries, persist the cleaned cache
        if (expiredCount > 0) {
          await _persistCache();
        }
      }
      
      _isInitialized = true;
    } catch (e) {
      DebugLogger.logError(
        '[AlbumArtCacheService] Failed to load persistent cache',
        error: e,
        tag: 'AlbumArtCache',
      );
      _isInitialized = true; // Continue without persistence
    }
  }
  
  Future<Box> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return Hive.openBox(_boxName);
  }
  
  /// Persist the current cache to Hive storage
  Future<void> _persistCache() async {
    try {
      final box = await _openBox();
      final entries = <Map<String, dynamic>>[];
      
      for (final key in _cache.keys) {
        final timestamp = _cacheTimestamps[key];
        if (timestamp != null) {
          entries.add({
            'key': key,
            'url': _cache[key],
            'timestamp': timestamp.millisecondsSinceEpoch,
            'source': _cacheSources[key],
          });
        }
      }
      
      await box.put(_entriesKey, entries);
    } catch (e) {
      DebugLogger.logError(
        '[AlbumArtCacheService] Failed to persist cache',
        error: e,
        tag: 'AlbumArtCache',
      );
    }
  }

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

  /// Cache album art URL with timestamp and persist to Hive
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
    
    // Persist to Hive asynchronously
    _persistCache();
  }

  /// Remove specific entry from cache (does not persist immediately)
  void _removeFromCache(String key) {
    _cache.remove(key);
    _cacheTimestamps.remove(key);
    _cacheSources.remove(key);
  }
  
  /// Remove specific entry and persist the change
  void _removeFromCacheAndPersist(String key) {
    _removeFromCache(key);
    _persistCache();
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
    
    // Persist after cleanup
    _persistCache();
  }

  /// Clear all cache (useful for testing or memory management)
  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
    _cacheSources.clear();
    _persistCache();
    DebugLogger.log('[AlbumArtCacheService] Cache cleared', tag: 'AlbumArtCache');
  }

  /// Manually invalidate cache for specific artist/title
  void invalidateCache(String artist, String title) {
    final key = _generateCacheKey(artist, title);
    _removeFromCacheAndPersist(key);
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
    
    if (keysToRemove.isNotEmpty) {
      _persistCache();
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
      'isInitialized': _isInitialized,
    };
  }
}
