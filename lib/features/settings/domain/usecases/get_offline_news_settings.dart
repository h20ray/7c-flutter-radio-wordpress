import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/offline_news_settings_entity.dart';
import '../repositories/settings_repository.dart';

class GetOfflineNewsSettings {
  final SettingsRepository repository;

  GetOfflineNewsSettings(this.repository);

  Future<Either<Failure, OfflineNewsSettingsEntity>> call() async {
    return await repository.getOfflineNewsSettings();
  }
}

