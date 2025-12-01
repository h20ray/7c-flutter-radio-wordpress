part of 'request_bloc.dart';

@freezed
class RequestState with _$RequestState {
  const factory RequestState.initial() = _Initial;
  const factory RequestState.loading() = _Loading;
  const factory RequestState.loaded({
    required List<RequestableTrackEntity> tracks,
    required int page,
    required bool hasMore,
  }) = _Loaded;
  const factory RequestState.success() = _Success;
  const factory RequestState.error(Failure failure) = _Error;
}

