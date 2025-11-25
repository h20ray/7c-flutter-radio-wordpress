import 'package:equatable/equatable.dart';

class UserListeningStatsEntity extends Equatable {
  final String userId;
  final int totalListeningSeconds;
  final String currentLevel;
  final DateTime lastUpdatedAt;

  const UserListeningStatsEntity({
    required this.userId,
    required this.totalListeningSeconds,
    required this.currentLevel,
    required this.lastUpdatedAt,
  });

  double get totalListeningHours => totalListeningSeconds / 3600;

  @override
  List<Object?> get props => [
        userId,
        totalListeningSeconds,
        currentLevel,
        lastUpdatedAt,
      ];
}

