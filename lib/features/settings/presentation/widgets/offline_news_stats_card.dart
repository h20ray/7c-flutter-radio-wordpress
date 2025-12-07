import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../domain/repositories/settings_repository.dart';

class OfflineNewsStatsCard extends StatelessWidget {
  final OfflineNewsStats stats;

  const OfflineNewsStatsCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
          border: Border.all(
          color: stats.isPostsLimitReached || stats.isSizeLimitReached
              ? colors.colorScheme.error
              : colors.borderSubtle,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'settings_offline_stats_title'.tr(),
            style: TextStyle(
              fontSize: DesignTokens.fontSizeBody,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingM),
          _buildStatRow(
            context,
            label: 'settings_offline_posts_count'.tr(),
            value: '${stats.currentPostCount} / ${stats.maxPosts}',
            percent: stats.postsUsagePercent,
            isWarning: stats.isPostsLimitReached,
          ),
          const SizedBox(height: DesignTokens.spacingS),
          _buildStatRow(
            context,
            label: 'settings_offline_size'.tr(),
            value: '${stats.currentSizeMB} MB / ${stats.maxSizeMB} MB',
            percent: stats.sizeUsagePercent,
            isWarning: stats.isSizeLimitReached,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context, {
    required String label,
    required String value,
    required double percent,
    required bool isWarning,
  }) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeCaption,
                color: colors.textSecondary,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeCaption,
                fontWeight: FontWeight.w600,
                color: isWarning ? colors.colorScheme.error : colors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingXs),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 6,
            backgroundColor: colors.borderSubtle,
            valueColor: AlwaysStoppedAnimation<Color>(
              isWarning ? colors.colorScheme.error : colors.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

