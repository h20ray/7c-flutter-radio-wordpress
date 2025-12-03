import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/themes/design_tokens.dart';

class LoginErrorWidget extends StatelessWidget {
  final Failure failure;

  const LoginErrorWidget({
    super.key,
    required this.failure,
  });

  String _getErrorMessage(Failure failure) {
    if (failure is InvalidCredentialsFailure) {
      return 'auth_error_invalid_credentials'.tr();
    } else if (failure is AccountLockedFailure) {
      return 'auth_error_account_locked'.tr();
    } else if (failure is NetworkFailure) {
      return 'radio_network_error'.tr();
    } else if (failure is TokenExpiredFailure) {
      return 'auth_error_token_expired'.tr();
    } else if (failure is ServerFailure) {
      return 'radio_server_error'.tr();
    } else {
      return failure.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(DesignTokens.spacingM),
      margin: EdgeInsets.only(bottom: DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        border: Border.all(
          color: colorScheme.error,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.onErrorContainer,
            size: 20,
          ),
          SizedBox(width: DesignTokens.spacingM),
          Expanded(
            child: Text(
              _getErrorMessage(failure),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

