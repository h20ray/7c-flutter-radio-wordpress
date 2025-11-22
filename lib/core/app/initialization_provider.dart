import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../di/injection_container.dart';
import 'loading_state_provider.dart';

enum AppState {
  introNotDone,
  loggedIn,
  loggedOut,
  initializing,
}

class InitializationState {
  final bool isCriticalInitComplete;
  final bool isLazyInitComplete;
  final AppState currentAppState;
  final Object? error;
  final StackTrace? stackTrace;

  const InitializationState({
    this.isCriticalInitComplete = false,
    this.isLazyInitComplete = false,
    this.currentAppState = AppState.initializing,
    this.error,
    this.stackTrace,
  });

  InitializationState copyWith({
    bool? isCriticalInitComplete,
    bool? isLazyInitComplete,
    AppState? currentAppState,
    Object? error,
    StackTrace? stackTrace,
  }) {
    return InitializationState(
      isCriticalInitComplete:
          isCriticalInitComplete ?? this.isCriticalInitComplete,
      isLazyInitComplete: isLazyInitComplete ?? this.isLazyInitComplete,
      currentAppState: currentAppState ?? this.currentAppState,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }
}

class InitializationArgument {
  final BuildContext context;

  InitializationArgument({
    required this.context,
  });
}

class AppInitializer {
  final LoadingStateNotifier loadingNotifier;
  InitializationState _state = const InitializationState();

  AppInitializer({required this.loadingNotifier});

  InitializationState get state => _state;

  Future<void> initialize(InitializationArgument arg) async {
    if (_state.isCriticalInitComplete) return;

    try {
      await _performCriticalInitialization(arg);

      final appState = await _determineAppState();

      _state = _state.copyWith(
        isCriticalInitComplete: true,
        currentAppState: appState,
      );

      _performLazyInitialization(arg).then((_) {
        _state = _state.copyWith(isLazyInitComplete: true);
      }).catchError((e, st) {
        // We don't fail the app for lazy init errors
      });
    } catch (e, st) {
      _state = _state.copyWith(
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<void> _performCriticalInitialization(
      InitializationArgument arg) async {
    void updateProgress(double progress, LoadingStatus status) {
      Future.microtask(() {
        loadingNotifier.updateProgress(progress, status);
      });
    }

    updateProgress(0.1, LoadingStatus.initializingDependencies);
    await initDependencies();

    updateProgress(0.2, LoadingStatus.initializingStorage);
    await Hive.openBox('settingsBox');

    updateProgress(0.3, LoadingStatus.initializingConnectivity);

    updateProgress(0.4, LoadingStatus.initializingNotifications);

    updateProgress(0.5, LoadingStatus.initializingDependencies);

    updateProgress(0.6, LoadingStatus.initializingAuth);

    updateProgress(0.7, LoadingStatus.initializingRadio);

    updateProgress(0.9, LoadingStatus.preparingApp);
  }

  Future<void> _performLazyInitialization(InitializationArgument arg) async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
    } catch (e) {
      if (e.toString().contains('duplicate-app') ||
          e.toString().contains('already exists')) {
        // Firebase already initialized, ignore
      } else {
        rethrow;
      }
    }
  }

  Future<AppState> _determineAppState() async {
    return AppState.loggedOut;
  }
}

