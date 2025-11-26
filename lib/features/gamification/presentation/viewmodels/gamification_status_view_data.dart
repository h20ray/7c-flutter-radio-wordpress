import 'package:equatable/equatable.dart';

import '../../../../config/game_radio_time_config.dart';
import '../../domain/entities/user_listening_stats_entity.dart';

class GamificationStatusViewData extends Equatable {
  final String levelId;
  final String levelName;
  final String levelDescription;
  final double totalListeningHours;
  final double progressToNextLevel;
  final String assetPath;
  final String animationAssetPath;
  final int badgeBackgroundColor;
  final bool isMaxLevel;
  final String? nextLevelName;
  final double? nextLevelTargetHours;

  const GamificationStatusViewData({
    required this.levelId,
    required this.levelName,
    required this.levelDescription,
    required this.totalListeningHours,
    required this.progressToNextLevel,
    required this.assetPath,
    required this.animationAssetPath,
    required this.badgeBackgroundColor,
    required this.isMaxLevel,
    required this.nextLevelName,
    required this.nextLevelTargetHours,
  });

  factory GamificationStatusViewData.fromEntity(
    UserListeningStatsEntity entity,
  ) {
    final definition = GameRadioTimeConfig.resolveByHours(
      entity.totalListeningHours,
    );
    final nextDefinition = GameRadioTimeConfig.nextLevel(definition.id);
    final progress =
        GameRadioTimeConfig.progressToNextLevel(entity.totalListeningHours);
    final normalizedProgress = progress.clamp(0, 1).toDouble();
    return GamificationStatusViewData(
      levelId: definition.id,
      levelName: definition.displayName,
      levelDescription: definition.description,
      totalListeningHours: entity.totalListeningHours,
      progressToNextLevel: normalizedProgress,
      assetPath: definition.assetPath,
      animationAssetPath: definition.animationAssetPath,
      badgeBackgroundColor: definition.badgeBackgroundColor,
      isMaxLevel: nextDefinition == null,
      nextLevelName: nextDefinition?.displayName,
      nextLevelTargetHours: nextDefinition?.minHours,
    );
  }

  @override
  List<Object?> get props => [
        levelName,
        levelId,
        levelDescription,
        totalListeningHours,
        progressToNextLevel,
        assetPath,
        animationAssetPath,
        badgeBackgroundColor,
        isMaxLevel,
        nextLevelName,
        nextLevelTargetHours,
      ];
}

