import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/tamtama_entity.dart';
import '../../domain/repositories/tamtama_repository.dart';

part 'tamtama_bloc.freezed.dart';
part 'tamtama_event.dart';
part 'tamtama_state.dart';

class TamtamaBloc extends Bloc<TamtamaEvent, TamtamaState> {
  final TamtamaRepository repository;
  final String userId;

  StreamSubscription<Either<Failure, TamtamaEntity>>? _tamtamaSubscription;

  TamtamaBloc({
    required this.repository,
    this.userId = 'local_user',
  }) : super(const TamtamaState.initial()) {
    on<LoadTamtamaEvent>(_onLoadTamtama);
    on<FeedPetEvent>(_onFeedPet);
    on<PlayWithPetEvent>(_onPlayWithPet);
    on<TamtamaUpdatedEvent>(_onTamtamaUpdated);
    on<TamtamaErrorEvent>(_onTamtamaError);

    _subscribeTamtama();
  }

  Future<void> _onLoadTamtama(
    LoadTamtamaEvent event,
    Emitter<TamtamaState> emit,
  ) async {
    emit(const TamtamaState.loading());
    final result = await repository.fetch(userId);
    result.fold(
      (failure) => emit(TamtamaState.error(failure.message)),
      (tamtama) => emit(TamtamaState.loaded(tamtama)),
    );
  }

  Future<void> _onFeedPet(
    FeedPetEvent event,
    Emitter<TamtamaState> emit,
  ) async {
    final currentTamtama = state.maybeWhen<TamtamaEntity?>(
      loaded: (tamtama) => tamtama,
      orElse: () => null,
    );

    if (currentTamtama == null || emit.isDone) return;

    final updatedHunger = (currentTamtama.hunger + 20).clamp(0, 100);
    final updatedHappiness = (currentTamtama.happiness + 5).clamp(0, 100);
    final updatedTamtama = currentTamtama.copyWith(
      hunger: updatedHunger,
      happiness: updatedHappiness,
      lastFedAt: DateTime.now(),
    );

    final result = await repository.save(updatedTamtama);
    if (emit.isDone) return;
    result.fold(
      (failure) => emit(TamtamaState.error(failure.message)),
      (saved) => emit(TamtamaState.loaded(saved)),
    );
  }

  Future<void> _onPlayWithPet(
    PlayWithPetEvent event,
    Emitter<TamtamaState> emit,
  ) async {
    final currentTamtama = state.maybeWhen<TamtamaEntity?>(
      loaded: (tamtama) => tamtama,
      orElse: () => null,
    );

    if (currentTamtama == null || emit.isDone) return;

    final updatedHappiness = (currentTamtama.happiness + 15).clamp(0, 100);
    final updatedLevel =
        currentTamtama.happiness >= 90 ? currentTamtama.level + 1 : currentTamtama.level;
    final updatedTamtama = currentTamtama.copyWith(
      happiness: updatedHappiness,
      level: updatedLevel,
      lastPlayedAt: DateTime.now(),
    );

    final result = await repository.save(updatedTamtama);
    if (emit.isDone) return;
    result.fold(
      (failure) => emit(TamtamaState.error(failure.message)),
      (saved) => emit(TamtamaState.loaded(saved)),
    );
  }

  void _onTamtamaUpdated(
    TamtamaUpdatedEvent event,
    Emitter<TamtamaState> emit,
  ) {
    emit(TamtamaState.loaded(event.tamtama));
  }

  void _onTamtamaError(
    TamtamaErrorEvent event,
    Emitter<TamtamaState> emit,
  ) {
    emit(TamtamaState.error(event.message));
  }

  void _subscribeTamtama() {
    _tamtamaSubscription = repository.watch(userId).listen((result) {
      result.fold(
        (failure) => add(TamtamaEvent.error(failure.message)),
        (tamtama) => add(TamtamaEvent.updated(tamtama)),
      );
    });
  }

  @override
  Future<void> close() {
    _tamtamaSubscription?.cancel();
    return super.close();
  }
}

