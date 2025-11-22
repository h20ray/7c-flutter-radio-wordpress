import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../../config/wp_config.dart';

import '../../features/radio/data/datasources/radio_remote_datasource.dart';
import '../../features/radio/data/repositories/radio_repository_impl.dart';
import '../../features/radio/domain/repositories/radio_repository.dart';
import '../../features/radio/domain/usecases/get_radio_config.dart';
import '../../features/radio/presentation/bloc/radio_bloc.dart';

import '../../features/shoutbox/data/datasources/shoutbox_remote_datasource.dart';
import '../../features/shoutbox/data/repositories/shoutbox_repository_impl.dart';
import '../../features/shoutbox/domain/repositories/shoutbox_repository.dart';
import '../../features/shoutbox/domain/usecases/get_shoutbox_messages.dart';
import '../../features/shoutbox/domain/usecases/send_shoutbox_message.dart';
import '../../features/shoutbox/domain/usecases/delete_shoutbox_message.dart';
import '../../features/shoutbox/presentation/bloc/shoutbox_bloc.dart';

import '../../features/wordpress/data/datasources/wordpress_remote_datasource.dart';
import '../../features/wordpress/data/repositories/wordpress_repository_impl.dart';
import '../../features/wordpress/domain/repositories/wordpress_repository.dart';
import '../../features/wordpress/domain/usecases/get_posts.dart';
import '../../features/wordpress/presentation/bloc/wordpress_bloc.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  if (getIt.isRegistered<Dio>()) {
    return;
  }

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options.baseUrl = 'https://${WPConfig.url}';
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    return dio;
  });

  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt()));

  final connectivity = Connectivity();
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity),
  );

  _initRadio();
  _initShoutbox();
  _initWordPress();
}

void _initRadio() {
  getIt.registerLazySingleton<RadioRemoteDataSource>(
    () => RadioRemoteDataSourceImpl(apiClient: getIt()),
  );

  getIt.registerLazySingleton<RadioRepository>(
    () => RadioRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(() => GetRadioConfig(getIt()));

  getIt.registerFactory(
    () => RadioBloc(getRadioConfig: getIt()),
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

