import 'package:flutter/foundation.dart';

class DebugLogger {
  static const String _tag = '[7C-Radio]';

  static void log(String message, {String? tag}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final logTag = tag != null ? '$_tag[$tag]' : _tag;
      debugPrint('$logTag $timestamp: $message');
    }
  }

  static void logError(String message, {Object? error, StackTrace? stackTrace, String? tag}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final logTag = tag != null ? '$_tag[$tag]' : _tag;
      debugPrint('$logTag ERROR $timestamp: $message');
      if (error != null) {
        debugPrint('$logTag ERROR Details: $error');
      }
      if (stackTrace != null) {
        debugPrint('$logTag ERROR StackTrace: $stackTrace');
      }
    }
  }

  static void logInit(String step, {double? progress}) {
    if (kDebugMode) {
      final progressStr = progress != null ? ' (${(progress * 100).toStringAsFixed(0)}%)' : '';
      log('Initialization: $step$progressStr', tag: 'INIT');
    }
  }

  static void logNavigation(String route, {String? reason}) {
    if (kDebugMode) {
      final reasonStr = reason != null ? ' - $reason' : '';
      log('Navigation: $route$reasonStr', tag: 'NAV');
    }
  }

  static void logRadio(String message, {String? state}) {
    if (kDebugMode) {
      final stateStr = state != null ? ' [$state]' : '';
      log('Radio$stateStr: $message', tag: 'RADIO');
    }
  }
}

