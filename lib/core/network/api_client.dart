import 'package:dio/dio.dart';
import '../error/exceptions.dart';
import '../../config/app_config.dart';

class ApiClient {
  final Dio dio;
  Function()? _onTokenExpired;

  ApiClient(this.dio) {
    dio.options.baseUrl = 'https://${AppConfig.url}';
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  void setAuthTokenGetter(Future<String?> Function() getToken) {
    dio.interceptors.removeWhere((interceptor) => interceptor is AuthInterceptor);
    dio.interceptors.add(AuthInterceptor(getToken, _onTokenExpired));
  }

  void setOnTokenExpired(Function() callback) {
    _onTokenExpired = callback;
    final existingInterceptor = dio.interceptors
        .whereType<AuthInterceptor>()
        .firstOrNull;
    if (existingInterceptor != null) {
      existingInterceptor.onTokenExpired = callback;
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.delete(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  AppException _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const TimeoutException('Connection timeout');
    } else if (error.type == DioExceptionType.connectionError) {
      return const NetworkException('No internet connection');
    } else if (error.response != null) {
      final statusCode = error.response?.statusCode;
      final responseData = error.response?.data;
      
      if (statusCode == 401) {
        final errorMessage = _extractErrorMessage(responseData) ?? 'Unauthorized';
        return InvalidCredentialsException(errorMessage);
      } else if (statusCode == 403) {
        return const AccountLockedException();
      } else {
        final errorMessage = _extractErrorMessage(responseData) ?? 'Server error: $statusCode';
        return ServerException(errorMessage);
      }
    } else {
      return NetworkException(error.message ?? 'Network error occurred');
    }
  }

  String? _extractErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData['message'] as String? ?? 
             responseData['error'] as String? ??
             responseData['data']?['message'] as String?;
    } else if (responseData is String) {
      try {
        if (responseData.contains('message')) {
          final match = RegExp(r'"message"\s*:\s*"([^"]+)"').firstMatch(responseData);
          if (match != null) {
            return match.group(1);
          }
        }
      } catch (e) {
        // Ignore parsing errors
      }
    }
    return null;
  }
}

class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getToken;
  Function()? onTokenExpired;

  AuthInterceptor(this.getToken, this.onTokenExpired);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      // Ignore token errors, proceed without auth
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      onTokenExpired?.call();
    }
    handler.next(err);
  }
}

