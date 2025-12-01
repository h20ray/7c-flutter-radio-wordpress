part of 'request_bloc.dart';

@freezed
class RequestEvent with _$RequestEvent {
  const factory RequestEvent.loadTracks({
    required String streamUrl,
    String? query,
    @Default(1) int page,
    @Default(20) int limit,
    @Default(false) bool random,
  }) = LoadTracksEvent;
  
  const factory RequestEvent.submit({
    required String streamUrl,
    required String requestId,
    String? title,
    String? artist,
  }) = SubmitRequestEvent;
  
  const factory RequestEvent.reset() = ResetRequestEvent;
}

