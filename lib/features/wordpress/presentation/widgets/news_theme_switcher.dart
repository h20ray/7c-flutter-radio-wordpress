import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import '../../../../core/widgets/haptic_widgets.dart';

class NewsThemeSwitcher extends StatelessWidget {
  const NewsThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return HapticIconButton(
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
        );
      },
    );
  }
}

