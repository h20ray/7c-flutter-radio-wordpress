import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/loading_app_page.dart';
import '../../features/radio/presentation/pages/radio_page.dart';
import '../../features/radio/presentation/bloc/radio_bloc.dart';
import '../../features/radio/presentation/bloc/radio_player_bloc.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/wordpress/presentation/bloc/wordpress_bloc.dart';
import '../di/injection_container.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.initial:
      case AppRoutes.loadingApp:
        return MaterialPageRoute(
          builder: (_) => const LoadingAppPage(),
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: getIt<RadioBloc>(),
              ),
              BlocProvider.value(
                value: getIt<RadioPlayerBloc>(),
              ),
              BlocProvider.value(
                value: getIt<WordPressBloc>(),
              ),
              BlocProvider(
                create: (_) => getIt<HomeBloc>(),
              ),
            ],
            child: const HomeScreen(),
          ),
        );
      case AppRoutes.radio:
        return MaterialPageRoute(
          builder: (_) => const RadioPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

