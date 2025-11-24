import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_listening_stats_entity.dart';
import '../repositories/listening_stats_repository.dart';

class WatchListeningStats {
  final ListeningStatsRepository repository;

  const WatchListeningStats(this.repository);

  Stream<Either<Failure, UserListeningStatsEntity>> call() {
    return repository.watchStats();
  }
}

