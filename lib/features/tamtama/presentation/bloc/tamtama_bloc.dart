import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/services/tamtama_tick_service.dart';
import '../../domain/entities/tamtama_economy_entity.dart';
import '../../domain/entities/tamtama_entity.dart';
import '../../domain/usecases/add_listening_rewards.dart';
import '../../domain/usecases/apply_offline_ticks.dart';
import '../../domain/usecases/apply_tick.dart';
import '../../domain/usecases/clean_pet.dart';
import '../../domain/usecases/evolve_pet.dart';
import '../../domain/usecases/feed_pet.dart';
import '../../domain/usecases/get_economy.dart';
import '../../domain/usecases/get_tamtama.dart';
import '../../domain/usecases/play_with_pet.dart';
import '../../domain/usecases/save_tamtama.dart';
import '../../domain/usecases/set_sleep_mode.dart';
import '../../domain/usecases/watch_economy.dart';
import '../../domain/usecases/watch_tamtama.dart';

part 'tamtama_bloc.freezed.dart';
part 'tamtama_event.dart';
part 'tamtama_state.dart';

/// BLoC for managing TamTama virtual pet state
class TamtamaBloc extends Bloc<TamtamaEvent, TamtamaState> {
  final TamtamaTickService tickService;
  final GetTamtama getTamtama;
  final SaveTamtama saveTamtama;
  final GetEconomy getEconomy;
  final WatchTamtama watchTamtama;
  final WatchEconomy watchEconomy;
  final FeedPet feedPet;
  final PlayWithPet playWithPet;
  final CleanPet cleanPet;
  final SetSleepMode setSleepMode;
  final ApplyTick applyTick;
  final ApplyOfflineTicks applyOfflineTicks;
  final AddListeningRewards addListeningRewards;
  final EvolvePet evolvePet;
  final String userId;

  StreamSubscription? _tamtamaSubscription;
  StreamSubscription? _economySubscription;
  StreamSubscription<TieredTickEvent>? _tieredTickSubscription;
  Timer? _tickTimer;
  bool _isListening = false;
  
  // Teen stage listening tracking for evolution scoring
  int _teenListeningMinutes = 0;
  int _teenDaysTracked = 0;

  TamtamaBloc({
    required this.tickService,
    required this.getTamtama,
    required this.saveTamtama,
    required this.getEconomy,
    required this.watchTamtama,
    required this.watchEconomy,
    required this.feedPet,
    required this.playWithPet,
    required this.cleanPet,
    required this.setSleepMode,
    required this.applyTick,
    required this.applyOfflineTicks,
    required this.addListeningRewards,
    required this.evolvePet,
    this.userId = 'local_user',
  }) : super(const TamtamaState.initial()) {
    // Lifecycle
    on<LoadTamtamaEvent>(_onLoad);
    on<TamtamaUpdatedEvent>(_onTamtamaUpdated);
    on<EconomyUpdatedEvent>(_onEconomyUpdated);
    on<TamtamaErrorEvent>(_onError);
    
    // Care Actions
    on<FeedPetEvent>(_onFeedPet);
    on<PlayWithPetEvent>(_onPlayWithPet);
    on<CleanPetEvent>(_onCleanPet);
    on<ToggleSleepEvent>(_onToggleSleep);
    
    // Tick System
    on<TickEvent>(_onTick);
    on<RewardTickEvent>(_onRewardTick);
    on<AutoSaveTickEvent>(_onAutoSaveTick);
    on<EvolutionCheckTickEvent>(_onEvolutionCheckTick);
    on<CheckEvolutionEvent>(_onCheckEvolution);
    on<ApplyOfflineTicksEvent>(_onApplyOfflineTicks);
    
    // Radio Integration
    on<ListeningTickEvent>(_onListeningTick);
    on<SetListeningEvent>(_onSetListening);
    
    // Debug
    on<DebugSetStatsEvent>(_onDebugSetStats);
    on<DebugAddCoinsEvent>(_onDebugAddCoins);
  }

  // --- Lifecycle ---

  Future<void> _onLoad(LoadTamtamaEvent event, Emitter<TamtamaState> emit) async {
    emit(const TamtamaState.loading());
    
    // Apply offline ticks first
    await applyOfflineTicks(ApplyOfflineTicksParams(userId));
    
    // Fetch current state
    final petResult = await getTamtama(GetTamtamaParams(userId));
    final economyResult = await getEconomy(GetEconomyParams(userId));
    
    petResult.fold(
      (failure) => emit(TamtamaState.error(failure.message)),
      (tamtama) {
        economyResult.fold(
          (failure) => emit(TamtamaState.error(failure.message)),
          (economy) {
            emit(TamtamaState.loaded(
              tamtama: tamtama,
              economy: economy,
              isListening: _isListening,
            ));
            _startSubscriptions();
            _startTickTimer();
          },
        );
      },
    );
  }

  void _onTamtamaUpdated(TamtamaUpdatedEvent event, Emitter<TamtamaState> emit) {
    state.maybeWhen(
      loaded: (_, economy, isListening) {
        emit(TamtamaState.loaded(
          tamtama: event.tamtama,
          economy: economy,
          isListening: isListening,
        ));
      },
      orElse: () {
        // If not loaded yet, just store the tamtama
      },
    );
  }

  void _onEconomyUpdated(EconomyUpdatedEvent event, Emitter<TamtamaState> emit) {
    state.maybeWhen(
      loaded: (tamtama, _, isListening) {
        emit(TamtamaState.loaded(
          tamtama: tamtama,
          economy: event.economy,
          isListening: isListening,
        ));
      },
      orElse: () {},
    );
  }

  void _onError(TamtamaErrorEvent event, Emitter<TamtamaState> emit) {
    emit(TamtamaState.error(event.message));
  }

  // --- Care Actions ---

  Future<void> _onFeedPet(FeedPetEvent event, Emitter<TamtamaState> emit) async {
    final food = event.food ?? FoodType.snack;
    final result = await feedPet(FeedPetParams(userId: userId, food: food));
    
    result.fold(
      (failure) {
        // Don't change state, just log error
        // Could emit a snackbar event here
      },
      (tamtama) => add(TamtamaEvent.updated(tamtama)),
    );
    
    // Refresh economy
    final economyResult = await getEconomy(GetEconomyParams(userId));
    economyResult.fold(
      (failure) {},
      (economy) => add(TamtamaEvent.economyUpdated(economy)),
    );
  }

  Future<void> _onPlayWithPet(PlayWithPetEvent event, Emitter<TamtamaState> emit) async {
    final activity = event.activity ?? ActivityType.quickPlay;
    final result = await playWithPet(PlayWithPetParams(userId: userId, activity: activity));
    
    result.fold(
      (failure) {},
      (tamtama) => add(TamtamaEvent.updated(tamtama)),
    );
    
    final economyResult = await getEconomy(GetEconomyParams(userId));
    economyResult.fold(
      (failure) {},
      (economy) => add(TamtamaEvent.economyUpdated(economy)),
    );
  }

  Future<void> _onCleanPet(CleanPetEvent event, Emitter<TamtamaState> emit) async {
    final result = await cleanPet(CleanPetParams(userId));
    
    result.fold(
      (failure) {},
      (tamtama) => add(TamtamaEvent.updated(tamtama)),
    );
    
    final economyResult = await getEconomy(GetEconomyParams(userId));
    economyResult.fold(
      (failure) {},
      (economy) => add(TamtamaEvent.economyUpdated(economy)),
    );
  }

  Future<void> _onToggleSleep(ToggleSleepEvent event, Emitter<TamtamaState> emit) async {
    final currentState = state;
    if (currentState is! TamtamaLoaded) return;
    
    final isSleeping = currentState.tamtama.petState == PetState.sleeping;
    final result = await setSleepMode(SetSleepModeParams(userId: userId, sleeping: !isSleeping));
    
    result.fold(
      (failure) {},
      (tamtama) => add(TamtamaEvent.updated(tamtama)),
    );
  }

  // --- Tick System ---

  Future<void> _onTick(TickEvent event, Emitter<TamtamaState> emit) async {
    final currentState = state;
    if (currentState is! TamtamaLoaded) return;
    
    final isSleeping = currentState.tamtama.petState == PetState.sleeping;
    
    final result = await applyTick(
      ApplyTickParams(
        userId: userId,
        isListening: _isListening,
        isSleeping: isSleeping,
      ),
    );
    
    result.fold(
      (failure) {},
      (tamtama) {
        add(TamtamaEvent.updated(tamtama));
        // Track listening for teen stage evolution scoring
        if (_isListening && tamtama.lifeStage == LifeStage.teen) {
          _teenListeningMinutes++;
        }
      },
    );
  }

  /// Handle reward tick (every 5 minutes) - apply radio listening rewards
  Future<void> _onRewardTick(RewardTickEvent event, Emitter<TamtamaState> emit) async {
    if (!_isListening) return;
    
    final currentState = state;
    if (currentState is! TamtamaLoaded) return;
    
    // Apply 5 minutes of listening rewards
    final result = await addListeningRewards(
      AddListeningRewardsParams(
        userId: userId,
        minutes: TamtamaTickService.rewardTickMinutes,
        stationId: 'default',
      ),
    );
    
    result.fold(
      (failure) {},
      (economy) => add(TamtamaEvent.economyUpdated(economy)),
    );
  }

  /// Handle auto-save tick (every 10 minutes) - persist current state
  Future<void> _onAutoSaveTick(AutoSaveTickEvent event, Emitter<TamtamaState> emit) async {
    final currentState = state;
    if (currentState is! TamtamaLoaded) return;
    
    // Force save current state
    await saveTamtama(SaveTamtamaParams(currentState.tamtama));
    
    // Update teen stage averages if in teen stage
    if (currentState.tamtama.lifeStage == LifeStage.teen) {
      _teenDaysTracked++;
      await _updateTeenAverages(currentState.tamtama, emit);
    }
  }

  /// Handle evolution check tick (every 30 minutes) - check for evolution
  Future<void> _onEvolutionCheckTick(EvolutionCheckTickEvent event, Emitter<TamtamaState> emit) async {
    add(const TamtamaEvent.checkEvolution());
  }

  /// Update teen stage averages for evolution scoring
  Future<void> _updateTeenAverages(TamtamaEntity tamtama, Emitter<TamtamaState> emit) async {
    // Calculate running average of listening minutes
    final avgListeningPerDay = _teenDaysTracked > 0 
        ? _teenListeningMinutes / _teenDaysTracked 
        : 0.0;
    
    // Calculate current happiness/stress/affection as running average
    const alpha = 0.1; // Smoothing factor for exponential moving average
    final newAvgHappiness = tamtama.avgHappiness * (1 - alpha) + (tamtama.happiness / 100.0) * alpha;
    final newAvgStress = tamtama.avgStress * (1 - alpha) + (tamtama.stress / 100.0) * alpha;
    final newAvgAffection = tamtama.avgAffection * (1 - alpha) + (tamtama.affection / 100.0) * alpha;
    
    final updated = tamtama.copyWith(
      avgListeningMinutesPerDay: avgListeningPerDay,
      avgHappiness: newAvgHappiness,
      avgStress: newAvgStress,
      avgAffection: newAvgAffection,
      neglectScoreTeen: tamtama.neglectScore, // Snapshot current neglect
    );
    
    final result = await saveTamtama(SaveTamtamaParams(updated));
    result.fold(
      (failure) {},
      (saved) => add(TamtamaEvent.updated(saved)),
    );
  }

  Future<void> _onCheckEvolution(CheckEvolutionEvent event, Emitter<TamtamaState> emit) async {
    final result = await evolvePet(EvolvePetParams(userId: userId));
    
    result.fold(
      (failure) {
        // Silent failure for evolution check is fine
      },
      (tamtama) {
        // If state changed (evolved), this will trigger update
        add(TamtamaEvent.updated(tamtama));
      },
    );
  }

  Future<void> _onApplyOfflineTicks(ApplyOfflineTicksEvent event, Emitter<TamtamaState> emit) async {
    final result = await applyOfflineTicks(ApplyOfflineTicksParams(userId));
    
    result.fold(
      (failure) {},
      (tamtama) => add(TamtamaEvent.updated(tamtama)),
    );
  }

  // --- Radio Integration ---

  Future<void> _onListeningTick(ListeningTickEvent event, Emitter<TamtamaState> emit) async {
    final result = await addListeningRewards(
      AddListeningRewardsParams(
        userId: userId,
        minutes: event.minutes,
        stationId: event.stationId,
      ),
    );
    
    result.fold(
      (failure) {},
      (economy) => add(TamtamaEvent.economyUpdated(economy)),
    );
    
    // Also fetch updated pet (XP increased)
    final petResult = await getTamtama(GetTamtamaParams(userId));
    petResult.fold(
      (failure) {},
      (tamtama) => add(TamtamaEvent.updated(tamtama)),
    );
  }

  void _onSetListening(SetListeningEvent event, Emitter<TamtamaState> emit) {
    _isListening = event.isListening;
    tickService.setListening(event.isListening);
    
    state.maybeWhen(
      loaded: (tamtama, economy, _) {
        emit(TamtamaState.loaded(
          tamtama: tamtama,
          economy: economy,
          isListening: event.isListening,
        ));
      },
      orElse: () {},
    );
  }

  // --- Debug ---

  Future<void> _onDebugSetStats(DebugSetStatsEvent event, Emitter<TamtamaState> emit) async {
    final currentState = state;
    if (currentState is! TamtamaLoaded) return;
    
    final current = currentState.tamtama;
    final updated = current.copyWith(
      hunger: event.hunger ?? current.hunger,
      energy: event.energy ?? current.energy,
      happiness: event.happiness ?? current.happiness,
      hygiene: event.hygiene ?? current.hygiene,
      affection: event.affection ?? current.affection,
      stress: event.stress ?? current.stress,
      health: event.health ?? current.health,
      lastUpdateAt: DateTime.now(),
    );
    
    final result = await saveTamtama(SaveTamtamaParams(updated));
    result.fold(
      (failure) {},
      (tamtama) => add(TamtamaEvent.updated(tamtama)),
    );
  }

  Future<void> _onDebugAddCoins(DebugAddCoinsEvent event, Emitter<TamtamaState> emit) async {
    final currentState = state;
    if (currentState is! TamtamaLoaded) return;
    
    final current = currentState.economy;
    final updated = current.copyWith(
      coins: current.coins + event.amount,
      lastUpdatedAt: DateTime.now(),
    );
    
    // Need to save via data source directly for debug
    add(TamtamaEvent.economyUpdated(updated));
  }

  // --- Private Helpers ---

  void _startSubscriptions() {
    _tamtamaSubscription?.cancel();
    _tamtamaSubscription = watchTamtama(userId).listen((result) {
      result.fold(
        (failure) => add(TamtamaEvent.error(failure.message)),
        (tamtama) => add(TamtamaEvent.updated(tamtama)),
      );
    });

    _economySubscription?.cancel();
    _economySubscription = watchEconomy(userId).listen((result) {
      result.fold(
        (failure) {},
        (economy) => add(TamtamaEvent.economyUpdated(economy)),
      );
    });
  }

  void _startTickTimer() {
    _tickTimer?.cancel();
    _tieredTickSubscription?.cancel();
    
    // Subscribe to tiered tick stream for multi-interval events
    _tieredTickSubscription = tickService.tieredTickStream.listen((event) {
      switch (event.type) {
        case TickType.base:
          add(const TamtamaEvent.tick());
          break;
        case TickType.reward:
          add(const TamtamaEvent.rewardTick());
          break;
        case TickType.autoSave:
          add(const TamtamaEvent.autoSaveTick());
          break;
        case TickType.evolutionCheck:
          add(const TamtamaEvent.evolutionCheckTick());
          break;
      }
    });
    
    // Start the tick service (this emits to the stream)
    tickService.startTicking((delta) {
      // Base tick deltas are handled via stream events
    });
  }

  @override
  Future<void> close() {
    _tamtamaSubscription?.cancel();
    _economySubscription?.cancel();
    _tieredTickSubscription?.cancel();
    _tickTimer?.cancel();
    tickService.dispose();
    return super.close();
  }
}
