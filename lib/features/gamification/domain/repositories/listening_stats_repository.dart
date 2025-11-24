import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_listening_stats_entity.dart';

abstract class ListeningStatsRepository {
  Stream<Either<Failure, UserListeningStatsEntity>> watchStats();
  Future<Either<Failure, UserListeningStatsEntity>> addListeningDuration(
    Duration duration,
  );
}

