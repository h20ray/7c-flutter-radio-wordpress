/// State model for album art management
/// Represents the current state of album art fetching and display
class AlbumArtState {
  final String? url;
  final bool isLoading;
  final String? error;
  final String? artist;
  final String? title;
  final bool isFallback;
  final bool isOffline;
  final DateTime? lastUpdateTime;
  final int retryCount;
  final String? cacheSource;

  const AlbumArtState({
    this.url,
    this.isLoading = false,
    this.error,
    this.artist,
    this.title,
    this.isFallback = false,
    this.isOffline = false,
    this.lastUpdateTime,
    this.retryCount = 0,
    this.cacheSource,
  });

  /// Create initial state
  factory AlbumArtState.initial() {
    return const AlbumArtState();
  }

  /// Create loading state
  factory AlbumArtState.loading({
    required String artist,
    required String title,
    bool isOffline = false,
    int retryCount = 0,
  }) {
    return AlbumArtState(
      isLoading: true,
      artist: artist,
      title: title,
      isOffline: isOffline,
      retryCount: retryCount,
      lastUpdateTime: DateTime.now(),
    );
  }

  /// Create success state with album art URL
  factory AlbumArtState.success({
    required String url,
    required String artist,
    required String title,
    bool isOffline = false,
    String? cacheSource,
  }) {
    return AlbumArtState(
      url: url,
      isLoading: false,
      artist: artist,
      title: title,
      isFallback: false,
      isOffline: isOffline,
      cacheSource: cacheSource,
      lastUpdateTime: DateTime.now(),
    );
  }

  /// Create fallback state (using default artwork)
  factory AlbumArtState.fallback({
    required String artist,
    required String title,
    bool isOffline = false,
  }) {
    return AlbumArtState(
      isLoading: false,
      artist: artist,
      title: title,
      isFallback: true,
      isOffline: isOffline,
      lastUpdateTime: DateTime.now(),
    );
  }

  /// Create error state
  factory AlbumArtState.error({
    required String error,
    required String artist,
    required String title,
    bool isOffline = false,
    int retryCount = 0,
  }) {
    return AlbumArtState(
      isLoading: false,
      error: error,
      artist: artist,
      title: title,
      isOffline: isOffline,
      retryCount: retryCount,
      lastUpdateTime: DateTime.now(),
    );
  }

  /// Copy with new values
  AlbumArtState copyWith({
    String? url,
    bool? isLoading,
    String? error,
    String? artist,
    String? title,
    bool? isFallback,
    bool? isOffline,
    DateTime? lastUpdateTime,
    int? retryCount,
    String? cacheSource,
  }) {
    return AlbumArtState(
      url: url ?? this.url,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      artist: artist ?? this.artist,
      title: title ?? this.title,
      isFallback: isFallback ?? this.isFallback,
      isOffline: isOffline ?? this.isOffline,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
      retryCount: retryCount ?? this.retryCount,
      cacheSource: cacheSource ?? this.cacheSource,
    );
  }

  /// Check if this state has valid album art URL
  bool get hasUrl => url != null && url!.isNotEmpty;

  /// Check if this state represents the same track as another state
  bool isSameTrack(AlbumArtState other) {
    return artist == other.artist && title == other.title;
  }

  /// Check if this state is stale and should be refreshed
  bool get isStale {
    if (lastUpdateTime == null) return true;
    
    // Consider stale if last update was more than 1 hour ago
    final timeSinceUpdate = DateTime.now().difference(lastUpdateTime!);
    return timeSinceUpdate.inHours >= 1;
  }

  /// Check if this state can be retried
  bool get canRetry => retryCount < 3 && !isLoading;

  /// Get time since last update
  Duration? get timeSinceLastUpdate {
    if (lastUpdateTime == null) return null;
    return DateTime.now().difference(lastUpdateTime!);
  }

  /// Check if this is a cached result
  bool get isCached => cacheSource != null && cacheSource!.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AlbumArtState &&
        other.url == url &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.artist == artist &&
        other.title == title &&
        other.isFallback == isFallback &&
        other.isOffline == isOffline &&
        other.lastUpdateTime == lastUpdateTime &&
        other.retryCount == retryCount &&
        other.cacheSource == cacheSource;
  }

  @override
  int get hashCode {
    return Object.hash(
      url,
      isLoading,
      error,
      artist,
      title,
      isFallback,
      isOffline,
      lastUpdateTime,
      retryCount,
      cacheSource,
    );
  }

  @override
  String toString() {
    return 'AlbumArtState(url: $url, isLoading: $isLoading, error: $error, artist: $artist, title: $title, isFallback: $isFallback, isOffline: $isOffline, retryCount: $retryCount, cacheSource: $cacheSource)';
  }
}

