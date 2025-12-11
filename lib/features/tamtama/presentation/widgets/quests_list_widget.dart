import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../domain/entities/quest_entity.dart';
import '../bloc/quest/quest_bloc.dart';

/// Widget displaying daily quests progress and claim buttons
class QuestsListWidget extends StatelessWidget {
  const QuestsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestBloc, QuestState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (quests) => _buildQuestsList(context, quests),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildQuestsList(BuildContext context, DailyQuestsEntity quests) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'daily_quests'.tr(),
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeH2,
                  fontWeight: DesignTokens.fontWeightH2,
                  color: colors.textPrimary,
                ),
              ),
              if (quests.pendingCoins > 0)
                TextButton(
                  onPressed: () {
                    context.read<QuestBloc>().add(const QuestEvent.claimAll());
                  },
                  child: Text(
                    'claim_all'.tr(),
                    style: TextStyle(
                      color: colors.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: DesignTokens.spacingS),
        ...quests.quests.map((quest) => _QuestCard(quest: quest)),
      ],
    );
  }
}

class _QuestCard extends StatelessWidget {
  final QuestEntity quest;

  const _QuestCard({required this.quest});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final successColor = colors.colorScheme.tertiary;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingL,
        vertical: DesignTokens.spacingXs,
      ),
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.spacingM),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
          border: quest.isCompleted
              ? Border.all(color: successColor.withValues(alpha: 0.5), width: 1)
              : null,
        ),
        child: Row(
          children: [
            _buildIcon(colors),
            const SizedBox(width: DesignTokens.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quest.title,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    quest.description,
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacingS),
                  _buildProgressBar(colors),
                ],
              ),
            ),
            const SizedBox(width: DesignTokens.spacingM),
            _buildRewardOrButton(context, colors),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(AppSemanticColors colors) {
    IconData icon;
    Color iconColor;
    final primaryColor = colors.colorScheme.primary;
    final successColor = colors.colorScheme.tertiary;

    switch (quest.type) {
      case QuestType.listening:
        icon = Icons.headphones;
        iconColor = primaryColor;
        break;
      case QuestType.feeding:
        icon = Icons.restaurant;
        iconColor = Colors.orange;
        break;
      case QuestType.cleaning:
        icon = Icons.cleaning_services;
        iconColor = Colors.blue;
        break;
      case QuestType.playing:
        icon = Icons.games;
        iconColor = Colors.purple;
        break;
      case QuestType.keepHappy:
        icon = Icons.sentiment_very_satisfied;
        iconColor = Colors.amber;
        break;
      case QuestType.dailyLogin:
        icon = Icons.login;
        iconColor = successColor;
        break;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }

  Widget _buildProgressBar(AppSemanticColors colors) {
    final successColor = colors.colorScheme.tertiary;
    final primaryColor = colors.colorScheme.primary;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: quest.progress,
        backgroundColor: colors.textSecondary.withValues(alpha: 0.2),
        valueColor: AlwaysStoppedAnimation<Color>(
          quest.isCompleted ? successColor : primaryColor,
        ),
        minHeight: 4,
      ),
    );
  }

  Widget _buildRewardOrButton(BuildContext context, AppSemanticColors colors) {
    final successColor = colors.colorScheme.tertiary;
    
    if (quest.isClaimed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: successColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          Icons.check,
          color: successColor,
          size: 16,
        ),
      );
    }

    if (quest.canClaim) {
      return ElevatedButton(
        onPressed: () {
          context.read<QuestBloc>().add(QuestEvent.claimQuest(quest.id));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: successColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          'claim'.tr(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      );
    }

    // Show reward preview
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.monetization_on, size: 14, color: Colors.amber),
            const SizedBox(width: 2),
            Text(
              '${quest.rewardCoins}',
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          '${quest.currentValue}/${quest.targetValue}',
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
