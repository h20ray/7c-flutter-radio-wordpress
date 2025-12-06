import 'debug_logger.dart';

/// Performance monitoring utility for tracking API calls, cache hits, and errors
class PerformanceMonitor {
  static final Map<String, List<Duration>> _apiCallTimes = {};
  static final Map<String, int> _cacheHits = {};
  static final Map<String, int> _cacheMisses = {};
  static final Map<String, int> _errorCounts = {};
  
  /// Track API call duration
  static void trackApiCall(String operation, Duration duration) {
    _apiCallTimes.putIfAbsent(operation, () => []).add(duration);
    
    // Keep only last 100 measurements per operation
    final times = _apiCallTimes[operation]!;
    if (times.length > 100) {
      times.removeRange(0, times.length - 100);
    }
    
    DebugLogger.log(
      'API call: $operation took ${duration.inMilliseconds}ms',
      tag: 'PerformanceMonitor',
    );
  }
  
  /// Track cache hit
  static void trackCacheHit(String operation) {
    _cacheHits[operation] = (_cacheHits[operation] ?? 0) + 1;
    DebugLogger.log(
      'Cache hit: $operation (total: ${_cacheHits[operation]})',
      tag: 'PerformanceMonitor',
    );
  }
  
  /// Track cache miss
  static void trackCacheMiss(String operation) {
    _cacheMisses[operation] = (_cacheMisses[operation] ?? 0) + 1;
    DebugLogger.log(
      'Cache miss: $operation (total: ${_cacheMisses[operation]})',
      tag: 'PerformanceMonitor',
    );
  }
  
  /// Track error
  static void trackError(String operation, String errorType) {
    final key = '$operation:$errorType';
    _errorCounts[key] = (_errorCounts[key] ?? 0) + 1;
    DebugLogger.log(
      'Error: $operation - $errorType (total: ${_errorCounts[key]})',
      tag: 'PerformanceMonitor',
    );
  }
  
  /// Get average API call time for an operation
  static Duration? getAverageApiTime(String operation) {
    final times = _apiCallTimes[operation];
    if (times == null || times.isEmpty) return null;
    
    final total = times.fold<int>(
      0,
      (sum, duration) => sum + duration.inMilliseconds,
    );
    return Duration(milliseconds: total ~/ times.length);
  }
  
  /// Get cache hit rate for an operation
  static double? getCacheHitRate(String operation) {
    final hits = _cacheHits[operation] ?? 0;
    final misses = _cacheMisses[operation] ?? 0;
    final total = hits + misses;
    
    if (total == 0) return null;
    return (hits / total) * 100;
  }
  
  /// Get error count for an operation
  static int getErrorCount(String operation, [String? errorType]) {
    if (errorType != null) {
      return _errorCounts['$operation:$errorType'] ?? 0;
    }
    
    // Sum all error types for this operation
    return _errorCounts.entries
        .where((e) => e.key.startsWith('$operation:'))
        .fold<int>(0, (sum, e) => sum + e.value);
  }
  
  /// Get performance summary
  static Map<String, dynamic> getPerformanceSummary() {
    return {
      'apiCallTimes': _apiCallTimes.map(
        (key, value) => MapEntry(
          key,
          {
            'averageMs': getAverageApiTime(key)?.inMilliseconds,
            'count': value.length,
            'minMs': value.map((d) => d.inMilliseconds).reduce((a, b) => a < b ? a : b),
            'maxMs': value.map((d) => d.inMilliseconds).reduce((a, b) => a > b ? a : b),
          },
        ),
      ),
      'cacheHitRates': _cacheHits.map(
        (key, value) => MapEntry(
          key,
          {
            'hitRate': getCacheHitRate(key),
            'hits': value,
            'misses': _cacheMisses[key] ?? 0,
          },
        ),
      ),
      'errorCounts': Map.from(_errorCounts),
    };
  }
  
  /// Reset all metrics
  static void reset() {
    _apiCallTimes.clear();
    _cacheHits.clear();
    _cacheMisses.clear();
    _errorCounts.clear();
  }
}

