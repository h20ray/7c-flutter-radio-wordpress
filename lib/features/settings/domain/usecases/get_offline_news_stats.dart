import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/settings_repository.dart';

class GetOfflineNewsStats {
  final SettingsRepository repository;

  GetOfflineNewsStats(this.repository);

  Future<Either<Failure, OfflineNewsStats>> call() async {
    return await repository.getOfflineNewsStats();
  }
}

