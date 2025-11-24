import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_listening_stats_entity.dart';
import '../repositories/listening_stats_repository.dart';

class RecordListeningSession {
  final ListeningStatsRepository repository;

  const RecordListeningSession(this.repository);

  Future<Either<Failure, UserListeningStatsEntity>> call(
    Duration duration,
  ) {
    return repository.addListeningDuration(duration);
  }
}

