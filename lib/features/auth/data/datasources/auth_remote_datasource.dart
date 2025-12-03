import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokenModel> loginWithEmail({
    required String email,
    required String password,
  });

  Future<AuthTokenModel> loginWithGoogle({
    required String idToken,
    required String accessToken,
  });

  Future<AuthTokenModel> refreshToken({
    required String refreshToken,
  });

  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthTokenModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        '/wp-json/jwt-auth/v1/token',
        data: {
          'username': email,
          'password': password,
        },
      );

      if (response.data == null) {
        throw const ServerException('Empty response from server');
      }

      final data = response.data;
      
      if (data == null || data is! Map<String, dynamic>) {
        throw const ServerException('Invalid response format from server');
      }
      
      if (data.containsKey('code') && data['code'] != null) {
        final code = data['code'] as String;
        if (code != 'jwt_auth_valid_token' && code != 'jwt_auth_valid_credential') {
          final errorMessage = data['message'] as String? ?? 'Authentication failed';
          throw InvalidCredentialsException(errorMessage);
        }
      }
      
      if (data['token'] == null && data['access_token'] == null) {
        final errorMessage = data['message'] as String? ?? 'Invalid credentials';
        throw InvalidCredentialsException(errorMessage);
      }

      return AuthTokenModel.fromJson(data);
    } on InvalidCredentialsException {
      rethrow;
    } on AccountLockedException {
      rethrow;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      if (e.toString().contains('403') || e.toString().contains('Forbidden')) {
        throw const AccountLockedException();
      }
      if (e.toString().contains('401') || e.toString().contains('Unauthorized')) {
        throw const InvalidCredentialsException();
      }
      throw ServerException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<AuthTokenModel> loginWithGoogle({
    required String idToken,
    required String accessToken,
  }) async {
    try {
      final response = await apiClient.post(
        '/wp-json/tujuhcahaya/v1/auth/google',
        data: {
          'id_token': idToken,
          'access_token': accessToken,
        },
      );

      final data = response.data as Map<String, dynamic>;
      
      if (data['token'] == null && data['access_token'] == null) {
        throw const InvalidCredentialsException('Failed to authenticate with Google');
      }

      return AuthTokenModel.fromJson(data);
    } catch (e) {
      if (e is InvalidCredentialsException || e is AccountLockedException) {
        rethrow;
      }
      if (e.toString().contains('403') || e.toString().contains('Forbidden')) {
        throw const AccountLockedException();
      }
      rethrow;
    }
  }

  @override
  Future<AuthTokenModel> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final response = await apiClient.post(
        '/wp-json/tujuhcahaya/v1/auth/refresh',
        data: {
          'refresh_token': refreshToken,
        },
      );

      final data = response.data as Map<String, dynamic>;
      
      if (data['token'] == null && data['access_token'] == null) {
        throw const TokenExpiredException();
      }

      return AuthTokenModel.fromJson(data);
    } catch (e) {
      if (e is TokenExpiredException) {
        rethrow;
      }
      if (e.toString().contains('401') || e.toString().contains('Unauthorized')) {
        throw const TokenExpiredException();
      }
      rethrow;
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.get('/wp-json/wp/v2/users/me');
      
      if (response.data == null) {
        throw const ServerException('Empty response from server');
      }
      
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const ServerException('Invalid response format from server');
      }
      
      return UserModel.fromJson(data);
    } on TokenExpiredException {
      rethrow;
    } on InvalidCredentialsException {
      rethrow;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      if (e.toString().contains('401') || e.toString().contains('Unauthorized')) {
        throw const TokenExpiredException();
      }
      throw ServerException('Failed to get current user: ${e.toString()}');
    }
  }
}

