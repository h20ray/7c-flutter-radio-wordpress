import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../domain/entities/tamtama_entity.dart';
import '../../domain/entities/tamtama_economy_entity.dart';
import '../bloc/tamtama_bloc.dart';

class TamtamaCareControls extends StatelessWidget {
  final TamtamaEntity tamtama;
  final TamtamaEconomyEntity economy;

  const TamtamaCareControls({
    super.key,
    required this.tamtama,
    required this.economy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CareButton(
          icon: Icons.restaurant,
          label: 'tamtama_feed'.tr(),
          cost: 10,
          canAfford: economy.coins >= 10,
          onTap: () => context.read<TamtamaBloc>().add(
            const TamtamaEvent.feedPet(),
          ),
          color: Colors.orange,
        ),
        _CareButton(
          icon: Icons.sports_esports,
          label: 'tamtama_play'.tr(),
          cost: 5,
          canAfford: economy.coins >= 5,
          isDisabled: tamtama.energy < 10,
          onTap: () => context.read<TamtamaBloc>().add(
            const TamtamaEvent.playWithPet(),
          ),
          color: Colors.pink,
        ),
        _CareButton(
          icon: Icons.cleaning_services,
          label: 'tamtama_clean'.tr(),
          cost: 10,
          canAfford: economy.coins >= 10,
          onTap: () => context.read<TamtamaBloc>().add(
            const TamtamaEvent.cleanPet(),
          ),
          color: Colors.teal,
        ),
        _CareButton(
          icon: tamtama.petState == PetState.sleeping
              ? Icons.wb_sunny
              : Icons.bedtime,
          label: 'tamtama_sleep'.tr(),
          cost: 0,
          canAfford: true,
          isActive: tamtama.petState == PetState.sleeping,
          onTap: () => context.read<TamtamaBloc>().add(
            const TamtamaEvent.toggleSleep(),
          ),
          color: Colors.indigo,
        ),
      ],
    );
  }
}

class _CareButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int cost;
  final bool canAfford;
  final bool isDisabled;
  final bool isActive;
  final VoidCallback onTap;
  final Color color;

  const _CareButton({
    required this.icon,
    required this.label,
    required this.cost,
    required this.canAfford,
    this.isDisabled = false,
    this.isActive = false,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final enabled = canAfford && !isDisabled;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: isActive ? color : (enabled ? colors.primaryBackground : colors.cardBackground),
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: enabled ? onTap : null,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isActive ? Colors.transparent : colors.borderSubtle.withValues(alpha: 0.3),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
              ),
              child: Icon(
                icon,
                color: isActive ? Colors.white : (enabled ? color : colors.textSecondary.withValues(alpha: 0.5)),
                size: 24,
              ),
            ),
          ),
        ),
        const SizedBox(height: DesignTokens.spacingXs),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: colors.textSecondary,
          ),
        ),
        if (cost > 0) ...[
          const SizedBox(height: 2),
          Text(
            '$cost',
            style: TextStyle(
              fontSize: 10,
              color: canAfford ? Colors.amber[700] : Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}
