import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/haptic_widgets.dart';
import '../../../../core/widgets/news_card_skeleton.dart';
import '../../../wordpress/domain/entities/post_entity.dart';
import '../../../wordpress/presentation/bloc/news_feed_bloc.dart';

class LatestNewsCarousel extends StatefulWidget {
  const LatestNewsCarousel({super.key});

  @override
  State<LatestNewsCarousel> createState() => _LatestNewsCarouselState();
}

class _LatestNewsCarouselState extends State<LatestNewsCarousel> {
  late PageController _pageController;
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier(0);
  List<PostEntity>? _previousPosts;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    final bloc = context.read<NewsFeedBloc>();
    final state = bloc.state;
    state.maybeWhen(
      loaded:
          (
            posts,
            postsByCategory,
            selectedCategoryId,
            hasMoreByCategory,
            isLoadingByCategory,
            errorsByCategory,
            currentPageByCategory,
            offlinePostIds,
          ) {
            _previousPosts = postsByCategory[null] ?? posts;
          },
      loading: (categoryId) {},
      orElse: () {
        bloc.add(const NewsFeedEvent.loadCachedData());
        bloc.add(const NewsFeedEvent.getPosts());
      },
    );

    _pageController.addListener(() {
      final next = _pageController.page?.round() ?? 0;
      if (_currentPageNotifier.value != next) {
        _currentPageNotifier.value = next;
        _preloadAdjacentImages(next);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }

  void _preloadImages(List<PostEntity> posts) {
    if (posts.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      for (int i = 0; i < posts.length; i++) {
        final post = posts[i];
        final imageUrl = post.featuredImageUrl;
        if (imageUrl == null || imageUrl.isEmpty) continue;

        final delay = i == 0 ? 0 : (i * 50);
        Future.delayed(Duration(milliseconds: delay), () {
          if (!mounted) return;
          final provider = _buildCarouselProvider(imageUrl);
          if (provider == null) return;
          precacheImage(provider, context).catchError((_) {});
        });
      }
    });
  }

  void _preloadAdjacentImages(int currentIndex) {
    if (_previousPosts == null || _previousPosts!.isEmpty) return;

    final carouselPosts = _previousPosts!.length > 5
        ? _previousPosts!.take(5).toList()
        : _previousPosts!;

    final indicesToPreload = <int>[];
    if (currentIndex > 0) {
      indicesToPreload.add(currentIndex - 1);
    }
    if (currentIndex < carouselPosts.length - 1) {
      indicesToPreload.add(currentIndex + 1);
    }

    for (final index in indicesToPreload) {
      if (index >= 0 && index < carouselPosts.length) {
        final post = carouselPosts[index];
        final imageUrl = post.featuredImageUrl;
        if (imageUrl == null || imageUrl.isEmpty) continue;

        final provider = _buildCarouselProvider(imageUrl);
        if (provider == null) continue;
        precacheImage(provider, context).catchError((_) {});
      }
    }
  }

  ImageProvider<Object>? _buildCarouselProvider(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return null;
    return buildAppNetworkImageProvider(
      imageUrl,
      memCacheWidth: 800,
      memCacheHeight: 450,
    );
  }

  Size _computeCardSize(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = DesignTokens.spacingL * 2;
    final cardWidth = width > horizontalPadding
        ? width - horizontalPadding
        : width;
    final cardHeight = cardWidth / (16 / 9);
    return Size(cardWidth, cardHeight);
  }

  @override
  Widget build(BuildContext context) {
    final buildStart = DateTime.now();
    final colors = context.appColors;
    final tokens = NewsCardTokens.of(context);

    final buildDuration = DateTime.now().difference(buildStart);
    DebugLogger.log(
      'LatestNewsCarousel.build took ${buildDuration.inMicroseconds}µs',
      tag: 'PERF_HOME_CAROUSEL',
    );

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
        BlocBuilder<NewsFeedBloc, NewsFeedState>(
          buildWhen: (previous, current) {
            final previousPosts = previous.maybeWhen(
              loaded:
                  (posts, postsByCategory, _, _, _, _, _, _) =>
                      postsByCategory[null] ?? posts,
              orElse: () => const <PostEntity>[],
            );
            final currentPosts = current.maybeWhen(
              loaded:
                  (posts, postsByCategory, _, _, _, _, _, _) =>
                      postsByCategory[null] ?? posts,
              orElse: () => const <PostEntity>[],
            );

            return !_arePostsEqual(previousPosts, currentPosts) ||
                previous.runtimeType != current.runtimeType;
          },
          builder: (context, state) {
            return state.maybeWhen(
              loaded:
                  (
                    posts,
                    postsByCategory,
                    selectedCategoryId,
                    hasMoreByCategory,
                    isLoadingByCategory,
                    errorsByCategory,
                    currentPageByCategory,
                    offlinePostIds,
                  ) {
                    final allPosts = postsByCategory[null] ?? posts;
                    final cardSize = _computeCardSize(context);

                    if (allPosts.isEmpty) {
                      final isLoading = isLoadingByCategory[null] ?? false;
                      if (isLoading) {
                        return SizedBox(
                          height: cardSize.height,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) =>
                                NewsCardSkeleton(index: index, totalItems: 5),
                          ),
                        );
                      }

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

                    final carouselPosts = allPosts.length > 5
                        ? allPosts.take(5).toList()
                        : allPosts;
                    final hasPostsChanged =
                        _previousPosts == null ||
                        _previousPosts!.length != carouselPosts.length ||
                        !_arePostsEqual(_previousPosts!, carouselPosts);

                    if (hasPostsChanged && _pageController.hasClients) {
                      WidgetsBinding.instance.addPostFrameCallback((duration) {
                        if (_pageController.hasClients &&
                            _currentPageNotifier.value > 0) {
                          final maxPage = (carouselPosts.length - 1).clamp(
                            0,
                            4,
                          );
                          final targetPage = _currentPageNotifier.value.clamp(
                            0,
                            maxPage,
                          );
                          if (targetPage != _currentPageNotifier.value) {
                            _pageController.jumpToPage(targetPage);
                          }
                        }
                      });
                    }

                    _previousPosts = carouselPosts;

                    _preloadImages(carouselPosts);

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
                              return RepaintBoundary(
                                child: _buildNewsCard(
                                  context,
                                  post,
                                  isLast,
                                  tokens,
                                  cardSize.width,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: DesignTokens.spacingS),
                        ValueListenableBuilder<int>(
                          valueListenable: _currentPageNotifier,
                          builder: (context, currentPage, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                carouselPosts.length,
                                (index) => Container(
                                  width: 6,
                                  height: 6,
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: currentPage == index
                                        ? colors.gradientStart
                                        : colors.borderSubtle,
                                  ),
                                ),
                              ),
                            );
                          },
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

                  final safeCurrentPage = _currentPageNotifier.value.clamp(
                    0,
                    carouselPosts.length - 1,
                  );
                  if (safeCurrentPage != _currentPageNotifier.value &&
                      _pageController.hasClients) {
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
                            return RepaintBoundary(
                              child: _buildNewsCard(
                                context,
                                post,
                                isLast,
                                tokens,
                                cardSize.width,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: DesignTokens.spacingS),
                      ValueListenableBuilder<int>(
                        valueListenable: _currentPageNotifier,
                        builder: (context, currentPage, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              carouselPosts.length,
                              (index) => Container(
                                width: 6,
                                height: 6,
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: currentPage == index
                                      ? colors.gradientStart
                                      : colors.borderSubtle,
                                ),
                              ),
                            ),
                          );
                        },
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

    return RepaintBoundary(
      child: Container(
        width: cardWidth,
        margin: EdgeInsets.only(
          left: DesignTokens.spacingL,
          right: isLast ? DesignTokens.spacingL : DesignTokens.spacingM,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
          boxShadow: [
            BoxShadow(
              color: tokens.shadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
          child: Material(
            color: Colors.transparent,
            child: HapticInkWell(
              onTap: () {
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
                    if (hasImage)
                      Positioned.fill(
                        child: _CarouselImage(
                          imageUrl: post.featuredImageUrl!,
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
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
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
                                      color: Colors.black.withValues(
                                        alpha: 0.5,
                                      ),
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
                                        color: Colors.black.withValues(
                                          alpha: 0.5,
                                        ),
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
      return 'time_just_now'.tr();
    } else if (difference.inMinutes < 60) {
      return 'time_minutes_ago'.tr(
        namedArgs: {'minutes': '${difference.inMinutes}'},
      );
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

class _CarouselImage extends StatefulWidget {
  final String imageUrl;

  const _CarouselImage({
    required this.imageUrl,
  });

  @override
  State<_CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<_CarouselImage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AppNetworkImage(
      imageUrl: widget.imageUrl,
      fit: BoxFit.cover,
      memCacheWidth: 800,
      memCacheHeight: 450,
      fadeInDuration: Duration.zero,
      placeholder: (context, url) => const SizedBox.shrink(),
      errorWidget: (context, url, error) => const SizedBox.shrink(),
    );
  }
}
