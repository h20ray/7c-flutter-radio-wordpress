part of 'song_history_bloc.dart';

@freezed
class SongHistoryState with _$SongHistoryState {
  const factory SongHistoryState.initial() = _Initial;
  const factory SongHistoryState.loading() = _Loading;
  const factory SongHistoryState.loaded(List<SongHistoryEntity> songs) =
      _Loaded;
  const factory SongHistoryState.error(Failure failure) = _Error;
}

