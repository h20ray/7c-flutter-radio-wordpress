part of 'tamtama_bloc.dart';

@freezed
class TamtamaState with _$TamtamaState {
  const factory TamtamaState.initial() = TamtamaInitial;
  const factory TamtamaState.loading() = TamtamaLoading;
  const factory TamtamaState.loaded({
    required TamtamaEntity tamtama,
    required TamtamaEconomyEntity economy,
    @Default(false) bool isListening,
  }) = TamtamaLoaded;
  const factory TamtamaState.error(String message) = TamtamaError;
}
