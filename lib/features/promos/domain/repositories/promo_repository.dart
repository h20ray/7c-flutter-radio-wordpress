import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/promo_entity.dart';

abstract class PromoRepository {
  Future<Either<Failure, List<PromoEntity>>> getPromosByCategory(int? categoryId);
}

