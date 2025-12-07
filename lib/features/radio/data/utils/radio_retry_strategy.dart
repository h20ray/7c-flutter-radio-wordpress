import 'dart:async';
import '../../../../config/radio_config.dart';

/// Result of a retry attempt
enum RetryResult {
  /// Retry was successful
  success,

  /// Retry failed but can try again
  retryable,

  /// All retries exhausted for current URL
  exhaustedAttempts,

  /// All URLs exhausted - final failure
  exhaustedUrls,
}

/// Callback type for retry actions
typedef RetryAction = Future<void> Function(String url);

/// Callback type for state updates
typedef RetryStateCallback = void Function({
  required int retryAttempt,
  required int urlIndex,
  required bool isRetrying,
  String? errorMessage,
});

/// Strategy class for handling retry logic with exponential backoff
/// and backup URL cycling.
///
/// This class encapsulates the retry logic that was previously embedded
/// in RadioPlayerRepositoryImpl, making it testable and reusable.
class RadioRetryStrategy {
  /// List of available URLs (primary + backups)
  final List<String> urls;

  /// Maximum retry attempts per URL
  final int maxAttempts;

  /// Backoff delays in milliseconds for each retry attempt
  final List<int> backoffDelays;

  /// Current retry attempt (0-indexed)
  int _currentAttempt = 0;

  /// Current URL index
  int _currentUrlIndex = 0;

  /// Active retry timer
  Timer? _retryTimer;

  /// Whether a retry is currently in progress
  bool _isRetrying = false;

  /// Creates a new retry strategy with the given URLs and configuration.
  ///
  /// If no configuration is provided, uses defaults from [RadioConfig].
  RadioRetryStrategy({
    required this.urls,
    int? maxAttempts,
    List<int>? backoffDelays,
  })  : maxAttempts = maxAttempts ?? RadioConfig.maxRetryAttempts,
        backoffDelays = backoffDelays ?? RadioConfig.retryBackoffDelays {
    if (urls.isEmpty) {
      throw ArgumentError('At least one URL must be provided');
    }
  }

  /// Creates a retry strategy from a primary URL and optional backup URLs.
  factory RadioRetryStrategy.fromPrimaryAndBackups({
    required String primaryUrl,
    List<String> backupUrls = const [],
    int? maxAttempts,
    List<int>? backoffDelays,
  }) {
    return RadioRetryStrategy(
      urls: [primaryUrl, ...backupUrls],
      maxAttempts: maxAttempts,
      backoffDelays: backoffDelays,
    );
  }

  /// Current retry attempt (0-indexed)
  int get currentAttempt => _currentAttempt;

  /// Current URL index
  int get currentUrlIndex => _currentUrlIndex;

  /// Whether a retry is currently pending
  bool get isRetrying => _isRetrying;

  /// Gets the current URL to try
  String get currentUrl => urls[_currentUrlIndex];

  /// Gets the delay in milliseconds for the current attempt
  int get currentDelayMs {
    if (_currentAttempt >= backoffDelays.length) {
      return backoffDelays.last;
    }
    return backoffDelays[_currentAttempt];
  }

  /// Whether there are more retry attempts available for the current URL
  bool get hasMoreAttempts => _currentAttempt < maxAttempts - 1;

  /// Whether there are more backup URLs to try
  bool get hasMoreUrls => _currentUrlIndex < urls.length - 1;

  /// Whether any retries are possible (attempts or URLs)
  bool get canRetry => hasMoreAttempts || hasMoreUrls;

  /// Resets the retry state to initial values
  void reset() {
    _retryTimer?.cancel();
    _retryTimer = null;
    _currentAttempt = 0;
    _currentUrlIndex = 0;
    _isRetrying = false;
  }

  /// Cancels any pending retry
  void cancel() {
    _retryTimer?.cancel();
    _retryTimer = null;
    _isRetrying = false;
  }

  /// Called when an attempt succeeds. Resets retry state.
  void onSuccess() {
    reset();
  }

  /// Called when an attempt fails. Returns the result indicating
  /// what should happen next.
  ///
  /// - [RetryResult.retryable] - Schedule a retry with the current URL
  /// - [RetryResult.exhaustedAttempts] - Move to next URL if available
  /// - [RetryResult.exhaustedUrls] - All options exhausted
  RetryResult onFailure() {
    if (hasMoreAttempts) {
      return RetryResult.retryable;
    }

    if (hasMoreUrls) {
      // Move to next URL and reset attempts
      _currentUrlIndex++;
      _currentAttempt = 0;
      return RetryResult.exhaustedAttempts;
    }

    return RetryResult.exhaustedUrls;
  }

  /// Schedules a retry with exponential backoff.
  ///
  /// The [onRetry] callback is called after the backoff delay.
  /// Returns the scheduled delay in milliseconds.
  int scheduleRetry({
    required void Function() onRetry,
  }) {
    if (_currentAttempt >= backoffDelays.length) {
      // Can't schedule more retries
      return 0;
    }

    final delayMs = backoffDelays[_currentAttempt];
    _currentAttempt++;
    _isRetrying = true;

    _retryTimer?.cancel();
    _retryTimer = Timer(Duration(milliseconds: delayMs), () {
      _isRetrying = false;
      onRetry();
    });

    return delayMs;
  }

  /// Advances to the next URL. Returns true if successful, false if
  /// no more URLs are available.
  bool advanceToNextUrl() {
    if (!hasMoreUrls) {
      return false;
    }
    _currentUrlIndex++;
    _currentAttempt = 0;
    return true;
  }

  /// Gets the total number of URLs available
  int get totalUrls => urls.length;

  /// Gets the remaining URLs (including current)
  int get remainingUrls => urls.length - _currentUrlIndex;

  /// Gets the remaining attempts for the current URL
  int get remainingAttempts => maxAttempts - _currentAttempt;

  /// Disposes of resources (timers)
  void dispose() {
    _retryTimer?.cancel();
    _retryTimer = null;
  }

  @override
  String toString() {
    return 'RadioRetryStrategy('
        'url=${_currentUrlIndex + 1}/${urls.length}, '
        'attempt=${_currentAttempt + 1}/$maxAttempts, '
        'isRetrying=$_isRetrying)';
  }
}
