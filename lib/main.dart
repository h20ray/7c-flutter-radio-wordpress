import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'config/wp_config.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/route_generator.dart';
import 'core/themes/app_theme.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await EasyLocalization.ensureInitialized();
  
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  
  Directory appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);
  
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('id', 'ID'),
      ],
      path: 'assets/translations',
      startLocale: const Locale('id', 'ID'),
      fallbackLocale: const Locale('id', 'ID'),
      child: TujuhCahayaApp(savedThemeMode: savedThemeMode),
    ),
  );
}

class TujuhCahayaApp extends StatelessWidget {
  const TujuhCahayaApp({super.key, this.savedThemeMode});
  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: AppTheme.lightTheme,
      dark: AppTheme.darkTheme,
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        title: WPConfig.appName,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: theme,
        darkTheme: darkTheme,
        navigatorObservers: [routeObserver],
        onGenerateRoute: RouteGenerator.onGenerate,
        initialRoute: AppRoutes.initial,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
