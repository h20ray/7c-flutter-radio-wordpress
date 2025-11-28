import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';
import '../datasources/config_remote_datasource.dart';
import '../datasources/category_local_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource categoryRemoteDataSource;
  final ConfigRemoteDataSource configRemoteDataSource;
  final CategoryLocalDataSource categoryLocalDataSource;

  CategoryRepositoryImpl({
    required this.categoryRemoteDataSource,
    required this.configRemoteDataSource,
    required this.categoryLocalDataSource,
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAvailableCategories() async {
    final cachedCategories = await categoryLocalDataSource.getCachedCategories();
    final cachedBlockedIds = await categoryLocalDataSource.getCachedBlockedCategories();
    
    if (cachedCategories != null && cachedCategories.isNotEmpty && cachedBlockedIds != null) {
      _fetchAndUpdateAvailableCategoriesInBackground();
      final availableCategories = cachedCategories
          .where((category) => !cachedBlockedIds.contains(category.id))
          .toList();
      return Right(availableCategories);
    }

    try {
      final allCategories = await categoryRemoteDataSource.getCategories();
      final blockedCategoryIds = await configRemoteDataSource.getBlockedCategories();
      
      await categoryLocalDataSource.cacheCategories(allCategories);
      await categoryLocalDataSource.cacheBlockedCategories(blockedCategoryIds);
      
      final availableCategories = allCategories
          .where((category) => !blockedCategoryIds.contains(category.id))
          .toList();
      
      return Right(availableCategories);
    } on ServerException catch (e) {
      if (cachedCategories != null && cachedCategories.isNotEmpty && cachedBlockedIds != null) {
        final availableCategories = cachedCategories
            .where((category) => !cachedBlockedIds.contains(category.id))
            .toList();
        return Right(availableCategories);
      }
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      if (cachedCategories != null && cachedCategories.isNotEmpty && cachedBlockedIds != null) {
        final availableCategories = cachedCategories
            .where((category) => !cachedBlockedIds.contains(category.id))
            .toList();
        return Right(availableCategories);
      }
      return Left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      if (cachedCategories != null && cachedCategories.isNotEmpty && cachedBlockedIds != null) {
        final availableCategories = cachedCategories
            .where((category) => !cachedBlockedIds.contains(category.id))
            .toList();
        return Right(availableCategories);
      }
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      if (cachedCategories != null && cachedCategories.isNotEmpty && cachedBlockedIds != null) {
        final availableCategories = cachedCategories
            .where((category) => !cachedBlockedIds.contains(category.id))
            .toList();
        return Right(availableCategories);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  void _fetchAndUpdateAvailableCategoriesInBackground() async {
    try {
      final allCategories = await categoryRemoteDataSource.getCategories();
      final blockedCategoryIds = await configRemoteDataSource.getBlockedCategories();
      await categoryLocalDataSource.cacheCategories(allCategories);
      await categoryLocalDataSource.cacheBlockedCategories(blockedCategoryIds);
    } catch (e, stackTrace) {
      DebugLogger.logError(
        'Background refresh for available categories failed',
        error: e,
        stackTrace: stackTrace,
        tag: 'CategoryRepository',
      );
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getFilterChipCategories() async {
    final cachedCategories = await categoryLocalDataSource.getCachedCategories();
    final cachedHomeTopTabIds = await categoryLocalDataSource.getCachedHomeTopTabCategories();
    final cachedBlockedIds = await categoryLocalDataSource.getCachedBlockedCategories();
    
    if (cachedCategories != null && cachedCategories.isNotEmpty && 
        cachedHomeTopTabIds != null && cachedBlockedIds != null) {
      _fetchAndUpdateFilterChipCategoriesInBackground();
      final filterChipCategories = cachedCategories
          .where((category) => 
              cachedHomeTopTabIds.contains(category.id) &&
              !cachedBlockedIds.contains(category.id))
          .toList();
      return Right(filterChipCategories);
    }

    try {
      final allCategories = await categoryRemoteDataSource.getCategories();
      final homeTopTabCategoryIds = await configRemoteDataSource.getHomeTopTabCategories();
      final blockedCategoryIds = await configRemoteDataSource.getBlockedCategories();
      
      await categoryLocalDataSource.cacheCategories(allCategories);
      await categoryLocalDataSource.cacheHomeTopTabCategories(homeTopTabCategoryIds);
      await categoryLocalDataSource.cacheBlockedCategories(blockedCategoryIds);
      
      final filterChipCategories = allCategories
          .where((category) => 
              homeTopTabCategoryIds.contains(category.id) &&
              !blockedCategoryIds.contains(category.id))
          .toList();
      
      return Right(filterChipCategories);
    } on ServerException catch (e) {
      if (cachedCategories != null && cachedCategories.isNotEmpty && 
          cachedHomeTopTabIds != null && cachedBlockedIds != null) {
        final filterChipCategories = cachedCategories
            .where((category) => 
                cachedHomeTopTabIds.contains(category.id) &&
                !cachedBlockedIds.contains(category.id))
            .toList();
        return Right(filterChipCategories);
      }
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      if (cachedCategories != null && cachedCategories.isNotEmpty && 
          cachedHomeTopTabIds != null && cachedBlockedIds != null) {
        final filterChipCategories = cachedCategories
            .where((category) => 
                cachedHomeTopTabIds.contains(category.id) &&
                !cachedBlockedIds.contains(category.id))
            .toList();
        return Right(filterChipCategories);
      }
      return Left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      if (cachedCategories != null && cachedCategories.isNotEmpty && 
          cachedHomeTopTabIds != null && cachedBlockedIds != null) {
        final filterChipCategories = cachedCategories
            .where((category) => 
                cachedHomeTopTabIds.contains(category.id) &&
                !cachedBlockedIds.contains(category.id))
            .toList();
        return Right(filterChipCategories);
      }
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      if (cachedCategories != null && cachedCategories.isNotEmpty && 
          cachedHomeTopTabIds != null && cachedBlockedIds != null) {
        final filterChipCategories = cachedCategories
            .where((category) => 
                cachedHomeTopTabIds.contains(category.id) &&
                !cachedBlockedIds.contains(category.id))
            .toList();
        return Right(filterChipCategories);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  void _fetchAndUpdateFilterChipCategoriesInBackground() async {
    try {
      final allCategories = await categoryRemoteDataSource.getCategories();
      final homeTopTabCategoryIds = await configRemoteDataSource.getHomeTopTabCategories();
      final blockedCategoryIds = await configRemoteDataSource.getBlockedCategories();
      await categoryLocalDataSource.cacheCategories(allCategories);
      await categoryLocalDataSource.cacheHomeTopTabCategories(homeTopTabCategoryIds);
      await categoryLocalDataSource.cacheBlockedCategories(blockedCategoryIds);
    } catch (e, stackTrace) {
      DebugLogger.logError(
        'Background refresh for filter chip categories failed',
        error: e,
        stackTrace: stackTrace,
        tag: 'CategoryRepository',
      );
    }
  }
}

