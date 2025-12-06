import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/app_config.dart';
import 'core/di/injection_container.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/route_generator.dart';
import 'core/services/level_up_celebration_service.dart';
import 'core/themes/app_theme.dart';
import 'core/widgets/global_level_up_overlay.dart';
import 'features/gamification/presentation/bloc/gamification_bloc.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  PaintingBinding.instance.imageCache.maximumSize = 100;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024;
  
  await EasyLocalization.ensureInitialized();
  
  Directory appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);
  
  await initDependencies();
  
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  
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

class TujuhCahayaApp extends StatefulWidget {
  const TujuhCahayaApp({super.key, this.savedThemeMode});
  final AdaptiveThemeMode? savedThemeMode;

  @override
  State<TujuhCahayaApp> createState() => _TujuhCahayaAppState();
}

class _TujuhCahayaAppState extends State<TujuhCahayaApp> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: AppTheme.lightTheme,
      dark: AppTheme.darkTheme,
      initial: widget.savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) {
        Widget app = MaterialApp(
          title: AppConfig.appName,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: theme,
          darkTheme: darkTheme,
          navigatorObservers: [routeObserver],
          onGenerateRoute: RouteGenerator.onGenerate,
          initialRoute: AppRoutes.initial,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return Stack(
              children: [
                child ?? const SizedBox.shrink(),
                const GlobalLevelUpOverlay(),
              ],
            );
          },
        );

        // Dependencies are guaranteed to be registered now
        final gamificationBloc = getIt<GamificationBloc>();
        gamificationBloc.state.maybeWhen(
          initial: () => gamificationBloc.add(const GamificationEvent.started()),
          orElse: () {},
        );
        
        app = BlocProvider.value(
          value: gamificationBloc,
          child: BlocListener<GamificationBloc, GamificationState>(
            listener: (context, state) {
              state.maybeWhen(
                loaded: (data) {
                  if (getIt.isRegistered<LevelUpCelebrationService>()) {
                    final service = getIt<LevelUpCelebrationService>();
                    service.checkAndShowCelebration(data);
                  }
                },
                orElse: () {},
              );
            },
            child: app,
          ),
        );

        return app;
      },
    );
  }
}
