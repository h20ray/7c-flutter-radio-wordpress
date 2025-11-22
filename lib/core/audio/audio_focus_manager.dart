import 'dart:async';
import 'package:flutter/services.dart';
import '../utils/debug_logger.dart';

/// Audio focus event types
enum AudioFocusEvent {
  gain,
  loss,
  lossTransient,
  lossTransientCanDuck,
}

/// Audio focus event data
class AudioFocusEventData {
  final AudioFocusEvent event;
  final bool hasFocus;
  final bool shouldDuck;

  const AudioFocusEventData({
    required this.event,
    required this.hasFocus,
    this.shouldDuck = false,
  });

  factory AudioFocusEventData.fromMap(Map<String, dynamic> map) {
    final eventString = map['event'] as String? ?? 'focus_loss';
    AudioFocusEvent event;

    switch (eventString) {
      case 'focus_gain':
        event = AudioFocusEvent.gain;
        break;
      case 'focus_loss':
        event = AudioFocusEvent.loss;
        break;
      case 'focus_loss_transient':
        event = AudioFocusEvent.lossTransient;
        break;
      case 'focus_loss_transient_can_duck':
        event = AudioFocusEvent.lossTransientCanDuck;
        break;
      default:
        event = AudioFocusEvent.loss;
    }

    return AudioFocusEventData(
      event: event,
      hasFocus: map['hasFocus'] as bool? ?? false,
      shouldDuck: map['shouldDuck'] as bool? ?? false,
    );
  }
}

/// Manages audio focus to prevent conflicts and improve streaming performance
/// Note: This is a simplified version. For full functionality, native code
/// needs to be implemented for Android/iOS platforms.
class AudioFocusManager {
  static const MethodChannel _channel = MethodChannel('audio_focus');

  static AudioFocusManager? _instance;
  static AudioFocusManager get instance => _instance ??= AudioFocusManager._();

  AudioFocusManager._() {
    _setupMethodCallHandler();
  }

  bool _hasAudioFocus = false;
  bool _isDucking = false;
  double _duckingVolume = 0.3;
  StreamController<AudioFocusEventData>? _focusController;

  /// Set up method call handler for native audio focus events
  void _setupMethodCallHandler() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onAudioFocusChange') {
        try {
          final data = AudioFocusEventData.fromMap(
              Map<String, dynamic>.from(call.arguments as Map));
          _handleAudioFocusChange(data);
        } catch (e) {
          DebugLogger.logError('Error handling audio focus change', error: e, tag: 'AudioFocusManager');
        }
      }
    });
  }

  /// Handle audio focus change from native side
  void _handleAudioFocusChange(AudioFocusEventData data) {
    _hasAudioFocus = data.hasFocus;

    switch (data.event) {
      case AudioFocusEvent.gain:
        _isDucking = false;
        DebugLogger.log('[AudioFocusManager] Audio focus gained', tag: 'AudioFocusManager');
        break;
      case AudioFocusEvent.loss:
        _isDucking = false;
        DebugLogger.log('[AudioFocusManager] Audio focus lost permanently', tag: 'AudioFocusManager');
        break;
      case AudioFocusEvent.lossTransient:
        _isDucking = false;
        DebugLogger.log('[AudioFocusManager] Audio focus lost temporarily', tag: 'AudioFocusManager');
        break;
      case AudioFocusEvent.lossTransientCanDuck:
        _isDucking = data.shouldDuck;
        DebugLogger.log('[AudioFocusManager] Audio focus lost - can duck: $_isDucking', tag: 'AudioFocusManager');
        break;
    }

    _focusController?.add(data);
  }

  /// Request audio focus for radio playback
  Future<bool> requestAudioFocus() async {
    try {
      final result = await _channel.invokeMethod<bool>('requestAudioFocus');
      _hasAudioFocus = result ?? false;

      if (_hasAudioFocus) {
        DebugLogger.log('[AudioFocusManager] Audio focus granted', tag: 'AudioFocusManager');
      } else {
        DebugLogger.log('[AudioFocusManager] Audio focus denied', tag: 'AudioFocusManager');
      }

      return _hasAudioFocus;
    } catch (e) {
      // If native code is not implemented, assume we have focus
      DebugLogger.log('[AudioFocusManager] Native audio focus not available, assuming focus granted', tag: 'AudioFocusManager');
      _hasAudioFocus = true;
      return true;
    }
  }

  /// Release audio focus
  Future<void> releaseAudioFocus() async {
    try {
      await _channel.invokeMethod('releaseAudioFocus');
      _hasAudioFocus = false;
      _isDucking = false;
      DebugLogger.log('[AudioFocusManager] Audio focus released', tag: 'AudioFocusManager');
    } catch (e) {
      DebugLogger.log('[AudioFocusManager] Native audio focus not available, releasing locally', tag: 'AudioFocusManager');
      _hasAudioFocus = false;
      _isDucking = false;
    }
  }

  /// Optimize audio session for streaming to prevent underruns
  Future<void> optimizeAudioSession() async {
    try {
      await _channel.invokeMethod('optimizeAudioSession');
      DebugLogger.log('[AudioFocusManager] Audio session optimized for streaming', tag: 'AudioFocusManager');
    } catch (e) {
      DebugLogger.log('[AudioFocusManager] Native audio session optimization not available', tag: 'AudioFocusManager');
    }
  }

  /// Set ducking volume (reduced volume during transient loss)
  Future<void> setDuckingVolume(double volume) async {
    try {
      _duckingVolume = volume.clamp(0.0, 1.0);
      await _channel.invokeMethod('setDuckingVolume', {'volume': _duckingVolume});
      DebugLogger.log('[AudioFocusManager] Ducking volume set to $_duckingVolume', tag: 'AudioFocusManager');
    } catch (e) {
      DebugLogger.log('[AudioFocusManager] Native ducking volume not available', tag: 'AudioFocusManager');
      _duckingVolume = volume.clamp(0.0, 1.0);
    }
  }

  /// Restore normal volume after ducking
  Future<void> restoreNormalVolume() async {
    try {
      await _channel.invokeMethod('restoreNormalVolume');
      _isDucking = false;
      DebugLogger.log('[AudioFocusManager] Normal volume restored', tag: 'AudioFocusManager');
    } catch (e) {
      DebugLogger.log('[AudioFocusManager] Native volume restore not available', tag: 'AudioFocusManager');
      _isDucking = false;
    }
  }

  /// Stream of audio focus changes with event details
  Stream<AudioFocusEventData> get focusEventStream {
    _focusController ??= StreamController<AudioFocusEventData>.broadcast();
    return _focusController!.stream;
  }

  /// Legacy stream for backward compatibility
  Stream<bool> get focusStream {
    return focusEventStream.map((data) => data.hasFocus);
  }

  /// Check if we currently have audio focus
  bool get hasAudioFocus => _hasAudioFocus;

  /// Check if we're currently ducking
  bool get isDucking => _isDucking;

  /// Get current ducking volume
  double get duckingVolume => _duckingVolume;

  void dispose() {
    _focusController?.close();
    _focusController = null;
  }
}

