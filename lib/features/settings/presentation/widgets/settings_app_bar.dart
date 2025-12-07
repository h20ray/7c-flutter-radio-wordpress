import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';

class SettingsAppBar extends StatelessWidget {
  const SettingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return SliverAppBar(
      expandedHeight: 120 + statusBarHeight,
      floating: false,
      pinned: true,
      backgroundColor: colors.primaryBackground,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          LucideIcons.arrow_left,
          color: colors.textPrimary,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(
          left: DimensionTokens.avatarSizeLarge,
          right: DesignTokens.spacingL,
          bottom: DesignTokens.spacingL,
        ),
        title: Text(
          'settings_title'.tr(),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: DesignTokens.fontWeightH2,
            color: colors.textPrimary,
          ),
        ),
      ),
    );
  }
}

