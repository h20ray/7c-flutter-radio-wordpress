part of 'shoutbox_bloc.dart';

@freezed
class ShoutboxState with _$ShoutboxState {
  const factory ShoutboxState.initial() = _Initial;
  const factory ShoutboxState.loading() = _Loading;
  const factory ShoutboxState.loaded(
    List<ShoutboxMessageEntity> messages, {
    @Default(0) int lastId,
  }) = _Loaded;
  const factory ShoutboxState.refreshing(
    List<ShoutboxMessageEntity> messages, {
    @Default(0) int lastId,
  }) = _Refreshing;
  const factory ShoutboxState.sending(
    List<ShoutboxMessageEntity> messages, {
    @Default(0) int lastId,
  }) = _Sending;
  const factory ShoutboxState.error(Failure failure) = _Error;
}

