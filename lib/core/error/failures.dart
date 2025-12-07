import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation failed']);
}

class StreamFailure extends Failure {
  const StreamFailure([super.message = 'Stream connection failed']);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Connection timeout']);
}

class ConfigurationFailure extends Failure {
  const ConfigurationFailure([super.message = 'Invalid configuration']);
}

class OfflineFailure extends Failure {
  const OfflineFailure([super.message = 'Operation failed - device is offline']);
}

class UnsupportedFailure extends Failure {
  const UnsupportedFailure([super.message = 'Operation is not supported']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unknown error occurred']);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure([super.message = 'Invalid email or password']);
}

class AccountLockedFailure extends Failure {
  const AccountLockedFailure([super.message = 'Account is locked or suspended']);
}

class TokenExpiredFailure extends Failure {
  const TokenExpiredFailure([super.message = 'Authentication token has expired']);
}

// Radio-specific failures

/// Failure when the radio stream is unavailable or offline
class StreamUnavailableFailure extends Failure {
  const StreamUnavailableFailure([super.message = 'Radio stream is currently unavailable']);
}

/// Failure when the audio codec is not supported by the device
class CodecUnsupportedFailure extends Failure {
  const CodecUnsupportedFailure([super.message = 'Audio format is not supported on this device']);
}

/// Failure when content is restricted by geographic location
class GeoRestrictionFailure extends Failure {
  const GeoRestrictionFailure([super.message = 'This content is not available in your region']);
}

/// Failure when all stream URLs and retry attempts have been exhausted
class AllStreamsExhaustedFailure extends Failure {
  final int totalUrls;
  final int totalAttempts;

  const AllStreamsExhaustedFailure([
    super.message = 'Unable to connect to radio stream after multiple attempts',
    this.totalUrls = 1,
    this.totalAttempts = 4,
  ]);

  @override
  List<Object> get props => [message, totalUrls, totalAttempts];
}

/// Failure when album art cannot be fetched or found
class AlbumArtNotFoundFailure extends Failure {
  const AlbumArtNotFoundFailure([super.message = 'Album artwork not available']);
}

/// Failure when stream metadata cannot be parsed
class MetadataParseFailure extends Failure {
  const MetadataParseFailure([super.message = 'Unable to read track information']);
}

/// Failure when playback was interrupted (e.g., by another app)
class PlaybackInterruptedFailure extends Failure {
  const PlaybackInterruptedFailure([super.message = 'Playback was interrupted']);
}

/// Failure when audio focus cannot be obtained
class AudioFocusFailure extends Failure {
  const AudioFocusFailure([super.message = 'Cannot play audio while another app is using audio']);
}
