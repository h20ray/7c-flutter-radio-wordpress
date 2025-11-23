import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../data/models/mock_listening_stats.dart';
import '../../data/models/mock_reward_points.dart';

class TopStatusCard extends StatelessWidget {
  final MockListeningStats? listeningStats;
  final MockRewardPoints? rewardPoints;

  const TopStatusCard({
    super.key,
    this.listeningStats,
    this.rewardPoints,
  });

  @override
  Widget build(BuildContext context) {
    final stats = listeningStats ?? MockListeningStats.defaultStats;
    final points = rewardPoints ?? MockRewardPoints.defaultPoints;

    return Transform.translate(
      offset: Offset(0, -DesignTokens.spacingXl),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
        height: 96,
        decoration: BoxDecoration(
          color: DesignTokens.colorCard,
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingL,
          vertical: DesignTokens.spacingM,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'home_status_active_plan'.tr(),
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeCaption,
                      color: DesignTokens.colorTextSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 2),
                  Text(
                    stats.planName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: DesignTokens.colorTextPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 2),
                  Text(
                    'home_status_renews_in'.tr(namedArgs: {'days': stats.renewalDays.toString()}),
                    style: TextStyle(
                      fontSize: 11,
                      color: DesignTokens.colorTextSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: DesignTokens.colorBorderSubtle,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'home_status_listening_time'.tr(),
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeCaption,
                      color: DesignTokens.colorTextSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 2),
                  Text(
                    stats.hoursListened,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeNumbers,
                      fontWeight: DesignTokens.fontWeightNumbers,
                      color: DesignTokens.colorTextPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: DesignTokens.colorBorderSubtle,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'home_status_reward_points'.tr(),
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeCaption,
                      color: DesignTokens.colorTextSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 2),
                  Text(
                    '${points.points} pts',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: DesignTokens.colorTextPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 2),
                  Text(
                    points.redemptionInfo,
                    style: TextStyle(
                      fontSize: 11,
                      color: DesignTokens.colorTextSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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

