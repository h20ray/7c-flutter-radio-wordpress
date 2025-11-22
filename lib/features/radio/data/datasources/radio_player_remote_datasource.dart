import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:radio_player/radio_player.dart';
import '../../../../config/radio_config.dart';
import '../../domain/entities/radio_entity.dart';
import '../../../../core/utils/debug_logger.dart';

/// Abstract interface for radio player data source
abstract class RadioPlayerRemoteDataSource {
  /// Initialize the radio player with configuration
  Future<void> initialize(RadioEntity config);

  /// Start radio playback
  Future<void> play();

  /// Pause radio playback
  Future<void> pause();

  /// Reset the radio player
  Future<void> reset();

  /// Set custom metadata
  Future<void> setCustomMetadata({
    required String artist,
    required String title,
    String? artworkUrl,
  });

  /// Update radio station configuration
  Future<void> updateStation({
    required String title,
    required String url,
    required bool parseStreamMetadata,
    required bool lookupOnlineArtwork,
    String? logoAssetPath,
    String? logoNetworkUrl,
  });

  /// Set navigation controls
  Future<void> setNavigationControls({
    required bool showNextButton,
    required bool showPreviousButton,
  });

  /// Set player volume 0.0–1.0 (best-effort; may be unsupported)
  Future<void> setVolume(double volume);

  /// Stream of playback state changes
  Stream<PlaybackState> get playbackStateStream;

  /// Stream of metadata updates
  Stream<Metadata> get metadataStream;

  /// Stream of remote command events
  Stream<RemoteCommand> get remoteCommandStream;
}

/// Implementation of radio player data source using radio_player package
class RadioPlayerRemoteDataSourceImpl implements RadioPlayerRemoteDataSource {
  StreamSubscription<PlaybackState>? _playbackStateSubscription;
  StreamSubscription<Metadata>? _metadataSubscription;
  StreamSubscription<RemoteCommand>? _remoteCommandSubscription;

  final StreamController<PlaybackState> _playbackStateController =
      StreamController<PlaybackState>.broadcast();
  final StreamController<Metadata> _metadataController =
      StreamController<Metadata>.broadcast();
  final StreamController<RemoteCommand> _remoteCommandController =
      StreamController<RemoteCommand>.broadcast();

  RadioPlayerRemoteDataSourceImpl() {
    _setupStreamListeners();
  }

  /// Set up stream listeners to the radio_player package
  void _setupStreamListeners() {
    _playbackStateSubscription = RadioPlayer.playbackStateStream.listen(
      (state) {
        _playbackStateController.add(state);
      },
      onError: (error) {
        DebugLogger.logError('Error in playback state stream', error: error, tag: 'RadioPlayerDataSource');
      },
    );

    _metadataSubscription = RadioPlayer.metadataStream.listen(
      (metadata) {
        _metadataController.add(metadata);
      },
      onError: (error) {
        DebugLogger.logError('Error in metadata stream', error: error, tag: 'RadioPlayerDataSource');
      },
    );

    _remoteCommandSubscription = RadioPlayer.remoteCommandStream.listen(
      (command) {
        _remoteCommandController.add(command);
      },
      onError: (error) {
        DebugLogger.logError('Error in remote command stream', error: error, tag: 'RadioPlayerDataSource');
      },
    );
  }

  @override
  Future<void> initialize(RadioEntity config) async {
    if (RadioConfig.enableVerboseLogging) {
      DebugLogger.log('[RadioPlayerDataSource] Initialize called - Stream URL: ${config.streamUrl}', tag: 'RadioPlayerDataSource');
      DebugLogger.log('[RadioPlayerDataSource] Album art source: ${config.albumArtSource}', tag: 'RadioPlayerDataSource');
    }

    await _handleRadioPlayerCall(() async {
      // Determine logo configuration based on album art source
      String? logoNetworkUrl;
      String? logoAssetPath;

      if (config.albumArtSource == 2) {
        // For AzuraCast, use fallback asset initially
        logoNetworkUrl = null;
        logoAssetPath = RadioConfig.fallbackArtworkPath;
      } else if (config.logoNetworkUrl.isNotEmpty) {
        // Use configured logo network URL
        logoNetworkUrl = config.logoNetworkUrl;
        logoAssetPath = null;
      } else {
        // Use fallback asset
        logoNetworkUrl = null;
        logoAssetPath = RadioConfig.fallbackArtworkPath;
      }

      if (RadioConfig.enableVerboseLogging) {
        DebugLogger.log('[RadioPlayerDataSource] Setting station with URL: ${config.streamUrl}', tag: 'RadioPlayerDataSource');
      }
      await RadioPlayer.setStation(
        title: 'radio_station_name'.tr(),
        url: config.streamUrl,
        parseStreamMetadata: config.showAlbumCover,
        lookupOnlineArtwork: config.albumArtSource == 3,
        logoAssetPath: logoAssetPath,
        logoNetworkUrl: logoNetworkUrl,
      );

      if (RadioConfig.enableVerboseLogging) {
        DebugLogger.log('[RadioPlayerDataSource] Setting navigation controls', tag: 'RadioPlayerDataSource');
      }
      await RadioPlayer.setNavigationControls(
        showNextButton: RadioConfig.showNextButton,
        showPreviousButton: RadioConfig.showPreviousButton,
      );

      if (RadioConfig.enableVerboseLogging) {
        DebugLogger.log('[RadioPlayerDataSource] Station setup completed', tag: 'RadioPlayerDataSource');
      }
    });
  }

  @override
  Future<void> play() async {
    await _handleRadioPlayerCall(() => RadioPlayer.play());
  }

  @override
  Future<void> pause() async {
    await _handleRadioPlayerCall(() => RadioPlayer.pause());
  }

  @override
  Future<void> reset() async {
    await _handleRadioPlayerCall(() => RadioPlayer.reset());
  }

  @override
  Future<void> setCustomMetadata({
    required String artist,
    required String title,
    String? artworkUrl,
  }) async {
    await _handleRadioPlayerCall(
      () => RadioPlayer.setCustomMetadata(
        artist: artist,
        title: title,
        artworkUrl: artworkUrl,
      ),
    );
  }

  @override
  Future<void> updateStation({
    required String title,
    required String url,
    required bool parseStreamMetadata,
    required bool lookupOnlineArtwork,
    String? logoAssetPath,
    String? logoNetworkUrl,
  }) async {
    await _handleRadioPlayerCall(
      () => RadioPlayer.setStation(
        title: title,
        url: url,
        parseStreamMetadata: parseStreamMetadata,
        lookupOnlineArtwork: lookupOnlineArtwork,
        logoAssetPath: logoAssetPath,
        logoNetworkUrl: logoNetworkUrl,
      ),
    );
  }

  @override
  Future<void> setNavigationControls({
    required bool showNextButton,
    required bool showPreviousButton,
  }) async {
    await _handleRadioPlayerCall(
      () => RadioPlayer.setNavigationControls(
        showNextButton: showNextButton,
        showPreviousButton: showPreviousButton,
      ),
    );
  }

  @override
  Future<void> setVolume(double volume) async {
    // Best-effort: not all versions expose setVolume; wrap in try/catch
    try {
      const MethodChannel channel = MethodChannel('radio_player');
      await channel.invokeMethod('setVolume', {
        'volume': volume.clamp(0.0, 1.0),
      });
    } on MissingPluginException {
      // Silently ignore on unsupported platforms
      DebugLogger.log('[RadioPlayerDataSource] setVolume not available on this platform', tag: 'RadioPlayerDataSource');
    } catch (e) {
      DebugLogger.logError('Error setting volume', error: e, tag: 'RadioPlayerDataSource');
    }
  }

  @override
  Stream<PlaybackState> get playbackStateStream =>
      _playbackStateController.stream;

  @override
  Stream<Metadata> get metadataStream => _metadataController.stream;

  @override
  Stream<RemoteCommand> get remoteCommandStream =>
      _remoteCommandController.stream;

  /// Helper method to handle MissingPluginException gracefully
  Future<T?> _handleRadioPlayerCall<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on MissingPluginException catch (e) {
      // Plugin not available - this is expected on some platforms
      DebugLogger.log('[RadioPlayerDataSource] MissingPluginException: ${e.toString()}', tag: 'RadioPlayerDataSource');
      throw Exception('Radio player plugin not available: ${e.toString()}');
    } catch (e) {
      // Re-throw other errors
      DebugLogger.logError('Error in radio player call', error: e, tag: 'RadioPlayerDataSource');
      rethrow;
    }
  }

  /// Dispose resources
  void dispose() {
    _playbackStateSubscription?.cancel();
    _metadataSubscription?.cancel();
    _remoteCommandSubscription?.cancel();
    _playbackStateController.close();
    _metadataController.close();
    _remoteCommandController.close();
  }
}

