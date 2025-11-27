import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/promo_entity.dart';
import '../../domain/repositories/promo_repository.dart';
import '../datasources/promo_remote_datasource.dart';
import '../../../wordpress/data/models/post_model.dart';

class PromoRepositoryImpl implements PromoRepository {
  final PromoRemoteDataSource remoteDataSource;

  PromoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PromoEntity>>> getPromosByCategory(int? categoryId) async {
    try {
      final posts = await remoteDataSource.getPromosByCategory(categoryId);
      final promos = posts.map((post) => _mapPostToPromo(post)).toList();
      return Right(promos);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  PromoEntity _mapPostToPromo(PostModel post) {
    return PromoEntity(
      id: post.id,
      title: post.title,
      categoryId: null,
      categoryName: post.categoryName,
      thumbnailUrl: post.featuredImageUrl,
      time: post.date != null ? _formatTime(post.date!) : null,
      distance: null,
      tags: post.categoryName != null ? [post.categoryName!] : [],
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

