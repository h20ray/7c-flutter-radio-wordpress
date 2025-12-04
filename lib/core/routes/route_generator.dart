import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/loading_app_page.dart';
import '../../features/radio/presentation/pages/radio_page.dart';
import '../../features/radio/presentation/bloc/radio_bloc.dart';
import '../../features/radio/presentation/bloc/radio_player_bloc.dart';
import '../../features/radio/presentation/pages/song_history_page.dart';
import '../../features/radio/presentation/pages/lyrics_page.dart';
import '../../features/radio/presentation/pages/request_page.dart';
import '../../features/radio/presentation/pages/radio_about_page.dart';
import '../../features/gamification/presentation/bloc/gamification_bloc.dart';
import '../../features/gamification/presentation/pages/level_details_page.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/wordpress/presentation/bloc/news_feed_bloc.dart';
import '../../features/wordpress/presentation/pages/news_page.dart';
import '../../features/wordpress/presentation/pages/post_detail_page_view.dart';
import '../../features/wordpress/domain/entities/post_entity.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/tamtama/presentation/bloc/tamtama_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../di/injection_container.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.initial:
      case AppRoutes.loadingApp:
        return MaterialPageRoute(builder: (context) => const LoadingAppPage());
      case AppRoutes.home:
        return _buildPageRoute(
          settings,
          (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<RadioBloc>()),
              BlocProvider.value(value: getIt<RadioPlayerBloc>()),
              BlocProvider.value(value: getIt<NewsFeedBloc>()),
              BlocProvider.value(value: getIt<HomeBloc>()),
              BlocProvider.value(value: getIt<GamificationBloc>()),
              BlocProvider.value(value: getIt<AuthBloc>()),
              BlocProvider(
                create: (context) =>
                    getIt<TamtamaBloc>()..add(const TamtamaEvent.load()),
              ),
            ],
            child: const HomeScreen(),
          ),
        );
      case AppRoutes.radio:
        return _buildPageRoute(settings, (context) => const RadioPage());
      case AppRoutes.news:
        return _buildPageRoute(settings, (context) => const NewsPage());
      case AppRoutes.profile:
        return _buildPageRoute(settings, (context) => const ProfilePage());
      case AppRoutes.levelDetails:
        return _buildPageRoute(settings, (context) {
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
      case AppRoutes.postDetail:
        final args = settings.arguments;
        PostEntity? post;
        if (args is PostEntity) {
          post = args;
        } else if (args is Map<String, dynamic> &&
            args['post'] is PostEntity) {
          post = args['post'] as PostEntity;
        }

        if (post == null) {
          return _buildPageRoute(
            settings,
            (context) => Scaffold(
              body: Center(child: Text('Post not found')),
            ),
          );
        }
        return _buildPostDetailRoute(settings, post);
      case AppRoutes.songHistory:
        return _buildPageRoute(
          settings,
          (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<RadioPlayerBloc>()),
            ],
            child: const SongHistoryPage(),
          ),
        );
      case AppRoutes.lyrics:
        return _buildPageRoute(
          settings,
          (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<RadioPlayerBloc>()),
            ],
            child: const LyricsPage(),
          ),
        );
      case AppRoutes.request:
        return _buildPageRoute(
          settings,
          (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<RadioPlayerBloc>()),
            ],
            child: const RequestPage(),
          ),
        );
      case AppRoutes.radioAbout:
        return _buildPageRoute(
          settings,
          (context) => const RadioAboutPage(),
        );
      default:
        if (settings.name?.startsWith('/auth/') ?? false) {
          return _handleAuthDeepLink(settings);
        }
        return _buildPageRoute(
          settings,
          (context) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static Route<dynamic> _handleAuthDeepLink(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '');
    final path = uri.path;
    
    if (path.contains('/auth/callback')) {
      final authBloc = getIt<AuthBloc>();
      final code = uri.queryParameters['code'];
      final error = uri.queryParameters['error'];
      
      if (error != null) {
        authBloc.add(const AuthEvent.tokenExpired());
      } else if (code != null) {
        // Handle OAuth callback - would need to exchange code for token
        // For now, just check auth status
        authBloc.add(const AuthEvent.checkAuthStatus());
      }
      
      return _buildPageRoute(
        settings,
        (context) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Completing authentication...'),
              ],
            ),
          ),
        ),
      );
    }
    
    return _buildPageRoute(
      settings,
      (context) => Scaffold(
        body: Center(child: Text('Unknown auth route: ${settings.name}')),
      ),
    );
  }

  static PageRouteBuilder<dynamic> _buildPageRoute(
    RouteSettings settings,
    WidgetBuilder builder,
  ) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
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

  static PageRouteBuilder<dynamic> _buildPostDetailRoute(
    RouteSettings settings,
    PostEntity post,
  ) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BlocProvider.value(
          value: getIt<NewsFeedBloc>(),
          child: PostDetailPageView(
            post: post,
          ),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        final slideAnimation = Tween(begin: begin, end: end).animate(
          CurvedAnimation(
            parent: animation,
            curve: curve,
            reverseCurve: Curves.easeInCubic,
          ),
        );

        final fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: curve,
            reverseCurve: Curves.easeInCubic,
          ),
        );

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }
}
