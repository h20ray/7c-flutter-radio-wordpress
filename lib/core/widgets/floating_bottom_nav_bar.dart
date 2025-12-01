import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../themes/app_color_system.dart';
import '../themes/component_tokens.dart';
import '../themes/design_tokens.dart';
import '../routes/app_routes.dart';

enum NavItem { home, radio, news, shoutbox, profile }

class FloatingBottomNavBar extends StatelessWidget {
  final NavItem selectedItem;
  final ValueChanged<NavItem> onItemSelected;

  const FloatingBottomNavBar({
    super.key,
    required this.selectedItem,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final colors = context.appColors;
    final shadows = AppShadowTokens.of(context);
    final navTint = colorScheme.primary.withValues(alpha: isDark ? 0.25 : 0.18);
    final tintedNavBackground = Color.alphaBlend(navTint, colors.navBackground);
    final navOpacity = isDark ? 0.95 : 0.9;

    return Container(
      margin: EdgeInsets.symmetric(vertical: DesignTokens.spacingS),
      height: 64,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: DesignTokens.backdropBlurSigma,
            sigmaY: DesignTokens.backdropBlurSigma,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: tintedNavBackground.withValues(alpha: navOpacity),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: shadows.level2,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  context,
                  icon: LucideIcons.house,
                  item: NavItem.home,
                  label: 'home_nav_home'.tr(),
                ),
                _buildNavItem(
                  context,
                  icon: LucideIcons.newspaper,
                  item: NavItem.news,
                  label: 'home_nav_news'.tr(),
                ),
                _buildNavItem(
                  context,
                  icon: LucideIcons.radio,
                  item: NavItem.radio,
                  label: 'home_nav_radio'.tr(),
                ),
                _buildNavItem(
                  context,
                  icon: LucideIcons.message_circle,
                  item: NavItem.shoutbox,
                  label: 'home_nav_shoutbox'.tr(),
                ),
                _buildNavItem(
                  context,
                  icon: LucideIcons.user,
                  item: NavItem.profile,
                  label: 'home_nav_profile'.tr(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required NavItem item,
    required String label,
  }) {
    final isSelected = selectedItem == item;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            if (isSelected) {
              return;
            }
            onItemSelected(item);
            _navigateToRoute(context, item);
          },
          child: AnimatedContainer(
            duration: DesignTokens.animationDurationMedium,
            curve: DesignTokens.animationCurveSpring,
            padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingS),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isSelected
                      ? context.appColors.navIconSelected
                      : context.appColors.navIconUnselected,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToRoute(BuildContext context, NavItem item) {
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
        // TODO: Add profile route
        break;
    }
  }
}
