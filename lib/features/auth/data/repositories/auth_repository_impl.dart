import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_token_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> loginWithEmail({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final token = await remoteDataSource.loginWithEmail(
        email: email,
        password: password,
      );
      
      await localDataSource.saveToken(token);
      
      if (rememberMe) {
        await localDataSource.saveCredentials(email, password);
      } else {
        await localDataSource.deleteCredentials();
      }
      
      final user = await remoteDataSource.getCurrentUser();
      await localDataSource.saveUser(user);
      
      return Right(user);
    } on InvalidCredentialsException {
      return const Left(InvalidCredentialsFailure());
    } on AccountLockedException {
      return const Left(AccountLockedFailure());
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle({
    required String idToken,
    required String accessToken,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final token = await remoteDataSource.loginWithGoogle(
        idToken: idToken,
        accessToken: accessToken,
      );
      
      await localDataSource.saveToken(token);
      
      final user = await remoteDataSource.getCurrentUser();
      await localDataSource.saveUser(user);
      
      return Right(user);
    } on InvalidCredentialsException {
      return const Left(InvalidCredentialsFailure());
    } on AccountLockedException {
      return const Left(AccountLockedFailure());
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.deleteToken();
      await localDataSource.deleteUser();
      await localDataSource.deleteCredentials();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, UserEntity>> autoLogin() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final credentials = await localDataSource.getCredentials();
      
      if (credentials == null) {
        return const Left(InvalidCredentialsFailure('No saved credentials'));
      }

      return await loginWithEmail(
        email: credentials['email']!,
        password: credentials['password']!,
        rememberMe: true,
      );
    } on InvalidCredentialsException {
      await localDataSource.deleteCredentials();
      return const Left(InvalidCredentialsFailure());
    } on AccountLockedException {
      return const Left(AccountLockedFailure());
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthTokenEntity>> refreshToken({
    required String refreshToken,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final token = await remoteDataSource.refreshToken(
        refreshToken: refreshToken,
      );
      
      await localDataSource.saveToken(token);
      
      return Right(token);
    } on TokenExpiredException {
      await localDataSource.deleteToken();
      await localDataSource.deleteUser();
      return const Left(TokenExpiredFailure());
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getUser();
      if (cachedUser != null && await networkInfo.isConnected) {
        try {
          final remoteUser = await remoteDataSource.getCurrentUser();
          await localDataSource.saveUser(remoteUser);
          return Right(remoteUser);
        } catch (e) {
          return Right(cachedUser);
        }
      }
      
      if (cachedUser != null) {
        return Right(cachedUser);
      }

      if (await networkInfo.isConnected) {
        final user = await remoteDataSource.getCurrentUser();
        await localDataSource.saveUser(user);
        return Right(user);
      }

      return const Left(NetworkFailure('No internet connection and no cached user'));
    } on TokenExpiredException {
      await localDataSource.deleteToken();
      await localDataSource.deleteUser();
      return const Left(TokenExpiredFailure());
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkAuthStatus() async {
    try {
      final token = await localDataSource.getToken();
      
      if (token == null) {
        final credentials = await localDataSource.getCredentials();
        if (credentials != null) {
          final autoLoginResult = await autoLogin();
          return autoLoginResult.fold(
            (failure) => const Right(false),
            (_) => const Right(true),
          );
        }
        return const Right(false);
      }

      if (token.isExpired) {
        if (token.refreshToken != null) {
          final refreshResult = await refreshToken(
            refreshToken: token.refreshToken!,
          );
          
          final refreshSuccess = refreshResult.fold(
            (failure) => false,
            (_) => true,
          );
          
          if (refreshSuccess) {
            return const Right(true);
          }
        }
        
        final credentials = await localDataSource.getCredentials();
        if (credentials != null) {
          final autoLoginResult = await autoLogin();
          final autoLoginSuccess = autoLoginResult.fold(
            (failure) => false,
            (_) => true,
          );
          
          if (autoLoginSuccess) {
            return const Right(true);
          }
          
          await localDataSource.deleteToken();
          await localDataSource.deleteUser();
          return const Right(false);
        }
        
        await localDataSource.deleteToken();
        await localDataSource.deleteUser();
        return const Right(false);
      }

      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthTokenEntity?>> getStoredToken() async {
    try {
      final token = await localDataSource.getToken();
      return Right(token);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}

