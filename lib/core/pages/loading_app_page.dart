import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../app/initialization_provider.dart';
import '../app/loading_state_provider.dart';
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
    final connectivity = Connectivity();
    final result = await connectivity.checkConnectivity();
    
    setState(() {
      _connectivityResult = result.first;
      _isCheckingConnectivity = false;
    });

    if (_connectivityResult != ConnectivityResult.none) {
      _initializeApp();
    }
  }

  Future<void> _initializeApp() async {
    if (_isInitialized) return;
    _isInitialized = true;

    _loadingNotifier.updateProgress(0.05, LoadingStatus.loadingConfig);

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    await _appInitializer.initialize(
      InitializationArgument(context: context),
    );

    _loadingNotifier.updateProgress(1.0, LoadingStatus.complete);

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home');
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

