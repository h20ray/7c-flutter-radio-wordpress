import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';
import '../datasources/config_remote_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource categoryRemoteDataSource;
  final ConfigRemoteDataSource configRemoteDataSource;

  CategoryRepositoryImpl({
    required this.categoryRemoteDataSource,
    required this.configRemoteDataSource,
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAvailableCategories() async {
    try {
      DebugLogger.log('Fetching all categories from remote', tag: 'CategoryRepository');
      final allCategories = await categoryRemoteDataSource.getCategories();
      DebugLogger.log('Fetched ${allCategories.length} categories from API', tag: 'CategoryRepository');
      
      final blockedCategoryIds = await configRemoteDataSource.getBlockedCategories();
      DebugLogger.log('Blocked category IDs: $blockedCategoryIds', tag: 'CategoryRepository');
      
      final availableCategories = allCategories
          .where((category) => !blockedCategoryIds.contains(category.id))
          .toList();
      
      DebugLogger.log('Available categories after filtering: ${availableCategories.length}', tag: 'CategoryRepository');
      return Right(availableCategories);
    } on ServerException catch (e) {
      DebugLogger.log('ServerException in getAvailableCategories: ${e.message}', tag: 'CategoryRepository');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      DebugLogger.log('NetworkException in getAvailableCategories: ${e.message}', tag: 'CategoryRepository');
      return Left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      DebugLogger.log('TimeoutException in getAvailableCategories: ${e.message}', tag: 'CategoryRepository');
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      DebugLogger.log('Unknown error in getAvailableCategories: ${e.toString()}', tag: 'CategoryRepository');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getFilterChipCategories() async {
    try {
      DebugLogger.log('Fetching filter chip categories', tag: 'CategoryRepository');
      final allCategories = await categoryRemoteDataSource.getCategories();
      final homeTopTabCategoryIds = await configRemoteDataSource.getHomeTopTabCategories();
      DebugLogger.log('Home top tab category IDs: $homeTopTabCategoryIds', tag: 'CategoryRepository');
      final blockedCategoryIds = await configRemoteDataSource.getBlockedCategories();
      
      final filterChipCategories = allCategories
          .where((category) => 
              homeTopTabCategoryIds.contains(category.id) &&
              !blockedCategoryIds.contains(category.id))
          .toList();
      
      DebugLogger.log('Filter chip categories after filtering: ${filterChipCategories.length}', tag: 'CategoryRepository');
      if (filterChipCategories.isEmpty && homeTopTabCategoryIds.isNotEmpty) {
        DebugLogger.log('WARNING: No filter chip categories found but homeTopTabCategoryIds is not empty. Available category IDs: ${allCategories.map((c) => c.id).toList()}', tag: 'CategoryRepository');
      }
      return Right(filterChipCategories);
    } on ServerException catch (e) {
      DebugLogger.log('ServerException in getFilterChipCategories: ${e.message}', tag: 'CategoryRepository');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      DebugLogger.log('NetworkException in getFilterChipCategories: ${e.message}', tag: 'CategoryRepository');
      return Left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      DebugLogger.log('TimeoutException in getFilterChipCategories: ${e.message}', tag: 'CategoryRepository');
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      DebugLogger.log('Unknown error in getFilterChipCategories: ${e.toString()}', tag: 'CategoryRepository');
      return Left(ServerFailure(e.toString()));
    }
  }
}

