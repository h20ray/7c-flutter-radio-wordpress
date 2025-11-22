import 'package:flutter/material.dart';

import '../pages/loading_app_page.dart';
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
          builder: (_) => const Scaffold(
            body: Center(child: Text('Home Page')),
          ),
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

