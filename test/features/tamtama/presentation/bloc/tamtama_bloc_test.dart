import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tujuhcahaya_wprs/features/tamtama/data/services/tamtama_tick_service.dart';
import 'package:tujuhcahaya_wprs/features/tamtama/domain/usecases/add_listening_rewards.dart';
import 'package:tujuhcahaya_wprs/features/tamtama/domain/usecases/apply_offline_ticks.dart';
import 'package:tujuhcahaya_wprs/features/tamtama/domain/usecases/apply_tick.dart';
import 'package:tujuhcahaya_wprs/features/tamtama/domain/usecases/clean_pet.dart';
import 'package:tujuhcahaya_wprs/features/tamtama/domain/usecases/delete_tamtama.dart';
import 'package:tujuhcahaya_wprs/features/tamtama/domain/usecases/evolve_pet.dart';
import 'package:tujuhcahaya_wprs/features/tamtama/domain/usecases/feed_pet.dart';
import 'package:tujuhcahaya_wprs/features/tamtama/domain/usecases/get_economy.dart';
import 'package:tujuhcahaya_wprs/features/tamtama/domain/usecases/get_tamtama.dart';
import 'package:tujuhcahaya_wprs/features/tamtama/domain/usecases/play_with_pet.dart';
import 'package:tujuhcahaya_wprs/features/tamtama/domain/usecases/save_tamtama.dart';
import 'package:tujuhcahaya_wprs/features/tamtama/domain/usecases/set_sleep_mode.dart';
import 'package:tujuhcahaya_wprs/features/tamtama/domain/usecases/watch_economy.dart';
import 'package:tujuhcahaya_wprs/features/tamtama/domain/usecases/watch_tamtama.dart';
import 'package:tujuhcahaya_wprs/features/tamtama/presentation/bloc/tamtama_bloc.dart';

class _MockGetTamtama extends Mock implements GetTamtama {}

class _MockSaveTamtama extends Mock implements SaveTamtama {}

class _MockGetEconomy extends Mock implements GetEconomy {}

class _MockWatchTamtama extends Mock implements WatchTamtama {}

class _MockWatchEconomy extends Mock implements WatchEconomy {}

class _MockFeedPet extends Mock implements FeedPet {}

class _MockPlayWithPet extends Mock implements PlayWithPet {}

class _MockCleanPet extends Mock implements CleanPet {}

class _MockSetSleepMode extends Mock implements SetSleepMode {}

class _MockApplyTick extends Mock implements ApplyTick {}

class _MockApplyOfflineTicks extends Mock implements ApplyOfflineTicks {}

class _MockAddListeningRewards extends Mock implements AddListeningRewards {}

class _MockEvolvePet extends Mock implements EvolvePet {}

class _MockDeleteTamtama extends Mock implements DeleteTamtama {}

void main() {
  test('TamtamaBloc starts with initial state', () {
    final bloc = TamtamaBloc(
      tickService: TamtamaTickService(),
      getTamtama: _MockGetTamtama(),
      saveTamtama: _MockSaveTamtama(),
      getEconomy: _MockGetEconomy(),
      watchTamtama: _MockWatchTamtama(),
      watchEconomy: _MockWatchEconomy(),
      feedPet: _MockFeedPet(),
      playWithPet: _MockPlayWithPet(),
      cleanPet: _MockCleanPet(),
      setSleepMode: _MockSetSleepMode(),
      applyTick: _MockApplyTick(),
      applyOfflineTicks: _MockApplyOfflineTicks(),
      addListeningRewards: _MockAddListeningRewards(),
      evolvePet: _MockEvolvePet(),
      deleteTamtama: _MockDeleteTamtama(),
    );

    expect(bloc.state, const TamtamaState.initial());
    bloc.close();
  });
}
