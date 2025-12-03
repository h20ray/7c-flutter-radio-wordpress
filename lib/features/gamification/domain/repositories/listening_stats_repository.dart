import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_listening_stats_entity.dart';

abstract class ListeningStatsRepository {
  Stream<Either<Failure, UserListeningStatsEntity>> watchStats();
  Future<Either<Failure, UserListeningStatsEntity>> addListeningDuration(
    Duration duration,
  );
  
  Future<Either<Failure, UserListeningStatsEntity>> switchToUser(String userId);
  Future<Either<Failure, UserListeningStatsEntity>> mergeGuestStatsToUser(
    String userId,
  );
  Future<Either<Failure, UserListeningStatsEntity>> flushToGuest();
  Future<Either<Failure, UserListeningStatsEntity>> syncWithServer(
    String userId,
    UserListeningStatsEntity serverStats,
  );
  String get currentUserId;
}

