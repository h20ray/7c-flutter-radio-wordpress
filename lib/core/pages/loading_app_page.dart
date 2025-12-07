import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../app/initialization_provider.dart';
import '../app/loading_state_provider.dart';
import '../error/failures.dart';
import '../routes/app_routes.dart';
import '../utils/debug_logger.dart';
import '../widgets/initialization_error_page.dart';
import '../widgets/loading_dependencies.dart';

class LoadingAppPage extends StatefulWidget {
  const LoadingAppPage({super.key});

  @override
  State<LoadingAppPage> createState() => _LoadingAppPageState();
}

class _LoadingAppPageState extends State<LoadingAppPage> {
  final LoadingStateNotifier _loadingNotifier = LoadingStateNotifier();
  late final AppInitializer _appInitializer;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  bool _isCheckingConnectivity = true;
  bool _isInitialized = false;
  Failure? _initializationError;
  Object? _initializationException;

  @override
  void initState() {
    super.initState();
    _appInitializer = AppInitializer(loadingNotifier: _loadingNotifier);
    _checkConnectivity();
  }

  Future<bool> _checkIfAlreadyInitialized() async {
    try {
      final settingsBox = await Hive.openBox('settingsBox');
      return settingsBox.get('app_initialized', defaultValue: false) as bool;
    } catch (e) {
      DebugLogger.logError('Failed to check initialization status', error: e, tag: 'LoadingPage');
      return false;
    }
  }

  Future<void> _checkConnectivity() async {
    DebugLogger.log('Checking connectivity...', tag: 'LoadingPage');
    final connectivity = Connectivity();
    final result = await connectivity.checkConnectivity();
    
    setState(() {
      _connectivityResult = result.first;
      _isCheckingConnectivity = false;
    });

    DebugLogger.log('Connectivity result: $_connectivityResult', tag: 'LoadingPage');
    if (_connectivityResult != ConnectivityResult.none) {
      unawaited(_initializeApp());
    } else {
      DebugLogger.log('No internet connection detected', tag: 'LoadingPage');
    }
  }

  Future<void> _initializeApp() async {
    if (_isInitialized) {
      DebugLogger.log('App already initialized, skipping', tag: 'LoadingPage');
      return;
    }

    _isInitialized = true;
    final wasInitialized = await _checkIfAlreadyInitialized();
    
    if (wasInitialized) {
      DebugLogger.log('App was previously initialized, performing quick initialization', tag: 'LoadingPage');
      _loadingNotifier.updateProgress(0.1, LoadingStatus.initializingDependencies);
    } else {
      DebugLogger.log('Starting app initialization...', tag: 'LoadingPage');
      _loadingNotifier.updateProgress(0.05, LoadingStatus.loadingConfig);
      await Future.delayed(const Duration(milliseconds: 500));
    }

    final startTime = DateTime.now();

    if (!mounted) {
      DebugLogger.log('Widget unmounted during initialization', tag: 'LoadingPage');
      return;
    }
    
    try {
      await _appInitializer.initialize(
        InitializationArgument(context: context),
      );
      DebugLogger.log('Initialization completed successfully', tag: 'LoadingPage');

      final initState = _appInitializer.state;
      if (initState.error != null) {
        DebugLogger.logError(
          'Initialization completed with error',
          error: initState.error,
          stackTrace: initState.stackTrace,
          tag: 'LoadingPage',
        );
        if (initState.error is Failure) {
          setState(() {
            _initializationError = initState.error as Failure;
          });
          return;
        } else {
          setState(() {
            _initializationException = initState.error;
          });
          return;
        }
      }
    } catch (e, st) {
      DebugLogger.logError('Initialization failed', error: e, stackTrace: st, tag: 'LoadingPage');
      if (e is Failure) {
        setState(() {
          _initializationError = e;
        });
        return;
      } else {
        setState(() {
          _initializationException = e;
        });
        return;
      }
    }

    if (_loadingNotifier.state.errorMessage != null) {
      DebugLogger.logError(
        'Loading state has error message',
        error: _loadingNotifier.state.errorMessage,
        tag: 'LoadingPage',
      );
      return;
    }

    _loadingNotifier.updateProgress(1.0, LoadingStatus.complete);

    final elapsed = DateTime.now().difference(startTime);
    const minDisplayTime = Duration(seconds: 2);
    
    if (elapsed < minDisplayTime) {
      final remainingTime = minDisplayTime - elapsed;
      DebugLogger.log('Ensuring minimum loading screen display time: ${remainingTime.inMilliseconds}ms', tag: 'LoadingPage');
      await Future.delayed(remainingTime);
    }

    if (!mounted) {
      DebugLogger.log('Widget unmounted after initialization', tag: 'LoadingPage');
      return;
    }
    _navigateToAppropriateScreen();
  }

  void _navigateToAppropriateScreen() {
    if (_initializationError != null || _initializationException != null) {
      DebugLogger.log('Initialization error detected, not navigating', tag: 'LoadingPage');
      return;
    }

    DebugLogger.log('Navigating to home screen', tag: 'LoadingPage');
    DebugLogger.logNavigation(AppRoutes.home, reason: 'Default landing page');
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  void _handleRetry() {
    setState(() {
      _initializationError = null;
      _initializationException = null;
      _isInitialized = false;
      _isCheckingConnectivity = true;
    });
    _loadingNotifier.reset();
    _checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    if (_initializationError != null) {
      return InitializationErrorPage.fromFailure(
        _initializationError!,
        onRetry: _handleRetry,
      );
    }

    if (_initializationException != null) {
      return InitializationErrorPage.fromException(
        _initializationException!,
        onRetry: _handleRetry,
      );
    }

    if (_loadingNotifier.state.errorMessage != null) {
      return InitializationErrorPage(
        errorType: InitializationErrorType.unknown,
        errorMessage: _loadingNotifier.state.errorMessage,
        onRetry: _handleRetry,
      );
    }

    if (_isCheckingConnectivity) {
      _loadingNotifier.updateProgress(0.0, LoadingStatus.checkingConnection);
      return ListenableBuilder(
        listenable: _loadingNotifier,
        builder: (context, _) {
          return LoadingDependencies(loadingState: _loadingNotifier.state);
        },
      );
    }

    if (_connectivityResult == ConnectivityResult.none) {
      return InitializationErrorPage(
        errorType: InitializationErrorType.connectivity,
        onRetry: _handleRetry,
      );
    }

    return ListenableBuilder(
      listenable: _loadingNotifier,
      builder: (context, _) {
        return LoadingDependencies(loadingState: _loadingNotifier.state);
      },
    );
  }
}

