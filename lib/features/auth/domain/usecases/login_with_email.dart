import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithEmail {
  final AuthRepository repository;

  const LoginWithEmail(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    bool rememberMe = false,
  }) {
    return repository.loginWithEmail(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );
  }
}

