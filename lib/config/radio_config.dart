/// Album art source options
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

/// Unified Radio Configuration
/// 
/// This file contains all radio-related settings that can be easily customized.
/// Most settings can also be configured via WordPress admin panel, which will
/// override these defaults at runtime.
/// 
/// IMPORTANT: Server configuration from WordPress API takes priority over these values.
class RadioConfig {
  // ============================================
  // BASIC SETTINGS (Easy to understand)
  // ============================================

  /// Your radio station name (shown in app)
  /// Example: "My Radio Station"
  /// Note: This can also be set in WordPress admin or translation files
  /// Translation key: "radio_station_name"
  static const String stationName = 'Tujuh Cahaya Radio';

  /// Logo configuration
  /// Path to your radio logo image file (in assets folder)
  /// Example: 'assets/images/radio_logo.png'
  static const String logoAssetPath = 'assets/images/radio_logo.png';
  
  /// Logo from network URL (optional)
  /// If you want to load logo from a URL instead of local file, set this
  /// Example: 'https://example.com/logo.png'
  /// Note: Usually set via WordPress admin
  static const String? logoNetworkUrl = null;

  /// Default artwork image (shown when no album art is available)
  /// Path to fallback image file (in assets folder)
  /// Example: 'assets/images/fallback_artwork.jpg'
  static const String fallbackArtworkPath = 'assets/images/fallback_artwork.jpg';

  /// Fallback artist name (shown when stream metadata is missing)
  /// Example: "Now On Air"
  static const String fallbackArtist = 'Now On Air';

  /// Fallback title (shown when stream metadata is missing)
  /// Example: "Live Radio Stream"
  static const String fallbackTitle = 'Live Radio Stream';

  // ============================================
  // APPEARANCE SETTINGS
  // ============================================

  /// Show album art from songs?
  /// true = Yes, show album covers when available
  /// false = No, don't show album art
  static const bool showAlbumCover = true;

  /// Enable text scrolling for long song titles?
  /// true = Yes, scroll long text automatically
  /// false = No, show text as-is (may be cut off)
  static const bool textScrolling = true;

  // ============================================
  // STREAM & PLAYBACK SETTINGS
  // ============================================

  /// Main stream URL (your radio stream address)
  /// Example: "https://stream.example.com/radio"
  /// Note: This is usually set in WordPress admin, but you can set a default here
  /// Leave empty to use WordPress admin setting only
  static const String streamUrl = '';

  /// Should radio play automatically when app opens?
  /// true = Yes, play automatically when radio screen loads
  /// false = No, wait for user to click play button
  static const bool autoplay = false;

  /// Backup stream URLs for failover (if main stream fails)
  /// Add multiple backup URLs here, one per line
  /// Example:
  ///   'https://backup1.example.com/stream',
  ///   'https://backup2.example.com/stream',
  /// Note: Usually set via WordPress admin
  static const List<String> backupStreamUrls = [
    // Add backup stream URLs here if needed
    // Example: 'https://backup1.example.com/stream',
  ];

  /// Parse metadata from stream?
  /// true = Yes, extract artist and title from stream
  /// false = No, don't parse stream metadata
  static const bool parseStreamMetadata = true;

  /// Lookup artwork online automatically?
  /// true = Yes, search for album art online
  /// false = No, only use stream metadata
  static const bool lookupOnlineArtwork = false;

  /// Pre-buffer time before playback starts (in milliseconds)
  /// Higher values = smoother playback but longer wait time
  /// Recommended: 500-2000ms
  /// Example: 500 = wait 0.5 seconds before starting playback
  static const int preBufferTimeMs = 500;

  // ============================================
  // ALBUM ART SETTINGS
  // ============================================

  /// Album art source preference
  /// 1 = Auto (try AzuraCast first, then Apple Music, then fallback)
  /// 2 = AzuraCast only
  /// 3 = Apple Music only
  /// 4 = Fallback only (use default image)
  /// Recommended: 1 (Auto)
  static const int albumArtSource = 1;

  /// AzuraCast base URL (if using AzuraCast for metadata)
  /// Example: "https://azuracast.example.com"
  /// Note: Usually set via WordPress admin
  static const String? azuracastBaseUrl = null;

  /// AzuraCast station ID (if using AzuraCast)
  /// Example: "1"
  /// Note: Usually set via WordPress admin
  static const String? azuracastStationId = null;

  /// Enable Apple Music/iTunes fallback for album art?
  /// true = Yes, search Apple Music if other sources fail
  /// false = No, skip Apple Music search
  static const bool enableAppleMusicFallback = true;

  /// Album art cache duration (in hours)
  /// How long to cache album art URLs before refreshing
  /// Example: 1 = cache for 1 hour
  static const int albumArtCacheTTLHours = 1;

  /// Album art request timeout (in milliseconds)
  /// How long to wait for album art API response
  /// Example: 10000 = wait up to 10 seconds
  static const int albumArtRequestTimeoutMs = 10000;

  // ============================================
  // RETRY & ERROR HANDLING SETTINGS
  // ============================================

  /// Maximum retry attempts when stream fails
  /// Example: 4 = try up to 4 times before giving up
  static const int maxRetryAttempts = 4;

  /// Retry delay times (in milliseconds)
  /// Wait these times between retry attempts
  /// Example: [1000, 2000, 4000, 8000] = wait 1s, then 2s, then 4s, then 8s
  static const List<int> retryBackoffDelays = [
    1000,  // First retry: wait 1 second
    2000,  // Second retry: wait 2 seconds
    4000,  // Third retry: wait 4 seconds
    8000,  // Fourth retry: wait 8 seconds
  ];

  /// Connection timeout (in milliseconds)
  /// How long to wait for stream connection
  /// Example: 10000 = wait up to 10 seconds
  static const int connectionTimeoutMs = 10000;

  // ============================================
  // ADVANCED SETTINGS (Rarely changed)
  // ============================================

  /// Enable radioCoreV2 features?
  /// true = Yes, use enhanced radio player features
  /// false = No, use basic player
  /// Note: Usually enabled by default
  static const bool radioCoreV2Enabled = true;

  /// Debounce window for play button clicks (in milliseconds)
  /// Prevents rapid clicking issues
  /// Example: 200 = ignore clicks within 200ms of each other
  static const int debounceWindowMs = 200;

  /// Audio buffer size (in bytes)
  /// Larger buffer = smoother playback but more memory usage
  /// Example: 8192 = 8KB buffer
  static const int audioBufferSize = 8192;

  /// Maximum buffer underruns before switching to backup URL
  /// Example: 3 = switch to backup after 3 buffer errors
  static const int maxBufferUnderruns = 3;

  /// Audio session optimization delay (in milliseconds)
  /// Delay before optimizing audio session
  /// Example: 200 = wait 200ms
  static const int audioSessionOptimizationDelayMs = 200;

  /// Audio focus delay (in milliseconds)
  /// Delay before requesting audio focus
  /// Example: 100 = wait 100ms
  static const int audioFocusDelayMs = 100;

  /// Notification update configuration
  /// Maximum retries for notification updates
  static const int notificationMaxRetries = 2;

  /// Initial delay before first notification retry (in milliseconds)
  static const int notificationInitialDelayMs = 500;

  /// Notification retry backoff multiplier
  /// Example: 2.0 = double the delay each retry
  static const double notificationBackoffMultiplier = 2.0;

  /// Maximum delay between notification retries (in milliseconds)
  static const int notificationMaxDelayMs = 2000;

  /// Maximum concurrent album art requests
  /// Example: 3 = fetch up to 3 album arts at the same time
  static const int albumArtMaxConcurrentRequests = 3;

  /// Delay metadata update until audio actually starts?
  /// true = Yes, wait for audio to start before showing metadata
  /// false = No, show metadata immediately
  static const bool delayMetadataUntilAudioStarts = true;

  /// Metadata sanitization phrases
  /// These phrases will be removed from artist/title text (case-insensitive)
  /// Example: "Now Playing:" will be removed from song titles
  static const List<String> metadataRemovePhrases = [
    'now on air:',
    'now playing:',
    'now playng:',
    'on air:',
    'Sorry, service not available. Try again later.',
  ];

  /// Show next/previous buttons in player?
  /// Note: Usually false for radio (no next/previous)
  static const bool showNextButton = false;
  static const bool showPreviousButton = false;

  // ============================================
  // DEBUG SETTINGS (For developers only)
  // ============================================

  /// Enable debug logging?
  /// true = Yes, show debug messages in console
  /// false = No, disable debug logging
  static const bool enableDebugLogging = false;

  /// Enable verbose logging?
  /// true = Yes, show detailed logs (may be very verbose)
  /// false = No, show only important logs
  static const bool enableVerboseLogging = false;

  /// Enable performance monitoring?
  /// true = Yes, track performance metrics
  /// false = No, skip performance tracking
  static const bool enablePerformanceMonitoring = false;

  /// Log notification updates?
  /// true = Yes, log notification update attempts
  /// false = No, skip notification logs
  static const bool logNotificationUpdates = true;

  /// Enable shoutbox debug logging?
  /// false = Disable to reduce log spam
  static const bool enableShoutboxDebugLogging = false;
}

