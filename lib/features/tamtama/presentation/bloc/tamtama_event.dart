part of 'tamtama_bloc.dart';

@freezed
class TamtamaEvent with _$TamtamaEvent {
  const factory TamtamaEvent.load() = LoadTamtamaEvent;
  const factory TamtamaEvent.feedPet() = FeedPetEvent;
  const factory TamtamaEvent.playWithPet() = PlayWithPetEvent;
  const factory TamtamaEvent.updated(TamtamaEntity tamtama) =
      TamtamaUpdatedEvent;
  const factory TamtamaEvent.error(String message) = TamtamaErrorEvent;
}

