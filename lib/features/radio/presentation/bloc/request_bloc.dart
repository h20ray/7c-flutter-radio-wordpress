import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/request_repository.dart';

part 'request_bloc.freezed.dart';
part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final RequestRepository repository;

  RequestBloc({required this.repository})
      : super(const RequestState.initial()) {
    on<LoadTracksEvent>(_onLoadTracks);
    on<SubmitRequestEvent>(_onSubmitRequest);
    on<ResetRequestEvent>(_onReset);
  }

  Future<void> _onLoadTracks(
    LoadTracksEvent event,
    Emitter<RequestState> emit,
  ) async {
    emit(const RequestState.loading());
    
    final result = await repository.listRequestableTracks(
      streamUrl: event.streamUrl,
      query: event.query,
      page: event.page,
      limit: event.limit,
      random: event.random,
    );
    result.fold(
      (failure) => emit(RequestState.error(failure)),
      (tracks) {
        emit(RequestState.loaded(
          tracks: tracks,
          page: event.page,
          hasMore: false,
        ));
      },
    );
  }

  Future<void> _onSubmitRequest(
    SubmitRequestEvent event,
    Emitter<RequestState> emit,
  ) async {
    emit(const RequestState.loading());
    final result = await repository.submitRequest(
      streamUrl: event.streamUrl,
      requestId: event.requestId,
      title: event.title,
      artist: event.artist,
    );
    result.fold(
      (failure) => emit(RequestState.error(failure)),
      (_) => emit(const RequestState.success()),
    );
  }

  void _onReset(
    ResetRequestEvent event,
    Emitter<RequestState> emit,
  ) {
    emit(const RequestState.initial());
  }
}

