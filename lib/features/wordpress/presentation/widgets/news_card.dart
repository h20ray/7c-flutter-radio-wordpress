import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../domain/entities/post_entity.dart';
import 'news_post_image.dart';

class NewsCard extends StatelessWidget {
  final PostEntity post;
  final bool compact;

  const NewsCard({
    super.key,
    required this.post,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasImage = post.featuredImageUrl != null && post.featuredImageUrl!.isNotEmpty;
    final chipTokens = NewsFilterChipTokens.of(context);

    return Container(
      margin: EdgeInsets.only(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.postDetail,
              arguments: {'post': post, 'heroTag': 'news-page-post-image-${post.id}'},
            );
          },
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasImage)
                  Hero(
                    tag: 'news-page-post-image-${post.id}',
                    child: RepaintBoundary(
                      child: Material(
                        color: Colors.transparent,
                        child: NewsPostImage(
                          imageUrl: post.featuredImageUrl!,
                          semanticLabel: post.title,
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(DesignTokens.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _NewsMetadataRow(
                        post: post,
                        compact: compact,
                        colors: colors,
                        chipTokens: chipTokens,
                      ),
                      SizedBox(height: DesignTokens.spacingS),
                      Text(
                        post.title,
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeH2,
                          fontWeight: FontWeight.bold,
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

  const _NewsMetadataRow({
    required this.post,
    required this.compact,
    required this.colors,
    required this.chipTokens,
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
          fontSize: 10,
          fontWeight: FontWeight.w500,
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
    return 'news_just_now'.tr();
  } else if (difference.inMinutes < 60) {
    return 'news_minutes_ago'.tr(namedArgs: {'minutes': '${difference.inMinutes}'});
  } else if (difference.inHours < 24) {
    return 'news_hours_ago'.tr(namedArgs: {'hours': '${difference.inHours}'});
  } else if (difference.inDays < 7) {
    return 'news_days_ago'.tr(namedArgs: {'days': '${difference.inDays}'});
  } else {
    final locale = context.locale;
    if (locale.languageCode == 'id') {
      return '${date.day}/${date.month}/${date.year}';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}


