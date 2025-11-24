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
  static const int albumArtCacheTTLHours = 1;

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

  /// Request/Feedback WebView configuration
  static const String requestWebViewTitle = 'Request Lagu';
  static const String requestWebViewUrl = 'https://www.upradio.id/request/';

  /// AzuraCast configuration
  static const String? azuracastBaseUrl = null;
  static const String? azuracastStationId = null;

  /// Album art max concurrent requests
  static const int albumArtMaxConcurrentRequests = 3;

  /// Debug settings
  static const bool enableDebugLogging = false;
  static const bool enableShoutboxDebugLogging = false;
}

enum RadioGameLevel {
  level1FrequencyWanderer,
  level2ActiveTuner,
  level3StudioCompanion,
  level4AirwaveCitizen,
  level5RadioStar,
  level6BroadcastLegend,
}

class RadioLevelDefinition {
  final RadioGameLevel level;
  final String displayName;
  final String description;
  final double minHours;
  final double? maxHours;
  final String assetPath;
  final String assetKey;

  const RadioLevelDefinition({
    required this.level,
    required this.displayName,
    required this.description,
    required this.minHours,
    required this.maxHours,
    required this.assetPath,
    required this.assetKey,
  });

  bool containsHours(double hours) {
    if (maxHours == null) {
      return hours >= minHours;
    }
    return hours >= minHours && hours < maxHours!;
  }
}

class RadioGameConfig {
  static const List<RadioLevelDefinition> levels = [
    RadioLevelDefinition(
      level: RadioGameLevel.level1FrequencyWanderer,
      displayName: 'Frequency Wanderer',
      description: 'Newcomer exploring different radio frequencies.',
      minHours: 0,
      maxHours: 10,
      assetPath:
          'assets/images/user_levels/ic_level_1_frequency_wanderer_placeholder.png',
      assetKey: 'ic_level_1_frequency_wanderer_placeholder',
    ),
    RadioLevelDefinition(
      level: RadioGameLevel.level2ActiveTuner,
      displayName: 'Active Tuner',
      description: 'Regular listener who tunes in often.',
      minHours: 10,
      maxHours: 30,
      assetPath:
          'assets/images/user_levels/ic_level_2_active_tuner_placeholder.png',
      assetKey: 'ic_level_2_active_tuner_placeholder',
    ),
    RadioLevelDefinition(
      level: RadioGameLevel.level3StudioCompanion,
      displayName: 'Studio Companion',
      description: 'Feels like a friend of the studio, emotionally connected.',
      minHours: 30,
      maxHours: 60,
      assetPath:
          'assets/images/user_levels/ic_level_3_studio_companion_placeholder.png',
      assetKey: 'ic_level_3_studio_companion_placeholder',
    ),
    RadioLevelDefinition(
      level: RadioGameLevel.level4AirwaveCitizen,
      displayName: 'Airwave Citizen',
      description: 'Feels like part of the radio world, a citizen of airwaves.',
      minHours: 60,
      maxHours: 120,
      assetPath:
          'assets/images/user_levels/ic_level_4_airwave_citizen_placeholder.png',
      assetKey: 'ic_level_4_airwave_citizen_placeholder',
    ),
    RadioLevelDefinition(
      level: RadioGameLevel.level5RadioStar,
      displayName: 'Radio Star',
      description: 'Highly engaged, standout community member.',
      minHours: 120,
      maxHours: 250,
      assetPath:
          'assets/images/user_levels/ic_level_5_radio_star_placeholder.png',
      assetKey: 'ic_level_5_radio_star_placeholder',
    ),
    RadioLevelDefinition(
      level: RadioGameLevel.level6BroadcastLegend,
      displayName: 'Broadcast Legend',
      description: 'Top-tier, iconic listener with huge presence.',
      minHours: 250,
      maxHours: null,
      assetPath:
          'assets/images/user_levels/ic_level_6_broadcast_legend_placeholder.png',
      assetKey: 'ic_level_6_broadcast_legend_placeholder',
    ),
  ];

  static RadioLevelDefinition resolveByHours(double hours) {
    final normalizedHours = hours < 0 ? 0.0 : hours;
    return levels.firstWhere((level) => level.containsHours(normalizedHours),
        orElse: () => levels.last);
  }

  static RadioLevelDefinition? nextLevel(RadioGameLevel level) {
    final index = levels.indexWhere((definition) => definition.level == level);
    if (index == -1 || index + 1 >= levels.length) {
      return null;
    }
    return levels[index + 1];
  }

  static double progressToNextLevel(double hours) {
    final definition = resolveByHours(hours);
    final clampedHours = hours.clamp(definition.minHours,
        definition.maxHours ?? double.maxFinite);
    if (definition.maxHours == null) {
      return 1;
    }
    final range = definition.maxHours! - definition.minHours;
    if (range == 0) {
      return 1;
    }
    return (clampedHours - definition.minHours) / range;
  }
}
