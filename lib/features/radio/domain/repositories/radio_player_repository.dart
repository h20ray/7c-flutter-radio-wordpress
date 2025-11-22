import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/radio_entity.dart';
import '../entities/radio_player_entity.dart';

/// Repository interface for radio player operations
/// Abstracts the radio player implementation from the domain layer
abstract class RadioPlayerRepository {
  /// Initialize the radio player with the given configuration
  Future<Either<Failure, Unit>> initialize(RadioEntity config);

  /// Start radio playback
  Future<Either<Failure, Unit>> play();

  /// Pause radio playback
  Future<Either<Failure, Unit>> pause();

  /// Reset the radio player to initial state
  Future<Either<Failure, Unit>> reset();

  /// Get album art URL for the given artist and title
  Future<Either<Failure, String>> getAlbumArt(
    String artist,
    String title,
    RadioEntity config,
  );

  /// Watch for changes in radio player state
  /// Returns a stream of RadioPlayerEntity updates
  Stream<RadioPlayerEntity> watchPlayerState();

  /// Set custom metadata for the radio player
  Future<Either<Failure, Unit>> setCustomMetadata({
    required String artist,
    required String title,
    String? artworkUrl,
  });

  /// Update the radio station configuration
  Future<Either<Failure, Unit>> updateStation({
    required String title,
    required String url,
    required bool parseStreamMetadata,
    required bool lookupOnlineArtwork,
    String? logoAssetPath,
    String? logoNetworkUrl,
  });

  /// Set navigation controls for the radio player
  Future<Either<Failure, Unit>> setNavigationControls({
    required bool showNextButton,
    required bool showPreviousButton,
  });

  /// Set player volume 0.0–1.0 (best-effort; may no-op on unsupported platforms)
  Future<Either<Failure, Unit>> setVolume(double volume);
}

