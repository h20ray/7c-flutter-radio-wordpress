import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/news_card_skeleton.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../wordpress/presentation/bloc/wordpress_bloc.dart';
import '../../../wordpress/domain/entities/post_entity.dart';

class LatestNewsCarousel extends StatefulWidget {
  const LatestNewsCarousel({super.key});

  @override
  State<LatestNewsCarousel> createState() => _LatestNewsCarouselState();
}

class _LatestNewsCarouselState extends State<LatestNewsCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  List<PostEntity>? _previousPosts;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    final state = context.read<WordPressBloc>().state;
    state.maybeWhen(
      loaded: (posts, postsByCategory, selectedCategoryId, hasMoreByCategory, isLoadingByCategory, errorsByCategory, currentPageByCategory, searchResults, searchQuery, searchPage, hasMoreSearchResults, isLoadingSearch, searchError) {
        _previousPosts = postsByCategory[null] ?? posts;
      },
      loading: (categoryId) {},
      orElse: () {
        context.read<WordPressBloc>().add(const GetPostsEvent());
      },
    );

    _pageController.addListener(() {
      final next = _pageController.page?.round() ?? 0;
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Size _computeCardSize(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = DesignTokens.spacingL * 2;
    final cardWidth = width > horizontalPadding ? width - horizontalPadding : width;
    final cardHeight = cardWidth / (16 / 9);
    return Size(cardWidth, cardHeight);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final tokens = NewsCardTokens.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'home_news_title'.tr(),
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeH1,
                  fontWeight: DesignTokens.fontWeightH1,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      'home_news_subtitle'.tr(),
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeCaption,
                        color: colors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: DesignTokens.spacingS),
                  _buildNewsProviderChip(context),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: DesignTokens.spacingM),
        BlocBuilder<WordPressBloc, WordPressState>(
          buildWhen: (previous, current) {
            final previousPosts = previous.maybeWhen(
              loaded: (posts, postsByCategory, _, _, _, _, _, _, _, _, _, _, _) => postsByCategory[null] ?? posts,
              orElse: () => const <PostEntity>[],
            );
            final currentPosts = current.maybeWhen(
              loaded: (posts, postsByCategory, _, _, _, _, _, _, _, _, _, _, _) => postsByCategory[null] ?? posts,
              orElse: () => const <PostEntity>[],
            );

            return !_arePostsEqual(previousPosts, currentPosts) ||
                previous.runtimeType != current.runtimeType;
          },
          builder: (context, state) {
            return state.maybeWhen(
              loaded: (posts, postsByCategory, selectedCategoryId, hasMoreByCategory, isLoadingByCategory, errorsByCategory, currentPageByCategory, searchResults, searchQuery, searchPage, hasMoreSearchResults, isLoadingSearch, searchError) {
                final allPosts = postsByCategory[null] ?? posts;
                final cardSize = _computeCardSize(context);
                
                if (allPosts.isEmpty) {
                  return SizedBox(
                    height: cardSize.height,
                    child: Center(
                      child: Text(
                        'news_empty_no_items'.tr(),
                        style: TextStyle(color: colors.textSecondary),
                      ),
                    ),
                  );
                }

                final carouselPosts = allPosts.length > 5 ? allPosts.take(5).toList() : allPosts;
                final hasPostsChanged = _previousPosts == null ||
                    _previousPosts!.length != carouselPosts.length ||
                    !_arePostsEqual(_previousPosts!, carouselPosts);
                
                if (hasPostsChanged && _pageController.hasClients) {
                  WidgetsBinding.instance.addPostFrameCallback((duration) {
                    if (_pageController.hasClients && _currentPage > 0) {
                      final maxPage = (carouselPosts.length - 1).clamp(0, 4);
                      final targetPage = _currentPage.clamp(0, maxPage);
                      if (targetPage != _currentPage) {
                        _pageController.jumpToPage(targetPage);
                      }
                    }
                  });
                }
                
                _previousPosts = carouselPosts;

                return Column(
                  children: [
                    SizedBox(
                      height: cardSize.height,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: carouselPosts.length,
                        itemBuilder: (context, index) {
                          final post = carouselPosts[index];
                          final isLast = index == carouselPosts.length - 1;
                          return _buildNewsCard(
                            context,
                            post,
                            isLast,
                            tokens,
                            cardSize.width,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: DesignTokens.spacingS),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        carouselPosts.length,
                        (index) => Container(
                          width: 6,
                          height: 6,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? colors.gradientStart
                                : colors.borderSubtle,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: (categoryId) {
                final cardSize = _computeCardSize(context);
                
                if (_previousPosts != null && _previousPosts!.isNotEmpty) {
                  final carouselPosts = _previousPosts!.length > 5
                      ? _previousPosts!.take(5).toList()
                      : _previousPosts!;
                  
                  final safeCurrentPage = _currentPage.clamp(0, carouselPosts.length - 1);
                  if (safeCurrentPage != _currentPage && _pageController.hasClients) {
                    WidgetsBinding.instance.addPostFrameCallback((duration) {
                      if (_pageController.hasClients) {
                        _pageController.jumpToPage(safeCurrentPage);
                      }
                    });
                  }
                  
                  return Column(
                    children: [
                      SizedBox(
                        height: cardSize.height,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: carouselPosts.length,
                          itemBuilder: (context, index) {
                            final post = carouselPosts[index];
                            final isLast = index == carouselPosts.length - 1;
                            return _buildNewsCard(
                              context,
                              post,
                              isLast,
                              tokens,
                              cardSize.width,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: DesignTokens.spacingS),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          carouselPosts.length,
                          (index) => Container(
                            width: 6,
                            height: 6,
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index
                                  ? colors.gradientStart
                                  : colors.borderSubtle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return SizedBox(
                  height: cardSize.height,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) =>
                        NewsCardSkeleton(index: index, totalItems: 5),
                  ),
                );
              },
              error: (failure, categoryId) {
                final cardSize = _computeCardSize(context);
                return SizedBox(
                  height: cardSize.height,
                  child: Center(
                    child: Text(
                      'Failed to load news',
                      style: TextStyle(color: colors.textSecondary),
                    ),
                  ),
                );
              },
              orElse: () {
                final cardSize = _computeCardSize(context);
                return SizedBox(
                  height: cardSize.height,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) =>
                        NewsCardSkeleton(index: index, totalItems: 5),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildNewsCard(
    BuildContext context,
    PostEntity post,
    bool isLast,
    NewsCardTokens tokens,
    double cardWidth,
  ) {
    final hasImage =
        post.featuredImageUrl != null && post.featuredImageUrl!.isNotEmpty;

    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(
        left: DesignTokens.spacingL,
        right: isLast ? DesignTokens.spacingL : DesignTokens.spacingM,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        boxShadow: [
          BoxShadow(color: tokens.shadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(
                context,
                AppRoutes.postDetail,
                arguments: post,
              );
            },
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  if (hasImage)
                    Positioned.fill(
                      child: AppNetworkImage(
                        imageUrl: post.featuredImageUrl!,
                        fit: BoxFit.cover,
                        memCacheWidth: 800,
                        memCacheHeight: 450,
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [tokens.gradientStart, tokens.gradientEnd],
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [tokens.gradientStart, tokens.gradientEnd],
                            ),
                          ),
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white.withValues(alpha: 0.3),
                            size: 48,
                          ),
                        ),
                      ),
                    )
              else
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [tokens.gradientStart, tokens.gradientEnd],
                      ),
                    ),
                  ),
                ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(DesignTokens.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (post.categoryName != null &&
                        post.categoryName!.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: tokens.badgeBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          post.categoryName!,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeCaption,
                            fontWeight: FontWeight.w600,
                            color: tokens.badgeText,
                          ),
                        ),
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 3,
                                color: Colors.black.withValues(alpha: 0.5),
                              ),
                            ],
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (post.date != null) ...[
                          SizedBox(height: DesignTokens.spacingS),
                          Text(
                            _formatDate(post.date!, context),
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeCaption,
                              color: Colors.white.withValues(alpha: 0.9),
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                  color: Colors.black.withValues(alpha: 0.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _arePostsEqual(List<PostEntity> list1, List<PostEntity> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].id != list2[i].id) return false;
    }
    return true;
  }

  String _formatDate(DateTime date, BuildContext context) {
    final now = DateTime.now();
    var difference = now.difference(date);
    
    if (difference.isNegative) {
      difference = Duration.zero;
    }

    if (difference.inMinutes < 1) {
      return 'news_just_now'.tr();
    } else if (difference.inMinutes < 60) {
      return 'news_minutes_ago'.tr(
        namedArgs: {'minutes': '${difference.inMinutes}'},
      );
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

  Widget _buildNewsProviderChip(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingXs,
        vertical: DesignTokens.spacingXs / 3,
      ),
      decoration: BoxDecoration(
        color: colors.navBackground.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Text(
        'tujuhcahaya.com',
        style: TextStyle(
          fontSize: DesignTokens.fontSizeCaption,
          fontWeight: FontWeight.w400,
          color: colors.textPrimary,
        ),
      ),
    );
  }
}
