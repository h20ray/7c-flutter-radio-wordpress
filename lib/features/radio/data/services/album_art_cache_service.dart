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
  
  final Map<String, String> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  final Map<String, String> _cacheSources = {};
  final List<String> _accessOrder = [];
  
  bool _isInitialized = false;

  Duration get _cacheDuration => Duration(hours: RadioConfig.albumArtCacheTTLHours);

  static const int _maxInMemorySize = 100;
  static const int _maxPersistedSize = 512;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final box = await _openBox();
      final raw = box.get(_entriesKey);
      
      if (raw != null && raw is List) {
        final now = DateTime.now();
        int expiredCount = 0;
        final validEntries = <Map<String, dynamic>>[];
        
        for (final item in raw) {
          if (item is Map) {
            final entry = Map<String, dynamic>.from(item);
            final key = entry['key'] as String?;
            final url = entry['url'] as String?;
            final timestampMs = entry['timestamp'] as int?;
            
            if (key != null && url != null && timestampMs != null) {
              final timestamp = DateTime.fromMillisecondsSinceEpoch(timestampMs);
              
              if (now.difference(timestamp) <= _cacheDuration) {
                validEntries.add(entry);
              } else {
                expiredCount++;
              }
            }
          }
        }
        
        DebugLogger.log(
          '[AlbumArtCacheService] Found ${validEntries.length} valid entries in persistent storage ($expiredCount expired entries will be removed)',
          tag: 'AlbumArtCache',
        );
        
        if (expiredCount > 0) {
          final box = await _openBox();
          await box.put(_entriesKey, validEntries);
        }
      }
      
      _isInitialized = true;
    } catch (e) {
      DebugLogger.logError(
        '[AlbumArtCacheService] Failed to load persistent cache',
        error: e,
        tag: 'AlbumArtCache',
      );
      _isInitialized = true;
    }
  }
  
  Future<Box> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return Hive.openBox(_boxName);
  }
  
  Future<void> _persistCache() async {
    try {
      final box = await _openBox();
      final raw = box.get(_entriesKey);
      final persistedEntries = <String, Map<String, dynamic>>{};
      
      if (raw != null && raw is List) {
        for (final item in raw) {
          if (item is Map) {
            final entry = Map<String, dynamic>.from(item);
            final key = entry['key'] as String?;
            if (key != null) {
              persistedEntries[key] = entry;
            }
          }
        }
      }
      
      for (final key in _cache.keys) {
        final timestamp = _cacheTimestamps[key];
        if (timestamp != null) {
          persistedEntries[key] = {
            'key': key,
            'url': _cache[key],
            'timestamp': timestamp.millisecondsSinceEpoch,
            'source': _cacheSources[key],
          };
        }
      }
      
      final entries = persistedEntries.values.toList();
      
      if (entries.length > _maxPersistedSize) {
        final sortedEntries = entries.toList()
          ..sort((a, b) {
            final aTime = a['timestamp'] as int? ?? 0;
            final bTime = b['timestamp'] as int? ?? 0;
            return aTime.compareTo(bTime);
          });
        final entriesToKeep = sortedEntries.skip(entries.length - _maxPersistedSize).toList();
        await box.put(_entriesKey, entriesToKeep);
      } else {
        await box.put(_entriesKey, entries);
      }
    } catch (e) {
      DebugLogger.logError(
        '[AlbumArtCacheService] Failed to persist cache',
        error: e,
        tag: 'AlbumArtCache',
      );
    }
  }

  Future<Map<String, dynamic>?> _loadFromHive(String key) async {
    try {
      final box = await _openBox();
      final raw = box.get(_entriesKey);
      
      if (raw != null && raw is List) {
        for (final item in raw) {
          if (item is Map) {
            final entry = Map<String, dynamic>.from(item);
            if (entry['key'] == key) {
              final timestampMs = entry['timestamp'] as int?;
              if (timestampMs != null) {
                final timestamp = DateTime.fromMillisecondsSinceEpoch(timestampMs);
                if (DateTime.now().difference(timestamp) <= _cacheDuration) {
                  return entry;
                }
              }
            }
          }
        }
      }
    } catch (e) {
      DebugLogger.logError(
        '[AlbumArtCacheService] Failed to load from Hive',
        error: e,
        tag: 'AlbumArtCache',
      );
    }
    return null;
  }

  void _updateAccessOrder(String key) {
    _accessOrder.remove(key);
    _accessOrder.add(key);
    
    if (_accessOrder.length > _maxInMemorySize) {
      final keyToRemove = _accessOrder.removeAt(0);
      _cache.remove(keyToRemove);
      _cacheTimestamps.remove(keyToRemove);
      _cacheSources.remove(keyToRemove);
    }
  }

  /// Generate cache key from artist and title
  String _generateCacheKey(String artist, String title) {
    return '${artist.trim().toLowerCase()}_${title.trim().toLowerCase()}';
  }

  /// Quick synchronous check for in-memory cache only
  /// Returns cached URL if available in memory, null otherwise
  /// Use this for fast lookups when you don't need to check Hive
  String? getCachedAlbumArtSync(String artist, String title) {
    final key = _generateCacheKey(artist, title);
    
    if (_cache.containsKey(key)) {
      final timestamp = _cacheTimestamps[key];
      if (timestamp != null && DateTime.now().difference(timestamp) <= _cacheDuration) {
        _updateAccessOrder(key);
        return _cache[key];
      } else {
        _removeFromCache(key);
      }
    }
    
    return null;
  }

  Future<String?> getCachedAlbumArt(String artist, String title) async {
    final key = _generateCacheKey(artist, title);
    
    if (_cache.containsKey(key)) {
      final timestamp = _cacheTimestamps[key];
      if (timestamp != null && DateTime.now().difference(timestamp) <= _cacheDuration) {
        _updateAccessOrder(key);
        return _cache[key];
      } else {
        _removeFromCache(key);
      }
    }
    
    final entry = await _loadFromHive(key);
    if (entry != null) {
      final url = entry['url'] as String?;
      final timestampMs = entry['timestamp'] as int?;
      final source = entry['source'] as String?;
      
      if (url != null && timestampMs != null) {
        final timestamp = DateTime.fromMillisecondsSinceEpoch(timestampMs);
        _cache[key] = url;
        _cacheTimestamps[key] = timestamp;
        if (source != null) {
          _cacheSources[key] = source;
        }
        _updateAccessOrder(key);
        return url;
      }
    }
    
    return null;
  }

  Future<Map<String, String?>?> getCachedAlbumArtWithSource(String artist, String title) async {
    final key = _generateCacheKey(artist, title);
    
    if (_cache.containsKey(key)) {
      final timestamp = _cacheTimestamps[key];
      if (timestamp != null && DateTime.now().difference(timestamp) <= _cacheDuration) {
        _updateAccessOrder(key);
        return {
          'url': _cache[key],
          'source': _cacheSources[key],
        };
      } else {
        _removeFromCache(key);
      }
    }
    
    final entry = await _loadFromHive(key);
    if (entry != null) {
      final url = entry['url'] as String?;
      final timestampMs = entry['timestamp'] as int?;
      final source = entry['source'] as String?;
      
      if (url != null && timestampMs != null) {
        final timestamp = DateTime.fromMillisecondsSinceEpoch(timestampMs);
        _cache[key] = url;
        _cacheTimestamps[key] = timestamp;
        if (source != null) {
          _cacheSources[key] = source;
        }
        _updateAccessOrder(key);
        return {
          'url': url,
          'source': source,
        };
      }
    }
    
    return null;
  }

  void cacheAlbumArt(String artist, String title, String albumArtUrl, {String? source}) {
    final key = _generateCacheKey(artist, title);

    if (!_cache.containsKey(key)) {
      if (_cache.length >= _maxInMemorySize) {
        final keyToRemove = _accessOrder.removeAt(0);
        _cache.remove(keyToRemove);
        _cacheTimestamps.remove(keyToRemove);
        _cacheSources.remove(keyToRemove);
      }
    }

    _cache[key] = albumArtUrl;
    _cacheTimestamps[key] = DateTime.now();
    if (source != null) {
      _cacheSources[key] = source;
    }
    _updateAccessOrder(key);

    DebugLogger.log('[AlbumArtCacheService] Cached album art for $artist - $title', tag: 'AlbumArtCache');
    
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

  Future<Map<String, dynamic>> getCacheStats() async {
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

    int persistedCount = 0;
    try {
      final box = await _openBox();
      final raw = box.get(_entriesKey);
      if (raw != null && raw is List) {
        persistedCount = raw.length;
      }
    } catch (e) {
      DebugLogger.logError(
        '[AlbumArtCacheService] Failed to get persisted count',
        error: e,
        tag: 'AlbumArtCache',
      );
    }

    return {
      'inMemorySize': _cache.length,
      'validInMemoryEntries': validCount,
      'expiredInMemoryEntries': expiredCount,
      'persistedEntries': persistedCount,
      'maxInMemorySize': _maxInMemorySize,
      'maxPersistedSize': _maxPersistedSize,
      'cacheDurationHours': _cacheDuration.inHours,
      'cacheDurationMinutes': _cacheDuration.inMinutes,
      'isInitialized': _isInitialized,
    };
  }
}
