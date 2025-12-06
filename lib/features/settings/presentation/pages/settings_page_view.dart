import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/floating_bottom_nav_bar.dart';
import '../../../../core/widgets/floating_play_fab.dart';
import '../widgets/settings_app_bar.dart';

class SettingsPageView extends StatelessWidget {
  const SettingsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final bottomSpacing = DesignTokens.spacingS;
    final extraSpacing = DesignTokens.spacingXl;
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),
                      _buildThemeSection(context),
                      const SizedBox(height: 24),
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
                padding: EdgeInsets.only(
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
                                Navigator.pushReplacementNamed(context, AppRoutes.home);
                                break;
                              case NavItem.radio:
                                Navigator.pushReplacementNamed(context, AppRoutes.radio);
                                break;
                              case NavItem.news:
                                Navigator.pushReplacementNamed(context, AppRoutes.news);
                                break;
                              case NavItem.shoutbox:
                                Navigator.pushNamed(context, AppRoutes.shoutbox);
                                break;
                              case NavItem.profile:
                                Navigator.pushReplacementNamed(context, AppRoutes.profile);
                                break;
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(width: DesignTokens.spacingM),
                    const FloatingPlayFab(
                      key: ValueKey('settings-play-fab'),
                      size: 60,
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
    final colors = context.appColors;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final adaptiveTheme = AdaptiveTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  isDark ? LucideIcons.moon : LucideIcons.sun,
                  color: colors.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'settings_theme'.tr(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              LucideIcons.sun,
              color: colors.textSecondary,
              size: 20,
            ),
            title: Text(
              'settings_theme_light'.tr(),
              style: TextStyle(
                fontSize: DesignTokens.fontSizeBody,
                color: colors.textPrimary,
              ),
            ),
            trailing: !isDark
                ? Icon(
                    LucideIcons.check,
                    color: colors.colorScheme.primary,
                    size: 20,
                  )
                : null,
            onTap: () {
              adaptiveTheme.setLight();
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              LucideIcons.moon,
              color: colors.textSecondary,
              size: 20,
            ),
            title: Text(
              'settings_theme_dark'.tr(),
              style: TextStyle(
                fontSize: DesignTokens.fontSizeBody,
                color: colors.textPrimary,
              ),
            ),
            trailing: isDark
                ? Icon(
                    LucideIcons.check,
                    color: colors.colorScheme.primary,
                    size: 20,
                  )
                : null,
            onTap: () {
              adaptiveTheme.setDark();
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              LucideIcons.monitor,
              color: colors.textSecondary,
              size: 20,
            ),
            title: Text(
              'settings_theme_system'.tr(),
              style: TextStyle(
                fontSize: DesignTokens.fontSizeBody,
                color: colors.textPrimary,
              ),
            ),
            trailing: adaptiveTheme.mode == AdaptiveThemeMode.system
                ? Icon(
                    LucideIcons.check,
                    color: colors.colorScheme.primary,
                    size: 20,
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
}

