import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

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
    DebugLogger.log('Navigating to home screen', tag: 'LoadingPage');
    DebugLogger.logNavigation(AppRoutes.home, reason: 'Default landing page');
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
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
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.wifi_off, size: 64, color: Colors.grey),
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

    return ListenableBuilder(
      listenable: _loadingNotifier,
      builder: (context, _) {
        return LoadingDependencies(loadingState: _loadingNotifier.state);
      },
    );
  }
}

