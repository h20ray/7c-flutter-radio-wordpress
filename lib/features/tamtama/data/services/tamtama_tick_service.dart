import 'dart:async';

import '../../domain/entities/tamtama_entity.dart';
import '../models/tamtama_model.dart';

/// Types of ticks in the multi-tier timer system
enum TickType {
  /// 1 minute - needs decay (hunger, energy, hygiene)
  base,
  
  /// 5 minutes - radio rewards application
  reward,
  
  /// 10 minutes - auto-save to persistent storage
  autoSave,
  
  /// 30 minutes - evolution window check
  evolutionCheck,
}

/// Event emitted by tiered tick system
class TieredTickEvent {
  final TickType type;
  final TamtamaTickDelta? delta;
  final int tickCount; // Total base ticks since start
  
  const TieredTickEvent({
    required this.type,
    this.delta,
    this.tickCount = 0,
  });
}

/// Data class representing changes from a tick
class TamtamaTickDelta {
  final double hungerDelta;
  final double energyDelta;
  final double happinessDelta;
  final double hygieneDelta;
  final double affectionDelta;
  final double stressDelta;
  final double healthDelta;
  final double neglectScoreDelta;
  final double xpDelta;
  final int minutesElapsed;

  const TamtamaTickDelta({
    this.hungerDelta = 0.0,
    this.energyDelta = 0.0,
    this.happinessDelta = 0.0,
    this.hygieneDelta = 0.0,
    this.affectionDelta = 0.0,
    this.stressDelta = 0.0,
    this.healthDelta = 0.0,
    this.neglectScoreDelta = 0.0,
    this.xpDelta = 0.0,
    this.minutesElapsed = 0,
  });

  TamtamaTickDelta operator +(TamtamaTickDelta other) {
    return TamtamaTickDelta(
      hungerDelta: hungerDelta + other.hungerDelta,
      energyDelta: energyDelta + other.energyDelta,
      happinessDelta: happinessDelta + other.happinessDelta,
      hygieneDelta: hygieneDelta + other.hygieneDelta,
      affectionDelta: affectionDelta + other.affectionDelta,
      stressDelta: stressDelta + other.stressDelta,
      healthDelta: healthDelta + other.healthDelta,
      neglectScoreDelta: neglectScoreDelta + other.neglectScoreDelta,
      xpDelta: xpDelta + other.xpDelta,
      minutesElapsed: minutesElapsed + other.minutesElapsed,
    );
  }
}

/// Service for managing real-time tick updates to TamTama stats
class TamtamaTickService {
  Timer? _tickTimer;
  void Function(TamtamaTickDelta delta)? _onTick;
  void Function(TieredTickEvent event)? _onTieredTick;
  bool _isListening = false;
  int _baseTickCount = 0;
  
  // Stream controller for tiered ticks
  final StreamController<TieredTickEvent> _tickStreamController = 
      StreamController<TieredTickEvent>.broadcast();

  /// Tick intervals as per blueprint
  static const int rewardTickMinutes = 5;    // Every 5 min: radio rewards
  static const int autoSaveMinutes = 10;     // Every 10 min: auto-save
  static const int evolutionCheckMinutes = 30; // Every 30 min: evolution check

  /// Decay rates per minute (when not sleeping)
  static const double hungerDecayPerMinute = 0.15; // ~11 hours to empty
  static const double energyDecayPerMinute = 0.10; // ~16 hours to empty
  static const double hygieneDecayPerMinute = 0.05; // ~33 hours to dirty
  static const double happinessDecayPerMinute = 0.03; // Very slow drift
  static const double stressGainPerMinute = 0.02; // Slow drift up

  /// Listening bonuses per minute
  static const double happinessGainWhileListening = 0.3;
  static const double stressReductionWhileListening = 0.2;
  static const double affectionGainWhileListening = 0.05;
  static const double energyDrainWhileListening = 0.05; // Mental fatigue

  /// Sleep recovery rates per minute
  static const double energyRecoveryWhileSleeping = 0.8;
  static const double stressReductionWhileSleeping = 0.1;
  static const double hungerDecayWhileSleeping = 0.05;
  
  /// Stream of tiered tick events for reactive listening
  Stream<TieredTickEvent> get tieredTickStream => _tickStreamController.stream;

  /// Start the tick timer (1 tick per minute)
  void startTicking(void Function(TamtamaTickDelta delta) onTick) {
    _onTick = onTick;
    _tickTimer?.cancel();
    _baseTickCount = 0;
    _tickTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _handleBaseTick();
    });
  }
  
  /// Start with tiered tick callback support
  void startTieredTicking({
    required void Function(TamtamaTickDelta delta) onBaseTick,
    void Function(TieredTickEvent event)? onTieredTick,
  }) {
    _onTick = onBaseTick;
    _onTieredTick = onTieredTick;
    _tickTimer?.cancel();
    _baseTickCount = 0;
    _tickTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _handleBaseTick();
    });
  }
  
  void _handleBaseTick() {
    _baseTickCount++;
    
    // Always compute and emit base tick delta
    final delta = computeTickDelta();
    _onTick?.call(delta);
    
    // Emit base tick event
    final baseEvent = TieredTickEvent(
      type: TickType.base,
      delta: delta,
      tickCount: _baseTickCount,
    );
    _tickStreamController.add(baseEvent);
    _onTieredTick?.call(baseEvent);
    
    // Check for reward tick (every 5 min)
    if (_baseTickCount % rewardTickMinutes == 0) {
      final rewardEvent = TieredTickEvent(
        type: TickType.reward,
        tickCount: _baseTickCount,
      );
      _tickStreamController.add(rewardEvent);
      _onTieredTick?.call(rewardEvent);
    }
    
    // Check for auto-save tick (every 10 min)
    if (_baseTickCount % autoSaveMinutes == 0) {
      final saveEvent = TieredTickEvent(
        type: TickType.autoSave,
        tickCount: _baseTickCount,
      );
      _tickStreamController.add(saveEvent);
      _onTieredTick?.call(saveEvent);
    }
    
    // Check for evolution check tick (every 30 min)
    if (_baseTickCount % evolutionCheckMinutes == 0) {
      final evolutionEvent = TieredTickEvent(
        type: TickType.evolutionCheck,
        tickCount: _baseTickCount,
      );
      _tickStreamController.add(evolutionEvent);
      _onTieredTick?.call(evolutionEvent);
    }
  }

  /// Stop the tick timer
  void stopTicking() {
    _tickTimer?.cancel();
    _tickTimer = null;
  }

  /// Set whether the user is currently listening to radio
  void setListening(bool isListening) {
    _isListening = isListening;
  }

  /// Compute stat deltas for a single tick
  TamtamaTickDelta computeTickDelta({
    bool? isListening,
    bool isSleeping = false,
    TamtamaEntity? current,
  }) {
    final listening = isListening ?? _isListening;

    if (isSleeping) {
      return const TamtamaTickDelta(
        hungerDelta: -hungerDecayWhileSleeping,
        energyDelta: energyRecoveryWhileSleeping,
        stressDelta: -stressReductionWhileSleeping,
        minutesElapsed: 1,
      );
    }

    if (listening) {
      // Check if pet is in poor condition while listening
      final isInPoorCondition = current != null &&
          (current.hunger < 20 || current.energy < 20);

      if (isInPoorCondition) {
        // Reduced benefits when neglected
        return const TamtamaTickDelta(
          hungerDelta: -hungerDecayPerMinute,
          energyDelta: -energyDecayPerMinute,
          happinessDelta: 0.05, // Minimal gain
          hygieneDelta: -hygieneDecayPerMinute,
          stressDelta: 0.2, // Actually increases stress
          minutesElapsed: 1,
        );
      }

      // Normal listening benefits
      return const TamtamaTickDelta(
        hungerDelta: -hungerDecayPerMinute,
        energyDelta: -energyDrainWhileListening,
        happinessDelta: happinessGainWhileListening - happinessDecayPerMinute,
        hygieneDelta: -hygieneDecayPerMinute,
        affectionDelta: affectionGainWhileListening,
        stressDelta: -stressReductionWhileListening + stressGainPerMinute,
        minutesElapsed: 1,
      );
    }

    // Idle state - passive decay
    return const TamtamaTickDelta(
      hungerDelta: -hungerDecayPerMinute,
      energyDelta: -energyDecayPerMinute,
      happinessDelta: -happinessDecayPerMinute,
      hygieneDelta: -hygieneDecayPerMinute,
      stressDelta: stressGainPerMinute,
      minutesElapsed: 1,
    );
  }

  /// Compute catch-up deltas when app resumes from background
  TamtamaTickDelta computeOfflineTicks({
    required DateTime lastUpdateAt,
    required TamtamaEntity current,
  }) {
    final now = DateTime.now();
    final elapsedMinutes = now.difference(lastUpdateAt).inMinutes;

    if (elapsedMinutes <= 0) {
      return const TamtamaTickDelta();
    }

    // Cap offline simulation at 24 hours to prevent extreme stat drops
    final cappedMinutes = elapsedMinutes.clamp(0, 24 * 60);

    // Assume idle state during offline (no listening/sleeping benefits)
    // Apply reduced decay to be forgiving
    const offlineDecayMultiplier = 0.5; // 50% of normal decay when offline

    return TamtamaTickDelta(
      hungerDelta: -hungerDecayPerMinute * cappedMinutes * offlineDecayMultiplier,
      energyDelta: -energyDecayPerMinute * cappedMinutes * offlineDecayMultiplier,
      happinessDelta: -happinessDecayPerMinute * cappedMinutes * offlineDecayMultiplier,
      hygieneDelta: -hygieneDecayPerMinute * cappedMinutes * offlineDecayMultiplier,
      stressDelta: stressGainPerMinute * cappedMinutes * offlineDecayMultiplier,
      minutesElapsed: cappedMinutes,
    );
  }

  /// Apply tick delta to entity and return updated model
  TamtamaModel applyDelta(TamtamaEntity entity, TamtamaTickDelta delta) {
    // Calculate need pressure for neglect/health
    final isStarving = entity.hunger < 10;
    final isDirty = entity.hygiene < 20;
    final isOvertired = entity.energy < 10;

    final needPressure = (isStarving ? 0.4 : 0.0) +
        (isDirty ? 0.25 : 0.0) +
        (isOvertired ? 0.2 : 0.0);

    final neglectDelta = 0.3 * needPressure * delta.minutesElapsed;
    final healthDelta = -0.25 * needPressure * delta.minutesElapsed;

    return TamtamaModel.fromEntity(entity.copyWith(
      hunger: (entity.hunger + delta.hungerDelta).clamp(0.0, 100.0),
      energy: (entity.energy + delta.energyDelta).clamp(0.0, 100.0),
      happiness: (entity.happiness + delta.happinessDelta).clamp(0.0, 100.0),
      hygiene: (entity.hygiene + delta.hygieneDelta).clamp(0.0, 100.0),
      affection: (entity.affection + delta.affectionDelta).clamp(0.0, 100.0),
      stress: (entity.stress + delta.stressDelta).clamp(0.0, 100.0),
      health: (entity.health + healthDelta).clamp(0.0, 100.0),
      neglectScore: (entity.neglectScore + neglectDelta).clamp(0.0, 100.0),
      xp: entity.xp + delta.xpDelta,
      lastUpdateAt: DateTime.now(),
    ));
  }

  void dispose() {
    stopTicking();
    _tickStreamController.close();
  }
}
