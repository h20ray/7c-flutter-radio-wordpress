import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_listening_stats_entity.dart';
import '../repositories/listening_stats_repository.dart';

class FlushListeningStatsToGuest {
  final ListeningStatsRepository repository;

  const FlushListeningStatsToGuest(this.repository);

  Future<Either<Failure, UserListeningStatsEntity>> call() {
    return repository.flushToGuest();
  }
}

