import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../domain/entities/tamtama_entity.dart';
import '../../domain/entities/tamtama_economy_entity.dart';
import '../bloc/tamtama_bloc.dart';
import 'background_sprite.dart';
import 'egg_sprite.dart';
import 'tamtama_stats_card.dart';
import 'tamtama_care_controls.dart';
import 'tamtama_economy_display.dart';

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
          loaded: (prevTamtama, prevEconomy, prevListening) => current.maybeWhen(
            loaded: (currTamtama, currEconomy, currListening) => 
                prevTamtama != currTamtama || prevEconomy != currEconomy,
            orElse: () => true,
          ),
          orElse: () => false,
        );
      },
      builder: (context, state) {
        final buildStart = DateTime.now();
        final result = state.maybeWhen(
          loaded: (tamtama, economy, isListening) => _buildTamtamaContent(context, tamtama, economy),
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

  Widget _buildTamtamaContent(BuildContext context, TamtamaEntity tamtama, TamtamaEconomyEntity economy) {
    final colors = context.appColors;
    final tokens = FeaturedRadioTokens.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'home_tamtama_title'.tr(),
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeH1,
                  fontWeight: DesignTokens.fontWeightH1,
                  color: colors.textPrimary,
                ),
              ),
              TamtamaEconomyDisplay(economy: economy),
            ],
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
                child: Column(
                  children: [
                    Container(
                      constraints: const BoxConstraints(minHeight: 140),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tamtama.petName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              _LevelTag(
                                level: tamtama.level,
                                backgroundColor: tokens.tagDefaultBackground,
                                textColor: tokens.tagText,
                              ),
                            ],
                          ),
                          const SizedBox(height: DesignTokens.spacingS),
                          TamtamaStatsCard(
                            hunger: tamtama.hunger,
                            energy: tamtama.energy,
                            happiness: tamtama.happiness,
                            hygiene: tamtama.hygiene,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: DesignTokens.spacingM),
        Padding(
           padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
           child: TamtamaCareControls(tamtama: tamtama, economy: economy),
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

class _LevelTag extends StatelessWidget {
  final int level;
  final Color backgroundColor;
  final Color textColor;

  const _LevelTag({
    required this.level,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingS,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusAlbumArt),
      ),
      child: Text(
        'Lvl $level',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
