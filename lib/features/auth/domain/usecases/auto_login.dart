import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class AutoLogin {
  final AuthRepository repository;

  const AutoLogin(this.repository);

  Future<Either<Failure, UserEntity>> call() {
    return repository.autoLogin();
  }
}

