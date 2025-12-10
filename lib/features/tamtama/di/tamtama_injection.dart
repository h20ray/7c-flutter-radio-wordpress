import 'package:get_it/get_it.dart';

import '../data/datasources/tamtama_local_data_source.dart';
import '../data/repositories/tamtama_repository_impl.dart';
import '../data/services/tamtama_tick_service.dart';
import '../domain/repositories/tamtama_repository.dart';
import '../presentation/bloc/tamtama_bloc.dart';

void initTamtamaModule(GetIt getIt) {
  getIt.registerLazySingleton<TamtamaLocalDataSource>(
    () => TamtamaLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<TamtamaTickService>(
    () => TamtamaTickService(),
  );
  getIt.registerLazySingleton<TamtamaRepository>(
    () => TamtamaRepositoryImpl(
      localDataSource: getIt(),
      tickService: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => TamtamaBloc(
      repository: getIt(),
      tickService: getIt(),
    ),
  );
}
