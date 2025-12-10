import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/tamtama_entity.dart';
import '../../domain/entities/tamtama_economy_entity.dart';
import '../../domain/repositories/tamtama_repository.dart';
import '../../data/services/tamtama_tick_service.dart';

part 'tamtama_bloc.freezed.dart';
part 'tamtama_event.dart';
part 'tamtama_state.dart';

/// BLoC for managing TamTama virtual pet state
class TamtamaBloc extends Bloc<TamtamaEvent, TamtamaState> {
  final TamtamaRepository repository;
  final TamtamaTickService tickService;
  final String userId;

  StreamSubscription? _tamtamaSubscription;
  StreamSubscription? _economySubscription;
  Timer? _tickTimer;
  bool _isListening = false;

  TamtamaBloc({
    required this.repository,
    required this.tickService,
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
    await repository.applyOfflineTicks(userId);
    
    // Fetch current state
    final petResult = await repository.fetch(userId);
    final economyResult = await repository.getEconomy(userId);
    
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
    final result = await repository.feedPet(userId, food);
    
    result.fold(
      (failure) {
        // Don't change state, just log error
        // Could emit a snackbar event here
      },
      (tamtama) => add(TamtamaEvent.updated(tamtama)),
    );
    
    // Refresh economy
    final economyResult = await repository.getEconomy(userId);
    economyResult.fold(
      (failure) {},
      (economy) => add(TamtamaEvent.economyUpdated(economy)),
    );
  }

  Future<void> _onPlayWithPet(PlayWithPetEvent event, Emitter<TamtamaState> emit) async {
    final activity = event.activity ?? ActivityType.quickPlay;
    final result = await repository.playWithPet(userId, activity);
    
    result.fold(
      (failure) {},
      (tamtama) => add(TamtamaEvent.updated(tamtama)),
    );
    
    final economyResult = await repository.getEconomy(userId);
    economyResult.fold(
      (failure) {},
      (economy) => add(TamtamaEvent.economyUpdated(economy)),
    );
  }

  Future<void> _onCleanPet(CleanPetEvent event, Emitter<TamtamaState> emit) async {
    final result = await repository.cleanPet(userId);
    
    result.fold(
      (failure) {},
      (tamtama) => add(TamtamaEvent.updated(tamtama)),
    );
    
    final economyResult = await repository.getEconomy(userId);
    economyResult.fold(
      (failure) {},
      (economy) => add(TamtamaEvent.economyUpdated(economy)),
    );
  }

  Future<void> _onToggleSleep(ToggleSleepEvent event, Emitter<TamtamaState> emit) async {
    final currentState = state;
    if (currentState is! TamtamaLoaded) return;
    
    final isSleeping = currentState.tamtama.petState == PetState.sleeping;
    final result = await repository.setSleepMode(userId, !isSleeping);
    
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
    
    final result = await repository.applyTick(
      userId,
      isListening: _isListening,
      isSleeping: isSleeping,
    );
    
    result.fold(
      (failure) {},
      (tamtama) => add(TamtamaEvent.updated(tamtama)),
    );
  }

  Future<void> _onApplyOfflineTicks(ApplyOfflineTicksEvent event, Emitter<TamtamaState> emit) async {
    final result = await repository.applyOfflineTicks(userId);
    
    result.fold(
      (failure) {},
      (tamtama) => add(TamtamaEvent.updated(tamtama)),
    );
  }

  // --- Radio Integration ---

  Future<void> _onListeningTick(ListeningTickEvent event, Emitter<TamtamaState> emit) async {
    final result = await repository.addListeningRewards(
      userId,
      event.minutes,
      event.stationId,
    );
    
    result.fold(
      (failure) {},
      (economy) => add(TamtamaEvent.economyUpdated(economy)),
    );
    
    // Also fetch updated pet (XP increased)
    final petResult = await repository.fetch(userId);
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
    
    final result = await repository.save(updated);
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
    _tamtamaSubscription = repository.watch(userId).listen((result) {
      result.fold(
        (failure) => add(TamtamaEvent.error(failure.message)),
        (tamtama) => add(TamtamaEvent.updated(tamtama)),
      );
    });

    _economySubscription?.cancel();
    _economySubscription = repository.watchEconomy(userId).listen((result) {
      result.fold(
        (failure) {},
        (economy) => add(TamtamaEvent.economyUpdated(economy)),
      );
    });
  }

  void _startTickTimer() {
    _tickTimer?.cancel();
    _tickTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      add(const TamtamaEvent.tick());
    });
  }

  @override
  Future<void> close() {
    _tamtamaSubscription?.cancel();
    _economySubscription?.cancel();
    _tickTimer?.cancel();
    tickService.dispose();
    return super.close();
  }
}
