import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../domain/entities/tamtama_entity.dart';
import '../bloc/tamtama_bloc.dart';
import 'background_sprite.dart';
import 'egg_sprite.dart';

class TamtamaSection extends StatelessWidget {
  const TamtamaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TamtamaBloc, TamtamaState>(
      buildWhen: (previous, current) {
        if (previous.runtimeType != current.runtimeType) {
          return true;
        }
        return previous.maybeWhen(
          loaded: (prevTamtama) => current.maybeWhen(
            loaded: (currTamtama) => prevTamtama != currTamtama,
            orElse: () => true,
          ),
          orElse: () => false,
        );
      },
      builder: (context, state) {
        final buildStart = DateTime.now();
        final result = state.maybeWhen(
          loaded: (tamtama) => _buildTamtamaContent(context, tamtama),
          loading: () => _buildLoading(context),
          error: (message) => _buildError(context, message),
          orElse: () => _buildLoading(context),
        );
        final buildDuration = DateTime.now().difference(buildStart);
        if (buildDuration.inMicroseconds > 10000) {
          DebugLogger.log(
            'TamtamaSection.build took ${buildDuration.inMicroseconds}µs',
            tag: 'PERF_TAMTAMA',
          );
        }
        return result;
      },
    );
  }

  Widget _buildTamtamaContent(BuildContext context, TamtamaEntity tamtama) {
    final colors = context.appColors;
    final tokens = FeaturedRadioTokens.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
          child: Text(
            'home_tamtama_title'.tr(),
            style: TextStyle(
              fontSize: DesignTokens.fontSizeH1,
              fontWeight: DesignTokens.fontWeightH1,
              color: colors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: DesignTokens.spacingM),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RepaintBoundary(
                child: Container(
                  width: 140,
                  height: 200,
                  decoration: BoxDecoration(
                    color: tokens.hostFrameBackground,
                    borderRadius: BorderRadius.circular(
                      DesignTokens.cornerRadiusCard,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: tokens.shadowSoft,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      DesignTokens.cornerRadiusCard,
                    ),
                    child: _TamtamaSpriteContainer(
                      backgroundIndex: tamtama.backgroundIndex,
                      eggIndex: tamtama.eggIndex,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: DesignTokens.spacingM),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 200),
                  padding: const EdgeInsets.all(DesignTokens.spacingM),
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: BorderRadius.circular(
                      DesignTokens.cornerRadiusCard,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: tokens.shadowStrong,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tamtama.petName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: DesignTokens.spacingS),
                      _TamtamaStatTags(
                        level: tamtama.level,
                        happiness: tamtama.happiness,
                        hunger: tamtama.hunger,
                        isHappy: tamtama.isHappy,
                        isHungry: tamtama.isHungry,
                        tagDefaultBackground: tokens.tagDefaultBackground,
                        tagLiveBackground: tokens.tagLiveBackground,
                        tagText: tokens.tagText,
                        tertiaryContainer: colorScheme.tertiaryContainer,
                      ),
                      const SizedBox(height: DesignTokens.spacingS),
                      if (tamtama.lastFedAt != null)
                        Text(
                          'tamtama_last_fed'.tr(
                            namedArgs: {
                              'time': _formatTimeAgo(tamtama.lastFedAt!),
                            },
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: DesignTokens.spacingM),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'tamtama_status'.tr(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  tamtama.needsAttention
                                      ? 'tamtama_needs_attention'.tr()
                                      : 'tamtama_happy'.tr(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: colors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: DesignTokens.spacingS),
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<TamtamaBloc>().add(
                                      const TamtamaEvent.feedPet(),
                                    );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.primaryAccent,
                                foregroundColor: colorScheme.onTertiary,
                                minimumSize: const Size(0, 36),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    DesignTokens.cornerRadiusButton,
                                  ),
                                ),
                              ),
                              child: Text(
                                'tamtama_feed'.tr(),
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildLoading(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        ),
        child: Center(
          child: Text(
            message,
            style: TextStyle(color: colors.textSecondary),
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'time_just_now'.tr();
    } else if (difference.inMinutes < 60) {
      return 'time_minutes_ago'.tr(
        namedArgs: {'minutes': '${difference.inMinutes}'},
      );
    } else if (difference.inHours < 24) {
      return 'time_hours_ago'.tr(
        namedArgs: {'hours': '${difference.inHours}'},
      );
    } else {
      return 'time_days_ago'.tr(
        namedArgs: {'days': '${difference.inDays}'},
      );
    }
  }
}

class _TamtamaSpriteContainer extends StatelessWidget {
  final int backgroundIndex;
  final int eggIndex;

  const _TamtamaSpriteContainer({
    required this.backgroundIndex,
    required this.eggIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        BackgroundSprite(
          key: ValueKey('bg_$backgroundIndex'),
          index: backgroundIndex,
        ),
        EggSprite(
          key: ValueKey('egg_$eggIndex'),
          eggIndex: eggIndex,
        ),
      ],
    );
  }
}

class _TamtamaStatTags extends StatelessWidget {
  final int level;
  final int happiness;
  final int hunger;
  final bool isHappy;
  final bool isHungry;
  final Color tagDefaultBackground;
  final Color tagLiveBackground;
  final Color tagText;
  final Color tertiaryContainer;

  const _TamtamaStatTags({
    required this.level,
    required this.happiness,
    required this.hunger,
    required this.isHappy,
    required this.isHungry,
    required this.tagDefaultBackground,
    required this.tagLiveBackground,
    required this.tagText,
    required this.tertiaryContainer,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: DesignTokens.spacingS,
      runSpacing: DesignTokens.spacingS,
      children: [
        _StatTag(
          label: 'tamtama_level'.tr(),
          value: '$level',
          backgroundColor: tagDefaultBackground,
          textColor: tagText,
        ),
        _StatTag(
          label: 'tamtama_happiness'.tr(),
          value: '$happiness%',
          backgroundColor: isHappy ? tagLiveBackground : tagDefaultBackground,
          textColor: tagText,
        ),
        _StatTag(
          label: 'tamtama_hunger'.tr(),
          value: '$hunger%',
          backgroundColor: isHungry
              ? tertiaryContainer.withValues(alpha: 0.5)
              : tagDefaultBackground,
          textColor: tagText,
        ),
      ],
    );
  }
}

class _StatTag extends StatelessWidget {
  final String label;
  final String value;
  final Color backgroundColor;
  final Color textColor;

  const _StatTag({
    required this.label,
    required this.value,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingS),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Center(
        child: Text(
          '$label: $value',
          style: TextStyle(
            fontSize: DesignTokens.fontSizeLabelSmall,
            fontWeight: DesignTokens.fontWeightLabelSmall,
            color: textColor,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}

