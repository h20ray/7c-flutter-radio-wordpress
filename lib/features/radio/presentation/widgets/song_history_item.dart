import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../domain/entities/song_history_entity.dart';

class SongHistoryItem extends StatelessWidget {
  final SongHistoryEntity song;
  final bool showBorder;

  const SongHistoryItem({
    super.key,
    required this.song,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final shadow = AppShadowTokens.elevation4(context);

    return Container(
      margin: EdgeInsets.only(bottom: DesignTokens.spacingM),
      padding: EdgeInsets.all(DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        border: showBorder
            ? Border.all(
                color: colors.borderSubtle,
                width: 1,
              )
            : null,
        boxShadow: showBorder ? null : shadow,
      ),
      child: Row(
        children: [
          if (song.albumArtUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
              child: AppNetworkImage(
                imageUrl: song.albumArtUrl!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  width: 60,
                  height: 60,
                  color: colors.surfaces.surfaceContainerHighest,
                  child: Icon(
                    Icons.music_note,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            )
          else
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: colors.surfaces.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
              ),
              child: Icon(
                Icons.music_note,
                color: colors.textSecondary,
              ),
            ),
          SizedBox(width: DesignTokens.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: DesignTokens.spacingXs),
                Text(
                  song.artist,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: DesignTokens.spacingXs),
                Text(
                  _formatTimestamp(song.timestamp),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'time_just_now'.tr();
    } else if (difference.inHours < 1) {
      return 'time_minutes_ago'.tr(namedArgs: {
        'minutes': difference.inMinutes.toString(),
      });
    } else if (difference.inDays < 1) {
      return 'time_hours_ago'.tr(namedArgs: {
        'hours': difference.inHours.toString(),
      });
    } else if (difference.inDays < 7) {
      return 'time_days_ago'.tr(namedArgs: {
        'days': difference.inDays.toString(),
      });
    } else {
      return DateFormat('MMM d, y').format(timestamp);
    }
  }
}

