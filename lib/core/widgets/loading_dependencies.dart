import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../app/loading_state_provider.dart';
import '../../config/wp_config.dart';

class LoadingDependencies extends StatefulWidget {
  const LoadingDependencies({
    super.key,
    required this.loadingState,
  });

  final LoadingState loadingState;

  @override
  State<LoadingDependencies> createState() => _LoadingDependenciesState();
}

class _LoadingDependenciesState extends State<LoadingDependencies> {
  final Color _textColor = Colors.white.withValues(alpha: 0.9);
  final Color _progressBarColor = WPConfig.primaryColor;

  String _getStatusTranslationKey(LoadingStatus status) {
    switch (status) {
      case LoadingStatus.checkingConnection:
        return 'loading_checking_connection';
      case LoadingStatus.loadingConfig:
        return 'loading_config';
      case LoadingStatus.initializingDependencies:
        return 'loading_dependencies';
      case LoadingStatus.initializingStorage:
        return 'loading_storage';
      case LoadingStatus.initializingConnectivity:
        return 'loading_connectivity';
      case LoadingStatus.initializingNotifications:
        return 'loading_notifications';
      case LoadingStatus.initializingAuth:
        return 'loading_auth';
      case LoadingStatus.initializingRadio:
        return 'loading_radio';
      case LoadingStatus.preparingApp:
        return 'loading_preparing';
      case LoadingStatus.complete:
        return 'loading_complete';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final statusKey = _getStatusTranslationKey(widget.loadingState.status);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/others/loading.png',
            fit: BoxFit.cover,
            width: size.width,
            height: size.height,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.black,
                child: Center(
                  child: Text(
                    WPConfig.appName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusKey.tr(),
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: widget.loadingState.progress,
                      minHeight: 2.0,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(_progressBarColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

