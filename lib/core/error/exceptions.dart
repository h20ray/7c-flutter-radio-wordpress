abstract class AppException implements Exception {
  final String message;

  const AppException([this.message = 'An error occurred']);

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error']);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Cache error']);
}

class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Connection timeout']);
}

