import 'package:get_it/get_it.dart';

import '../../../config/radio_config.dart';
import '../data/datasources/lyrics_local_data_source.dart';
import '../data/datasources/lyrics_remote_data_source.dart';
import '../data/datasources/radio_player_remote_datasource.dart';
import '../data/datasources/radio_remote_datasource.dart';
import '../data/datasources/request_azuracast_data_source.dart';
import '../data/datasources/request_remote_data_source.dart';
import '../data/datasources/song_history_azuracast_data_source.dart';
import '../data/datasources/song_history_local_data_source.dart';
import '../data/datasources/song_history_remote_data_source.dart';
import '../data/repositories/album_art_repository_impl.dart';
import '../data/repositories/greeting_repository.dart';
import '../data/repositories/lyrics_repository_impl.dart';
import '../data/repositories/radio_player_repository_impl.dart';
import '../data/repositories/radio_repository_impl.dart';
import '../data/repositories/request_repository_impl.dart';
import '../data/repositories/song_history_azuracast_repository_impl.dart';
import '../data/repositories/song_history_repository_impl.dart';
import '../data/services/album_art_service.dart';
import '../data/services/now_playing_polling_service.dart';
import '../domain/repositories/album_art_repository.dart';
import '../domain/repositories/lyrics_repository.dart';
import '../domain/repositories/radio_player_repository.dart';
import '../domain/repositories/radio_repository.dart';
import '../domain/repositories/request_repository.dart';
import '../domain/repositories/song_history_repository.dart';
import '../domain/usecases/get_album_art_url.dart';
import '../domain/usecases/get_radio_config.dart';
import '../domain/usecases/initialize_radio_player.dart';
import '../domain/usecases/pause_radio.dart';
import '../domain/usecases/play_radio.dart';
import '../domain/usecases/reset_radio_player.dart';
import '../presentation/bloc/lyrics_bloc.dart';
import '../presentation/bloc/radio_bloc.dart';
import '../presentation/bloc/radio_player_bloc.dart';
import '../presentation/bloc/request_bloc.dart';
import '../presentation/bloc/song_history_bloc.dart';
import '../presentation/controllers/listening_session_controller.dart';

void initRadioModule(GetIt getIt) {
  getIt.registerLazySingleton<RadioRemoteDataSource>(
    () => RadioRemoteDataSourceImpl(apiClient: getIt()),
  );
  getIt.registerLazySingleton<RadioPlayerRemoteDataSource>(
    () => RadioPlayerRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<AlbumArtService>(() => AlbumArtService.instance);
  getIt.registerLazySingleton<RadioRepository>(
    () => RadioRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<NowPlayingPollingService>(
    () => NowPlayingPollingService(dio: getIt()),
  );
  getIt.registerLazySingleton<RadioPlayerRepository>(
    () => RadioPlayerRepositoryImpl(
      remoteDataSource: getIt(),
      albumArtService: getIt(),
      nowPlayingPollingService: getIt(),
      notificationCenterRepository: getIt(),
      pendingRequestTracker: getIt(),
    ),
  );
  getIt.registerLazySingleton<AlbumArtRepository>(
    () => AlbumArtRepositoryImpl(
      dio: getIt(),
      azuracastBaseUrl: null,
      azuracastStationId: null,
    ),
  );
  getIt.registerLazySingleton(() => GetRadioConfig(getIt()));
  getIt.registerLazySingleton(() => InitializeRadioPlayer(getIt()));
  getIt.registerLazySingleton(() => PlayRadio(getIt()));
  getIt.registerLazySingleton(() => PauseRadio(getIt()));
  getIt.registerLazySingleton(() => ResetRadioPlayer(getIt()));
  getIt.registerLazySingleton(() => GetAlbumArtUrl(getIt()));
  getIt.registerLazySingleton(
    () => ListeningSessionController(
      recordListeningSession: getIt(),
      tamtamaBloc: getIt(),
    ),
  );
  getIt.registerLazySingleton(() => RadioBloc(getRadioConfig: getIt()));
  getIt.registerLazySingleton(
    () => RadioPlayerBloc(
      initializeRadioPlayer: getIt(),
      playRadio: getIt(),
      pauseRadio: getIt(),
      resetRadioPlayer: getIt(),
      repository: getIt(),
      radioConfigBloc: getIt<RadioBloc>(),
      songHistoryRepository: getIt<SongHistoryRepository>(),
      tamtamaBloc: getIt(),
      listeningSessionController: getIt(),
    ),
  );
  getIt.registerLazySingleton<SongHistoryLocalDataSource>(
    () => SongHistoryLocalDataSourceImpl(),
  );
  if (RadioConfig.songHistoryMode == 'azuracast') {
    getIt.registerLazySingleton<SongHistoryAzuracastDataSource>(
      () => SongHistoryAzuracastDataSourceImpl(dio: getIt()),
    );
    getIt.registerLazySingleton<SongHistoryRepository>(
      () => SongHistoryAzuracastRepositoryImpl(
        azuracastDataSource: getIt(),
        localDataSource: getIt(),
        networkInfo: getIt(),
      ),
    );
  } else {
    getIt.registerLazySingleton<SongHistoryRemoteDataSource>(
      () => SongHistoryRemoteDataSourceImpl(apiClient: getIt()),
    );
    getIt.registerLazySingleton<SongHistoryRepository>(
      () => SongHistoryRepositoryImpl(
        localDataSource: getIt(),
        remoteDataSource: getIt(),
      ),
    );
  }
  getIt.registerFactory(() => SongHistoryBloc(repository: getIt()));
  getIt.registerLazySingleton<LyricsLocalDataSource>(
    () => LyricsLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<LyricsRemoteDataSource>(
    () => LyricsRemoteDataSourceImpl(apiClient: getIt(), dio: getIt()),
  );
  getIt.registerLazySingleton<LyricsRepository>(
    () => LyricsRepositoryImpl(
      localDataSource: getIt(),
      remoteDataSource: getIt(),
    ),
  );
  getIt.registerFactory(() => LyricsBloc(repository: getIt()));
  getIt.registerLazySingleton<RequestRemoteDataSource>(
    () => RequestRemoteDataSourceImpl(apiClient: getIt()),
  );
  if (RadioConfig.requestMode != 'webview') {
    getIt.registerLazySingleton<RequestAzuracastDataSource>(
      () => RequestAzuracastDataSourceImpl(dio: getIt()),
    );
  }
  getIt.registerLazySingleton<RequestRepository>(
    () => RequestRepositoryImpl(
      remoteDataSource: getIt(),
      azuracastDataSource: RadioConfig.requestMode != 'webview'
          ? getIt<RequestAzuracastDataSource>()
          : null,
      pendingRequestTracker: getIt(),
    ),
  );
  getIt.registerFactory(() => RequestBloc(repository: getIt()));
  getIt.registerLazySingleton<GreetingRepository>(
    () => GreetingRepository(),
  );
}
