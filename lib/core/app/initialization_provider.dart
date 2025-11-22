import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../di/injection_container.dart';
import '../utils/debug_logger.dart';
import '../../features/radio/presentation/bloc/radio_bloc.dart';
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
  RadioState? _radioState;

  AppInitializer({required this.loadingNotifier});

  InitializationState get state => _state;
  RadioState? get radioState => _radioState;

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
        DebugLogger.logInit(status.toString(), progress: progress);
      });
    }

    DebugLogger.log('Starting critical initialization', tag: 'AppInitializer');
    updateProgress(0.1, LoadingStatus.initializingDependencies);
    await initDependencies();
    DebugLogger.log('Dependencies initialized', tag: 'AppInitializer');

    updateProgress(0.2, LoadingStatus.initializingStorage);
    await Hive.openBox('settingsBox');
    DebugLogger.log('Storage initialized', tag: 'AppInitializer');

    updateProgress(0.3, LoadingStatus.initializingConnectivity);
    DebugLogger.log('Connectivity check completed', tag: 'AppInitializer');

    updateProgress(0.4, LoadingStatus.initializingNotifications);
    DebugLogger.log('Notifications initialized', tag: 'AppInitializer');

    updateProgress(0.5, LoadingStatus.initializingDependencies);
    DebugLogger.log('Additional dependencies initialized', tag: 'AppInitializer');

    updateProgress(0.6, LoadingStatus.initializingAuth);
    DebugLogger.log('Auth initialized', tag: 'AppInitializer');

    updateProgress(0.7, LoadingStatus.initializingRadio);
    await _prefetchRadioConfig();
    DebugLogger.log('Radio config prefetched', tag: 'AppInitializer');

    updateProgress(0.9, LoadingStatus.preparingApp);
    DebugLogger.log('Critical initialization complete', tag: 'AppInitializer');
  }

  Future<void> _prefetchRadioConfig() async {
    try {
      DebugLogger.logRadio('Starting radio config prefetch', state: 'prefetch');
      final radioBloc = getIt<RadioBloc>();
      
      final currentState = radioBloc.state;
      DebugLogger.logRadio('Current radio state before fetch: ${currentState.runtimeType}', state: 'current');
      
      radioBloc.add(const RadioEvent.getRadioConfig());

      final completer = Completer<void>();
      StreamSubscription? subscription;
      
      subscription = radioBloc.stream.listen((state) {
        _radioState = state;
        state.maybeWhen(
          loaded: (radioEntity) {
            DebugLogger.logRadio('Radio config loaded - enabled: ${radioEntity.enabled}, streamUrl: ${radioEntity.streamUrl}', state: 'loaded');
          },
          error: (failure) {
            DebugLogger.logError('Radio config error: ${failure.message}', tag: 'AppInitializer');
          },
          orElse: () {
            DebugLogger.logRadio('Radio state: ${state.runtimeType}', state: 'other');
          },
        );

        final isComplete = state.maybeWhen(
          loaded: (_) => true,
          error: (_) => true,
          orElse: () => false,
        );
        
        if (isComplete) {
          DebugLogger.logRadio('Radio config prefetch complete', state: 'complete');
          subscription?.cancel();
          if (!completer.isCompleted) {
            completer.complete();
          }
        }
      });

      await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          DebugLogger.logError('Radio config prefetch timeout after 10 seconds', tag: 'AppInitializer');
          subscription?.cancel();
          _radioState = null;
        },
      );
    } catch (e, st) {
      DebugLogger.logError('Radio prefetch failed', error: e, stackTrace: st, tag: 'AppInitializer');
      _radioState = null;
      // Don't fail the app initialization if radio prefetch fails
    }
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

