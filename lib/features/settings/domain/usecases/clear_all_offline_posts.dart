import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/settings_repository.dart';

class ClearAllOfflinePosts {
  final SettingsRepository repository;

  ClearAllOfflinePosts(this.repository);

  Future<Either<Failure, Unit>> call() async {
    return await repository.clearAllOfflinePosts();
  }
}

