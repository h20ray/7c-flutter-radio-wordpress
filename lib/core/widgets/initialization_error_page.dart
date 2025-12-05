import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../error/failures.dart';
import '../../config/app_config.dart';

enum InitializationErrorType {
  connectivity,
  dependencies,
  storage,
  radioConfig,
  unknown,
}

class InitializationErrorPage extends StatelessWidget {
  final InitializationErrorType errorType;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const InitializationErrorPage({
    super.key,
    required this.errorType,
    this.errorMessage,
    this.onRetry,
  });

  String _getErrorTitle() {
    switch (errorType) {
      case InitializationErrorType.connectivity:
        return 'init_error_no_connection_title'.tr();
      case InitializationErrorType.dependencies:
        return 'init_error_dependencies_title'.tr();
      case InitializationErrorType.storage:
        return 'init_error_storage_title'.tr();
      case InitializationErrorType.radioConfig:
        return 'init_error_radio_config_title'.tr();
      case InitializationErrorType.unknown:
        return 'init_error_unknown_title'.tr();
    }
  }

  String _getErrorMessage() {
    if (errorMessage != null && errorMessage!.isNotEmpty) {
      return errorMessage!;
    }

    switch (errorType) {
      case InitializationErrorType.connectivity:
        return 'init_error_no_connection_message'.tr();
      case InitializationErrorType.dependencies:
        return 'init_error_dependencies_message'.tr();
      case InitializationErrorType.storage:
        return 'init_error_storage_message'.tr();
      case InitializationErrorType.radioConfig:
        return 'init_error_radio_config_message'.tr();
      case InitializationErrorType.unknown:
        return 'init_error_unknown_message'.tr();
    }
  }

  IconData _getErrorIcon() {
    switch (errorType) {
      case InitializationErrorType.connectivity:
        return LucideIcons.wifi_off;
      case InitializationErrorType.dependencies:
        return LucideIcons.package_x;
      case InitializationErrorType.storage:
        return LucideIcons.database;
      case InitializationErrorType.radioConfig:
        return LucideIcons.radio;
      case InitializationErrorType.unknown:
        return LucideIcons.circle_alert;
    }
  }

  Color _getErrorColor() {
    switch (errorType) {
      case InitializationErrorType.connectivity:
        return Colors.orange;
      case InitializationErrorType.dependencies:
      case InitializationErrorType.storage:
      case InitializationErrorType.radioConfig:
        return Colors.red;
      case InitializationErrorType.unknown:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = _getErrorColor();
    final icon = _getErrorIcon();
    final title = _getErrorTitle();
    final message = _getErrorMessage();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 80,
                  color: errorColor,
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (onRetry != null)
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(LucideIcons.refresh_cw),
                    label: Text('retry'.tr()),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppConfig.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  AppConfig.appName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white38,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  factory InitializationErrorPage.fromFailure(
    Failure failure, {
    VoidCallback? onRetry,
  }) {
    InitializationErrorType errorType;
    String? errorMessage;

    if (failure is NetworkFailure || failure is OfflineFailure) {
      errorType = InitializationErrorType.connectivity;
      errorMessage = null;
    } else if (failure is ServerFailure) {
      errorType = InitializationErrorType.radioConfig;
      errorMessage = failure.message;
    } else if (failure is TimeoutFailure) {
      errorType = InitializationErrorType.connectivity;
      errorMessage = null;
    } else if (failure is ConfigurationFailure) {
      errorType = InitializationErrorType.dependencies;
      errorMessage = failure.message;
    } else {
      errorType = InitializationErrorType.unknown;
      errorMessage = failure.message;
    }

    return InitializationErrorPage(
      errorType: errorType,
      errorMessage: errorMessage,
      onRetry: onRetry,
    );
  }

  factory InitializationErrorPage.fromException(
    Object exception, {
    VoidCallback? onRetry,
  }) {
    final message = exception.toString();
    InitializationErrorType errorType = InitializationErrorType.unknown;

    if (message.contains('network') ||
        message.contains('connection') ||
        message.contains('connectivity')) {
      errorType = InitializationErrorType.connectivity;
    } else if (message.contains('storage') ||
        message.contains('database') ||
        message.contains('hive')) {
      errorType = InitializationErrorType.storage;
    } else if (message.contains('dependency') ||
        message.contains('initialization')) {
      errorType = InitializationErrorType.dependencies;
    }

    return InitializationErrorPage(
      errorType: errorType,
      errorMessage: message,
      onRetry: onRetry,
    );
  }
}

