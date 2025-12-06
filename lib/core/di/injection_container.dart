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
import '../../features/radio/data/datasources/song_history_local_data_source.dart';
import '../../features/radio/data/datasources/song_history_remote_data_source.dart';
import '../../features/radio/data/datasources/song_history_azuracast_data_source.dart';
import '../../features/radio/data/repositories/song_history_repository_impl.dart';
import '../../features/radio/data/repositories/song_history_azuracast_repository_impl.dart';
import '../../features/radio/domain/repositories/song_history_repository.dart';
import '../../features/radio/presentation/bloc/song_history_bloc.dart';
import '../../config/radio_config.dart';
import '../../features/radio/data/datasources/lyrics_local_data_source.dart';
import '../../features/radio/data/datasources/lyrics_remote_data_source.dart';
import '../../features/radio/data/repositories/lyrics_repository_impl.dart';
import '../../features/radio/domain/repositories/lyrics_repository.dart';
import '../../features/radio/presentation/bloc/lyrics_bloc.dart';
import '../../features/radio/data/datasources/request_remote_data_source.dart';
import '../../features/radio/data/datasources/request_azuracast_data_source.dart';
import '../../features/radio/data/repositories/request_repository_impl.dart';
import '../../features/radio/domain/repositories/request_repository.dart';
import '../../features/radio/presentation/bloc/request_bloc.dart';

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
import '../../features/wordpress/data/datasources/wordpress_local_data_source.dart';
import '../../features/wordpress/data/datasources/offline_news_local_data_source.dart';
import '../../features/wordpress/data/services/offline_news_service.dart';
import '../../features/wordpress/data/repositories/wordpress_repository_impl.dart';
import '../../features/wordpress/domain/repositories/wordpress_repository.dart';
import '../../features/wordpress/domain/usecases/get_posts.dart';
import '../../features/wordpress/presentation/bloc/news_feed_bloc.dart';
import '../../features/wordpress/presentation/bloc/news_search_bloc.dart';

// Home feature imports
import '../../features/gamification/data/datasources/listening_stats_local_data_source.dart';
import '../../features/gamification/data/datasources/listening_stats_remote_data_source.dart';
import '../../features/gamification/data/datasources/level_celebration_local_data_source.dart';
import '../../features/gamification/data/repositories/listening_stats_repository_impl.dart';
import '../../features/gamification/domain/repositories/listening_stats_repository.dart';
import '../../features/gamification/domain/usecases/record_listening_session.dart';
import '../../features/gamification/domain/usecases/watch_listening_stats.dart';
import '../../features/gamification/domain/usecases/switch_listening_stats_user.dart';
import '../../features/gamification/domain/usecases/merge_guest_stats_to_user.dart';
import '../../features/gamification/domain/usecases/flush_listening_stats_to_guest.dart';
import '../../features/gamification/domain/usecases/sync_listening_stats_with_server.dart';
import '../../features/gamification/domain/usecases/fetch_listening_stats_from_server.dart';
import '../../features/gamification/presentation/bloc/gamification_bloc.dart';
import '../../features/home/data/datasources/home_radio_metadata_datasource.dart';
import '../../features/home/data/repositories/home_radio_repository_impl.dart';
import '../../features/home/domain/repositories/home_radio_repository.dart';
import '../../features/home/domain/usecases/watch_home_now_playing.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';

// Categories feature imports
import '../../features/categories/data/datasources/category_remote_datasource.dart';
import '../../features/categories/data/datasources/category_local_data_source.dart';
import '../../features/categories/data/datasources/config_remote_datasource.dart';
import '../../features/categories/data/repositories/category_repository_impl.dart';
import '../../features/categories/domain/repositories/category_repository.dart';

// Promos feature imports
import '../../features/promos/data/datasources/promo_remote_datasource.dart';
import '../../features/promos/data/repositories/promo_repository_impl.dart';
import '../../features/promos/domain/repositories/promo_repository.dart';
import '../../features/promos/domain/usecases/get_promos_by_category.dart';

// TamTama feature imports
import '../../features/tamtama/data/datasources/tamtama_local_data_source.dart';
import '../../features/tamtama/data/repositories/tamtama_repository_impl.dart';
import '../../features/tamtama/domain/repositories/tamtama_repository.dart';
import '../../features/tamtama/presentation/bloc/tamtama_bloc.dart';

// Auth feature imports
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/check_auth_status.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/login_with_email.dart';
import '../../features/auth/domain/usecases/login_with_google.dart';
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/auth/domain/usecases/refresh_token.dart';
import '../../features/auth/domain/usecases/auto_login.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Guard to avoid double initialization
  if (getIt.isRegistered<Dio>()) {
    DebugLogger.log(
      '[DI] Dependencies already initialized, skipping',
      tag: 'DI',
    );
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
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectivity));

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
  _initCategories();
  _initPromos();
  _initHome();
  _initTamtama();
  _initAuth();

  // Initialize network status service
  await getIt<NetworkStatusService>().initialize();

  // Setup auth token interceptor after all dependencies are registered
  final apiClient = getIt<ApiClient>();
  apiClient.setAuthTokenGetter(() async {
    try {
      final localDataSource = getIt<AuthLocalDataSource>();
      final token = await localDataSource.getToken();
      if (token != null && !token.isExpired) {
        return token.accessToken;
      }
    } catch (e) {
      // Ignore errors
    }
    return null;
  });
  apiClient.setOnTokenExpired(() {
    getIt<AuthBloc>().add(const AuthEvent.tokenExpired());
  });

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
  getIt.registerLazySingleton<AlbumArtService>(() => AlbumArtService.instance);

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
  getIt.registerLazySingleton(() => RadioBloc(getRadioConfig: getIt()));
  getIt.registerLazySingleton(
    () => RadioPlayerBloc(
      initializeRadioPlayer: getIt(),
      playRadio: getIt(),
      pauseRadio: getIt(),
      resetRadioPlayer: getIt(),
      repository: getIt(),
      radioConfigBloc: getIt<RadioBloc>(),
      recordListeningSession: getIt(),
      songHistoryRepository: getIt<SongHistoryRepository>(),
    ),
  );

  // Song History
  // Local data source is used by both modes (for caching in Azuracast mode)
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

  // Lyrics
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

  // Request
  getIt.registerLazySingleton<RequestRemoteDataSource>(
    () => RequestRemoteDataSourceImpl(apiClient: getIt()),
  );

  // Register AzuraCast request data source if mode is not webview
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
    ),
  );
  getIt.registerFactory(() => RequestBloc(repository: getIt()));
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

  getIt.registerLazySingleton<WordPressLocalDataSource>(
    () => WordPressLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<OfflineNewsLocalDataSource>(
    () => OfflineNewsLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<OfflineNewsService>(
    () => OfflineNewsService(localDataSource: getIt()),
  );

  getIt.registerLazySingleton<WordPressRepository>(
    () => WordPressRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      offlineNewsService: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => GetPosts(getIt()));

  getIt.registerLazySingleton(() => NewsFeedBloc(
        getPosts: getIt(),
        repository: getIt(),
      ));
  getIt.registerLazySingleton(() => NewsSearchBloc(getPosts: getIt()));
}

void _initHome() {
  getIt.registerLazySingleton<HomeRadioMetadataDataSource>(
    () => HomeRadioMetadataDataSourceImpl(radioPlayerRepository: getIt()),
  );
  getIt.registerLazySingleton<HomeRadioRepository>(
    () => HomeRadioRepositoryImpl(metadataDataSource: getIt()),
  );
  getIt.registerLazySingleton(() => WatchHomeNowPlaying(getIt()));
  getIt.registerLazySingleton(
    () => HomeBloc(watchHomeNowPlaying: getIt(), categoryRepository: getIt()),
  );
}

void _initCategories() {
  getIt.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(apiClient: getIt()),
  );

  getIt.registerLazySingleton<ConfigRemoteDataSource>(
    () => ConfigRemoteDataSourceImpl(apiClient: getIt()),
  );

  getIt.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      categoryRemoteDataSource: getIt(),
      configRemoteDataSource: getIt(),
      categoryLocalDataSource: getIt(),
    ),
  );
}

void _initPromos() {
  getIt.registerLazySingleton<PromoRemoteDataSource>(
    () => PromoRemoteDataSourceImpl(apiClient: getIt()),
  );

  getIt.registerLazySingleton<PromoRepository>(
    () => PromoRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(() => GetPromosByCategory(getIt()));
}

void _initGamification() {
  getIt.registerLazySingleton<ListeningStatsLocalDataSource>(
    () => ListeningStatsLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<ListeningStatsRemoteDataSource>(
    () => ListeningStatsRemoteDataSourceImpl(apiClient: getIt()),
  );
  getIt.registerLazySingleton<LevelCelebrationLocalDataSource>(
    () => LevelCelebrationLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<ListeningStatsRepository>(
    () => ListeningStatsRepositoryImpl(
      localDataSource: getIt(),
      remoteDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton(() => WatchListeningStats(getIt()));
  getIt.registerLazySingleton(() => RecordListeningSession(getIt()));
  getIt.registerLazySingleton(() => SwitchListeningStatsUser(getIt()));
  getIt.registerLazySingleton(() => MergeGuestStatsToUser(getIt()));
  getIt.registerLazySingleton(() => FlushListeningStatsToGuest(getIt()));
  getIt.registerLazySingleton(() => SyncListeningStatsWithServer(getIt()));
  getIt.registerLazySingleton(() => FetchListeningStatsFromServer(getIt()));
  getIt.registerLazySingleton(
    () => GamificationBloc(watchListeningStats: getIt()),
  );

  getIt.registerLazySingleton(() => LevelUpCelebrationService.instance);
}

void _initTamtama() {
  getIt.registerLazySingleton<TamtamaLocalDataSource>(
    () => TamtamaLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<TamtamaRepository>(
    () => TamtamaRepositoryImpl(localDataSource: getIt()),
  );
  getIt.registerFactory(() => TamtamaBloc(repository: getIt()));
}

void _initAuth() {
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: getIt()),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  getIt.registerLazySingleton(() => LoginWithEmail(getIt()));
  getIt.registerLazySingleton(() => LoginWithGoogle(getIt()));
  getIt.registerLazySingleton(() => Logout(getIt()));
  getIt.registerLazySingleton(() => RefreshToken(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUser(getIt()));
  getIt.registerLazySingleton(() => CheckAuthStatus(getIt()));
  getIt.registerLazySingleton(() => AutoLogin(getIt()));
  getIt.registerLazySingleton(
    () => AuthBloc(
      loginWithEmail: getIt(),
      loginWithGoogle: getIt(),
      logout: getIt(),
      refreshToken: getIt(),
      getCurrentUser: getIt(),
      checkAuthStatus: getIt(),
      mergeGuestStatsToUser: getIt(),
      flushListeningStatsToGuest: getIt(),
      syncListeningStatsWithServer: getIt(),
      fetchListeningStatsFromServer: getIt(),
    ),
  );
}
