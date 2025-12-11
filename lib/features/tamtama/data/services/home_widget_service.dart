import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/utils/debug_logger.dart';
import '../../domain/entities/tamtama_entity.dart';
import '../../domain/entities/tamtama_widget_data.dart';
import '../../presentation/services/tamtama_sprite_service.dart';

/// Service for synchronizing TamTama data with native home screen widgets.
/// 
/// Handles:
/// - Saving widget data to SharedPreferences/UserDefaults
/// - Rendering pet sprites as images for widget display
/// - Triggering widget updates
/// - Processing widget tap actions
class HomeWidgetService {
  static const String _tag = 'HOME_WIDGET';
  
  // Widget identifiers
  static const String _androidWidgetName = 'TamtamaWidgetReceiver';
  static const String _iosWidgetName = 'TamtamaWidget';
  
  // App Group for iOS (configured in Xcode)
  static const String _appGroupId = 'group.com.tujuhcahaya.wprs';
  
  // Data keys for widget storage
  static const String _keyPetName = 'pet_name';
  static const String _keyPetId = 'pet_id';
  static const String _keyLifeStage = 'life_stage';
  static const String _keyHunger = 'hunger';
  static const String _keyHappiness = 'happiness';
  static const String _keyEnergy = 'energy';
  static const String _keyLevel = 'level';
  static const String _keyNeedsAttention = 'needs_attention';
  static const String _keySpritePath = 'sprite_path';
  static const String _keyLastUpdated = 'last_updated';
  
  final TamtamaSpriteService _spriteService;
  
  HomeWidgetService({required TamtamaSpriteService spriteService})
      : _spriteService = spriteService;

  /// Initialize the home widget service
  Future<void> initialize() async {
    try {
      // Set app group for iOS
      await HomeWidget.setAppGroupId(_appGroupId);
      DebugLogger.log('HomeWidgetService initialized', tag: _tag);
    } catch (e) {
      DebugLogger.log('Failed to initialize HomeWidgetService: $e', tag: _tag);
    }
  }

  /// Update widget data from a TamTama entity
  Future<void> updateWidgetData(TamtamaEntity entity) async {
    try {
      final spritePath = _spriteService.getSpritePath(entity);
      final widgetData = TamtamaWidgetData.fromEntity(entity, spritePath);
      
      // Render sprite as image for widget display
      final imagePath = await _renderSpriteToFile(entity);
      
      // Save all widget data
      await Future.wait([
        HomeWidget.saveWidgetData<String>(_keyPetName, widgetData.petName),
        HomeWidget.saveWidgetData<int>(_keyPetId, widgetData.petId),
        HomeWidget.saveWidgetData<String>(_keyLifeStage, widgetData.lifeStage),
        HomeWidget.saveWidgetData<double>(_keyHunger, widgetData.hunger),
        HomeWidget.saveWidgetData<double>(_keyHappiness, widgetData.happiness),
        HomeWidget.saveWidgetData<double>(_keyEnergy, widgetData.energy),
        HomeWidget.saveWidgetData<int>(_keyLevel, widgetData.level),
        HomeWidget.saveWidgetData<bool>(_keyNeedsAttention, widgetData.needsAttention),
        HomeWidget.saveWidgetData<String>(_keySpritePath, imagePath ?? spritePath),
        HomeWidget.saveWidgetData<int>(_keyLastUpdated, widgetData.lastUpdated.millisecondsSinceEpoch),
      ]);
      
      DebugLogger.log(
        'Widget data updated: ${widgetData.petName} (Lv.${widgetData.level})',
        tag: _tag,
      );
    } catch (e) {
      DebugLogger.log('Failed to update widget data: $e', tag: _tag);
    }
  }

  /// Trigger native widget refresh
  Future<void> refreshWidget() async {
    try {
      if (Platform.isAndroid) {
        await HomeWidget.updateWidget(
          name: _androidWidgetName,
          qualifiedAndroidName: 'com.tujuhcahaya.wprs.widget.$_androidWidgetName',
        );
      } else if (Platform.isIOS) {
        await HomeWidget.updateWidget(
          name: _iosWidgetName,
          iOSName: _iosWidgetName,
        );
      }
      DebugLogger.log('Widget refresh triggered', tag: _tag);
    } catch (e) {
      DebugLogger.log('Failed to refresh widget: $e', tag: _tag);
    }
  }

  /// Update widget data and trigger refresh
  Future<void> syncToWidget(TamtamaEntity entity) async {
    await updateWidgetData(entity);
    await refreshWidget();
  }

  /// Request to pin widget to home screen (Android only)
  /// 
  /// On Android 8.0+, this shows a system dialog asking the user
  /// to confirm adding the widget to their home screen.
  /// Returns true if the request was made successfully.
  Future<bool> requestPinWidget() async {
    try {
      if (!Platform.isAndroid) {
        DebugLogger.log('Pin widget only supported on Android', tag: _tag);
        return false;
      }
      
      await HomeWidget.requestPinWidget(
        name: _androidWidgetName,
        qualifiedAndroidName: 'com.tujuhcahaya.wprs.widget.$_androidWidgetName',
      );
      
      DebugLogger.log('Pin widget request sent', tag: _tag);
      return true;
    } catch (e) {
      DebugLogger.log('Failed to request pin widget: $e', tag: _tag);
      return false;
    }
  }

  /// Render the pet sprite as a PNG file for widget display
  Future<String?> _renderSpriteToFile(TamtamaEntity entity) async {
    try {
      final petId = entity.petId ?? 11010;
      final spritePath = _spriteService.getSpritePath(entity);
      
      // Load sprite from assets
      final byteData = await rootBundle.load(spritePath);
      final codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      final image = frame.image;
      
      // Convert to PNG bytes
      final pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);
      if (pngBytes == null) return null;
      
      // Get shared directory for widget
      final directory = await _getWidgetDirectory();
      if (directory == null) return null;
      
      // Save sprite image
      final fileName = 'tamtama_sprite_$petId.png';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(pngBytes.buffer.asUint8List());
      
      DebugLogger.log('Sprite rendered to: ${file.path}', tag: _tag);
      return file.path;
    } catch (e) {
      DebugLogger.log('Failed to render sprite: $e', tag: _tag);
      return null;
    }
  }

  /// Get the shared directory for widget assets
  Future<Directory?> _getWidgetDirectory() async {
    try {
      if (Platform.isAndroid) {
        // Use external files directory for Android
        final extDir = await getExternalStorageDirectory();
        if (extDir != null) {
          final widgetDir = Directory('${extDir.path}/widget');
          if (!await widgetDir.exists()) {
            await widgetDir.create(recursive: true);
          }
          return widgetDir;
        }
      } else if (Platform.isIOS) {
        // Use app group container for iOS
        final appDir = await getApplicationDocumentsDirectory();
        final widgetDir = Directory('${appDir.path}/widget');
        if (!await widgetDir.exists()) {
          await widgetDir.create(recursive: true);
        }
        return widgetDir;
      }
      return null;
    } catch (e) {
      DebugLogger.log('Failed to get widget directory: $e', tag: _tag);
      return null;
    }
  }

  /// Handle URI from widget tap action
  /// Returns the action to perform (e.g., 'care', 'feed', 'play')
  String? handleWidgetUri(Uri? uri) {
    if (uri == null) return null;
    
    // Expected format: tcwhrs://tamtama/action
    if (uri.scheme == 'tcwhrs' && uri.host == 'tamtama') {
      final action = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      DebugLogger.log('Widget action received: $action', tag: _tag);
      return action;
    }
    return null;
  }

  /// Register callback for widget clicks
  Future<void> registerWidgetCallback(
    Future<void> Function(Uri?) callback,
  ) async {
    try {
      // Check if app was launched from widget
      final uri = await HomeWidget.initiallyLaunchedFromHomeWidget();
      if (uri != null) {
        await callback(uri);
      }
      
      // Register for future widget clicks
      HomeWidget.widgetClicked.listen(callback);
      
      DebugLogger.log('Widget callback registered', tag: _tag);
    } catch (e) {
      DebugLogger.log('Failed to register widget callback: $e', tag: _tag);
    }
  }

  /// Get stored widget data (for debugging)
  Future<TamtamaWidgetData?> getWidgetData() async {
    try {
      final petName = await HomeWidget.getWidgetData<String>(_keyPetName);
      final petId = await HomeWidget.getWidgetData<int>(_keyPetId);
      final lifeStage = await HomeWidget.getWidgetData<String>(_keyLifeStage);
      final hunger = await HomeWidget.getWidgetData<double>(_keyHunger);
      final happiness = await HomeWidget.getWidgetData<double>(_keyHappiness);
      final energy = await HomeWidget.getWidgetData<double>(_keyEnergy);
      final level = await HomeWidget.getWidgetData<int>(_keyLevel);
      final needsAttention = await HomeWidget.getWidgetData<bool>(_keyNeedsAttention);
      final spritePath = await HomeWidget.getWidgetData<String>(_keySpritePath);
      final lastUpdated = await HomeWidget.getWidgetData<int>(_keyLastUpdated);
      
      return TamtamaWidgetData(
        petName: petName ?? 'TamTama',
        petId: petId ?? 11010,
        lifeStage: lifeStage ?? 'egg',
        hunger: hunger ?? 100.0,
        happiness: happiness ?? 100.0,
        energy: energy ?? 100.0,
        level: level ?? 1,
        needsAttention: needsAttention ?? false,
        spritePath: spritePath ?? '',
        lastUpdated: DateTime.fromMillisecondsSinceEpoch(
          lastUpdated ?? DateTime.now().millisecondsSinceEpoch,
        ),
      );
    } catch (e) {
      DebugLogger.log('Failed to get widget data: $e', tag: _tag);
      return null;
    }
  }
}
