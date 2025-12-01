part of 'lyrics_bloc.dart';

@freezed
class LyricsState with _$LyricsState {
  const factory LyricsState.initial() = _Initial;
  const factory LyricsState.loading() = _Loading;
  const factory LyricsState.loaded(LyricsEntity lyrics) = _Loaded;
  const factory LyricsState.error(Failure failure) = _Error;
}

