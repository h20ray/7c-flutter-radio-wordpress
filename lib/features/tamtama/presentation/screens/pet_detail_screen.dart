import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../domain/entities/tamtama_entity.dart';
import '../bloc/tamtama_bloc.dart';
import '../widgets/tamtama_sprite_widget.dart';
import '../widgets/background_sprite.dart';

/// Full pet details screen showing all pet information
class PetDetailScreen extends StatelessWidget {
  const PetDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TamtamaBloc, TamtamaState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (tamtama, economy, isListening) => _PetDetailContent(
            tamtama: tamtama,
            isListening: isListening,
          ),
          orElse: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class _PetDetailContent extends StatelessWidget {
  final TamtamaEntity tamtama;
  final bool isListening;

  const _PetDetailContent({
    required this.tamtama,
    required this.isListening,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.primaryBackground,
      appBar: AppBar(
        title: Text(tamtama.petName),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PetHeroSection(tamtama: tamtama),
            const SizedBox(height: DesignTokens.spacingL),
            _StatsSection(tamtama: tamtama),
            const SizedBox(height: DesignTokens.spacingL),
            _InfoSection(tamtama: tamtama, isListening: isListening),
            const SizedBox(height: DesignTokens.spacingL),
            _EvolutionHistorySection(tamtama: tamtama),
            const SizedBox(height: DesignTokens.spacingL),
            _TeenStatsSection(tamtama: tamtama),
          ],
        ),
      ),
    );
  }
}

class _PetHeroSection extends StatelessWidget {
  final TamtamaEntity tamtama;

  const _PetHeroSection({required this.tamtama});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        child: Stack(
          fit: StackFit.expand,
          children: [
            BackgroundSprite(index: tamtama.backgroundIndex),
            Center(
              child: TamtamaSpriteWidget(
                tamtama: tamtama,
                size: 180,
              ),
            ),
            // Level badge
            Positioned(
              top: DesignTokens.spacingM,
              right: DesignTokens.spacingM,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingS,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colors.colorScheme.primary,
                  borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusAlbumArt),
                ),
                child: Text(
                  'Lvl ${tamtama.level}',
                  style: TextStyle(
                    color: colors.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            // Life stage badge
            Positioned(
              top: DesignTokens.spacingM,
              left: DesignTokens.spacingM,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingS,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStageColor(tamtama.lifeStage),
                  borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusAlbumArt),
                ),
                child: Text(
                  _getStageName(tamtama.lifeStage),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStageName(LifeStage stage) {
    switch (stage) {
      case LifeStage.egg:
        return 'Egg';
      case LifeStage.baby:
        return 'Baby';
      case LifeStage.child:
        return 'Child';
      case LifeStage.teen:
        return 'Teen';
      case LifeStage.adult:
        return 'Adult';
      case LifeStage.specialAdult:
        return 'Special';
    }
  }

  Color _getStageColor(LifeStage stage) {
    switch (stage) {
      case LifeStage.egg:
        return Colors.grey;
      case LifeStage.baby:
        return Colors.pink;
      case LifeStage.child:
        return Colors.orange;
      case LifeStage.teen:
        return Colors.blue;
      case LifeStage.adult:
        return Colors.purple;
      case LifeStage.specialAdult:
        return Colors.amber;
    }
  }
}

class _StatsSection extends StatelessWidget {
  final TamtamaEntity tamtama;

  const _StatsSection({required this.tamtama});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'stats'.tr(),
            style: TextStyle(
              fontSize: DesignTokens.fontSizeH2,
              fontWeight: DesignTokens.fontWeightH2,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingM),
          _StatBar(
            label: 'hunger'.tr(),
            value: tamtama.hunger,
            color: Colors.orange,
            icon: Icons.restaurant,
          ),
          _StatBar(
            label: 'energy'.tr(),
            value: tamtama.energy,
            color: Colors.yellow.shade700,
            icon: Icons.bolt,
          ),
          _StatBar(
            label: 'happiness'.tr(),
            value: tamtama.happiness,
            color: Colors.pink,
            icon: Icons.favorite,
          ),
          _StatBar(
            label: 'hygiene'.tr(),
            value: tamtama.hygiene,
            color: Colors.blue,
            icon: Icons.water_drop,
          ),
          const Divider(),
          _StatBar(
            label: 'health'.tr(),
            value: tamtama.health,
            color: Colors.red,
            icon: Icons.local_hospital,
          ),
          _StatBar(
            label: 'affection'.tr(),
            value: tamtama.affection,
            color: Colors.purple,
            icon: Icons.favorite_border,
          ),
          _StatBar(
            label: 'stress'.tr(),
            value: tamtama.stress,
            color: Colors.grey,
            icon: Icons.psychology,
            inverted: true,
          ),
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;
  final bool inverted;

  const _StatBar({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    this.inverted = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final displayValue = value.clamp(0.0, 100.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: displayValue / 100.0,
                backgroundColor: colors.textSecondary.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  inverted 
                      ? (displayValue > 50 ? Colors.red : color)
                      : color,
                ),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 35,
            child: Text(
              '${displayValue.toInt()}%',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final TamtamaEntity tamtama;
  final bool isListening;

  const _InfoSection({
    required this.tamtama,
    required this.isListening,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final age = DateTime.now().difference(tamtama.createdAt);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'info'.tr(),
            style: TextStyle(
              fontSize: DesignTokens.fontSizeH2,
              fontWeight: DesignTokens.fontWeightH2,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingM),
          _InfoRow(
            label: 'age'.tr(),
            value: _formatAge(age),
            icon: Icons.cake,
          ),
          _InfoRow(
            label: 'xp'.tr(),
            value: '${tamtama.xp.toInt()} / ${tamtama.xpForNextLevel}',
            icon: Icons.star,
          ),
          _InfoRow(
            label: 'state'.tr(),
            value: tamtama.petState.name,
            icon: Icons.mood,
          ),
          if (tamtama.archetype != null)
            _InfoRow(
              label: 'archetype'.tr(),
              value: tamtama.archetype!.name,
              icon: Icons.auto_awesome,
            ),
          _InfoRow(
            label: 'pet_id'.tr(),
            value: tamtama.petId?.toString() ?? 'N/A',
            icon: Icons.tag,
          ),
          _InfoRow(
            label: 'family'.tr(),
            value: 'Family ${tamtama.familyIndex}',
            icon: Icons.family_restroom,
          ),
          _InfoRow(
            label: 'listening'.tr(),
            value: isListening ? 'Yes' : 'No',
            icon: Icons.headphones,
          ),
        ],
      ),
    );
  }

  String _formatAge(Duration age) {
    if (age.inDays > 0) {
      return '${age.inDays}d ${age.inHours % 24}h';
    } else if (age.inHours > 0) {
      return '${age.inHours}h ${age.inMinutes % 60}m';
    } else {
      return '${age.inMinutes}m';
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colors.textSecondary),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EvolutionHistorySection extends StatelessWidget {
  final TamtamaEntity tamtama;

  const _EvolutionHistorySection({required this.tamtama});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final history = tamtama.history.stageHistory;

    if (history.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'evolution_history'.tr(),
            style: TextStyle(
              fontSize: DesignTokens.fontSizeH2,
              fontWeight: DesignTokens.fontWeightH2,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingM),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: history.length,
              itemBuilder: (context, index) {
                final stageId = history[index];
                final isLast = index == history.length - 1;
                return Row(
                  children: [
                    _EvolutionStageChip(
                      stageId: stageId,
                      isCurrent: isLast,
                    ),
                    if (!isLast)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: colors.textSecondary,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EvolutionStageChip extends StatelessWidget {
  final int stageId;
  final bool isCurrent;

  const _EvolutionStageChip({
    required this.stageId,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isCurrent 
            ? colors.colorScheme.primary 
            : colors.colorScheme.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusAlbumArt),
        border: isCurrent 
            ? null 
            : Border.all(color: colors.colorScheme.primary.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '#$stageId',
            style: TextStyle(
              color: isCurrent 
                  ? colors.colorScheme.onPrimary 
                  : colors.colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Text(
            _getStageType(stageId),
            style: TextStyle(
              color: isCurrent 
                  ? colors.colorScheme.onPrimary.withValues(alpha: 0.8)
                  : colors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  String _getStageType(int id) {
    final prefix = (id ~/ 1000);
    switch (prefix) {
      case 11:
        return 'Egg';
      case 12:
        return 'Baby';
      case 13:
        return 'Child';
      case 14:
        return 'Teen';
      case 15:
        return 'Adult';
      case 17:
        return 'Special';
      default:
        return 'Form';
    }
  }
}

class _TeenStatsSection extends StatelessWidget {
  final TamtamaEntity tamtama;

  const _TeenStatsSection({required this.tamtama});

  @override
  Widget build(BuildContext context) {
    // Only show for teen stage
    if (tamtama.lifeStage != LifeStage.teen) {
      return const SizedBox.shrink();
    }

    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'teen_stats'.tr(),
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeH2,
                  fontWeight: DesignTokens.fontWeightH2,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'teen_stats_desc'.tr(),
            style: TextStyle(
              fontSize: 12,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingM),
          _InfoRow(
            label: 'avg_listening'.tr(),
            value: '${tamtama.avgListeningMinutesPerDay.toInt()} min/day',
            icon: Icons.headphones,
          ),
          _InfoRow(
            label: 'avg_happiness'.tr(),
            value: '${(tamtama.avgHappiness * 100).toInt()}%',
            icon: Icons.sentiment_satisfied,
          ),
          _InfoRow(
            label: 'avg_stress'.tr(),
            value: '${(tamtama.avgStress * 100).toInt()}%',
            icon: Icons.psychology,
          ),
          _InfoRow(
            label: 'avg_affection'.tr(),
            value: '${(tamtama.avgAffection * 100).toInt()}%',
            icon: Icons.favorite,
          ),
          _InfoRow(
            label: 'neglect_score'.tr(),
            value: '${tamtama.neglectScoreTeen.toInt()}',
            icon: Icons.warning_amber,
          ),
        ],
      ),
    );
  }
}
