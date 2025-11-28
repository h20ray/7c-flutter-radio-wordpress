import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/loading_app_page.dart';
import '../../features/radio/presentation/pages/radio_page.dart';
import '../../features/radio/presentation/bloc/radio_bloc.dart';
import '../../features/radio/presentation/bloc/radio_player_bloc.dart';
import '../../features/gamification/presentation/bloc/gamification_bloc.dart';
import '../../features/gamification/presentation/pages/level_details_page.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/wordpress/presentation/bloc/wordpress_bloc.dart';
import '../../features/wordpress/presentation/pages/news_page.dart';
import '../../features/tamtama/presentation/bloc/tamtama_bloc.dart';
import '../di/injection_container.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.initial:
      case AppRoutes.loadingApp:
        return MaterialPageRoute(builder: (_) => const LoadingAppPage());
      case AppRoutes.home:
        return _buildPageRoute(
          settings,
          (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<RadioBloc>()),
              BlocProvider.value(value: getIt<RadioPlayerBloc>()),
              BlocProvider.value(value: getIt<WordPressBloc>()),
              BlocProvider.value(value: getIt<HomeBloc>()),
              BlocProvider.value(value: getIt<GamificationBloc>()),
              BlocProvider(
                create: (_) =>
                    getIt<TamtamaBloc>()..add(const TamtamaEvent.load()),
              ),
            ],
            child: const HomeScreen(),
          ),
        );
      case AppRoutes.radio:
        return _buildPageRoute(settings, (_) => const RadioPage());
      case AppRoutes.news:
        return _buildPageRoute(settings, (_) => const NewsPage());
      case AppRoutes.levelDetails:
        return _buildPageRoute(settings, (_) {
          final bloc = getIt<GamificationBloc>();
          bloc.state.maybeWhen(
            initial: () => bloc.add(const GamificationEvent.started()),
            orElse: () {},
          );
          return BlocProvider.value(
            value: bloc,
            child: const LevelDetailsPage(),
          );
        });
      default:
        return _buildPageRoute(
          settings,
          (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static PageRouteBuilder<dynamic> _buildPageRoute(
    RouteSettings settings,
    WidgetBuilder builder,
  ) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return builder(context);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(opacity: curvedAnimation, child: child);
      },
    );
  }
}
