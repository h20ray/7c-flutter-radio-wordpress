part of 'radio_bloc.dart';

@freezed
class RadioState with _$RadioState {
  const factory RadioState.initial() = _Initial;
  const factory RadioState.loading() = _Loading;
  const factory RadioState.loaded(RadioEntity radioEntity) = _Loaded;
  const factory RadioState.error(Failure failure) = _Error;
}

