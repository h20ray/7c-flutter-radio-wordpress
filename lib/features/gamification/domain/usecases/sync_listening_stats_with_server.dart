import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_listening_stats_entity.dart';
import '../repositories/listening_stats_repository.dart';

class SyncListeningStatsWithServer {
  final ListeningStatsRepository repository;

  const SyncListeningStatsWithServer(this.repository);

  Future<Either<Failure, UserListeningStatsEntity>> call({
    required String userId,
    required UserListeningStatsEntity serverStats,
  }) {
    return repository.syncWithServer(userId, serverStats);
  }
}

