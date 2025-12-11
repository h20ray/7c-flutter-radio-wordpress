import 'dart:convert';

import 'package:flutter/services.dart';

/// Animation configuration loaded from anim_index.json
class AnimationConfig {
  final String key;
  final String displayName;
  final int defaultFps;
  final bool loop;
  
  const AnimationConfig({
    required this.key,
    required this.displayName,
    required this.defaultFps,
    required this.loop,
  });
  
  factory AnimationConfig.fromJson(Map<String, dynamic> json) {
    return AnimationConfig(
      key: json['key'] as String,
      displayName: json['displayName'] as String,
      defaultFps: json['defaultFps'] as int? ?? 8,
      loop: json['loop'] as bool? ?? true,
    );
  }
  
  /// Duration per frame based on FPS
  Duration get frameDuration => Duration(milliseconds: (1000 / defaultFps).round());
}

/// Service for loading and managing TamTama sprite animations.
/// 
/// Features:
/// - Load sprite frames from numeric ID folders
/// - Parse animation metadata from anim_index.json
/// - Manage frame sequences and timing
class AnimationService {
  static const String _animIndexPath = 'assets/config/anim_index.json';
  
  Map<String, AnimationConfig>? _animationConfigs;
  Map<String, int>? _defaultFrameCounts;
  bool _initialized = false;
  
  /// Initialize the service by loading the animation index
  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      final jsonString = await rootBundle.loadString(_animIndexPath);
      final data = json.decode(jsonString) as Map<String, dynamic>;
      
      // Parse animation configs
      final animations = data['animations'] as Map<String, dynamic>?;
      if (animations != null) {
        _animationConfigs = {};
        animations.forEach((key, value) {
          _animationConfigs![key] = AnimationConfig.fromJson(
            value as Map<String, dynamic>,
          );
        });
      }
      
      // Parse default frame counts
      final defaults = data['defaultFrameCounts'] as Map<String, dynamic>?;
      if (defaults != null) {
        _defaultFrameCounts = defaults.map(
          (key, value) => MapEntry(key, value as int),
        );
      }
      
      _initialized = true;
    } catch (e) {
      // Use defaults if loading fails
      _initializeDefaults();
    }
  }
  
  void _initializeDefaults() {
    _animationConfigs = {
      '01': const AnimationConfig(key: 'idle', displayName: 'Idle', defaultFps: 8, loop: true),
      '02': const AnimationConfig(key: 'blink', displayName: 'Blink', defaultFps: 6, loop: false),
      '03': const AnimationConfig(key: 'smile', displayName: 'Smile', defaultFps: 10, loop: false),
      '04': const AnimationConfig(key: 'sad', displayName: 'Sad', defaultFps: 8, loop: true),
      '08': const AnimationConfig(key: 'sleeping', displayName: 'Sleeping', defaultFps: 6, loop: true),
      '12': const AnimationConfig(key: 'radio', displayName: 'Radio Listen', defaultFps: 10, loop: true),
    };
    _defaultFrameCounts = {
      'idle': 10,
      'blink': 4,
      'smile': 6,
      'sad': 6,
      'sleeping': 10,
      'radio': 12,
    };
    _initialized = true;
  }
  
  /// Get animation configuration by ID (e.g., "01" for idle)
  AnimationConfig? getAnimationConfigById(String animId) {
    return _animationConfigs?[animId];
  }
  
  /// Get animation configuration by key (e.g., "idle", "blink")
  AnimationConfig? getAnimationConfigByKey(String key) {
    return _animationConfigs?.values.firstWhere(
      (config) => config.key == key,
      orElse: () => const AnimationConfig(
        key: 'idle',
        displayName: 'Idle',
        defaultFps: 8,
        loop: true,
      ),
    );
  }
  
  /// Get animation ID from key (e.g., "idle" -> "01")
  String getAnimationIdFromKey(String key) {
    const defaultEntry = MapEntry('01', AnimationConfig(
      key: 'idle',
      displayName: 'Idle',
      defaultFps: 8,
      loop: true,
    ));
    final entry = _animationConfigs?.entries.firstWhere(
      (e) => e.value.key == key,
      orElse: () => defaultEntry,
    );
    return entry?.key ?? '01';
  }
  
  /// Get default frame count for an animation type
  int getDefaultFrameCount(String animationKey) {
    return _defaultFrameCounts?[animationKey] ?? 1;
  }
  
  /// Generate sprite frame paths for a pet and animation
  /// Returns list of asset paths for each frame
  List<String> getFramePaths(int petId, String animationKey) {
    final animId = getAnimationIdFromKey(animationKey);
    final frameCount = getDefaultFrameCount(animationKey);
    final paths = <String>[];
    
    for (int i = 0; i < frameCount; i++) {
      // Format: assets/sprites/{petId}/{petId}_{animId}_{frameIndex}.png
      // Or single file: assets/sprites/{petId}/{petId}_{animId}.png
      if (frameCount == 1) {
        paths.add('assets/sprites/$petId/${petId}_$animId.png');
      } else {
        final frameIdx = i.toString().padLeft(2, '0');
        paths.add('assets/sprites/$petId/${petId}_${animId}_$frameIdx.png');
      }
    }
    
    return paths;
  }
  
  /// Get single sprite path (first frame or static sprite)
  String getSpritePath(int petId, String animationKey) {
    final paths = getFramePaths(petId, animationKey);
    return paths.isNotEmpty ? paths.first : 'assets/sprites/eggs/egg_0.png';
  }
  
  /// Get all available animation keys
  List<String> get availableAnimations {
    return _animationConfigs?.values.map((c) => c.key).toList() ?? ['idle'];
  }
}
