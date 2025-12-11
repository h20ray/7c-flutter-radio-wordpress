import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/utils/debug_logger.dart';

/// Pet form mapping from numeric ID to display information.
/// 
/// Each pet form has three identifiers:
/// - **id**: Opaque numeric asset identifier (e.g., 11010, 15011)
///   Used by engine, file system, and asset paths
/// - **key**: Stable semantic identifier (e.g., "EGG_TAMAUNO_A", "ADULT_TAMAUNO_DJSTAR")
///   Used by developers, designers, evolution logic, and BLoC state
/// - **displayName**: UI-facing name (e.g., "Tamauno Egg A", "Tamauno DJ Star")
///   Used for user display and localization
class PetFormInfo {
  final int id;
  final String key;
  final String displayName;

  const PetFormInfo({
    required this.id,
    required this.key,
    required this.displayName,
  });

  factory PetFormInfo.fromJson(int id, Map<String, dynamic> json) {
    return PetFormInfo(
      id: id,
      key: json['key'] as String,
      displayName: json['displayName'] as String,
    );
  }
}

/// Service for loading and accessing pet ID to name mappings.
/// 
/// Maps numeric pet IDs to semantic keys and display names.
/// Loads from `assets/config/pet_map.json`.
/// 
/// Usage:
/// ```dart
/// final petMap = getIt<PetMapService>();
/// await petMap.load();
/// 
/// // Get display name for UI
/// final name = petMap.getDisplayName(15011); // "Tamauno DJ Star"
/// 
/// // Get key for code logic
/// final key = petMap.getKey(15011); // "ADULT_TAMAUNO_DJSTAR"
/// 
/// // Reverse lookup: key -> ID
/// final id = petMap.getIdByKey("ADULT_TAMAUNO_DJSTAR"); // 15011
/// ```
class PetMapService {
  static const String _configPath = 'assets/config/pet_map.json';

  Map<int, PetFormInfo>? _mappings;
  Map<String, int>? _keyToId;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  /// Load configuration from assets
  Future<void> load() async {
    if (_isLoaded) return;

    try {
      final jsonString = await rootBundle.loadString(_configPath);
      final json = jsonDecode(jsonString) as Map<String, dynamic>;

      final mappingsJson = json['mappings'] as Map<String, dynamic>? ?? {};
      
      _mappings = {};
      _keyToId = {};
      
      for (final entry in mappingsJson.entries) {
        final id = int.tryParse(entry.key);
        if (id != null) {
          final info = PetFormInfo.fromJson(id, entry.value as Map<String, dynamic>);
          _mappings![id] = info;
          _keyToId![info.key] = id;
        }
      }

      _isLoaded = true;
      DebugLogger.log('[PetMapService] Loaded ${_mappings?.length ?? 0} pet form mappings');

    } catch (e, stackTrace) {
      DebugLogger.logError('[PetMapService] Failed to load: $e', stackTrace: stackTrace);
      _mappings = {};
      _keyToId = {};
      _isLoaded = true;
    }
  }

  /// Get pet info by numeric ID
  PetFormInfo? getById(int id) => _mappings?[id];

  /// Get display name by numeric ID
  String getDisplayName(int id) => _mappings?[id]?.displayName ?? 'Unknown Pet';

  /// Get key by numeric ID  
  String? getKey(int id) => _mappings?[id]?.key;

  /// Get numeric ID by key
  int? getIdByKey(String key) => _keyToId?[key];

  /// Check if an ID exists in the mapping
  bool exists(int id) => _mappings?.containsKey(id) ?? false;

  /// Get all pet IDs
  List<int> get allIds => _mappings?.keys.toList() ?? [];

  /// Get all pet infos
  List<PetFormInfo> get allInfos => _mappings?.values.toList() ?? [];

  /// Get sprite folder path for a pet ID
  /// 
  /// Schema: assets/sprites/{petId}/
  String getSpriteFolderPath(int petId) {
    return 'assets/sprites/$petId/';
  }

  /// Get sprite file path for a pet ID and animation
  /// 
  /// Schema: assets/sprites/{petId}/{petId}_{animId}.png
  String getSpriteFilePath(int petId, String animId) {
    return 'assets/sprites/$petId/${petId}_$animId.png';
  }

  /// Get metadata file path for a pet ID
  /// 
  /// Schema: assets/sprites/{petId}/{petId}.meta.json
  String getMetadataPath(int petId) {
    return 'assets/sprites/$petId/$petId.meta.json';
  }
}
