import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:easy_localization/easy_localization.dart';
import '../themes/design_tokens.dart';
import '../routes/app_routes.dart';

enum NavItem {
  home,
  radio,
  news,
  shoutbox,
  profile,
}

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
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingL,
        vertical: DesignTokens.spacingL,
      ),
      height: 64,
      decoration: BoxDecoration(
        color: DesignTokens.colorNavBarBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: Offset(0, 4),
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
            icon: LucideIcons.radio,
            item: NavItem.radio,
            label: 'home_nav_radio'.tr(),
          ),
          _buildNavItem(
            context,
            icon: LucideIcons.newspaper,
            item: NavItem.news,
            label: 'home_nav_news'.tr(),
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
      child: GestureDetector(
        onTap: () {
          onItemSelected(item);
          _navigateToRoute(context, item);
        },
        child: AnimatedContainer(
          duration: DesignTokens.animationDurationMedium,
          curve: DesignTokens.animationCurveSpring,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected
                    ? DesignTokens.colorNavBarIconSelected
                    : DesignTokens.colorNavBarIconUnselected,
              ),
            ],
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
        // TODO: Add news route
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

