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
import '../services/palette_service.dart';
import '../services/image_capture_service.dart';
import '../services/instagram_sticker_service.dart';
import '../services/sleep_timer_service.dart';
import '../utils/debug_logger.dart';

// Radio feature imports
import '../../features/radio/di/radio_injection.dart';
import '../../features/radio/data/repositories/greeting_repository.dart';
import '../../features/radio/data/services/album_art_service.dart';
import '../../features/radio/presentation/bloc/radio_player_bloc.dart';
import '../../features/radio/presentation/bloc/radio_player_event.dart';

// Notification center imports
import '../../features/notification_center/data/datasources/notification_local_data_source.dart';
import '../../features/notification_center/data/datasources/pending_request_local_data_source.dart';
import '../../features/notification_center/data/repositories/notification_center_repository_impl.dart';
import '../../features/notification_center/data/services/system_notification_service.dart';
import '../../features/notification_center/domain/repositories/notification_center_repository.dart';
import '../../features/notification_center/domain/repositories/pending_request_tracker.dart';
import '../../features/notification_center/presentation/cubit/notification_center_cubit.dart';

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


// TamTama feature imports
import '../../features/tamtama/di/tamtama_injection.dart';

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

// Settings feature imports
import '../../features/settings/data/datasources/settings_local_data_source.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_offline_news_settings.dart';
import '../../features/settings/domain/usecases/save_offline_news_settings.dart';
import '../../features/settings/domain/usecases/get_offline_news_stats.dart';
import '../../features/settings/domain/usecases/clear_all_offline_posts.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';

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
    dio.options.baseUrl = AppConfig.baseUrl;
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
  getIt.registerLazySingleton<PaletteService>(
    () => PaletteService(),
  );
  getIt.registerLazySingleton<ImageCaptureService>(
    () => ImageCaptureService(),
  );
  getIt.registerLazySingleton<InstagramStickerService>(
    () => InstagramStickerService(),
  );
  getIt.registerLazySingleton<SleepTimerService>(
    () => SleepTimerService(),
  );

  // Initialize features
  _initNotificationCenter();
  initTamtamaModule(getIt);
  _initGamification();
  initRadioModule(getIt);
  _initShoutbox();
  _initWordPress();
  _initCategories();
  _initHome();
  _initAuth();
  _initSettings();
  
  // Initialize network status service
  await getIt<NetworkStatusService>().initialize();

  // Initialize greeting repository
  await getIt<GreetingRepository>().initialize();

  // Initialize album art service (loads Hive cache)
  await getIt<AlbumArtService>().initialize();

  // Initialize sleep timer service and wire up completion callback
  final sleepTimer = getIt<SleepTimerService>();
  await sleepTimer.initialize();
  sleepTimer.setOnTimerComplete(() {
    getIt<RadioPlayerBloc>().add(const RadioPlayerEvent.pause());
  });

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

void _initNotificationCenter() {
  getIt.registerLazySingleton<SystemNotificationService>(
    () => SystemNotificationService(),
  );
  getIt.registerLazySingleton<NotificationLocalDataSource>(
    () => NotificationLocalDataSource(),
  );
  getIt.registerLazySingleton<PendingRequestTracker>(
    () => PendingRequestLocalDataSource(),
  );
  getIt.registerLazySingleton<NotificationCenterRepository>(
    () => NotificationCenterRepositoryImpl(
      localDataSource: getIt(),
      systemNotificationService: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => NotificationCenterCubit(repository: getIt()),
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

  getIt.registerLazySingleton(
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

  // Note: NewsFeedBloc and NewsSearchBloc are registered as lazy singletons
  // because they manage app-wide news state that should persist across navigation.
  // This is intentional and correct - they are disposed when the app terminates.
  // For page-specific state, use BlocProvider with factory registration instead.
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

void _initSettings() {
  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      localDataSource: getIt(),
      offlineNewsService: getIt(),
      wordPressLocalDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => GetOfflineNewsSettings(getIt()));
  getIt.registerLazySingleton(() => SaveOfflineNewsSettings(getIt()));
  getIt.registerLazySingleton(() => GetOfflineNewsStats(getIt()));
  getIt.registerLazySingleton(() => ClearAllOfflinePosts(getIt()));

  getIt.registerLazySingleton(
    () => SettingsBloc(
      getOfflineNewsSettings: getIt(),
      saveOfflineNewsSettings: getIt(),
      getOfflineNewsStats: getIt(),
      clearAllOfflinePosts: getIt(),
    ),
  );
  
  // Initialize offline news service with settings (fire-and-forget, non-blocking)
  _initializeOfflineNewsServiceFromSettings();
}

void _initializeOfflineNewsServiceFromSettings() {
  // Fire and forget - don't block initialization
  Future.microtask(() async {
    try {
      if (getIt.isRegistered<OfflineNewsService>() && getIt.isRegistered<SettingsLocalDataSource>()) {
        final service = getIt<OfflineNewsService>();
        final settingsDataSource = getIt<SettingsLocalDataSource>();
        final settings = await settingsDataSource.getOfflineNewsSettings();
        service.updateLimits(
          maxPosts: settings.maxPosts,
          maxSizeMB: settings.maxSizeMB,
        );
      }
    } catch (e) {
      // Use defaults if settings can't be loaded - Hive might not be initialized yet
      // This is fine, settings will be loaded when user opens settings page
    }
  });
}
