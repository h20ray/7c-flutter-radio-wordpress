import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// A strategy for handling data fetching with caching support.
///
/// This strategy implements a "Cache First, then Network" approach:
/// 1. Return cached data immediately if available.
/// 2. Fetch fresh data from the network in the background.
/// 3. Update the cache with the fresh data.
/// 4. Notify the caller with the fresh data (or error).
///
/// It also handles:
/// - Force refresh (skip cache, fetch network directly).
/// - Network errors (fallback to cache if network fails).
/// - Cache validation (check if cache is fresh enough).
abstract class CacheStrategy<T> {
  /// Fetch data using the cache strategy.
  ///
  /// [forceRefresh] If true, skips the initial cache check and fetches from network immediately.
  /// [onCacheHit] Callback invoked when valid cached data is found.
  /// [onNetworkSuccess] Callback invoked when fresh data is successfully fetched from network.
  /// [onNetworkError] Callback invoked when network fetch fails.
  Future<void> execute({
    bool forceRefresh = false,
    required Future<void> Function(T data) onCacheHit,
    required Future<void> Function(T data) onNetworkSuccess,
    required Future<void> Function(Failure failure) onNetworkError,
  }) async {
    // 1. Try to load from cache first (unless forced to refresh)
    T? cachedData;
    if (!forceRefresh) {
      try {
        cachedData = await loadFromCache();
        if (cachedData != null && shouldUseCache(cachedData)) {
          await onCacheHit(cachedData);
        }
      } catch (e) {
        // Ignore cache errors, proceed to network
      }
    }

    // 2. Fetch from network
    // If we have cached data and it's considered fresh enough to not need immediate update,
    // we might skip network, but for "Cache First, Background Update" we usually always fetch.
    // You can override [shouldFetchFromNetwork] to control this.
    if (shouldFetchFromNetwork(cachedData, forceRefresh)) {
      final result = await fetchFromNetwork();
      
      await result.fold(
        (failure) async {
          // Network failed
          await onNetworkError(failure);
        },
        (data) async {
          // Network success
          try {
            await saveToCache(data);
          } catch (e) {
            // Ignore cache save errors
          }
          await onNetworkSuccess(data);
        },
      );
    }
  }

  /// Load data from local cache.
  /// Return null if no cache is available.
  Future<T?> loadFromCache();

  /// Fetch fresh data from the network.
  Future<Either<Failure, T>> fetchFromNetwork();

  /// Save fresh data to local cache.
  Future<void> saveToCache(T data);

  /// Determine if the cached data is valid/usable.
  /// Default implementation checks if data is not null.
  bool shouldUseCache(T? data) => data != null;

  /// Determine if we should fetch from network.
  /// Default implementation always returns true to ensure data is up-to-date (Background Update),
  /// unless overridden.
  bool shouldFetchFromNetwork(T? cachedData, bool forceRefresh) => true;
}
