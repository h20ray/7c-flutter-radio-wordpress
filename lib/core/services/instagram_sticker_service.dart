import 'dart:io';
import 'package:flutter/services.dart';
import '../utils/debug_logger.dart';

enum InstagramShareResult {
  success,
  instagramNotInstalled,
  sharingFailed,
  unknownError,
}

class InstagramStickerService {
  static const MethodChannel _channel = MethodChannel('instagram_sticker_share');

  /// Share a sticker to Instagram Stories.
  /// 
  /// [imageFile] - The sticker image file to share
  /// [topColor] - Optional top gradient color (hex format like '#FF5733')
  /// [bottomColor] - Optional bottom gradient color (hex format like '#C70039')
  /// 
  /// If colors are not provided, Instagram will use a default black background.
  Future<InstagramShareResult> shareSticker(
    File imageFile, {
    String? topColor,
    String? bottomColor,
  }) async {
    try {
      if (!await imageFile.exists()) {
        DebugLogger.logError(
          'InstagramStickerService: Image file does not exist',
          error: Exception('File not found: ${imageFile.path}'),
          tag: 'InstagramStickerService',
        );
        return InstagramShareResult.sharingFailed;
      }

      final Map<String, dynamic> arguments = {
        'imagePath': imageFile.path,
      };
      
      // Add gradient colors if provided
      if (topColor != null) {
        arguments['topBackgroundColor'] = topColor;
      }
      if (bottomColor != null) {
        arguments['bottomBackgroundColor'] = bottomColor;
      }

      final result = await _channel.invokeMethod<String>(
        'shareToInstagramStories',
        arguments,
      );

      if (result == 'success') {
        DebugLogger.log(
          'InstagramStickerService: Successfully shared to Instagram',
          tag: 'InstagramStickerService',
        );
        return InstagramShareResult.success;
      } else if (result == 'instagram_not_installed') {
        DebugLogger.log(
          'InstagramStickerService: Instagram app not installed',
          tag: 'InstagramStickerService',
        );
        return InstagramShareResult.instagramNotInstalled;
      } else {
        DebugLogger.logError(
          'InstagramStickerService: Sharing failed',
          error: Exception('Result: $result'),
          tag: 'InstagramStickerService',
        );
        return InstagramShareResult.sharingFailed;
      }
    } on PlatformException catch (e) {
      if (e.code == 'instagram_not_installed') {
        DebugLogger.log(
          'InstagramStickerService: Instagram app not installed (PlatformException)',
          tag: 'InstagramStickerService',
        );
        return InstagramShareResult.instagramNotInstalled;
      }
      DebugLogger.logError(
        'InstagramStickerService: Platform exception',
        error: e,
        tag: 'InstagramStickerService',
      );
      return InstagramShareResult.sharingFailed;
    } catch (e, stackTrace) {
      DebugLogger.logError(
        'InstagramStickerService: Unknown error',
        error: e,
        stackTrace: stackTrace,
        tag: 'InstagramStickerService',
      );
      return InstagramShareResult.unknownError;
    }
  }
}

