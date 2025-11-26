part of 'tamtama_bloc.dart';

@freezed
class TamtamaState with _$TamtamaState {
  const factory TamtamaState.initial() = _Initial;
  const factory TamtamaState.loading() = _Loading;
  const factory TamtamaState.loaded(TamtamaEntity tamtama) = _Loaded;
  const factory TamtamaState.error(String message) = _Error;
}

