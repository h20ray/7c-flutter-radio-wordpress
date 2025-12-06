import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/offline_news_settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';
import '../models/offline_news_settings_model.dart';
import '../../../wordpress/data/services/offline_news_service.dart';
import '../../../wordpress/data/datasources/wordpress_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;
  final OfflineNewsService offlineNewsService;
  final WordPressLocalDataSource wordPressLocalDataSource;

  SettingsRepositoryImpl({
    required this.localDataSource,
    required this.offlineNewsService,
    required this.wordPressLocalDataSource,
  });

  @override
  Future<Either<Failure, OfflineNewsSettingsEntity>> getOfflineNewsSettings() async {
    try {
      final settings = await localDataSource.getOfflineNewsSettings();
      return Right(settings);
    } catch (e) {
      return Left(CacheFailure('Failed to get offline news settings: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveOfflineNewsSettings(OfflineNewsSettingsEntity settings) async {
    try {
      final settingsModel = OfflineNewsSettingsModel(
        maxPosts: settings.maxPosts,
        maxSizeMB: settings.maxSizeMB,
        autoSaveEnabled: settings.autoSaveEnabled,
      );
      
      await localDataSource.saveOfflineNewsSettings(settingsModel);
      
      offlineNewsService.updateLimits(
        maxPosts: settings.maxPosts,
        maxSizeMB: settings.maxSizeMB,
      );
      
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Failed to save offline news settings: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, OfflineNewsStats>> getOfflineNewsStats() async {
    try {
      final settings = await localDataSource.getOfflineNewsSettings();
      
      // Count explicitly saved posts (from offline_news_box)
      final explicitPostCount = await offlineNewsService.getOfflinePostCount();
      final explicitSizeBytes = await offlineNewsService.getEstimatedSizeMB() * 1024 * 1024;
      
      // Count cached posts (from wordpress_posts_box) - automatically available offline
      final cachedPostCount = await wordPressLocalDataSource.getCachedPostsCount();
      final cachedSizeBytes = await wordPressLocalDataSource.getCachedPostsSizeBytes();
      
      // Total = explicitly saved + cached (but avoid double counting)
      // Since cached posts are automatically available, we count both separately
      // But for stats display, we show total available offline posts
      final totalPostCount = explicitPostCount + cachedPostCount;
      final totalSizeBytes = explicitSizeBytes + cachedSizeBytes;
      final totalSizeMB = totalSizeBytes ~/ (1024 * 1024);
      
      return Right(OfflineNewsStats(
        currentPostCount: totalPostCount,
        currentSizeMB: totalSizeMB,
        maxPosts: settings.maxPosts,
        maxSizeMB: settings.maxSizeMB,
      ));
    } catch (e) {
      return Left(CacheFailure('Failed to get offline news stats: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearAllOfflinePosts() async {
    try {
      await offlineNewsService.clearAll();
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Failed to clear offline posts: ${e.toString()}'));
    }
  }
}

