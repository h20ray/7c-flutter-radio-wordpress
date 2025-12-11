import 'package:get_it/get_it.dart';

import '../data/datasources/tamtama_local_data_source.dart';
import '../data/repositories/tamtama_repository_impl.dart';
import '../data/services/tamtama_tick_service.dart';
import '../domain/repositories/tamtama_repository.dart';
import '../presentation/bloc/tamtama_bloc.dart';

import '../domain/services/animation_service.dart';
import '../domain/services/evolution_config_service.dart';
import '../domain/services/pet_map_service.dart';
import '../domain/services/tamtama_evolution_service.dart';
import '../domain/usecases/add_listening_rewards.dart';
import '../domain/usecases/apply_offline_ticks.dart';
import '../domain/usecases/apply_tick.dart';
import '../domain/usecases/clean_pet.dart';
import '../domain/usecases/delete_tamtama.dart';
import '../domain/usecases/evolve_pet.dart';
import '../domain/usecases/feed_pet.dart';
import '../domain/usecases/get_economy.dart';
import '../domain/usecases/get_tamtama.dart';
import '../domain/usecases/play_with_pet.dart';
import '../domain/usecases/save_tamtama.dart';
import '../domain/usecases/set_sleep_mode.dart';
import '../domain/usecases/watch_economy.dart';
import '../domain/usecases/watch_tamtama.dart';
import '../presentation/services/tamtama_sprite_service.dart';

void initTamtamaModule(GetIt getIt) {
  // Services
  getIt.registerLazySingleton<TamtamaLocalDataSource>(
    () => TamtamaLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<TamtamaTickService>(
    () => TamtamaTickService(),
  );
  getIt.registerLazySingleton<EvolutionConfigService>(
    () => EvolutionConfigService(),
  );
  getIt.registerLazySingleton<PetMapService>(
    () => PetMapService(),
  );
  getIt.registerLazySingleton<AnimationService>(
    () => AnimationService(),
  );
  getIt.registerLazySingleton<TamtamaEvolutionService>(
    () => TamtamaEvolutionServiceImpl(configService: getIt()),
  );
  getIt.registerLazySingleton<TamtamaSpriteService>(
    () => TamtamaSpriteService(
      petMapService: getIt(),
      useNumericIds: true,
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => EvolvePet(getIt(), getIt()),
  );
  getIt.registerLazySingleton(() => GetTamtama(getIt()));
  getIt.registerLazySingleton(() => SaveTamtama(getIt()));
  getIt.registerLazySingleton(() => GetEconomy(getIt()));
  getIt.registerLazySingleton(() => WatchTamtama(getIt()));
  getIt.registerLazySingleton(() => WatchEconomy(getIt()));
  getIt.registerLazySingleton(() => FeedPet(getIt()));
  getIt.registerLazySingleton(() => PlayWithPet(getIt()));
  getIt.registerLazySingleton(() => CleanPet(getIt()));
  getIt.registerLazySingleton(() => SetSleepMode(getIt()));
  getIt.registerLazySingleton(() => ApplyTick(getIt()));
  getIt.registerLazySingleton(() => ApplyOfflineTicks(getIt()));
  getIt.registerLazySingleton(() => AddListeningRewards(getIt()));
  getIt.registerLazySingleton(() => DeleteTamtama(getIt()));

  // Repository
  getIt.registerLazySingleton<TamtamaRepository>(
    () => TamtamaRepositoryImpl(
      localDataSource: getIt(),
      tickService: getIt(),
      petMapService: getIt(),
    ),
  );

  // Bloc
  getIt.registerLazySingleton(
    () => TamtamaBloc(
      tickService: getIt(),
      getTamtama: getIt(),
      saveTamtama: getIt(),
      getEconomy: getIt(),
      watchTamtama: getIt(),
      watchEconomy: getIt(),
      feedPet: getIt(),
      playWithPet: getIt(),
      cleanPet: getIt(),
      setSleepMode: getIt(),
      applyTick: getIt(),
      applyOfflineTicks: getIt(),
      addListeningRewards: getIt(),
      evolvePet: getIt(),
      deleteTamtama: getIt(),
    ),
  );
}
