import 'dart:async';
import 'dart:math';

/// Utility class for implementing exponential backoff retry logic
/// Provides configurable retry delays with exponential backoff and jitter
class ExponentialBackoff {
  final int maxRetries;
  final int initialDelayMs;
  final double multiplier;
  final int maxDelayMs;
  final bool useJitter;
  final Random _random = Random();

  ExponentialBackoff({
    required this.maxRetries,
    required this.initialDelayMs,
    required this.multiplier,
    required this.maxDelayMs,
    this.useJitter = true,
  });

  /// Execute a function with exponential backoff retry logic
  /// Returns the result of the function or throws the last exception
  Future<T> execute<T>(
    Future<T> Function() operation, {
    bool Function(dynamic error)? shouldRetry,
    void Function(int attempt, dynamic error)? onRetry,
  }) async {
    int attempt = 0;
    dynamic lastError;

    while (attempt <= maxRetries) {
      try {
        return await operation();
      } catch (error) {
        lastError = error;

        // Check if we should retry this error
        if (shouldRetry != null && !shouldRetry(error)) {
          rethrow;
        }

        // If this was the last attempt, throw the error
        if (attempt >= maxRetries) {
          rethrow;
        }

        // Calculate delay for next attempt
        final delayMs = _calculateDelay(attempt);

        // Notify about retry
        if (onRetry != null) {
          onRetry(attempt + 1, error);
        }

        // Wait before next attempt
        await Future.delayed(Duration(milliseconds: delayMs));
        attempt++;
      }
    }

    throw lastError;
  }

  /// Calculate delay for the given attempt number
  int _calculateDelay(int attempt) {
    // Calculate exponential delay
    final exponentialDelay = (initialDelayMs * pow(multiplier, attempt))
        .round();

    // Cap at maximum delay
    final cappedDelay = min(exponentialDelay, maxDelayMs);

    // Add jitter if enabled (random variation of ±25%)
    if (useJitter) {
      final jitterRange = (cappedDelay * 0.25).round();
      final jitter = _random.nextInt(jitterRange * 2) - jitterRange;
      return max(0, cappedDelay + jitter);
    }

    return cappedDelay;
  }

  /// Get the delay for a specific attempt (useful for testing or logging)
  int getDelayForAttempt(int attempt) {
    return _calculateDelay(attempt);
  }

  /// Create a backoff instance with default notification settings
  factory ExponentialBackoff.forNotifications() {
    return ExponentialBackoff(
      maxRetries: 2,
      initialDelayMs: 500,
      multiplier: 2.0,
      maxDelayMs: 2000,
      useJitter: true,
    );
  }

  /// Create a backoff instance with default network request settings
  factory ExponentialBackoff.forNetworkRequests() {
    return ExponentialBackoff(
      maxRetries: 3,
      initialDelayMs: 1000,
      multiplier: 2.0,
      maxDelayMs: 8000,
      useJitter: true,
    );
  }
}
