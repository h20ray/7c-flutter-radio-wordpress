part of 'lyrics_bloc.dart';

@freezed
class LyricsEvent with _$LyricsEvent {
  const factory LyricsEvent.load({
    required String artist,
    required String title,
  }) = LoadLyricsEvent;
  
  const factory LyricsEvent.refresh() = RefreshLyricsEvent;
}

