import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/collapsible_settings_section.dart';
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

    return CollapsibleSettingsSection(
      icon: LucideIcons.bookmark,
      title: 'settings_offline_news_title'.tr(),
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (stats != null) ...[
              _buildSimpleStats(context, stats),
              const SizedBox(height: DesignTokens.spacingL),
            ],
            const SizedBox(height: DesignTokens.spacingM),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingL,
                vertical: DesignTokens.spacingS,
              ),
              minVerticalPadding: DesignTokens.spacingM,
              leading: Icon(
                LucideIcons.list,
                color: colors.colorScheme.primary,
                size: DimensionTokens.iconSizeMedium,
              ),
              title: Text(
                'settings_offline_view_posts'.tr(),
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeBodyLarge,
                  fontWeight: DesignTokens.fontWeightBody,
                  letterSpacing: DesignTokens.letterSpacingBodyLarge,
                  color: colors.textPrimary,
                ),
              ),
              trailing: Icon(
                LucideIcons.chevron_right,
                color: colors.textSecondary,
                size: DimensionTokens.iconSizeMedium,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const OfflineNewsListDialog(),
                );
              },
            ),
            const SizedBox(height: DesignTokens.spacingM),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingL,
                vertical: DesignTokens.spacingS,
              ),
              minVerticalPadding: DesignTokens.spacingM,
              leading: Icon(
                LucideIcons.trash,
                color: colors.colorScheme.error,
                size: DimensionTokens.iconSizeMedium,
              ),
              title: Text(
                'settings_offline_clear_all'.tr(),
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeBodyLarge,
                  fontWeight: DesignTokens.fontWeightBody,
                  letterSpacing: DesignTokens.letterSpacingBodyLarge,
                  color: colors.colorScheme.error,
                ),
              ),
              enabled: !isSaving && stats != null && stats.currentPostCount > 0,
              onTap: () => _showClearAllConfirmation(context),
            ),
            if (isSaving)
              Padding(
                padding: const EdgeInsets.all(DesignTokens.spacingM),
                child: Center(
                  child: CircularProgressIndicator(
                    color: colors.colorScheme.primary,
                  ),
                ),
              ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.all(DesignTokens.spacingM),
                child: Container(
                  padding: const EdgeInsets.all(DesignTokens.spacingS),
                  decoration: BoxDecoration(
                    color: colors.colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      DesignTokens.cornerRadiusCard,
                    ),
                  ),
                  child: Text(
                    'settings_offline_error'.tr(),
                    style: TextStyle(
                      color: colors.colorScheme.error,
                      fontSize: DesignTokens.fontSizeCaption,
                      fontWeight: DesignTokens.fontWeightCaption,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingContent(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingL),
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

    return CollapsibleSettingsSection(
      icon: LucideIcons.bookmark,
      title: 'settings_offline_news_title'.tr(),
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingL),
        child: Column(
          children: [
            Icon(
              LucideIcons.circle_alert,
              color: colors.colorScheme.error,
              size: DimensionTokens.avatarSizeMedium,
            ),
            const SizedBox(height: DesignTokens.spacingM),
            Text(
              'settings_offline_error_loading'.tr(),
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: DesignTokens.fontSizeBodyMedium,
                fontWeight: DesignTokens.fontWeightBody,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingM),
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
      ),
    );
  }

  Widget _buildSimpleStats(BuildContext context, stats) {
    final colors = context.appColors;
    
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: colors.cardBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        border: Border.all(
          color: colors.borderSubtle,
          width: DimensionTokens.borderWidthThin,
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
            width: DimensionTokens.borderWidthThin,
            height: DimensionTokens.buttonHeightMedium,
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
            size: DimensionTokens.iconSizeLarge,
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Text(
            value,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeH2,
              fontWeight: DesignTokens.fontWeightH2,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Text(
            label,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeCaption,
              fontWeight: DesignTokens.fontWeightCaption,
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
    final settingsBloc = context.read<SettingsBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              settingsBloc.add(
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

