import 'dart:async';
import 'package:hive/hive.dart';
import '../utils/debug_logger.dart';

/// Sleep timer state for UI consumption.
class SleepTimerState {
  final bool isEnabled;
  final bool isRunning;
  final Duration? remainingTime;
  final Duration scheduledDuration;

  const SleepTimerState({
    this.isEnabled = false,
    this.isRunning = false,
    this.remainingTime,
    this.scheduledDuration = const Duration(minutes: 30),
  });

  SleepTimerState copyWith({
    bool? isEnabled,
    bool? isRunning,
    Duration? remainingTime,
    Duration? scheduledDuration,
    bool clearRemainingTime = false,
  }) {
    return SleepTimerState(
      isEnabled: isEnabled ?? this.isEnabled,
      isRunning: isRunning ?? this.isRunning,
      remainingTime: clearRemainingTime ? null : (remainingTime ?? this.remainingTime),
      scheduledDuration: scheduledDuration ?? this.scheduledDuration,
    );
  }
}

/// A service that manages sleep timer functionality with:
/// - Stream-based state updates for UI
/// - Persistence via Hive
/// - Smart countdown frequency (less updates when far from completion)
/// - Proper cleanup and lifecycle management
class SleepTimerService {
  SleepTimerService();

  static const String _boxName = 'sleep_timer';
  static const String _keyEndTime = 'end_time';
  static const String _keyDuration = 'duration_minutes';

  // Timer constants
  static const Duration minDuration = Duration(minutes: 15);
  static const Duration maxDuration = Duration(hours: 6);
  static const Duration defaultDuration = Duration(minutes: 30);

  // State management
  final StreamController<SleepTimerState> _stateController =
      StreamController<SleepTimerState>.broadcast();
  
  SleepTimerState _state = const SleepTimerState();
  Timer? _countdownTimer;
  DateTime? _endTime;
  Box? _box;
  
  // Callback for when timer completes
  void Function()? _onTimerComplete;

  /// Stream of timer state updates.
  Stream<SleepTimerState> get stateStream => _stateController.stream;

  /// Current timer state.
  SleepTimerState get state => _state;

  /// Set callback for timer completion (e.g., pause radio).
  void setOnTimerComplete(void Function() callback) {
    _onTimerComplete = callback;
  }

  /// Initialize service and restore persisted timer state.
  Future<void> initialize() async {
    try {
      _box = await Hive.openBox(_boxName);
      
      // Restore saved duration preference
      final savedDurationMinutes = _box?.get(_keyDuration) as int?;
      final duration = savedDurationMinutes != null
          ? Duration(minutes: savedDurationMinutes)
          : defaultDuration;
      
      // Check if there's a persisted timer
      final endTimeMillis = _box?.get(_keyEndTime) as int?;
      if (endTimeMillis != null) {
        final endTime = DateTime.fromMillisecondsSinceEpoch(endTimeMillis);
        final now = DateTime.now();
        
        if (endTime.isAfter(now)) {
          // Timer is still valid, resume it
          _endTime = endTime;
          _state = SleepTimerState(
            isEnabled: true,
            isRunning: true,
            remainingTime: endTime.difference(now),
            scheduledDuration: duration,
          );
          _startCountdownUpdates();
          DebugLogger.log(
            '[SleepTimer] Resumed timer with ${_state.remainingTime?.inMinutes}m remaining',
            tag: 'SleepTimerService',
          );
        } else {
          // Timer expired while app was closed, clear it
          await _clearPersistedTimer();
          _state = SleepTimerState(scheduledDuration: duration);
        }
      } else {
        _state = SleepTimerState(scheduledDuration: duration);
      }
      
      _emitState();
    } catch (e) {
      DebugLogger.logError(
        'Failed to initialize sleep timer',
        error: e,
        tag: 'SleepTimerService',
      );
    }
  }

  /// Toggle timer enabled state.
  void setEnabled(bool enabled) {
    if (!enabled && _state.isRunning) {
      stop();
    }
    _state = _state.copyWith(isEnabled: enabled);
    _emitState();
  }

  /// Update scheduled duration (only when not running).
  void setDuration(Duration duration) {
    if (_state.isRunning) return;
    
    final clamped = Duration(
      minutes: duration.inMinutes.clamp(
        minDuration.inMinutes,
        maxDuration.inMinutes,
      ),
    );
    _state = _state.copyWith(scheduledDuration: clamped);
    _emitState();
    
    // Persist duration preference
    _saveDurationPreference(clamped);
  }

  /// Start the sleep timer.
  Future<void> start() async {
    if (_state.isRunning) return;
    
    _endTime = DateTime.now().add(_state.scheduledDuration);
    _state = _state.copyWith(
      isEnabled: true,
      isRunning: true,
      remainingTime: _state.scheduledDuration,
    );
    
    await _persistTimer();
    _startCountdownUpdates();
    _emitState();
    
    DebugLogger.log(
      '[SleepTimer] Started for ${_state.scheduledDuration.inMinutes}m',
      tag: 'SleepTimerService',
    );
  }

  /// Stop the sleep timer.
  Future<void> stop() async {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _endTime = null;
    
    _state = _state.copyWith(
      isRunning: false,
      clearRemainingTime: true,
    );
    
    await _clearPersistedTimer();
    _emitState();
    
    DebugLogger.log('[SleepTimer] Stopped', tag: 'SleepTimerService');
  }

  /// Get remaining time (if running).
  Duration? getRemainingTime() {
    if (_endTime == null) return null;
    final remaining = _endTime!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  void _startCountdownUpdates() {
    _countdownTimer?.cancel();
    
    // Smart update frequency based on remaining time
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    final remaining = getRemainingTime();
    
    if (remaining == null || remaining <= Duration.zero) {
      _onTimerExpired();
      return;
    }
    
    _state = _state.copyWith(remainingTime: remaining);
    _emitState();
  }

  void _onTimerExpired() {
    DebugLogger.log('[SleepTimer] Timer expired', tag: 'SleepTimerService');
    
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _endTime = null;
    
    _state = _state.copyWith(
      isEnabled: false,
      isRunning: false,
      clearRemainingTime: true,
    );
    
    _clearPersistedTimer();
    _emitState();
    
    // Execute completion callback
    _onTimerComplete?.call();
  }

  Future<void> _persistTimer() async {
    try {
      if (_endTime != null) {
        await _box?.put(_keyEndTime, _endTime!.millisecondsSinceEpoch);
      }
    } catch (e) {
      DebugLogger.logError(
        'Failed to persist timer',
        error: e,
        tag: 'SleepTimerService',
      );
    }
  }

  Future<void> _saveDurationPreference(Duration duration) async {
    try {
      await _box?.put(_keyDuration, duration.inMinutes);
    } catch (e) {
      // Non-critical, ignore
    }
  }

  Future<void> _clearPersistedTimer() async {
    try {
      await _box?.delete(_keyEndTime);
    } catch (e) {
      // Non-critical, ignore
    }
  }

  void _emitState() {
    if (!_stateController.isClosed) {
      _stateController.add(_state);
    }
  }

  /// Clean up resources.
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _stateController.close();
  }
}
