import 'package:equatable/equatable.dart';

/// Domain entity representing the current state of the radio player
class RadioPlayerEntity extends Equatable {
  final bool isInitialized;
  final bool isPlaying;
  final String? currentUrl;
  final String? currentArtist;
  final String? currentTitle;
  final String? currentAlbumArtUrl;
  final String? errorMessage;

  // radioCoreV2 enhanced fields
  final int retryAttempt;
  final int currentBackupUrlIndex;
  final DateTime? lastErrorTimestamp;
  final int? connectionTimeMs;
  final int? resumeTimeMs;
  final bool isConnecting;
  final bool isBuffering;
  final bool isRetrying;

  const RadioPlayerEntity({
    required this.isInitialized,
    required this.isPlaying,
    this.currentUrl,
    this.currentArtist,
    this.currentTitle,
    this.currentAlbumArtUrl,
    this.errorMessage,
    this.retryAttempt = 0,
    this.currentBackupUrlIndex = 0,
    this.lastErrorTimestamp,
    this.connectionTimeMs,
    this.resumeTimeMs,
    this.isConnecting = false,
    this.isBuffering = false,
    this.isRetrying = false,
  });

  /// Create initial state
  const RadioPlayerEntity.initial()
      : isInitialized = false,
        isPlaying = false,
        currentUrl = null,
        currentArtist = null,
        currentTitle = null,
        currentAlbumArtUrl = null,
        errorMessage = null,
        retryAttempt = 0,
        currentBackupUrlIndex = 0,
        lastErrorTimestamp = null,
        connectionTimeMs = null,
        resumeTimeMs = null,
        isConnecting = false,
        isBuffering = false,
        isRetrying = false;

  /// Create a copy with updated values
  RadioPlayerEntity copyWith({
    bool? isInitialized,
    bool? isPlaying,
    String? currentUrl,
    String? currentArtist,
    String? currentTitle,
    String? currentAlbumArtUrl,
    String? errorMessage,
    int? retryAttempt,
    int? currentBackupUrlIndex,
    DateTime? lastErrorTimestamp,
    int? connectionTimeMs,
    int? resumeTimeMs,
    bool? isConnecting,
    bool? isBuffering,
    bool? isRetrying,
  }) {
    return RadioPlayerEntity(
      isInitialized: isInitialized ?? this.isInitialized,
      isPlaying: isPlaying ?? this.isPlaying,
      currentUrl: currentUrl ?? this.currentUrl,
      currentArtist: currentArtist ?? this.currentArtist,
      currentTitle: currentTitle ?? this.currentTitle,
      currentAlbumArtUrl: currentAlbumArtUrl ?? this.currentAlbumArtUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      retryAttempt: retryAttempt ?? this.retryAttempt,
      currentBackupUrlIndex:
          currentBackupUrlIndex ?? this.currentBackupUrlIndex,
      lastErrorTimestamp: lastErrorTimestamp ?? this.lastErrorTimestamp,
      connectionTimeMs: connectionTimeMs ?? this.connectionTimeMs,
      resumeTimeMs: resumeTimeMs ?? this.resumeTimeMs,
      isConnecting: isConnecting ?? this.isConnecting,
      isBuffering: isBuffering ?? this.isBuffering,
      isRetrying: isRetrying ?? this.isRetrying,
    );
  }

  /// Check if player is ready for operations
  bool get isReady =>
      isInitialized && errorMessage == null && !isConnecting && !isBuffering;

  /// Check if player has current track metadata
  bool get hasMetadata => currentArtist != null || currentTitle != null;

  /// Check if player has album art
  bool get hasAlbumArt =>
      currentAlbumArtUrl != null && currentAlbumArtUrl!.isNotEmpty;

  /// Check if player is in a transitional state
  bool get isTransitioning => isConnecting || isBuffering || isRetrying;

  @override
  List<Object?> get props => [
        isInitialized,
        isPlaying,
        currentUrl,
        currentArtist,
        currentTitle,
        currentAlbumArtUrl,
        errorMessage,
        retryAttempt,
        currentBackupUrlIndex,
        lastErrorTimestamp,
        connectionTimeMs,
        resumeTimeMs,
        isConnecting,
        isBuffering,
        isRetrying,
      ];
}

