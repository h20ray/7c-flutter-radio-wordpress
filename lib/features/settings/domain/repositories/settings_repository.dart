import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/offline_news_settings_entity.dart';

abstract class SettingsRepository {
  Future<Either<Failure, OfflineNewsSettingsEntity>> getOfflineNewsSettings();
  Future<Either<Failure, Unit>> saveOfflineNewsSettings(OfflineNewsSettingsEntity settings);
  Future<Either<Failure, OfflineNewsStats>> getOfflineNewsStats();
  Future<Either<Failure, Unit>> clearAllOfflinePosts();
}

class OfflineNewsStats {
  final int currentPostCount;
  final int currentSizeMB;
  final int maxPosts;
  final int maxSizeMB;

  const OfflineNewsStats({
    required this.currentPostCount,
    required this.currentSizeMB,
    required this.maxPosts,
    required this.maxSizeMB,
  });

  double get postsUsagePercent => maxPosts > 0 ? (currentPostCount / maxPosts) * 100 : 0;
  double get sizeUsagePercent => maxSizeMB > 0 ? (currentSizeMB / maxSizeMB) * 100 : 0;
  bool get isPostsLimitReached => currentPostCount >= maxPosts;
  bool get isSizeLimitReached => currentSizeMB >= maxSizeMB;
}

