import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/app_config.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/glass_app_bar_background.dart';
import '../../domain/entities/post_entity.dart';
import '../bloc/news_feed_bloc.dart';
import '../widgets/news_share_card.dart';

class PostDetailPageView extends StatefulWidget {
  final PostEntity post;

  const PostDetailPageView({
    super.key,
    required this.post,
  });

  @override
  State<PostDetailPageView> createState() => _PostDetailPageViewState();
}

class _PostDetailPageViewState extends State<PostDetailPageView> {
  static final Map<int?, DateTime> _categoryRefreshTimestamps = {};
  final GlobalKey _shareCardKey = GlobalKey();

  late PostEntity _currentPost;
  int? _trackedCategoryId;

  @override
  void initState() {
    super.initState();
    _currentPost = widget.post;
    _trackedCategoryId = _currentPost.categoryIds.isNotEmpty
        ? _currentPost.categoryIds.first
        : null;
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      if (mounted) {
        _requestBackgroundRefresh();
      }
    });
  }

  @override
  void didUpdateWidget(covariant PostDetailPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post != widget.post) {
      _currentPost = widget.post;
      _trackedCategoryId = _currentPost.categoryIds.isNotEmpty
          ? _currentPost.categoryIds.first
          : null;
      WidgetsBinding.instance.addPostFrameCallback((duration) {
        if (mounted) {
          _requestBackgroundRefresh();
        }
      });
    }
  }

  void _requestBackgroundRefresh() {
    final bloc = context.read<NewsFeedBloc>();
    final now = DateTime.now();
    final categoryId = _trackedCategoryId;
    final lastRefresh = _categoryRefreshTimestamps[categoryId];

    final alreadyLoading = bloc.state.maybeWhen(
      loading: (activeCategoryId) => activeCategoryId == categoryId,
      loaded: (
        _,
        _,
        _,
        _,
        isLoadingByCategory,
        _,
        _,
      ) =>
          isLoadingByCategory[categoryId] ?? false,
      orElse: () => false,
    );

    if (alreadyLoading) {
      return;
    }

    if (lastRefresh != null &&
        now.difference(lastRefresh) < const Duration(seconds: 45)) {
      return;
    }

    _categoryRefreshTimestamps[categoryId] = now;
    bloc.add(NewsFeedEvent.getPosts(
      categoryId: categoryId,
      forceRefresh: true,
    ));
  }

  void _syncPostFromState(NewsFeedState state) {
    state.maybeWhen(
      loaded: (
        posts,
        postsByCategory,
        selectedCategoryId,
        hasMoreByCategory,
        isLoadingByCategory,
        errorsByCategory,
        currentPageByCategory,
      ) {
        final updated = _findMatchingPost(postsByCategory[_trackedCategoryId]) ??
            _findMatchingPost(posts);
        if (updated != null && updated != _currentPost) {
          setState(() {
            _currentPost = updated;
          });
        }
      },
      orElse: () {},
    );
  }

  PostEntity? _findMatchingPost(List<PostEntity>? posts) {
    if (posts == null) return null;
    for (final post in posts) {
      if (post.id == _currentPost.id) {
        return post;
      }
    }
    return null;
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

  bool _isInternalLink(String url) {
    try {
      final uri = Uri.parse(url);
      if (!uri.hasScheme || !uri.hasAuthority) {
        return true;
      }
      final host = uri.host.toLowerCase();
      final baseDomain = AppConfig.url.toLowerCase();
      return host == baseDomain || host.endsWith('.$baseDomain');
    } catch (e) {
      return false;
    }
  }

  Future<void> _handleLinkTap(String? url, Map<String, String> attributes, dynamic element) async {
    if (url == null || url.isEmpty) return;

    try {
      Uri uri;
      if (url.startsWith('http://') || url.startsWith('https://')) {
        uri = Uri.parse(url);
      } else if (url.startsWith('//')) {
        uri = Uri.parse('https:$url');
      } else if (url.startsWith('/')) {
        uri = Uri.parse('https://${AppConfig.url}$url');
      } else if (url.startsWith('mailto:') || url.startsWith('tel:') || url.startsWith('sms:')) {
        uri = Uri.parse(url);
      } else {
        uri = Uri.parse('https://${AppConfig.url}/$url');
      }

      if (!uri.hasScheme || (!uri.hasAuthority && !uri.scheme.startsWith('mailto') && !uri.scheme.startsWith('tel') && !uri.scheme.startsWith('sms'))) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('news_link_unavailable'.tr()),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      final isInternal = _isInternalLink(uri.toString());
      final launched = await launchUrl(
        uri,
        mode: isInternal ? LaunchMode.inAppWebView : LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('news_link_unavailable'.tr()),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('news_link_error'.tr()),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _captureAndShare() async {
    try {
      // 1. Find the render object
      final boundary = _shareCardKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      if (boundary == null) {
        debugPrint('Could not find render boundary');
        return;
      }

      // 2. Capture image
      // Use a pixel ratio > 1.0 for better quality
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes == null) {
        debugPrint('Could not generate PNG bytes');
        return;
      }

      // 3. Save to temp file
      final directory = await getTemporaryDirectory();
      final fileName = 'share_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(pngBytes);

      // 4. Copy link to clipboard for easy pasting in Instagram Story
      await Clipboard.setData(ClipboardData(text: _currentPost.link));
      
      // 5. Share
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: '${_currentPost.title}\n\n${_currentPost.link}',
          subject: _currentPost.title,
        ),
      );
      
      // 6. Show confirmation that link is copied
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Link copied to clipboard! Paste it in Instagram Story link sticker.'),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error capturing share card: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('news_link_error'.tr())),
        );
      }
    }
  }

  Widget _buildFeaturedImage(BuildContext context, PostEntity post) {
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
        fadeInDuration: Duration.zero,
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
    final hasImage =
        _currentPost.featuredImageUrl != null && _currentPost.featuredImageUrl!.isNotEmpty;

    return BlocListener<NewsFeedBloc, NewsFeedState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) => _syncPostFromState(state),
      child: Scaffold(
        backgroundColor: colors.primaryBackground,
        body: Stack(
          children: [
            // Hidden Share Card
            Transform.translate(
              offset: const Offset(-10000, -10000),
              child: RepaintBoundary(
                key: _shareCardKey,
                child: NewsShareCard(post: _currentPost),
              ),
            ),
            CustomScrollView(
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
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.share_2),
                  onPressed: _captureAndShare,
                ),
              ],
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
                  _currentPost.title,
                  style: textTheme.headlineMedium?.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ),
            if (hasImage) ...[
              SliverToBoxAdapter(
                child: SizedBox(height: DesignTokens.spacingM),
              ),
              SliverToBoxAdapter(
                child: _buildFeaturedImage(context, _currentPost),
              ),
            ],
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                DesignTokens.spacingL,
                DesignTokens.spacingL,
                DesignTokens.spacingL,
                DesignTokens.spacingL,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PostMetadataRow(
                      post: _currentPost,
                      colors: colors,
                      formatDate: _formatNewsDate,
                    ),
                    SizedBox(height: DesignTokens.spacingL),
                    _PostContentHtml(
                      htmlContent: _currentPost.content,
                      colors: colors,
                      textTheme: textTheme,
                      onLinkTap: _handleLinkTap,
                    ),
                  ],
                ),
              ),
            ),
          ],
            ),
          ],
        ),
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

    final authorBackground = isLight
        ? colors.navBackground.withValues(alpha: 0.9)
        : colors.navBackground.withValues(alpha: 0.8);
    final authorTextColor = colors.textPrimary;

    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: DesignTokens.spacingS,
            runSpacing: DesignTokens.spacingS,
            children: [
              if (post.categoryName != null && post.categoryName!.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
          ),
        ),
        if (post.authorName != null && post.authorName!.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: authorBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.borderSubtle,
                width: 1,
              ),
            ),
            child: Text(
              post.authorName!,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: authorTextColor,
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
  final Function(String?, Map<String, String>, dynamic)? onLinkTap;

  const _PostContentHtml({
    required this.htmlContent,
    required this.colors,
    required this.textTheme,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Html(
      data: htmlContent,
      onLinkTap: onLinkTap,
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
          display: Display.inlineBlock,
          padding: HtmlPaddings.symmetric(
            horizontal: 4,
            vertical: 12,
          ),
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
