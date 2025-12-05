import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';

class RadioAboutPage extends StatelessWidget {
  const RadioAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final shadow = AppShadowTokens.elevation4(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('radio_menu_about'.tr()),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(DesignTokens.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(DesignTokens.spacingL),
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
                boxShadow: shadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(DesignTokens.spacingM),
                        decoration: BoxDecoration(
                          color: colors.primaryAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
                        ),
                        child: Icon(
                          LucideIcons.radio,
                          color: colors.primaryAccent,
                          size: 32,
                        ),
                      ),
                      SizedBox(width: DesignTokens.spacingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'radio_station_name'.tr(),
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                              ),
                            ),
                            SizedBox(height: DesignTokens.spacingXs),
                            Text(
                              'radio_info_dialog_heading'.tr(),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: DesignTokens.spacingL),
                  Text(
                    'radio_info_dialog_welcome'.tr(
                      namedArgs: {'radio_station_name': 'radio_station_name'.tr()},
                    ),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: DesignTokens.spacingL),
            Container(
              padding: EdgeInsets.all(DesignTokens.spacingL),
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
                boxShadow: shadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'radio_info_details_title'.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: DesignTokens.spacingM),
                  _InfoRow(
                    icon: LucideIcons.radio,
                    label: 'radio_info_frequency_label'.tr(),
                    value: 'radio_info_frequency_value'.tr(),
                  ),
                  SizedBox(height: DesignTokens.spacingM),
                  _InfoRow(
                    icon: LucideIcons.map_pin,
                    label: 'radio_info_location_label'.tr(),
                    value: 'radio_info_location_value'.tr(),
                  ),
                  SizedBox(height: DesignTokens.spacingM),
                  _InfoRow(
                    icon: LucideIcons.globe,
                    label: 'radio_info_website_label'.tr(),
                    value: 'radio_info_website_value'.tr(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(DesignTokens.spacingS),
          decoration: BoxDecoration(
            color: colors.surfaces.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusButton),
          ),
          child: Icon(
            icon,
            size: 18,
            color: colors.textSecondary,
          ),
        ),
        SizedBox(width: DesignTokens.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: DesignTokens.spacingXs),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

