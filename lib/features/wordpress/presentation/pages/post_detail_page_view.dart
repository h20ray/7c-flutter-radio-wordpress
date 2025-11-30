import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/glass_app_bar_background.dart';
import '../../domain/entities/post_entity.dart';

class PostDetailPageView extends StatelessWidget {
  final PostEntity post;

  const PostDetailPageView({
    super.key,
    required this.post,
  });

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

  Widget _buildFeaturedImage(BuildContext context) {
    final colors = context.appColors;
    final hasImage = post.featuredImageUrl != null && post.featuredImageUrl!.isNotEmpty;
    
    if (!hasImage) {
      return const SizedBox.shrink();
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: AppNetworkImage(
        imageUrl: post.featuredImageUrl!,
        fit: BoxFit.cover,
        memCacheWidth: 800,
        memCacheHeight: 450,
        fadeInDuration: DesignTokens.animationDurationMedium,
        placeholder: (context, url) => Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        errorWidget: (context, url, error) => Container(
          color: colors.borderSubtle,
          child: Icon(
            Icons.image_not_supported,
            color: colors.textSecondary,
            size: 48,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final hasImage = post.featuredImageUrl != null && post.featuredImageUrl!.isNotEmpty;

    return Scaffold(
      backgroundColor: colors.primaryBackground,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            leading: IconButton(
              icon: const Icon(LucideIcons.arrow_left),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.transparent,
            surfaceTintColor: theme.colorScheme.surfaceTint,
            elevation: 0,
            scrolledUnderElevation: 0,
            flexibleSpace: GlassAppBarBackground(
              child: Container(),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              DesignTokens.spacingL,
              DesignTokens.spacingL,
              DesignTokens.spacingL,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: Text(
                post.title,
                style: textTheme.headlineMedium?.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
          if (hasImage)
            SliverToBoxAdapter(
              child: _buildFeaturedImage(context),
            ),
          SliverPadding(
            padding: EdgeInsets.all(DesignTokens.spacingL),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PostMetadataRow(
                    post: post,
                    colors: colors,
                    formatDate: _formatNewsDate,
                  ),
                  SizedBox(height: DesignTokens.spacingXl),
                  _PostContentHtml(
                    htmlContent: post.content,
                    colors: colors,
                    textTheme: textTheme,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostMetadataRow extends StatelessWidget {
  final PostEntity post;
  final AppSemanticColors colors;
  final String Function(DateTime, BuildContext) formatDate;

  const _PostMetadataRow({
    required this.post,
    required this.colors,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final vibrantColor = isLight
        ? colors.gradientStart.withValues(alpha: 0.15)
        : colors.gradientStart.withValues(alpha: 0.25);
    final vibrantTextColor = isLight
        ? colors.gradientStart
        : colors.gradientStart.withValues(alpha: 0.9);

    return Wrap(
      spacing: DesignTokens.spacingS,
      runSpacing: DesignTokens.spacingS,
      children: [
        if (post.categoryName != null && post.categoryName!.isNotEmpty)
          Container(
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
              post.categoryName!,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: vibrantTextColor,
              ),
            ),
          ),
        if (post.date != null)
          Container(
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
              formatDate(post.date!, context),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: vibrantTextColor,
              ),
            ),
          ),
      ],
    );
  }
}

class _PostContentHtml extends StatelessWidget {
  final String htmlContent;
  final AppSemanticColors colors;
  final TextTheme textTheme;

  const _PostContentHtml({
    required this.htmlContent,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Html(
      data: htmlContent,
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(DesignTokens.fontSizeBody),
          lineHeight: const LineHeight(1.6),
          color: colors.textPrimary,
          fontFamily: 'Inter',
        ),
        'p': Style(
          margin: Margins.only(bottom: DesignTokens.spacingM),
          fontSize: FontSize(DesignTokens.fontSizeBody),
          lineHeight: const LineHeight(1.6),
          color: colors.textPrimary,
        ),
        'h1': Style(
          margin: Margins.only(
            top: DesignTokens.spacingXl,
            bottom: DesignTokens.spacingM,
          ),
          fontSize: FontSize(DesignTokens.fontSizeH1),
          fontWeight: DesignTokens.fontWeightH1,
          color: colors.textPrimary,
        ),
        'h2': Style(
          margin: Margins.only(
            top: DesignTokens.spacingXl,
            bottom: DesignTokens.spacingM,
          ),
          fontSize: FontSize(DesignTokens.fontSizeH2),
          fontWeight: DesignTokens.fontWeightH2,
          color: colors.textPrimary,
        ),
        'h3': Style(
          margin: Margins.only(
            top: DesignTokens.spacingL,
            bottom: DesignTokens.spacingS,
          ),
          fontSize: FontSize(18),
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        'a': Style(
          color: colors.gradientStart,
          textDecoration: TextDecoration.underline,
        ),
        'img': Style(
          width: Width(100, Unit.percent),
          margin: Margins.symmetric(
            vertical: DesignTokens.spacingM,
          ),
        ),
        'blockquote': Style(
          margin: Margins.symmetric(vertical: DesignTokens.spacingM),
          padding: HtmlPaddings.only(left: DesignTokens.spacingL),
          border: Border(
            left: BorderSide(
              color: colors.borderSubtle,
              width: 4,
            ),
          ),
        ),
        'code': Style(
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          padding: HtmlPaddings.symmetric(
            horizontal: 4,
            vertical: 2,
          ),
          fontFamily: 'monospace',
          fontSize: FontSize(DesignTokens.fontSizeCaption),
        ),
        'pre': Style(
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          padding: HtmlPaddings.all(DesignTokens.spacingM),
          margin: Margins.symmetric(vertical: DesignTokens.spacingM),
        ),
        'ul': Style(
          margin: Margins.only(
            top: DesignTokens.spacingM,
            bottom: DesignTokens.spacingM,
            left: DesignTokens.spacingL,
          ),
          padding: HtmlPaddings.zero,
        ),
        'ol': Style(
          margin: Margins.only(
            top: DesignTokens.spacingM,
            bottom: DesignTokens.spacingM,
            left: DesignTokens.spacingL,
          ),
          padding: HtmlPaddings.zero,
        ),
        'li': Style(
          margin: Margins.only(bottom: DesignTokens.spacingS),
          fontSize: FontSize(DesignTokens.fontSizeBody),
          lineHeight: const LineHeight(1.6),
          color: colors.textPrimary,
        ),
      },
    );
  }
}
