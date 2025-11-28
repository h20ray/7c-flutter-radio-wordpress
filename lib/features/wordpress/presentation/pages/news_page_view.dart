import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/floating_bottom_nav_bar.dart';
import '../../../../core/widgets/floating_play_fab.dart';
import '../../../../core/widgets/news_list_skeleton.dart';
import '../../../../core/routes/app_routes.dart';
import '../bloc/wordpress_bloc.dart';
import '../../domain/entities/post_entity.dart';

class NewsPageView extends StatefulWidget {
  const NewsPageView({super.key});

  @override
  State<NewsPageView> createState() => _NewsPageViewState();
}

class _NewsPageViewState extends State<NewsPageView> {
  NavItem _selectedNavItem = NavItem.news;

  @override
  void initState() {
    super.initState();
    final state = context.read<WordPressBloc>().state;
    state.maybeWhen(
      loaded: (_, _, _, _, _, _) {},
      loading: (_) {},
      orElse: () {
        context.read<WordPressBloc>().add(const GetPostsEvent());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      },
      child: Scaffold(
        backgroundColor: colors.primaryBackground,
        body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar.large(
                expandedHeight: 120,
                collapsedHeight: 64,
                pinned: true,
                stretch: true,
                backgroundColor: Theme.of(context).colorScheme.surface,
                surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
                leading: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 16,
                    end: 8,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'assets/others/horizontal_logo_dark.png'
                        : 'assets/others/horizontal_logo_light.png',
                    fit: BoxFit.contain,
                    height: 32,
                  ),
                ),
                leadingWidth: 140,
                title: Text(
                  'home_nav_news'.tr(),
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeH1,
                    fontWeight: DesignTokens.fontWeightH1,
                    color: colors.textPrimary,
                  ),
                ),
                centerTitle: false,
                actions: [
                  IconButton(
                    onPressed: () {
                      // TODO: Navigate to notifications page
                    },
                    icon: const Icon(Icons.notifications_none, size: 20),
                    tooltip: 'Notifications',
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: IconButton(
                      onPressed: () {
                        // TODO: Implement search
                      },
                      icon: const Icon(Icons.search, size: 20),
                      tooltip: 'Search',
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
                  child: BlocBuilder<WordPressBloc, WordPressState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        loaded: (
                          posts,
                          postsByCategory,
                          selectedCategoryId,
                          hasMoreByCategory,
                          isLoadingByCategory,
                          errorsByCategory,
                        ) {
                          final displayPosts = selectedCategoryId != null
                              ? postsByCategory[selectedCategoryId] ?? posts
                              : posts;
                          
                          if (displayPosts.isEmpty) {
                            return SizedBox(
                              height: 400,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.article_outlined,
                                      size: 64,
                                      color: colors.textSecondary,
                                    ),
                                    SizedBox(height: DesignTokens.spacingM),
                                    Text(
                                      'No news available',
                                      style: TextStyle(
                                        fontSize: DesignTokens.fontSizeH2,
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: DesignTokens.spacingL),
                              ...displayPosts.map((post) => _buildNewsCard(context, post, colors)),
                            ],
                          );
                        },
                        loading: (categoryId) => const NewsListSkeleton(),
                        error: (failure, categoryId) => Padding(
                          padding: EdgeInsets.only(top: DesignTokens.spacingXl),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: colors.textSecondary,
                                ),
                                SizedBox(height: DesignTokens.spacingM),
                                Text(
                                  'Failed to load news',
                                  style: TextStyle(
                                    fontSize: DesignTokens.fontSizeH2,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        orElse: () => const NewsListSkeleton(),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 120),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(
                  left: DesignTokens.spacingL,
                  right: DesignTokens.spacingL,
                  bottom: DesignTokens.spacingS,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FloatingBottomNavBar(
                        selectedItem: _selectedNavItem,
                        onItemSelected: (item) {
                          setState(() {
                            _selectedNavItem = item;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: DesignTokens.spacingM),
                    FloatingPlayFab(
                      key: const ValueKey('news-play-fab'),
                      size: 60,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, PostEntity post, AppSemanticColors colors) {
    final hasImage = post.featuredImageUrl != null && post.featuredImageUrl!.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: DesignTokens.spacingL),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasImage)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: post.featuredImageUrl!,
                  fit: BoxFit.cover,
                  memCacheWidth: 800,
                  memCacheHeight: 450,
                  placeholder: (context, url) => Container(
                    color: colors.borderSubtle,
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
              ),
            Padding(
              padding: EdgeInsets.all(DesignTokens.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.categoryName != null && post.categoryName!.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingS,
                        vertical: DesignTokens.spacingXs,
                      ),
                      decoration: BoxDecoration(
                        color: colors.gradientStart.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        post.categoryName!,
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeCaption,
                          fontWeight: FontWeight.w600,
                          color: colors.gradientStart,
                        ),
                      ),
                    ),
                    SizedBox(height: DesignTokens.spacingS),
                  ],
                  Text(
                    post.title,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeH2,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (post.excerpt.isNotEmpty) ...[
                    SizedBox(height: DesignTokens.spacingS),
                    Text(
                      post.excerpt,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeBody,
                        color: colors.textSecondary,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (post.date != null) ...[
                    SizedBox(height: DesignTokens.spacingS),
                    Text(
                      _formatDate(post.date!, context),
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeCaption,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date, BuildContext context) {
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
}

