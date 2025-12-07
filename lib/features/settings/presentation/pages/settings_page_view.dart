import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/floating_bottom_nav_bar.dart';
import '../../../../core/widgets/floating_play_fab.dart';
import '../../../../core/widgets/collapsible_settings_section.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/settings_app_bar.dart';
import '../widgets/offline_news_settings_section.dart';
import '../bloc/settings_bloc.dart';

class SettingsPageView extends StatefulWidget {
  const SettingsPageView({super.key});

  @override
  State<SettingsPageView> createState() => _SettingsPageViewState();
}

class _SettingsPageViewState extends State<SettingsPageView> {
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadSettings();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh stats when page becomes visible (after initial load)
    if (_hasLoaded && mounted) {
      // Only refresh stats, not settings (to avoid unnecessary reloads)
      context.read<SettingsBloc>().add(
            const SettingsEvent.loadOfflineNewsStats(),
          );
    }
  }

  void _loadSettings() {
    if (!mounted) return;
    _hasLoaded = true;
    context.read<SettingsBloc>().add(
          const SettingsEvent.loadOfflineNewsSettings(),
        );
    context.read<SettingsBloc>().add(
          const SettingsEvent.loadOfflineNewsStats(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    const bottomSpacing = DesignTokens.spacingS;
    const extraSpacing = DesignTokens.spacingXl;
    final totalBottomSpacing =
        FloatingBottomNavBar.totalHeight + bottomSpacing + safeAreaBottom + extraSpacing;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colors.primaryBackground,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SettingsAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: DesignTokens.spacingXxl),
                      _buildThemeSection(context),
                      const SizedBox(height: DesignTokens.spacingXl),
                      const OfflineNewsSettingsSection(),
                      const SizedBox(height: DesignTokens.spacingXxl),
                      _buildLogoutSection(context),
                      SizedBox(height: totalBottomSpacing),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: DesignTokens.spacingL,
                  right: DesignTokens.spacingL,
                  bottom: DesignTokens.spacingS,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FloatingBottomNavBar(
                        selectedItem: NavItem.profile,
                        onItemSelected: (item) {
                          if (item != NavItem.profile) {
                            switch (item) {
                              case NavItem.home:
                                Navigator.pushNamed(context, AppRoutes.home);
                                break;
                              case NavItem.radio:
                                Navigator.pushNamed(context, AppRoutes.radio);
                                break;
                              case NavItem.news:
                                Navigator.pushNamed(context, AppRoutes.news);
                                break;
                              case NavItem.shoutbox:
                                Navigator.pushNamed(context, AppRoutes.shoutbox);
                                break;
                              case NavItem.profile:
                                Navigator.pushNamed(context, AppRoutes.profile);
                                break;
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacingM),
                    const FloatingPlayFab(
                      key: ValueKey('settings-play-fab'),
                      size: DimensionTokens.avatarSizeLarge + DesignTokens.spacingXs,
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

  Widget _buildThemeSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final adaptiveTheme = AdaptiveTheme.of(context);
    final colors = context.appColors;

    return CollapsibleSettingsSection(
      icon: isDark ? LucideIcons.moon : LucideIcons.sun,
      title: 'settings_theme'.tr(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingL,
              vertical: DesignTokens.spacingS,
            ),
            minVerticalPadding: DesignTokens.spacingM,
            leading: Icon(
              LucideIcons.sun,
              color: colors.textSecondary,
              size: DimensionTokens.iconSizeMedium,
            ),
            title: Text(
              'settings_theme_light'.tr(),
              style: TextStyle(
                fontSize: DesignTokens.fontSizeBodyLarge,
                fontWeight: DesignTokens.fontWeightBody,
                letterSpacing: DesignTokens.letterSpacingBodyLarge,
                color: colors.textPrimary,
              ),
            ),
            trailing: !isDark
                ? Icon(
                    LucideIcons.check,
                    color: colors.colorScheme.primary,
                    size: DimensionTokens.iconSizeMedium,
                  )
                : null,
            onTap: () {
              adaptiveTheme.setLight();
            },
          ),
          const Divider(
            height: DimensionTokens.dividerThickness,
            thickness: DimensionTokens.dividerThickness,
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingL,
              vertical: DesignTokens.spacingS,
            ),
            minVerticalPadding: DesignTokens.spacingM,
            leading: Icon(
              LucideIcons.moon,
              color: colors.textSecondary,
              size: DimensionTokens.iconSizeMedium,
            ),
            title: Text(
              'settings_theme_dark'.tr(),
              style: TextStyle(
                fontSize: DesignTokens.fontSizeBodyLarge,
                fontWeight: DesignTokens.fontWeightBody,
                letterSpacing: DesignTokens.letterSpacingBodyLarge,
                color: colors.textPrimary,
              ),
            ),
            trailing: isDark
                ? Icon(
                    LucideIcons.check,
                    color: colors.colorScheme.primary,
                    size: DimensionTokens.iconSizeMedium,
                  )
                : null,
            onTap: () {
              adaptiveTheme.setDark();
            },
          ),
          const Divider(
            height: DimensionTokens.dividerThickness,
            thickness: DimensionTokens.dividerThickness,
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingL,
              vertical: DesignTokens.spacingS,
            ),
            minVerticalPadding: DesignTokens.spacingM,
            leading: Icon(
              LucideIcons.monitor,
              color: colors.textSecondary,
              size: DimensionTokens.iconSizeMedium,
            ),
            title: Text(
              'settings_theme_system'.tr(),
              style: TextStyle(
                fontSize: DesignTokens.fontSizeBodyLarge,
                fontWeight: DesignTokens.fontWeightBody,
                letterSpacing: DesignTokens.letterSpacingBodyLarge,
                color: colors.textPrimary,
              ),
            ),
            trailing: adaptiveTheme.mode == AdaptiveThemeMode.system
                ? Icon(
                    LucideIcons.check,
                    color: colors.colorScheme.primary,
                    size: DimensionTokens.iconSizeMedium,
                  )
                : null,
            onTap: () {
              adaptiveTheme.setSystem();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return authState.maybeWhen(
          authenticated: (_) => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingL,
              vertical: DesignTokens.spacingXl,
            ),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEvent.logout(),
                      );
                },
                icon: const Icon(
                  LucideIcons.log_out,
                  size: DimensionTokens.iconSizeMedium,
                ),
                label: Text(
                  'auth_logout'.tr(),
                  style: const TextStyle(
                    fontSize: DesignTokens.fontSizeLabelLarge,
                    fontWeight: DesignTokens.fontWeightLabelLarge,
                    letterSpacing: DesignTokens.letterSpacingLabelLarge,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.appColors.colorScheme.error,
                  side: BorderSide(
                    color: context.appColors.colorScheme.error,
                    width: DimensionTokens.borderWidthThin,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingXl,
                    vertical: DesignTokens.spacingL,
                  ),
                  minimumSize: const Size(
                    0,
                    DimensionTokens.buttonHeightLarge,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      DesignTokens.cornerRadiusButton,
                    ),
                  ),
                ),
              ),
            ),
          ),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}

