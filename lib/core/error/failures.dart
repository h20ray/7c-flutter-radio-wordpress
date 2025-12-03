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

