import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../config/game_radio_time_config.dart';
import '../../../../../core/themes/design_tokens.dart';
import 'level_card_item.dart';

class LevelListSection extends StatelessWidget {
  final double currentHours;
  final String currentLevelId;

  const LevelListSection({
    super.key,
    required this.currentHours,
    required this.currentLevelId,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final allLevels = GameRadioTimeConfig.levels;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
          child: Text(
            'level_details_all_levels'.tr(),
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: DesignTokens.spacingL),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: allLevels.length,
          itemBuilder: (context, index) {
            final level = allLevels[index];
            final isCurrent = level.id == currentLevelId;
            final isUnlocked = currentHours >= level.minHours;
            final isMaxLevel = level.isMaxLevel && isCurrent;

            return Padding(
              padding: EdgeInsets.only(
                left: DesignTokens.spacingL,
                right: DesignTokens.spacingL,
                bottom: DesignTokens.spacingM,
              ),
              child: LevelCardItem(
                level: level,
                isCurrent: isCurrent,
                isUnlocked: isUnlocked,
                isMaxLevel: isMaxLevel,
                currentHours: currentHours,
              ),
            );
          },
        ),
      ],
    );
  }
}

