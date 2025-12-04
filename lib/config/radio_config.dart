/// Radio configuration settings for the app.
///
/// Contains static configuration constants for radio playback behavior,
/// album art sources, UI preferences, retry logic, and metadata handling.
enum AlbumArtSource {
  auto(1, 'Auto'),
  azuracast(2, 'AzuraCast'),
  appleMusic(3, 'Apple Music'),
  fallback(4, 'Fallback');

  const AlbumArtSource(this.value, this.displayName);

  final int value;
  final String displayName;

  static AlbumArtSource fromValue(int value) {
    return AlbumArtSource.values.firstWhere(
      (source) => source.value == value,
      orElse: () => AlbumArtSource.auto,
    );
  }
}

class RadioConfig {
  /// Whether to use the RadioCore V2 implementation for playback.
  static const bool radioCoreV2Enabled = true;

  /// Pre-buffer time in milliseconds before starting audio playback.
  static const int preBufferTimeMs = 500;

  /// Maximum number of retry attempts for failed network requests.
  static const int maxRetryAttempts = 4;

  /// Backoff delays in milliseconds for each retry attempt.
  /// Each value corresponds to the delay before the next retry.
  static const List<int> retryBackoffDelays = [1000, 2000, 4000, 8000];

  /// Album art source preference (1=Auto, 2=AzuraCast, 3=Apple Music, 4=Fallback).
  static const int albumArtSource = 1;

  /// Whether to enable Apple Music as a fallback source for album art.
  static const bool enableAppleMusicFallback = true;

  /// Path to the fallback artwork image asset.
  static const String fallbackArtworkPath =
      'assets/images/fallback_artwork.jpg';

  /// Album art cache time-to-live in hours.
  /// Set to 30 days (720 hours) for long-term caching
  static const int albumArtCacheTTLHours = 720;

  /// Timeout in milliseconds for album art network requests.
  static const int albumArtRequestTimeoutMs = 10000;

  /// Whether to display the album cover in the UI.
  static const bool showAlbumCover = true;

  /// Whether to enable text scrolling for long metadata text.
  static const bool textScrolling = true;

  /// Whether to show the next track button in the player UI.
  static const bool showNextButton = false;

  /// Whether to show the previous track button in the player UI.
  static const bool showPreviousButton = false;

  /// Fallback artist name displayed when metadata is unavailable.
  static const String fallbackArtist = 'Now On Air';

  /// Fallback track title displayed when metadata is unavailable.
  static const String fallbackTitle = 'Live Radio Stream';

  /// Whether to delay metadata display until audio playback actually starts.
  static const bool delayMetadataUntilAudioStarts = true;

  /// Phrases to remove from metadata text for cleaner display.
  static const List<String> metadataRemovePhrases = [
    'now on air:',
    'now playing:',
    'now playng:',
    'on air:',
    'Sorry, service not available. Try again later.',
  ];

  /// Debounce window in milliseconds for metadata updates.
  static const int debounceWindowMs = 200;

  /// Delay in milliseconds before optimizing audio session settings.
  static const int audioSessionOptimizationDelayMs = 200;

  /// Delay in milliseconds before requesting audio focus.
  static const int audioFocusDelayMs = 100;

  /// Whether to enable verbose logging for debugging purposes.
  static const bool enableVerboseLogging = false;

  /// Whether to enable performance monitoring and metrics collection.
  static const bool enablePerformanceMonitoring = false;

  /// Whether to log notification updates for debugging.
  static const bool logNotificationUpdates = true;

  /// Notification update configuration
  static const int notificationMaxRetries = 2;
  static const int notificationInitialDelayMs = 500;
  static const double notificationBackoffMultiplier = 2.0;
  static const int notificationMaxDelayMs = 2000;

  /// Performance targets
  static const int targetColdStartMs = 3000;
  static const int targetFastResumeMs = 500;

  /// Audio buffer configuration to prevent underruns
  static const int audioBufferSize = 8192;
  static const int maxBufferUnderruns = 3;

  /// Logo configuration
  static const String logoAssetPath = 'assets/images/radio_logo.png';
  static const String? logoNetworkUrl = null;

  /// Sticky player logo path (acts as radio station identity)
  static const String stickyLogoPath = 'assets/images/fallback_artwork.jpg';

  /// Request/Feedback WebView configuration
  static const String requestWebViewTitle = 'Request Lagu';

  /// AzuraCast configuration
  /// Note: Azuracast's public API endpoints (now playing, history) don't require authentication
  static const String? azuracastBaseUrl = null;
  static const String? azuracastStationId = null;

  /// Album art max concurrent requests
  static const int albumArtMaxConcurrentRequests = 3;

  /// Debug settings
  static const bool enableDebugLogging = false;
  static const bool enableShoutboxDebugLogging = false;

  /// Menu chips visibility
  static const bool showSongHistory = true;
  static const bool showLyrics = true;
  static const bool showRequest = true;
  static const bool showAbout = true;

  /// Song history configuration
  static const int songHistoryMaxEntries = 100;
  static const bool songHistorySyncToWordPress = true;
  
  /// Song history mode: 'local' for local storage, 'azuracast' for Azuracast API
  static const String songHistoryMode = 'azuracast'; // 'local' or 'azuracast'
  
  /// Minimum time in seconds between adding the same song to prevent duplicates
  static const int songHistoryDuplicatePreventionSeconds = 30;

  /// Lyrics API configuration
  /// Provider options: 'proxy' (uses proxy API like WordPress), 'musixmatch' (direct), 'wordpress' (WordPress endpoint)
  static const String lyricsApiProvider = 'proxy'; // 'proxy', 'musixmatch', 'wordpress'
  
  /// Lyrics proxy API base URL (used when lyricsApiProvider is 'proxy')
  static const String lyricsProxyApiBaseUrl = 'https://lyrics.lewdhutao.my.eu.org/v2';
  
  /// Lyrics provider fallback chain (used when lyricsApiProvider is 'proxy')
  /// Order: first provider is tried first, then fallback to next
  static const List<String> lyricsProviderFallbackChain = ['youtube', 'musixmatch']; // 'youtube', 'musixmatch'
  
  /// Lyrics cache TTL in days (1-180)
  static const int lyricsCacheTtlDays = 30;
  
  /// Musixmatch API key (only used when lyricsApiProvider is 'musixmatch' and using direct API)
  static const String? lyricsApiKey = null;

  /// Request configuration
  /// Mode options: 'azuracast' (native AzuraCast API), 'webview' (WebView fallback)
  /// If 'auto', will try AzuraCast first, fallback to WebView if unavailable
  static const String requestMode = 'auto'; // 'azuracast', 'webview', 'auto'
  
  /// WebView URL for request page (used when requestMode is 'webview' or as fallback)
  static const String? requestWebViewUrl = null; // e.g., 'https://radio.example.com/request'
  
  /// Request rate limit in minutes (prevents spam)
  static const int requestRateLimitMinutes = 5;
  
  /// Request list cache duration in minutes
  static const int requestListCacheMinutes = 5;
  
  /// Request list items per page (initial load)
  static const int requestListItemsPerPage = 15;
  
  /// WordPress request endpoint path (legacy, used if requestMode is not 'azuracast' or 'webview')
  /// Auto-configured: ApiClient automatically prepends 'https://${AppConfig.url}' to this path
  /// Same pattern as lyrics endpoint - just provide the path, ApiClient handles the baseUrl
  static const String requestApiEndpoint = '/wp-json/tujuhcahaya/radio/request';
  
  /// Blob animation speed: 'fast' or 'slow'
  /// Fast: Quick, energetic movement
  /// Slow: Smooth, gentle movement
  static const String blobAnimationSpeed = 'fast'; // 'fast' or 'slow'
  
  /// Minimum duration to show fallback album art before transitioning to actual album art
  /// This ensures smooth transitions without flash-bang effect
  /// Value in milliseconds (1000 = 1 second, 2000 = 2 seconds)
  static const int minFallbackDisplayDuration = 1500; // 1.5 seconds
}

@Deprecated(
  'Use GameRadioTimeConfig from game_radio_time_config.dart instead. '
  'This enum is kept only for migration compatibility.',
)
enum RadioGameLevel {
  level1FrequencyWanderer,
  level2ActiveTuner,
  level3StudioCompanion,
  level4AirwaveCitizen,
  level5RadioStar,
  level6BroadcastLegend,
}
