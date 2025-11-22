import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../app/initialization_provider.dart';
import '../app/loading_state_provider.dart';
import '../routes/app_routes.dart';
import '../utils/debug_logger.dart';
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

  @override
  void initState() {
    super.initState();
    _appInitializer = AppInitializer(loadingNotifier: _loadingNotifier);
    _checkConnectivity();
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
      _initializeApp();
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
    DebugLogger.log('Starting app initialization...', tag: 'LoadingPage');

    final startTime = DateTime.now();
    
    _loadingNotifier.updateProgress(0.05, LoadingStatus.loadingConfig);

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) {
      DebugLogger.log('Widget unmounted during initialization', tag: 'LoadingPage');
      return;
    }
    
    try {
      await _appInitializer.initialize(
        InitializationArgument(context: context),
      );
      DebugLogger.log('Initialization completed successfully', tag: 'LoadingPage');
    } catch (e, st) {
      DebugLogger.logError('Initialization failed', error: e, stackTrace: st, tag: 'LoadingPage');
    }

    _loadingNotifier.updateProgress(1.0, LoadingStatus.complete);

    final elapsed = DateTime.now().difference(startTime);
    final minDisplayTime = const Duration(seconds: 2);
    
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
    final radioState = _appInitializer.radioState;
    DebugLogger.log('Determining navigation target...', tag: 'LoadingPage');
    DebugLogger.log('Radio state: ${radioState?.runtimeType}', tag: 'LoadingPage');
    
    if (radioState == null) {
      DebugLogger.log('Radio state is null, defaulting to home', tag: 'LoadingPage');
      DebugLogger.logNavigation(AppRoutes.home, reason: 'Radio state null');
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      return;
    }
    
    radioState.maybeWhen(
      loaded: (radioEntity) {
        DebugLogger.log('Radio config loaded - enabled: ${radioEntity.enabled}', tag: 'LoadingPage');
        if (radioEntity.enabled) {
          DebugLogger.logNavigation(AppRoutes.radio, reason: 'Radio enabled');
          Navigator.of(context).pushReplacementNamed(AppRoutes.radio);
        } else {
          DebugLogger.logNavigation(AppRoutes.home, reason: 'Radio disabled');
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        }
      },
      error: (failure) {
        DebugLogger.logError('Radio config error: ${failure.message}', tag: 'LoadingPage');
        DebugLogger.logNavigation(AppRoutes.home, reason: 'Radio config error');
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      },
      orElse: () {
        DebugLogger.log('Radio state not loaded, defaulting to home', tag: 'LoadingPage');
        DebugLogger.logNavigation(AppRoutes.home, reason: 'Radio state not available');
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingConnectivity) {
      _loadingNotifier.updateProgress(0.0, LoadingStatus.checkingConnection);
      return LoadingDependencies(loadingState: _loadingNotifier.state);
    }

    if (_connectivityResult == ConnectivityResult.none) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('No Internet Connection'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isCheckingConnectivity = true;
                    _isInitialized = false;
                  });
                  _checkConnectivity();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return LoadingDependencies(loadingState: _loadingNotifier.state);
  }
}

