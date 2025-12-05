import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/glass_app_bar_background.dart';
import '../../../../core/widgets/haptic_widgets.dart';

class ProfileAppBar extends StatelessWidget {
  final VoidCallback onScrollToTop;

  const ProfileAppBar({super.key, required this.onScrollToTop});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      leading: IconButton(
        icon: const Icon(LucideIcons.arrow_left),
        onPressed: () =>
            Navigator.pushReplacementNamed(context, AppRoutes.home),
      ),
      title: HapticGestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onScrollToTop,
        child: Text(
          'home_nav_profile'.tr(),
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      actions: [
        HapticIconButton(
          onPressed: () {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            if (isDark) {
              AdaptiveTheme.of(context).setLight();
            } else {
              AdaptiveTheme.of(context).setDark();
            }
          },
          icon: Builder(
            builder: (context) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return Icon(
                isDark ? LucideIcons.sun : LucideIcons.moon,
                size: 20,
              );
            },
          ),
          tooltip: 'Switch Theme',
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: GlassAppBarBackground(child: Container()),
    );
  }
}
