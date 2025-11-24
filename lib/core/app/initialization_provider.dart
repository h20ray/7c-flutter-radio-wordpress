import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../di/injection_container.dart';
import '../error/exceptions.dart';
import '../error/failures.dart';
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
      final settingsBox = await Hive.openBox('settingsBox');
      final wasInitialized = settingsBox.get('app_initialized', defaultValue: false) as bool;

      if (wasInitialized) {
        DebugLogger.log('App was previously initialized, skipping full initialization', tag: 'AppInitializer');
        await _performQuickInitialization(arg);
        _state = _state.copyWith(
          isCriticalInitComplete: true,
          currentAppState: await _determineAppState(),
        );
        return;
      }

      await _performCriticalInitialization(arg);

      final appState = await _determineAppState();

      await settingsBox.put('app_initialized', true);
      await settingsBox.put('app_initialized_at', DateTime.now().toIso8601String());

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

  Future<void> _performQuickInitialization(InitializationArgument arg) async {
    DebugLogger.log('Performing quick initialization (already initialized before)', tag: 'AppInitializer');
    
    try {
      await initDependencies();
      await Hive.openBox('settingsBox');
      
      try {
        await _prefetchRadioConfig();
        DebugLogger.log('Radio config prefetched during quick initialization', tag: 'AppInitializer');
      } catch (e) {
        DebugLogger.logError('Radio config prefetch failed during quick init (non-critical)', error: e, tag: 'AppInitializer');
      }
      
      DebugLogger.log('Quick initialization complete', tag: 'AppInitializer');
    } catch (e, st) {
      DebugLogger.logError('Quick initialization failed, will perform full initialization', error: e, stackTrace: st, tag: 'AppInitializer');
      final settingsBox = await Hive.openBox('settingsBox');
      await settingsBox.put('app_initialized', false);
      await _performCriticalInitialization(arg);
    }
  }

  Future<void> _performCriticalInitialization(
      InitializationArgument arg) async {
    void updateProgress(double progress, LoadingStatus status) {
      loadingNotifier.updateProgress(progress, status);
      DebugLogger.logInit(status.toString(), progress: progress);
    }

    DebugLogger.log('Starting critical initialization', tag: 'AppInitializer');
    updateProgress(0.1, LoadingStatus.initializingDependencies);
    try {
      await initDependencies();
    } catch (e, st) {
      DebugLogger.logError('Dependencies initialization failed', error: e, stackTrace: st, tag: 'AppInitializer');
      if (e is Failure) {
        rethrow;
      } else if (e is NetworkException) {
        throw const NetworkFailure('Failed to initialize dependencies: Network error');
      } else if (e is ServerException) {
        throw ServerFailure('Failed to initialize dependencies: ${e.message}');
      } else {
        throw ConfigurationFailure('Failed to initialize dependencies: ${e.toString()}');
      }
    }
    await Future.delayed(const Duration(milliseconds: 50));
    DebugLogger.log('Dependencies initialized', tag: 'AppInitializer');

    updateProgress(0.2, LoadingStatus.initializingStorage);
    try {
      await Hive.openBox('settingsBox');
    } catch (e, st) {
      DebugLogger.logError('Storage initialization failed', error: e, stackTrace: st, tag: 'AppInitializer');
      throw CacheFailure('Failed to initialize storage: ${e.toString()}');
    }
    await Future.delayed(const Duration(milliseconds: 50));
    DebugLogger.log('Storage initialized', tag: 'AppInitializer');

    updateProgress(0.3, LoadingStatus.initializingConnectivity);
    await Future.delayed(const Duration(milliseconds: 50));
    DebugLogger.log('Connectivity check completed', tag: 'AppInitializer');

    updateProgress(0.4, LoadingStatus.initializingNotifications);
    await Future.delayed(const Duration(milliseconds: 50));
    DebugLogger.log('Notifications initialized', tag: 'AppInitializer');

    updateProgress(0.5, LoadingStatus.initializingDependencies);
    await Future.delayed(const Duration(milliseconds: 50));
    DebugLogger.log('Additional dependencies initialized', tag: 'AppInitializer');

    updateProgress(0.6, LoadingStatus.initializingAuth);
    await Future.delayed(const Duration(milliseconds: 50));
    DebugLogger.log('Auth initialized', tag: 'AppInitializer');

    updateProgress(0.7, LoadingStatus.initializingRadio);
    await _prefetchRadioConfig();
    await Future.delayed(const Duration(milliseconds: 50));
    DebugLogger.log('Radio config prefetched', tag: 'AppInitializer');

    updateProgress(0.9, LoadingStatus.preparingApp);
    await Future.delayed(const Duration(milliseconds: 50));
    DebugLogger.log('Critical initialization complete', tag: 'AppInitializer');
  }

  Future<void> _prefetchRadioConfig() async {
    StreamSubscription? subscription;
    try {
      DebugLogger.logRadio('Starting radio config prefetch', state: 'prefetch');
      final radioBloc = getIt<RadioBloc>();
      
      final currentState = radioBloc.state;
      DebugLogger.logRadio('Current radio state before fetch: ${currentState.runtimeType}', state: 'current');
      
      radioBloc.add(const RadioEvent.getRadioConfig());

      final completer = Completer<void>();
      Failure? radioFailure;
      
      subscription = radioBloc.stream.listen((state) {
        _radioState = state;
        state.maybeWhen(
          loaded: (radioEntity) {
            DebugLogger.logRadio('Radio config loaded - enabled: ${radioEntity.enabled}, streamUrl: ${radioEntity.streamUrl}', state: 'loaded');
          },
          error: (failure) {
            DebugLogger.logError('Radio config error: ${failure.message}', tag: 'AppInitializer');
            radioFailure = failure;
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
            if (radioFailure != null) {
              completer.completeError(radioFailure!);
            } else {
              completer.complete();
            }
          }
        }
      });

      try {
        await completer.future.timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            DebugLogger.logError('Radio config prefetch timeout after 10 seconds', tag: 'AppInitializer');
            subscription?.cancel();
            _radioState = null;
            throw const TimeoutFailure('Radio config prefetch timeout');
          },
        );
      } catch (e) {
        subscription.cancel();
        if (e is Failure) {
          rethrow;
        }
        throw TimeoutFailure('Radio config prefetch failed: ${e.toString()}');
      }
    } catch (e, st) {
      subscription?.cancel();
      DebugLogger.logError('Radio prefetch failed', error: e, stackTrace: st, tag: 'AppInitializer');
      _radioState = null;
      if (e is Failure) {
        rethrow;
      }
      throw ServerFailure('Failed to prefetch radio config: ${e.toString()}');
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

