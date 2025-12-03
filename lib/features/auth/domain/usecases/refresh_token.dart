import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_token_entity.dart';
import '../repositories/auth_repository.dart';

class RefreshToken {
  final AuthRepository repository;

  const RefreshToken(this.repository);

  Future<Either<Failure, AuthTokenEntity>> call({
    required String refreshToken,
  }) {
    return repository.refreshToken(refreshToken: refreshToken);
  }
}

