part of 'song_history_bloc.dart';

@freezed
class SongHistoryEvent with _$SongHistoryEvent {
  const factory SongHistoryEvent.load({@Default(100) int limit}) =
      LoadSongHistoryEvent;
  const factory SongHistoryEvent.clearHistory() = ClearHistoryEvent;
}

