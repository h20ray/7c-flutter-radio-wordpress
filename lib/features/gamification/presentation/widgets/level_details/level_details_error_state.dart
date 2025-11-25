import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/themes/design_tokens.dart';

class LevelDetailsErrorState extends StatelessWidget {
  final Failure failure;
  final VoidCallback onRetry;

  const LevelDetailsErrorState({
    super.key,
    required this.failure,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(DesignTokens.spacingXl),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.circle_alert,
              size: 64,
              color: colorScheme.error,
            ),
            SizedBox(height: DesignTokens.spacingL),
            Text(
              'error_title'.tr(),
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: DesignTokens.spacingS),
            Text(
              failure.message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: DesignTokens.spacingXl),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(LucideIcons.refresh_cw),
              label: Text('retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

