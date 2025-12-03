import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_listening_stats_entity.dart';
import '../repositories/listening_stats_repository.dart';

class SwitchListeningStatsUser {
  final ListeningStatsRepository repository;

  const SwitchListeningStatsUser(this.repository);

  Future<Either<Failure, UserListeningStatsEntity>> call(String userId) {
    return repository.switchToUser(userId);
  }
}

