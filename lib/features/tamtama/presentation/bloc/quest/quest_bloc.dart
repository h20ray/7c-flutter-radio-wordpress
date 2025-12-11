import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/quest_entity.dart';
import '../../../domain/services/quest_service.dart';

part 'quest_bloc.freezed.dart';
part 'quest_event.dart';
part 'quest_state.dart';

/// BLoC for managing daily quests
class QuestBloc extends Bloc<QuestEvent, QuestState> {
  final QuestService questService;
  final void Function(int coins, int xp)? onRewardsClaimed;
  
  QuestBloc({
    required this.questService,
    this.onRewardsClaimed,
  }) : super(const QuestState.initial()) {
    on<LoadQuestsEvent>(_onLoadQuests);
    on<IncrementProgressEvent>(_onIncrementProgress);
    on<ClaimQuestEvent>(_onClaimQuest);
    on<ClaimAllQuestsEvent>(_onClaimAllQuests);
    on<RefreshQuestsEvent>(_onRefreshQuests);
  }
  
  DailyQuestsEntity? _currentQuests;
  
  Future<void> _onLoadQuests(LoadQuestsEvent event, Emitter<QuestState> emit) async {
    emit(const QuestState.loading());
    
    // Check if we need new quests
    if (_currentQuests == null || questService.needsRefresh(_currentQuests)) {
      _currentQuests = questService.generateDailyQuests();
    }
    
    emit(QuestState.loaded(quests: _currentQuests!));
  }
  
  Future<void> _onIncrementProgress(IncrementProgressEvent event, Emitter<QuestState> emit) async {
    if (_currentQuests == null) return;
    
    _currentQuests = questService.incrementQuestProgress(
      _currentQuests!,
      event.type,
      event.amount,
    );
    
    emit(QuestState.loaded(quests: _currentQuests!));
  }
  
  Future<void> _onClaimQuest(ClaimQuestEvent event, Emitter<QuestState> emit) async {
    if (_currentQuests == null) return;
    
    final result = questService.claimQuest(_currentQuests!, event.questId);
    _currentQuests = result.quests;
    
    emit(QuestState.loaded(quests: _currentQuests!));
    
    // Notify about claimed rewards
    if (result.coins > 0 || result.xp > 0) {
      onRewardsClaimed?.call(result.coins, result.xp);
    }
  }
  
  Future<void> _onClaimAllQuests(ClaimAllQuestsEvent event, Emitter<QuestState> emit) async {
    if (_currentQuests == null) return;
    
    final result = questService.claimAllQuests(_currentQuests!);
    _currentQuests = result.quests;
    
    emit(QuestState.loaded(quests: _currentQuests!));
    
    // Notify about claimed rewards
    if (result.coins > 0 || result.xp > 0) {
      onRewardsClaimed?.call(result.coins, result.xp);
    }
  }
  
  Future<void> _onRefreshQuests(RefreshQuestsEvent event, Emitter<QuestState> emit) async {
    if (questService.needsRefresh(_currentQuests)) {
      _currentQuests = questService.generateDailyQuests();
      emit(QuestState.loaded(quests: _currentQuests!));
    }
  }
  
  /// Increment progress for a specific quest type (called externally)
  void trackAction(QuestType type, {int amount = 1}) {
    add(QuestEvent.incrementProgress(type: type, amount: amount));
  }
}
