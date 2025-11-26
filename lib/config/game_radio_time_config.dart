import 'package:flutter/foundation.dart';

/// Configuration for a single game level.
///
/// Each level defines:
/// - [id]: Unique identifier (e.g., 'level_1', 'bronze', 'silver')
/// - [displayName]: Name shown to users (e.g., 'Frequency Wanderer')
/// - [description]: Brief description of the level
/// - [minHours]: Minimum listening hours required to reach this level
/// - [maxHours]: Maximum hours for this level (null for unlimited/final level)
/// - [assetPath]: Path to the static level badge/image asset
/// - [animationAssetPath]: Path to the level animation asset (Lottie)
///
/// Example:
/// ```dart
/// GameLevelDefinition(
///   id: 'level_1',
///   displayName: 'Frequency Wanderer',
///   description: 'Newcomer exploring different radio frequencies.',
///   minHours: 0,
///   maxHours: 10,
///   assetPath: 'assets/images/user_levels/level_1.png',
/// )
/// ```
class GameLevelDefinition {
  final String id;
  final String displayName;
  final String description;
  final double minHours;
  final double? maxHours;
  final String assetPath;
  final String animationAssetPath;
  final int badgeBackgroundColor;

  const GameLevelDefinition({
    required this.id,
    required this.displayName,
    required this.description,
    required this.minHours,
    required this.maxHours,
    required this.assetPath,
    required this.animationAssetPath,
    required this.badgeBackgroundColor,
  });

  bool containsHours(double hours) {
    if (maxHours == null) {
      return hours >= minHours;
    }
    return hours >= minHours && hours < maxHours!;
  }

  double get hourRange => (maxHours ?? double.maxFinite) - minHours;

  bool get isMaxLevel => maxHours == null;
}

/// Unified game radio time configuration.
///
/// This configuration file centralizes all game/level settings, making it easy
/// for clients to customize levels, images, and hour requirements.
///
/// ## How to Customize Levels
///
/// 1. **Add a new level**: Add a new `GameLevelDefinition` to the [levels] list
/// 2. **Modify existing level**: Edit the properties of any level definition
/// 3. **Change hour requirements**: Update [minHours] and [maxHours] values
/// 4. **Update images**: Change [assetPath] to point to your custom images
/// 5. **Rename levels**: Modify [displayName] and [description] as needed
///
/// ## Important Rules
///
/// - Levels must be ordered by [minHours] (ascending)
/// - Hour ranges must not overlap (except the last level can be unlimited)
/// - Only the last level should have [maxHours] set to `null`
/// - All fields are required and cannot be empty
/// - Level IDs must be unique
///
/// ## Example: Adding a New Level
///
/// ```dart
/// GameLevelDefinition(
///   id: 'level_7',
///   displayName: 'Radio Master',
///   description: 'Ultimate radio enthusiast.',
///   minHours: 500,
///   maxHours: null, // Unlimited - must be last level
///   assetPath: 'assets/images/user_levels/level_7.png',
/// ),
/// ```
///
/// The configuration is automatically validated on first use to ensure safety.
class GameRadioTimeConfig {
  GameRadioTimeConfig._();

  static const int levelAnimationInitialLoops = 1;
  static const int levelAnimationTapLoopMin = 1;
  static const int levelAnimationTapLoopMax = 3;

  /// List of game level definitions.
  ///
  /// **Easy to edit**: Simply modify this list to customize levels.
  /// Levels are automatically validated for correctness.
  ///
  /// To add more levels, insert new entries in the appropriate position
  /// based on hour requirements. Remember to update the last level's
  /// [maxHours] to `null` if it should be unlimited.
  static const List<GameLevelDefinition> levels = [
    GameLevelDefinition(
      id: 'level_1',
      displayName: 'Pemula',
      description: 'Baru join? Yuk mulai denger & eksplor!',
      minHours: 0,
      maxHours: 0.01,
      assetPath: 'assets/images/user_levels/ic_level_01.png',
      animationAssetPath: 'assets/sprites/game_level_listening/level_1.lottie',
      badgeBackgroundColor: 0xFF7EC8E3,
    ),
    GameLevelDefinition(
      id: 'level_2',
      displayName: 'Pendengar Aktif',
      description: 'Rutin denger, tapi masih malu-malu interaksi',
      minHours: 0.01,
      maxHours: 0.02,
      assetPath: 'assets/images/user_levels/ic_level_02.png',
      animationAssetPath: 'assets/sprites/game_level_listening/level_2.lottie',
      badgeBackgroundColor: 0xFF4CAF50,
    ),
    GameLevelDefinition(
      id: 'level_3',
      displayName: 'Partisipan',
      description: 'Mulai hafal lagu & nimbrung di chat',
      minHours: 0.02,
      maxHours: 0.03,
      assetPath: 'assets/images/user_levels/ic_level_03.png',
      animationAssetPath: 'assets/sprites/game_level_listening/level_3.lottie',
      badgeBackgroundColor: 0xFFFBC02D,
    ),
    GameLevelDefinition(
      id: 'level_4',
      displayName: 'Hype Squad',
      description: 'Feels like part of the radio world, a citizen of airwaves.',
      minHours: 0.03,
      maxHours: 0.04,
      assetPath: 'assets/images/user_levels/ic_level_04.png',
      animationAssetPath: 'assets/sprites/game_level_listening/level_4.lottie',
      badgeBackgroundColor: 0xFFFB8C00,
    ),
    GameLevelDefinition(
      id: 'level_5',
      displayName: 'Radio Star',
      description: 'Highly engaged, standout community member.',
      minHours: 0.04,
      maxHours: 0.05,
      assetPath: 'assets/images/user_levels/ic_level_05.png',
      animationAssetPath: 'assets/sprites/game_level_listening/level_5.lottie',
      badgeBackgroundColor: 0xFFE53935,
    ),
    GameLevelDefinition(
      id: 'level_6',
      displayName: 'Broadcast Icon',
      description: 'Iconic listener with huge presence.',
      minHours: 0.05,
      maxHours: 0.06,
      assetPath: 'assets/images/user_levels/ic_level_06.png',
      animationAssetPath: 'assets/sprites/game_level_listening/level_6.lottie',
      badgeBackgroundColor: 0xFF8E24AA,
    ),
    GameLevelDefinition(
      id: 'level_7',
      displayName: 'Broadcast Legend',
      description: 'Legenda hidup, dikenal penyiar & komunitas.',
      minHours: 0.07,
      maxHours: null,
      assetPath: 'assets/images/user_levels/ic_level_06.png',
      animationAssetPath: 'assets/sprites/game_level_listening/level_7.lottie',
      badgeBackgroundColor: 0xFF121212,
    ),
  ];

  static bool _isValidated = false;
  static String? _validationError;

  static void _validateConfig() {
    if (_isValidated) {
      if (_validationError != null) {
        throw StateError(_validationError!);
      }
      return;
    }

    _isValidated = true;

    if (levels.isEmpty) {
      _validationError =
          'GameRadioTimeConfig: At least one level must be defined';
      throw StateError(_validationError!);
    }

    final idSet = <String>{};
    for (var i = 0; i < levels.length; i++) {
      final level = levels[i];

      if (level.id.isEmpty) {
        _validationError =
            'GameRadioTimeConfig: Level at index $i has empty ID';
        throw StateError(_validationError!);
      }

      if (level.displayName.isEmpty) {
        _validationError =
            'GameRadioTimeConfig: Level "${level.id}" has empty display name';
        throw StateError(_validationError!);
      }

      if (level.description.isEmpty) {
        _validationError =
            'GameRadioTimeConfig: Level "${level.id}" has empty description';
        throw StateError(_validationError!);
      }

      if (level.assetPath.isEmpty) {
        _validationError =
            'GameRadioTimeConfig: Level "${level.id}" has empty asset path';
        throw StateError(_validationError!);
      }

      if (level.animationAssetPath.isEmpty) {
        _validationError =
            'GameRadioTimeConfig: Level "${level.id}" has empty animation asset path';
        throw StateError(_validationError!);
      }

      if (level.minHours < 0) {
        _validationError =
            'GameRadioTimeConfig: Level "${level.id}" has negative minHours';
        throw StateError(_validationError!);
      }

      if (level.maxHours != null && level.maxHours! <= level.minHours) {
        _validationError =
            'GameRadioTimeConfig: Level "${level.id}" maxHours must be greater than minHours';
        throw StateError(_validationError!);
      }

      if (idSet.contains(level.id)) {
        _validationError =
            'GameRadioTimeConfig: Duplicate level ID "${level.id}" found';
        throw StateError(_validationError!);
      }
      idSet.add(level.id);

      if (level.maxHours == null && i < levels.length - 1) {
        _validationError =
            'GameRadioTimeConfig: Only the last level can have unlimited maxHours. '
            'Level "${level.id}" has maxHours null but is not the last level';
        throw StateError(_validationError!);
      }

      if (i > 0) {
        final previousLevel = levels[i - 1];
        if (level.minHours < previousLevel.minHours) {
          _validationError =
              'GameRadioTimeConfig: Levels must be ordered by minHours. '
              'Level "${level.id}" has minHours ${level.minHours} which is less than '
              'previous level "${previousLevel.id}" minHours ${previousLevel.minHours}';
          throw StateError(_validationError!);
        }

        if (previousLevel.maxHours != null &&
            level.minHours < previousLevel.maxHours!) {
          _validationError =
              'GameRadioTimeConfig: Overlapping hour ranges detected. '
              'Level "${level.id}" minHours ${level.minHours} overlaps with '
              'previous level "${previousLevel.id}" maxHours ${previousLevel.maxHours}';
          throw StateError(_validationError!);
        }
      }
    }

    final lastLevel = levels.last;
    if (lastLevel.maxHours != null) {
      debugPrint(
        'GameRadioTimeConfig: Warning - Last level "${lastLevel.id}" has a maxHours '
        'value. Consider setting maxHours to null for unlimited progression.',
      );
    }
  }

  static GameLevelDefinition resolveByHours(double hours) {
    _validateConfig();
    final normalizedHours = hours < 0 ? 0.0 : hours;

    for (final level in levels) {
      if (level.containsHours(normalizedHours)) {
        return level;
      }
    }

    return levels.last;
  }

  static GameLevelDefinition? getLevelById(String id) {
    _validateConfig();
    try {
      return levels.firstWhere((level) => level.id == id);
    } catch (e) {
      return null;
    }
  }

  static GameLevelDefinition? nextLevel(String currentLevelId) {
    _validateConfig();
    final currentIndex = levels.indexWhere(
      (level) => level.id == currentLevelId,
    );
    if (currentIndex == -1 || currentIndex + 1 >= levels.length) {
      return null;
    }
    return levels[currentIndex + 1];
  }

  static double progressToNextLevel(double hours) {
    _validateConfig();
    final definition = resolveByHours(hours);
    final clampedHours = hours.clamp(
      definition.minHours,
      definition.maxHours ?? double.maxFinite,
    );

    if (definition.maxHours == null) {
      return 1.0;
    }

    final range = definition.maxHours! - definition.minHours;
    if (range <= 0) {
      return 1.0;
    }

    return ((clampedHours - definition.minHours) / range).clamp(0.0, 1.0);
  }

  static GameLevelDefinition getFirstLevel() {
    _validateConfig();
    return levels.first;
  }

  static GameLevelDefinition getLastLevel() {
    _validateConfig();
    return levels.last;
  }

  static bool isMaxLevel(String levelId) {
    _validateConfig();
    return levels.last.id == levelId;
  }
}
