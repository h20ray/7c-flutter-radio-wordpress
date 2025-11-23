/// State model for tracking notification update operations
/// Provides detailed tracking of notification update attempts, failures, and success
class NotificationUpdateState {
  final String? artist;
  final String? title;
  final String? artworkUrl;
  final int attemptCount;
  final int maxAttempts;
  final DateTime? lastAttemptTime;
  final DateTime? lastSuccessTime;
  final String? lastError;
  final bool isUpdating;
  final bool hasFailed;

  const NotificationUpdateState({
    this.artist,
    this.title,
    this.artworkUrl,
    this.attemptCount = 0,
    this.maxAttempts = 2,
    this.lastAttemptTime,
    this.lastSuccessTime,
    this.lastError,
    this.isUpdating = false,
    this.hasFailed = false,
  });

  /// Create initial state
  factory NotificationUpdateState.initial() {
    return const NotificationUpdateState();
  }

  /// Create state for starting an update
  factory NotificationUpdateState.updating({
    required String artist,
    required String title,
    String? artworkUrl,
    required int maxAttempts,
  }) {
    return NotificationUpdateState(
      artist: artist,
      title: title,
      artworkUrl: artworkUrl,
      maxAttempts: maxAttempts,
      isUpdating: true,
      attemptCount: 1,
      lastAttemptTime: DateTime.now(),
    );
  }

  /// Create state for successful update
  factory NotificationUpdateState.success({
    required String artist,
    required String title,
    String? artworkUrl,
    required int attemptCount,
    required int maxAttempts,
    DateTime? lastAttemptTime,
  }) {
    return NotificationUpdateState(
      artist: artist,
      title: title,
      artworkUrl: artworkUrl,
      attemptCount: attemptCount,
      maxAttempts: maxAttempts,
      lastAttemptTime: lastAttemptTime,
      lastSuccessTime: DateTime.now(),
      isUpdating: false,
      hasFailed: false,
    );
  }

  /// Create state for failed update
  factory NotificationUpdateState.failed({
    required String artist,
    required String title,
    String? artworkUrl,
    required int attemptCount,
    required int maxAttempts,
    required String error,
    DateTime? lastAttemptTime,
  }) {
    return NotificationUpdateState(
      artist: artist,
      title: title,
      artworkUrl: artworkUrl,
      attemptCount: attemptCount,
      maxAttempts: maxAttempts,
      lastAttemptTime: lastAttemptTime,
      lastError: error,
      isUpdating: false,
      hasFailed: true,
    );
  }

  /// Create state for retry attempt
  factory NotificationUpdateState.retrying({
    required String artist,
    required String title,
    String? artworkUrl,
    required int attemptCount,
    required int maxAttempts,
    String? lastError,
    DateTime? lastAttemptTime,
  }) {
    return NotificationUpdateState(
      artist: artist,
      title: title,
      artworkUrl: artworkUrl,
      attemptCount: attemptCount,
      maxAttempts: maxAttempts,
      lastError: lastError,
      lastAttemptTime: DateTime.now(),
      isUpdating: true,
      hasFailed: false,
    );
  }

  /// Copy with new values
  NotificationUpdateState copyWith({
    String? artist,
    String? title,
    String? artworkUrl,
    int? attemptCount,
    int? maxAttempts,
    DateTime? lastAttemptTime,
    DateTime? lastSuccessTime,
    String? lastError,
    bool? isUpdating,
    bool? hasFailed,
  }) {
    return NotificationUpdateState(
      artist: artist ?? this.artist,
      title: title ?? this.title,
      artworkUrl: artworkUrl ?? this.artworkUrl,
      attemptCount: attemptCount ?? this.attemptCount,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      lastAttemptTime: lastAttemptTime ?? this.lastAttemptTime,
      lastSuccessTime: lastSuccessTime ?? this.lastSuccessTime,
      lastError: lastError ?? this.lastError,
      isUpdating: isUpdating ?? this.isUpdating,
      hasFailed: hasFailed ?? this.hasFailed,
    );
  }

  /// Check if this state represents the same notification content as another state
  bool isSameContent(NotificationUpdateState other) {
    return artist == other.artist && 
           title == other.title && 
           artworkUrl == other.artworkUrl;
  }

  /// Check if we can retry (haven't exceeded max attempts)
  bool get canRetry => attemptCount < maxAttempts && !isUpdating;

  /// Check if this is a new notification (different from last successful update)
  bool get isNewNotification {
    if (lastSuccessTime == null) return true;
    
    // Consider new if content changed or if last success was more than 5 minutes ago
    final timeSinceLastSuccess = DateTime.now().difference(lastSuccessTime!);
    return timeSinceLastSuccess.inMinutes > 5;
  }

  /// Get time since last attempt
  Duration? get timeSinceLastAttempt {
    if (lastAttemptTime == null) return null;
    return DateTime.now().difference(lastAttemptTime!);
  }

  /// Get time since last success
  Duration? get timeSinceLastSuccess {
    if (lastSuccessTime == null) return null;
    return DateTime.now().difference(lastSuccessTime!);
  }

  /// Check if the notification update is stale (should be refreshed)
  bool get isStale {
    if (lastSuccessTime == null) return true;
    
    // Consider stale if last success was more than 10 minutes ago
    final timeSinceLastSuccess = DateTime.now().difference(lastSuccessTime!);
    return timeSinceLastSuccess.inMinutes > 10;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationUpdateState &&
        other.artist == artist &&
        other.title == title &&
        other.artworkUrl == artworkUrl &&
        other.attemptCount == attemptCount &&
        other.maxAttempts == maxAttempts &&
        other.lastAttemptTime == lastAttemptTime &&
        other.lastSuccessTime == lastSuccessTime &&
        other.lastError == lastError &&
        other.isUpdating == isUpdating &&
        other.hasFailed == hasFailed;
  }

  @override
  int get hashCode {
    return Object.hash(
      artist,
      title,
      artworkUrl,
      attemptCount,
      maxAttempts,
      lastAttemptTime,
      lastSuccessTime,
      lastError,
      isUpdating,
      hasFailed,
    );
  }

  @override
  String toString() {
    return 'NotificationUpdateState(artist: $artist, title: $title, artworkUrl: $artworkUrl, attemptCount: $attemptCount, maxAttempts: $maxAttempts, isUpdating: $isUpdating, hasFailed: $hasFailed, lastError: $lastError)';
  }
}

