import 'dart:async';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';

import '../../../../../core/themes/app_color_system.dart';
import '../../../../../core/themes/component_tokens.dart';
import '../../../../../core/themes/design_tokens.dart';
import '../../../../../core/widgets/haptic_widgets.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../domain/entities/post_entity.dart';
import 'news_post_image.dart';

class NewsCard extends StatelessWidget {
  final PostEntity post;
  final bool compact;
  final bool isOffline;

  const NewsCard({
    super.key,
    required this.post,
    this.compact = false,
    this.isOffline = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasImage = post.featuredImageUrl != null && post.featuredImageUrl!.isNotEmpty;
    final chipTokens = NewsFilterChipTokens.of(context);

    return Container(
      margin: const EdgeInsets.only(
        bottom: DesignTokens.spacingL,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        child: Material(
          color: Colors.transparent,
          child: HapticInkWell(
            onTap: () {
              unawaited(Navigator.pushNamed(
                context,
                AppRoutes.postDetail,
                arguments: post,
              ));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasImage)
                  Stack(
                    children: [
                      RepaintBoundary(
                        child: NewsPostImage(
                          imageUrl: post.featuredImageUrl!,
                          semanticLabel: post.title,
                        ),
                      ),
                      if (isOffline)
                        Positioned(
                          top: DesignTokens.spacingS,
                          right: DesignTokens.spacingS,
                          child: Container(
                            padding: const EdgeInsets.all(DesignTokens.spacingS - 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.offline_pin,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _NewsMetadataRow(
                    post: post,
                    compact: compact,
                    colors: colors,
                    chipTokens: chipTokens,
                    isOffline: isOffline,
                  ),
                  const SizedBox(height: DesignTokens.spacingS),
                  Text(
                    post.title,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeH2,
                      fontWeight: DesignTokens.fontWeightH2,
                      color: colors.textPrimary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NewsMetadataRow extends StatelessWidget {
  final PostEntity post;
  final bool compact;
  final AppSemanticColors colors;
  final NewsFilterChipTokens chipTokens;
  final bool isOffline;

  const _NewsMetadataRow({
    required this.post,
    required this.compact,
    required this.colors,
    required this.chipTokens,
    this.isOffline = false,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalSpacing = compact ? DesignTokens.spacingXs : DesignTokens.spacingS;

    return Wrap(
      spacing: horizontalSpacing,
      runSpacing: horizontalSpacing,
      children: [
        if (post.categoryName != null && post.categoryName!.isNotEmpty)
          _NewsPillChip(
            text: post.categoryName!,
            colors: colors,
          ),
        if (post.date != null)
          _NewsPillChip(
            text: _formatNewsDate(post.date!, context),
            colors: colors,
          ),
        if (isOffline)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: colors.gradientStart.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.gradientStart.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.offline_pin,
                  size: 12,
                  color: colors.gradientStart,
                ),
                const SizedBox(width: 4),
                Text(
                  'news_offline_label'.tr(),
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeLabelSmall,
                    fontWeight: DesignTokens.fontWeightLabelSmall,
                    color: colors.gradientStart,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _NewsPillChip extends StatelessWidget {
  final String text;
  final AppSemanticColors colors;

  const _NewsPillChip({
    required this.text,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final vibrantColor = isLight
        ? colors.gradientStart.withValues(alpha: 0.15)
        : colors.gradientStart.withValues(alpha: 0.25);
    final vibrantTextColor = isLight
        ? colors.gradientStart
        : colors.gradientStart.withValues(alpha: 0.9);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: vibrantColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: vibrantTextColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: DesignTokens.fontSizeLabelSmall,
          fontWeight: DesignTokens.fontWeightLabelSmall,
          letterSpacing: DesignTokens.letterSpacingLabelSmall,
          color: vibrantTextColor,
        ),
      ),
    );
  }
}

String _formatNewsDate(DateTime date, BuildContext context) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inMinutes < 1) {
    return 'time_just_now'.tr();
  } else if (difference.inMinutes < 60) {
    return 'time_minutes_ago'.tr(namedArgs: {'minutes': '${difference.inMinutes}'});
  } else if (difference.inHours < 24) {
    return 'time_hours_ago'.tr(namedArgs: {'hours': '${difference.inHours}'});
  } else if (difference.inDays < 7) {
    return 'time_days_ago'.tr(namedArgs: {'days': '${difference.inDays}'});
  } else {
    final locale = context.locale;
    if (locale.languageCode == 'id') {
      return '${date.day}/${date.month}/${date.year}';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}

