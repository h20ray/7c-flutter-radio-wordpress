
import 'package:flutter/material.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';

class TamtamaStatsCard extends StatelessWidget {
  final double hunger;
  final double energy;
  final double happiness;
  final double hygiene;

  const TamtamaStatsCard({
    super.key,
    required this.hunger,
    required this.energy,
    required this.happiness,
    required this.hygiene,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: colors.primaryBackground,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        border: Border.all(
          color: colors.borderSubtle.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatRow(
            value: hunger,
            color: Colors.orange,
            icon: Icons.restaurant,
          ),
          const SizedBox(height: DesignTokens.spacingS),
          _StatRow(
            value: energy,
            color: Colors.blue,
            icon: Icons.bolt,
          ),
          const SizedBox(height: DesignTokens.spacingS),
          _StatRow(
            value: happiness,
            color: Colors.pink,
            icon: Icons.sentiment_satisfied_alt,
          ),
          const SizedBox(height: DesignTokens.spacingS),
          _StatRow(
            value: hygiene,
            color: Colors.teal,
            icon: Icons.clean_hands,
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final double value;
  final Color color;
  final IconData icon;

  const _StatRow({
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: DesignTokens.spacingM),
        Expanded(
          flex: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: colors.cardBackground,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: DesignTokens.spacingS),
        SizedBox(
          width: 30,
          child: Text(
            '${value.round()}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
