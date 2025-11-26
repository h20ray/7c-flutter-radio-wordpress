import 'package:hive/hive.dart';

abstract class LevelCelebrationLocalDataSource {
  Future<String?> getLastCelebratedLevel(String userId);
  Future<void> setLastCelebratedLevel(String userId, String levelId);
}

class LevelCelebrationLocalDataSourceImpl
    implements LevelCelebrationLocalDataSource {
  static const _boxName = 'level_celebration_box';

  Future<Box> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return Hive.openBox(_boxName);
  }

  @override
  Future<String?> getLastCelebratedLevel(String userId) async {
    final box = await _openBox();
    final stored = box.get(userId);
    if (stored is String) {
      return stored;
    }
    return null;
  }

  @override
  Future<void> setLastCelebratedLevel(String userId, String levelId) async {
    final box = await _openBox();
    await box.put(userId, levelId);
  }
}

