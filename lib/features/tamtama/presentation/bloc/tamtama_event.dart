part of 'tamtama_bloc.dart';

@freezed
class TamtamaEvent with _$TamtamaEvent {
  // Lifecycle
  const factory TamtamaEvent.load() = LoadTamtamaEvent;
  const factory TamtamaEvent.updated(TamtamaEntity tamtama) = TamtamaUpdatedEvent;
  const factory TamtamaEvent.error(String message) = TamtamaErrorEvent;
  
  // Care Actions
  const factory TamtamaEvent.feedPet([FoodType? food]) = FeedPetEvent;
  const factory TamtamaEvent.playWithPet([ActivityType? activity]) = PlayWithPetEvent;
  const factory TamtamaEvent.cleanPet() = CleanPetEvent;
  const factory TamtamaEvent.toggleSleep() = ToggleSleepEvent;
  
  // Tick System
  const factory TamtamaEvent.tick() = TickEvent;
  const factory TamtamaEvent.applyOfflineTicks() = ApplyOfflineTicksEvent;
  
  // Radio Integration
  const factory TamtamaEvent.onListeningTick(int minutes, String stationId) = ListeningTickEvent;
  const factory TamtamaEvent.setListening(bool isListening) = SetListeningEvent;
  
  // Economy
  const factory TamtamaEvent.economyUpdated(TamtamaEconomyEntity economy) = EconomyUpdatedEvent;
  
  // Debug
  const factory TamtamaEvent.debugSetStats({
    double? hunger,
    double? energy,
    double? happiness,
    double? hygiene,
    double? affection,
    double? stress,
    double? health,
  }) = DebugSetStatsEvent;
  const factory TamtamaEvent.debugAddCoins(double amount) = DebugAddCoinsEvent;
}
