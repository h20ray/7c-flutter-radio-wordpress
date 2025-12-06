import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../bloc/settings_bloc.dart';
import 'offline_news_list_dialog.dart';

class OfflineNewsSettingsSection extends StatelessWidget {
  const OfflineNewsSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (settings, stats, isSaving, error) => _buildLoadedContent(
            context,
            settings: settings,
            stats: stats,
            isSaving: isSaving,
            error: error,
          ),
          loading: () => _buildLoadingContent(context),
          error: (failure) => _buildErrorContent(context, failure),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildLoadedContent(
    BuildContext context, {
    required settings,
    required stats,
    required bool isSaving,
    required error,
  }) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(DesignTokens.spacingL),
            child: Row(
              children: [
                Icon(
                  LucideIcons.bookmark,
                  color: colors.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: DesignTokens.spacingS),
                Text(
                  'settings_offline_news_title'.tr(),
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeH2,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.all(DesignTokens.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (stats != null) ...[
                  _buildSimpleStats(context, stats),
                  SizedBox(height: DesignTokens.spacingL),
                ],
                SizedBox(height: DesignTokens.spacingM),
                ListTile(
                  leading: Icon(
                    LucideIcons.list,
                    color: colors.colorScheme.primary,
                  ),
                  title: Text(
                    'settings_offline_view_posts'.tr(),
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeBody,
                      color: colors.textPrimary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: colors.textSecondary,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const OfflineNewsListDialog(),
                    );
                  },
                ),
                SizedBox(height: DesignTokens.spacingM),
                ListTile(
                  leading: Icon(
                    LucideIcons.trash,
                    color: colors.colorScheme.error,
                  ),
                  title: Text(
                    'settings_offline_clear_all'.tr(),
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeBody,
                      color: colors.colorScheme.error,
                    ),
                  ),
                  enabled: !isSaving && stats != null && stats.currentPostCount > 0,
                  onTap: () => _showClearAllConfirmation(context),
                ),
                if (isSaving)
                  Padding(
                    padding: EdgeInsets.all(DesignTokens.spacingM),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: colors.colorScheme.primary,
                      ),
                    ),
                  ),
                if (error != null)
                  Padding(
                    padding: EdgeInsets.all(DesignTokens.spacingM),
                    child: Container(
                      padding: EdgeInsets.all(DesignTokens.spacingS),
                      decoration: BoxDecoration(
                        color: colors.colorScheme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'settings_offline_error'.tr(),
                        style: TextStyle(
                          color: colors.colorScheme.error,
                          fontSize: DesignTokens.fontSizeCaption,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(DesignTokens.spacingL),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: colors.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, failure) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(DesignTokens.spacingL),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: colors.colorScheme.error,
            size: 48,
          ),
          SizedBox(height: DesignTokens.spacingM),
          Text(
            'settings_offline_error_loading'.tr(),
            style: TextStyle(
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: DesignTokens.spacingM),
          TextButton(
            onPressed: () {
              context.read<SettingsBloc>().add(
                    const SettingsEvent.loadOfflineNewsSettings(),
                  );
            },
            child: Text('retry'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStats(BuildContext context, stats) {
    final colors = context.appColors;
    
    return Container(
      padding: EdgeInsets.all(DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: colors.cardBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colors.borderSubtle,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            icon: LucideIcons.file,
            label: 'settings_offline_posts_count'.tr(),
            value: '${stats.currentPostCount}',
            colors: colors,
          ),
          Container(
            width: 1,
            height: 40,
            color: colors.borderSubtle,
          ),
          _buildStatItem(
            context,
            icon: LucideIcons.database,
            label: 'settings_offline_size'.tr(),
            value: '${stats.currentSizeMB} MB',
            colors: colors,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required colors,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: colors.colorScheme.primary,
            size: 24,
          ),
          SizedBox(height: DesignTokens.spacingXs),
          Text(
            value,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeH2,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: DesignTokens.spacingXs),
          Text(
            label,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeCaption,
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showClearAllConfirmation(BuildContext context) {
    final colors = context.appColors;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'settings_offline_clear_all'.tr(),
          style: TextStyle(color: colors.textPrimary),
        ),
        content: Text(
          'settings_offline_clear_all_confirmation'.tr(),
          style: TextStyle(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<SettingsBloc>().add(
                    const SettingsEvent.clearAllOfflinePosts(),
                  );
            },
            style: TextButton.styleFrom(
              foregroundColor: colors.colorScheme.error,
            ),
            child: Text('delete'.tr()),
          ),
        ],
      ),
    );
  }
}

