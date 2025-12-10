import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../domain/entities/tamtama_economy_entity.dart';

class TamtamaEconomyDisplay extends StatelessWidget {
  final TamtamaEconomyEntity economy;

  const TamtamaEconomyDisplay({
    super.key,
    required this.economy,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        _EconomyPill(
          icon: Icons.music_note,
          value: economy.tunePoints.floor().toString(),
          label: 'tamtama_tp'.tr(),
          color: Colors.purpleAccent,
          backgroundColor: colors.primaryBackground,
        ),
        const SizedBox(width: DesignTokens.spacingS),
        _EconomyPill(
          icon: Icons.monetization_on,
          value: economy.coins.floor().toString(),
          label: 'tamtama_coins'.tr(),
          color: Colors.amber,
          backgroundColor: colors.primaryBackground,
        ),
      ],
    );
  }
}

class _EconomyPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Color backgroundColor;

  const _EconomyPill({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingS,
        vertical: DesignTokens.spacingXs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusPill),
        border: Border.all(
          color: colors.borderSubtle.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
