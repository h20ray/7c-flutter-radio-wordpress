import 'dart:async';

import '../../config/game_radio_time_config.dart';
import '../../features/gamification/data/datasources/level_celebration_local_data_source.dart';
import '../../features/gamification/presentation/viewmodels/gamification_status_view_data.dart';
import '../di/injection_container.dart';
import '../utils/debug_logger.dart';

class LevelUpCelebrationData {
  final String levelId;
  final String levelName;

  const LevelUpCelebrationData({
    required this.levelId,
    required this.levelName,
  });
}

class LevelUpCelebrationService {
  static LevelUpCelebrationService? _instance;
  static const String _userId = 'local_user';

  LevelCelebrationLocalDataSource? _levelCelebrationStorage;

  final StreamController<LevelUpCelebrationData?> _celebrationController =
      StreamController<LevelUpCelebrationData?>.broadcast();

  bool _isChecking = false;
  bool _isVisible = false;

  LevelUpCelebrationService._internal();

  LevelCelebrationLocalDataSource get _storage {
    _levelCelebrationStorage ??= getIt<LevelCelebrationLocalDataSource>();
    return _levelCelebrationStorage!;
  }

  static LevelUpCelebrationService get instance {
    _instance ??= LevelUpCelebrationService._internal();
    return _instance!;
  }

  Stream<LevelUpCelebrationData?> get celebrationStream =>
      _celebrationController.stream;

  bool get isVisible => _isVisible;

  Future<void> checkAndShowCelebration(GamificationStatusViewData data) async {
    if (_isChecking || _isVisible || data.levelId.isEmpty) {
      return;
    }

    _isChecking = true;

    try {
      final shouldCelebrate = await _shouldShowCelebration(data.levelId);
      if (shouldCelebrate) {
        _isVisible = true;
        _celebrationController.add(
          LevelUpCelebrationData(
            levelId: data.levelId,
            levelName: data.levelName,
          ),
        );
      }
    } catch (e) {
      DebugLogger.logError(
        'Error checking level up celebration',
        error: e,
        tag: 'LevelUpCelebrationService',
      );
    } finally {
      _isChecking = false;
    }
  }

  Future<bool> _shouldShowCelebration(String currentLevelId) async {
    if (!getIt.isRegistered<LevelCelebrationLocalDataSource>()) {
      return false;
    }
    try {
      final stored = await _storage.getLastCelebratedLevel(_userId);
      final ackLevelId = stored ?? GameRadioTimeConfig.getFirstLevel().id;
      final ackIndex = GameRadioTimeConfig.levels
          .indexWhere((level) => level.id == ackLevelId);
      final currentIndex = GameRadioTimeConfig.levels
          .indexWhere((level) => level.id == currentLevelId);

      if (currentIndex == -1) {
        return false;
      }
      if (ackIndex == -1) {
        return true;
      }
      return currentIndex > ackIndex;
    } catch (e) {
      DebugLogger.logError(
        'Error checking should show celebration',
        error: e,
        tag: 'LevelUpCelebrationService',
      );
      return false;
    }
  }

  Future<void> dismissCelebration(String levelId) async {
    if (!_isVisible) {
      return;
    }

    _isVisible = false;
    _celebrationController.add(null);

    if (!getIt.isRegistered<LevelCelebrationLocalDataSource>()) {
      return;
    }
    try {
      await _storage.setLastCelebratedLevel(_userId, levelId);
    } catch (e) {
      DebugLogger.logError(
        'Error dismissing celebration',
        error: e,
        tag: 'LevelUpCelebrationService',
      );
    }
  }

  void dispose() {
    _celebrationController.close();
  }
}

