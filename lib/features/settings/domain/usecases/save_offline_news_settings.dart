import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/offline_news_settings_entity.dart';
import '../repositories/settings_repository.dart';

class SaveOfflineNewsSettings {
  final SettingsRepository repository;

  SaveOfflineNewsSettings(this.repository);

  Future<Either<Failure, Unit>> call(OfflineNewsSettingsEntity settings) async {
    return await repository.saveOfflineNewsSettings(settings);
  }
}

