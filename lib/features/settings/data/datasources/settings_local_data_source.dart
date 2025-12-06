import 'package:hive/hive.dart';
import '../models/offline_news_settings_model.dart';

abstract class SettingsLocalDataSource {
  Future<OfflineNewsSettingsModel> getOfflineNewsSettings();
  Future<void> saveOfflineNewsSettings(OfflineNewsSettingsModel settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String _boxName = 'settingsBox';
  static const String _offlineNewsSettingsKey = 'offline_news_settings';

  Future<Box> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return Hive.openBox(_boxName);
  }

  @override
  Future<OfflineNewsSettingsModel> getOfflineNewsSettings() async {
    try {
      final box = await _openBox();
      final raw = box.get(_offlineNewsSettingsKey);

      if (raw is Map) {
        return OfflineNewsSettingsModel.fromJson(
            Map<String, dynamic>.from(raw));
      }

      final defaults = OfflineNewsSettingsModel.defaults();
      await saveOfflineNewsSettings(defaults);
      return defaults;
    } catch (e) {
      return OfflineNewsSettingsModel.defaults();
    }
  }

  @override
  Future<void> saveOfflineNewsSettings(
      OfflineNewsSettingsModel settings) async {
    try {
      final box = await _openBox();
      await box.put(_offlineNewsSettingsKey, settings.toJson());
    } catch (e) {
      throw Exception('Failed to save offline news settings: $e');
    }
  }
}

