import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/lyrics_entity.dart';
import '../../domain/repositories/lyrics_repository.dart';

part 'lyrics_bloc.freezed.dart';
part 'lyrics_event.dart';
part 'lyrics_state.dart';

class LyricsBloc extends Bloc<LyricsEvent, LyricsState> {
  final LyricsRepository repository;

  LyricsBloc({required this.repository})
      : super(const LyricsState.initial()) {
    on<LoadLyricsEvent>(_onLoadLyrics);
  }

  Future<void> _onLoadLyrics(
    LoadLyricsEvent event,
    Emitter<LyricsState> emit,
  ) async {
    emit(const LyricsState.loading());
    final result = await repository.getLyrics(
      artist: event.artist,
      title: event.title,
    );
    result.fold(
      (failure) => emit(LyricsState.error(failure)),
      (lyrics) => emit(LyricsState.loaded(lyrics)),
    );
  }
}

