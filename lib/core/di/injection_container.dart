import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../../config/app_config.dart';
import '../audio/audio_focus_manager.dart';
import '../services/system_volume_service.dart';
import '../services/network_status_service.dart';
import '../services/level_up_celebration_service.dart';
import '../utils/debug_logger.dart';

// Radio feature imports
import '../../features/radio/data/datasources/radio_remote_datasource.dart';
import '../../features/radio/data/datasources/radio_player_remote_datasource.dart';
import '../../features/radio/data/repositories/radio_repository_impl.dart';
import '../../features/radio/data/repositories/radio_player_repository_impl.dart';
import '../../features/radio/data/repositories/album_art_repository_impl.dart';
import '../../features/radio/data/services/album_art_service.dart';
import '../../features/radio/data/services/now_playing_polling_service.dart';
import '../../features/radio/domain/repositories/radio_repository.dart';
import '../../features/radio/domain/repositories/radio_player_repository.dart';
import '../../features/radio/domain/repositories/album_art_repository.dart';
import '../../features/radio/domain/usecases/get_radio_config.dart';
import '../../features/radio/domain/usecases/initialize_radio_player.dart';
import '../../features/radio/domain/usecases/play_radio.dart';
import '../../features/radio/domain/usecases/pause_radio.dart';
import '../../features/radio/domain/usecases/reset_radio_player.dart';
import '../../features/radio/domain/usecases/get_album_art_url.dart';
import '../../features/radio/presentation/bloc/radio_bloc.dart';
import '../../features/radio/presentation/bloc/radio_player_bloc.dart';

// Shoutbox feature imports
import '../../features/shoutbox/data/datasources/shoutbox_remote_datasource.dart';
import '../../features/shoutbox/data/repositories/shoutbox_repository_impl.dart';
import '../../features/shoutbox/domain/repositories/shoutbox_repository.dart';
import '../../features/shoutbox/domain/usecases/get_shoutbox_messages.dart';
import '../../features/shoutbox/domain/usecases/send_shoutbox_message.dart';
import '../../features/shoutbox/domain/usecases/delete_shoutbox_message.dart';
import '../../features/shoutbox/presentation/bloc/shoutbox_bloc.dart';

// WordPress feature imports
import '../../features/wordpress/data/datasources/wordpress_remote_datasource.dart';
import '../../features/wordpress/data/repositories/wordpress_repository_impl.dart';
import '../../features/wordpress/domain/repositories/wordpress_repository.dart';
import '../../features/wordpress/domain/usecases/get_posts.dart';
import '../../features/wordpress/presentation/bloc/wordpress_bloc.dart';

// Home feature imports
import '../../features/gamification/data/datasources/listening_stats_local_data_source.dart';
import '../../features/gamification/data/datasources/level_celebration_local_data_source.dart';
import '../../features/gamification/data/repositories/listening_stats_repository_impl.dart';
import '../../features/gamification/domain/repositories/listening_stats_repository.dart';
import '../../features/gamification/domain/usecases/record_listening_session.dart';
import '../../features/gamification/domain/usecases/watch_listening_stats.dart';
import '../../features/gamification/presentation/bloc/gamification_bloc.dart';
import '../../features/home/data/datasources/home_radio_metadata_datasource.dart';
import '../../features/home/data/repositories/home_radio_repository_impl.dart';
import '../../features/home/domain/repositories/home_radio_repository.dart';
import '../../features/home/domain/usecases/watch_home_now_playing.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';

// TamTama feature imports
import '../../features/tamtama/data/datasources/tamtama_local_data_source.dart';
import '../../features/tamtama/data/repositories/tamtama_repository_impl.dart';
import '../../features/tamtama/domain/repositories/tamtama_repository.dart';
import '../../features/tamtama/presentation/bloc/tamtama_bloc.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Guard to avoid double initialization
  if (getIt.isRegistered<Dio>()) {
    DebugLogger.log('[DI] Dependencies already initialized, skipping', tag: 'DI');
    return;
  }

  DebugLogger.log('[DI] Initializing dependencies...', tag: 'DI');

  // External dependencies
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options.baseUrl = 'https://${AppConfig.url}';
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    return dio;
  });

  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt()));

  final connectivity = Connectivity();
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity),
  );

  // Core services
  getIt.registerLazySingleton<AudioFocusManager>(
    () => AudioFocusManager.instance,
  );
  getIt.registerLazySingleton<SystemVolumeService>(() {
    final svc = SystemVolumeService();
    svc.ensureInitialized();
    return svc;
  });
  getIt.registerLazySingleton<NetworkStatusService>(
    () => NetworkStatusService.instance,
  );

  // Initialize features
  _initRadio();
  _initGamification();
  _initShoutbox();
  _initWordPress();
  _initHome();
  _initTamtama();

  // Initialize network status service
  await getIt<NetworkStatusService>().initialize();

  DebugLogger.log('[DI] Dependencies initialized successfully', tag: 'DI');
}

void _initRadio() {
  // Data sources
  getIt.registerLazySingleton<RadioRemoteDataSource>(
    () => RadioRemoteDataSourceImpl(apiClient: getIt()),
  );
  getIt.registerLazySingleton<RadioPlayerRemoteDataSource>(
    () => RadioPlayerRemoteDataSourceImpl(),
  );

  // Services
  getIt.registerLazySingleton<AlbumArtService>(
    () => AlbumArtService.instance,
  );

  // Repositories
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
    ),
  );
  getIt.registerLazySingleton<AlbumArtRepository>(
    () => AlbumArtRepositoryImpl(
      dio: getIt(),
      azuracastBaseUrl: null,
      azuracastStationId: null,
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetRadioConfig(getIt()));
  getIt.registerLazySingleton(() => InitializeRadioPlayer(getIt()));
  getIt.registerLazySingleton(() => PlayRadio(getIt()));
  getIt.registerLazySingleton(() => PauseRadio(getIt()));
  getIt.registerLazySingleton(() => ResetRadioPlayer(getIt()));
  getIt.registerLazySingleton(() => GetAlbumArtUrl(getIt()));

  // BLoCs
  getIt.registerLazySingleton(
    () => RadioBloc(getRadioConfig: getIt()),
  );
  getIt.registerLazySingleton(
    () => RadioPlayerBloc(
      initializeRadioPlayer: getIt(),
      playRadio: getIt(),
      pauseRadio: getIt(),
      resetRadioPlayer: getIt(),
      repository: getIt(),
      radioConfigBloc: getIt<RadioBloc>(),
      recordListeningSession: getIt(),
    ),
  );
}

void _initShoutbox() {
  getIt.registerLazySingleton<ShoutboxRemoteDataSource>(
    () => ShoutboxRemoteDataSourceImpl(apiClient: getIt()),
  );

  getIt.registerLazySingleton<ShoutboxRepository>(
    () => ShoutboxRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(() => GetShoutboxMessages(getIt()));
  getIt.registerLazySingleton(() => SendShoutboxMessage(getIt()));
  getIt.registerLazySingleton(() => DeleteShoutboxMessage(getIt()));

  getIt.registerFactory(
    () => ShoutboxBloc(
      getMessages: getIt(),
      sendMessage: getIt(),
      deleteMessage: getIt(),
    ),
  );
}

void _initWordPress() {
  getIt.registerLazySingleton<WordPressRemoteDataSource>(
    () => WordPressRemoteDataSourceImpl(apiClient: getIt()),
  );

  getIt.registerLazySingleton<WordPressRepository>(
    () => WordPressRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(() => GetPosts(getIt()));

  getIt.registerFactory(
    () => WordPressBloc(getPosts: getIt()),
  );
}

void _initHome() {
  getIt.registerLazySingleton<HomeRadioMetadataDataSource>(
    () => HomeRadioMetadataDataSourceImpl(
      radioPlayerRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton<HomeRadioRepository>(
    () => HomeRadioRepositoryImpl(
      metadataDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => WatchHomeNowPlaying(getIt()),
  );
  getIt.registerFactory(
    () => HomeBloc(
      watchHomeNowPlaying: getIt(),
    ),
  );
}

void _initGamification() {
  getIt.registerLazySingleton<ListeningStatsLocalDataSource>(
    () => ListeningStatsLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<LevelCelebrationLocalDataSource>(
    () => LevelCelebrationLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<ListeningStatsRepository>(
    () => ListeningStatsRepositoryImpl(
      localDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton(() => WatchListeningStats(getIt()));
  getIt.registerLazySingleton(() => RecordListeningSession(getIt()));
  getIt.registerLazySingleton(
    () => GamificationBloc(
      watchListeningStats: getIt(),
    ),
  );
  
  getIt.registerLazySingleton(() => LevelUpCelebrationService.instance);
}

void _initTamtama() {
  getIt.registerLazySingleton<TamtamaLocalDataSource>(
    () => TamtamaLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<TamtamaRepository>(
    () => TamtamaRepositoryImpl(
      localDataSource: getIt(),
    ),
  );
  getIt.registerFactory(
    () => TamtamaBloc(
      repository: getIt(),
    ),
  );
}

