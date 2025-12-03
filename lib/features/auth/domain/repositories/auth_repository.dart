import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_token_entity.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithEmail({
    required String email,
    required String password,
    bool rememberMe = false,
  });
  
  Future<Either<Failure, UserEntity>> autoLogin();

  Future<Either<Failure, UserEntity>> loginWithGoogle({
    required String idToken,
    required String accessToken,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, AuthTokenEntity>> refreshToken({
    required String refreshToken,
  });

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, bool>> checkAuthStatus();

  Future<Either<Failure, AuthTokenEntity?>> getStoredToken();
}

