import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../domain/entities/tamtama_entity.dart';
import '../bloc/tamtama_bloc.dart';
import 'background_sprite.dart';

class TamtamaSection extends StatelessWidget {
  const TamtamaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TamtamaBloc, TamtamaState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (tamtama) => _buildTamtamaContent(context, tamtama),
          loading: () => _buildLoading(context),
          error: (message) => _buildError(context, message),
          orElse: () => _buildLoading(context),
        );
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
          padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
          child: Text(
            'home_tamtama_title'.tr(),
            style: TextStyle(
              fontSize: DesignTokens.fontSizeH1,
              fontWeight: DesignTokens.fontWeightH1,
              color: colors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: DesignTokens.spacingM),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    DesignTokens.cornerRadiusCard,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      BackgroundSprite(index: tamtama.backgroundIndex),
                    ],
                  ),
                ),
              ),
              SizedBox(width: DesignTokens.spacingM),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 200),
                  padding: EdgeInsets.all(DesignTokens.spacingM),
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: BorderRadius.circular(
                      DesignTokens.cornerRadiusCard,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: tokens.shadowStrong,
                        blurRadius: 12,
                        offset: Offset(0, 4),
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
                      SizedBox(height: DesignTokens.spacingS),
                      Wrap(
                        spacing: DesignTokens.spacingS,
                        runSpacing: DesignTokens.spacingS,
                        children: [
                          _buildStatTag(
                            context,
                            'tamtama_level'.tr(),
                            '${tamtama.level}',
                            tokens.tagDefaultBackground,
                            tokens.tagText,
                          ),
                          _buildStatTag(
                            context,
                            'tamtama_happiness'.tr(),
                            '${tamtama.happiness}%',
                            tamtama.isHappy
                                ? tokens.tagLiveBackground
                                : tokens.tagDefaultBackground,
                            tokens.tagText,
                          ),
                          _buildStatTag(
                            context,
                            'tamtama_hunger'.tr(),
                            '${tamtama.hunger}%',
                            tamtama.isHungry
                                ? Colors.orange.withValues(alpha: 0.2)
                                : tokens.tagDefaultBackground,
                            tokens.tagText,
                          ),
                        ],
                      ),
                      SizedBox(height: DesignTokens.spacingS),
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
                      SizedBox(height: DesignTokens.spacingM),
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
                                SizedBox(height: 2),
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
                          SizedBox(width: DesignTokens.spacingS),
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
                                minimumSize: Size(0, 36),
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    DesignTokens.cornerRadiusButton,
                                  ),
                                ),
                              ),
                              child: Text(
                                'tamtama_feed'.tr(),
                                style: TextStyle(fontSize: 12),
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

  Widget _buildStatTag(
    BuildContext context,
    String label,
    String value,
    Color backgroundColor,
    Color textColor,
  ) {
    return Container(
      height: 22,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Center(
        child: Text(
          '$label: $value',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    final colors = context.appColors;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
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
      return 'tamtama_just_now'.tr();
    } else if (difference.inMinutes < 60) {
      return 'tamtama_minutes_ago'.tr(
        namedArgs: {'minutes': '${difference.inMinutes}'},
      );
    } else if (difference.inHours < 24) {
      return 'tamtama_hours_ago'.tr(
        namedArgs: {'hours': '${difference.inHours}'},
      );
    } else {
      return 'tamtama_days_ago'.tr(
        namedArgs: {'days': '${difference.inDays}'},
      );
    }
  }
}

