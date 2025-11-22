part of 'shoutbox_bloc.dart';

@freezed
class ShoutboxState with _$ShoutboxState {
  const factory ShoutboxState.initial() = _Initial;
  const factory ShoutboxState.loading() = _Loading;
  const factory ShoutboxState.loaded(List<ShoutboxMessageEntity> messages) = _Loaded;
  const factory ShoutboxState.error(Failure failure) = _Error;
}

