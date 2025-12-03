import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/widgets/glass_app_bar_background.dart';
import '../../../../core/widgets/haptic_widgets.dart';
import '../widgets/volume_dialog.dart';

class RadioAppBar extends StatelessWidget {
  final VoidCallback onScrollToTop;

  const RadioAppBar({
    super.key,
    required this.onScrollToTop,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      title: HapticGestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onScrollToTop,
        child: Text(
          'radio_station_name'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      actions: [
        Builder(
          builder: (context) {
            return HapticIconButton(
              onPressed: () => VolumeDialog.show(context),
              icon: const Icon(LucideIcons.volume_2, size: 20),
              tooltip: 'Volume',
            );
          },
        ),
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
      flexibleSpace: GlassAppBarBackground(
        child: Container(),
      ),
    );
  }
}

