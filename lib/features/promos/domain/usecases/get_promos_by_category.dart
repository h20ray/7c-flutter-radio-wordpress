import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/promo_entity.dart';
import '../repositories/promo_repository.dart';

class GetPromosByCategory {
  final PromoRepository repository;

  GetPromosByCategory(this.repository);

  Future<Either<Failure, List<PromoEntity>>> call(int? categoryId) async {
    return await repository.getPromosByCategory(categoryId);
  }
}

