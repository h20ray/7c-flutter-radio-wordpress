import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/song_history_entity.dart';
import '../../domain/repositories/song_history_repository.dart';

part 'song_history_bloc.freezed.dart';
part 'song_history_event.dart';
part 'song_history_state.dart';

class SongHistoryBloc extends Bloc<SongHistoryEvent, SongHistoryState> {
  final SongHistoryRepository repository;

  SongHistoryBloc({required this.repository})
      : super(const SongHistoryState.initial()) {
    on<LoadSongHistoryEvent>(_onLoadSongHistory);
  }

  Future<void> _onLoadSongHistory(
    LoadSongHistoryEvent event,
    Emitter<SongHistoryState> emit,
  ) async {
    emit(const SongHistoryState.loading());
    final result = await repository.getSongHistory(limit: event.limit);
    result.fold(
      (failure) => emit(SongHistoryState.error(failure)),
      (songs) => emit(SongHistoryState.loaded(songs)),
    );
  }
}

