import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/radio_entity.dart';
import '../../domain/usecases/get_radio_config.dart';

part 'radio_bloc.freezed.dart';
part 'radio_event.dart';
part 'radio_state.dart';

class RadioBloc extends Bloc<RadioEvent, RadioState> {
  final GetRadioConfig getRadioConfig;

  RadioBloc({required this.getRadioConfig}) : super(const RadioState.initial()) {
    on<GetRadioConfigEvent>(_onGetRadioConfig);
  }

  Future<void> _onGetRadioConfig(
    GetRadioConfigEvent event,
    Emitter<RadioState> emit,
  ) async {
    emit(const RadioState.loading());
    final result = await getRadioConfig();
    result.fold(
      (failure) => emit(RadioState.error(failure)),
      (radioEntity) => emit(RadioState.loaded(radioEntity)),
    );
  }
}

