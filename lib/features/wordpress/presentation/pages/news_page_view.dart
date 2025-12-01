import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/floating_bottom_nav_bar.dart';
import '../../../../core/widgets/floating_play_fab.dart';
import '../../../../core/widgets/glass_app_bar_background.dart';
import '../../../../core/widgets/news_list_skeleton.dart';
import '../../../../core/widgets/shimmer_skeleton.dart';
import '../bloc/news_bloc.dart';
import '../widgets/news_card.dart';
import '../../domain/entities/post_entity.dart';

class NewsPageView extends StatelessWidget {
  const NewsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = getIt<NewsBloc>();
    if (bloc.state == const NewsState.initial()) {
      bloc.add(const NewsEvent.getPosts(useNewsPageLimit: true));
    }
    
    return BlocProvider.value(
      value: bloc,
      child: const _NewsPageViewContent(),
    );
  }
}

class _NewsPageViewContent extends StatefulWidget {
  const _NewsPageViewContent();

  @override
  State<_NewsPageViewContent> createState() => _NewsPageViewContentState();
}

class _NewsPageViewContentState extends State<_NewsPageViewContent> {
  NavItem _selectedNavItem = NavItem.news;
  late ScrollController _scrollController;
  bool _didInitialAutoLoadCheck = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  Future<void> _scrollToTop() async {
    if (!_scrollController.hasClients) return;
    await _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || !_scrollController.hasClients) return;
    
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    
    if (currentScroll < maxScroll - 200) return;

    final bloc = context.read<NewsBloc>();
    final state = bloc.state;
    state.maybeWhen(
      loaded: (
        posts,
        postsByCategory,
        selectedCategoryId,
        hasMoreByCategory,
        isLoadingByCategory,
        errorsByCategory,
        currentPageByCategory,
        searchResults,
        searchQuery,
        searchPage,
        hasMoreSearchResults,
        isLoadingSearch,
        searchError,
      ) {
        final isShowingSearchResults = searchQuery != null && searchQuery.isNotEmpty;

        if (isShowingSearchResults) {
          if (hasMoreSearchResults && !isLoadingSearch) {
            bloc.add(const NewsEvent.loadMoreSearchResults());
          }
          return;
        }



        final hasMore = hasMoreByCategory[selectedCategoryId] ?? false;
        final isLoading = isLoadingByCategory[selectedCategoryId] ?? false;

        if (hasMore && !isLoading) {
          bloc.add(
            NewsEvent.loadMorePosts(categoryId: selectedCategoryId),
          );
        }
      },
      orElse: () {},
    );
  }

  void _checkFillViewportIfNeeded(NewsState state) {
    if (_didInitialAutoLoadCheck) return;
    if (!mounted) return;
    if (!_scrollController.hasClients) return;

    state.maybeWhen(
      loaded: (
        posts,
        postsByCategory,
        selectedCategoryId,
        hasMoreByCategory,
        isLoadingByCategory,
        errorsByCategory,
        currentPageByCategory,
        searchResults,
        searchQuery,
        searchPage,
        hasMoreSearchResults,
        isLoadingSearch,
        searchError,
      ) {
        final position = _scrollController.position;
        final canScroll = position.maxScrollExtent > 0;
        if (canScroll) return;

        final bloc = context.read<NewsBloc>();
        final isShowingSearchResults = searchQuery != null && searchQuery.isNotEmpty;

        if (isShowingSearchResults) {
          if (hasMoreSearchResults && !isLoadingSearch) {
            _didInitialAutoLoadCheck = true;
            bloc.add(const NewsEvent.loadMoreSearchResults());
          }
          return;
        }



        final hasMore = hasMoreByCategory[selectedCategoryId] ?? false;
        final isLoading = isLoadingByCategory[selectedCategoryId] ?? false;

        if (hasMore && !isLoading) {
          _didInitialAutoLoadCheck = true;
          bloc.add(
            NewsEvent.loadMorePosts(categoryId: selectedCategoryId),
          );
        }
      },
      orElse: () {},
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
            BlocListener<NewsBloc, NewsState>(
              listener: (context, state) {
                WidgetsBinding.instance.addPostFrameCallback((duration) {
                  _checkFillViewportIfNeeded(state);
                });
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar.large(
                    pinned: true,
                    stretch: true,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
                    actions: const [],
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        final theme = Theme.of(context);
                        final textTheme = theme.textTheme;
                        final topPadding = MediaQuery.of(context).padding.top;
                        final collapsedHeight = kToolbarHeight + topPadding;
                        final currentHeight = constraints.maxHeight;

                        final t = ((currentHeight - collapsedHeight) / 80.0).clamp(0.0, 1.0);

                        const collapsedPadding = EdgeInsetsDirectional.only(
                          start: 16,
                          end: 16,
                          bottom: 16,
                        );

                        final expandedPadding = EdgeInsetsDirectional.only(
                          start: 16,
                          end: 16,
                          top: topPadding + 12,
                          bottom: 16,
                        );

                        final titlePadding = EdgeInsetsDirectional.lerp(
                          collapsedPadding,
                          expandedPadding,
                          t,
                        )!;

                        return GlassAppBarBackground(
                          child: FlexibleSpaceBar(
                            centerTitle: false,
                            titlePadding: titlePadding,
                            title: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: _scrollToTop,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'home_nav_news'.tr(),
                                    style: textTheme.headlineSmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (t > 0.1) ...[
                                    const SizedBox(height: 4),
                                    Opacity(
                                      opacity: t,
                                      child: Text(
                                        'home_news_title'.tr(),
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                    BlocBuilder<NewsBloc, NewsState>(
                    buildWhen: (previous, current) {
                      // Helper to extract relevant data for comparison
                      (List<PostEntity>, bool, bool, String?) extractData(NewsState state) {
                        return state.maybeWhen(
                          loaded: (posts, postsByCategory, selectedCategoryId, hasMoreByCategory, isLoadingByCategory, errorsByCategory, currentPageByCategory, searchResults, searchQuery, searchPage, hasMoreSearchResults, isLoadingSearch, searchError) {
                            final isShowingSearchResults = searchQuery != null && searchQuery.isNotEmpty;
                            final displayPosts = isShowingSearchResults
                                ? (searchResults ?? [])
                                : (selectedCategoryId != null
                                    ? postsByCategory[selectedCategoryId] ?? posts
                                    : posts);
                            final isLoadingMore = isShowingSearchResults
                                ? isLoadingSearch
                                : (isLoadingByCategory[selectedCategoryId] ?? false);
                            final hasError = isShowingSearchResults
                                ? searchError != null
                                : errorsByCategory[selectedCategoryId] != null;
                            return (displayPosts, isLoadingMore, hasError, searchQuery);
                          },
                          orElse: () => (<PostEntity>[], false, false, null),
                        );
                      }

                      final prevData = extractData(previous);
                      final currData = extractData(current);

                      // If search query changed, rebuild
                      if (prevData.$4 != currData.$4) return true;

                      // If loading or error state changed, rebuild
                      if (prevData.$2 != currData.$2 || prevData.$3 != currData.$3) return true;

                      // Check if posts are equal
                      final prevPosts = prevData.$1;
                      final currPosts = currData.$1;
                      
                      if (prevPosts.length != currPosts.length) return true;
                      
                      for (int i = 0; i < prevPosts.length; i++) {
                        if (prevPosts[i].id != currPosts[i].id) return true;
                      }
                      
                      return false;
                    },
                    builder: (context, state) {
                      return state.maybeWhen(
                        loaded: (
                          posts,
                          postsByCategory,
                          selectedCategoryId,
                          hasMoreByCategory,
                          isLoadingByCategory,
                          errorsByCategory,
                          currentPageByCategory,
                          searchResults,
                          searchQuery,
                          searchPage,
                          hasMoreSearchResults,
                          isLoadingSearch,
                          searchError,
                        ) {
                          final isShowingSearchResults = searchQuery != null && searchQuery.isNotEmpty;
                          final displayPosts = isShowingSearchResults
                              ? (searchResults ?? [])
                              : (selectedCategoryId != null
                                  ? postsByCategory[selectedCategoryId] ?? posts
                                  : posts);
                          
                          final isLoadingMore = isShowingSearchResults
                              ? isLoadingSearch
                              : (isLoadingByCategory[selectedCategoryId] ?? false);
                              
                          if (displayPosts.isEmpty && !isLoadingMore) {
                            return SliverToBoxAdapter(
                              child: SizedBox(
                                height: 400,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        isShowingSearchResults
                                            ? Icons.search_off
                                            : Icons.article_outlined,
                                        size: 64,
                                        color: colors.textSecondary,
                                      ),
                                      const SizedBox(height: DesignTokens.spacingM),
                                      Text(
                                        isShowingSearchResults
                                            ? 'news_empty_no_results'.tr()
                                            : 'news_empty_no_items'.tr(),
                                        style: TextStyle(
                                          fontSize: DesignTokens.fontSizeH2,
                                          color: colors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }

                          return SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  if (index == 0) {
                                    if (isShowingSearchResults) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          top: DesignTokens.spacingL,
                                          bottom: DesignTokens.spacingS,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'news_search_results_for'.tr(namedArgs: {'query': searchQuery}),
                                                style: TextStyle(
                                                  fontSize: DesignTokens.fontSizeBody,
                                                  color: colors.textSecondary,
                                                ),
                                              ),
                                            ),
                                            TextButton.icon(
                                              onPressed: () {
                                                context.read<NewsBloc>().add(
                                                  const NewsEvent.clearSearch(),
                                                );
                                              },
                                              icon: const Icon(Icons.close, size: 16),
                                              label: Text('news_search_clear'.tr()),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return const SizedBox(height: DesignTokens.spacingL);
                                    }
                                  }
                                  
                                  final postIndex = index - 1;
                                  
                                  if (postIndex < displayPosts.length) {
                                    final post = displayPosts[postIndex];
                                    return NewsCard(
                                      key: ValueKey(post.id),
                                      post: post,
                                      compact: isShowingSearchResults,
                                    );
                                  }
                                  
                                  if (isLoadingMore) {
                                    return _NewsLoadMoreFooter();
                                  }
                                  
                                  return const SizedBox.shrink();
                                },
                                childCount: displayPosts.length + 1 + (isLoadingMore ? 1 : 0),
                              ),
                            ),
                          );
                        },
                        loading: (categoryId) => SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
                            child: const NewsListSkeleton(),
                          ),
                        ),
                        error: (failure, categoryId) => SliverToBoxAdapter(
                          child: Padding(
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
                                  const SizedBox(height: DesignTokens.spacingM),
                                  Text(
                                    'news_error_failed_to_load'.tr(),
                                    style: TextStyle(
                                      fontSize: DesignTokens.fontSizeH2,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        orElse: () => SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
                            child: const NewsListSkeleton(),
                          ),
                        ),
                      );
                    },
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 120),
                  ),
                ],
              ),
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
}

class _NewsLoadMoreFooter extends StatelessWidget {
  const _NewsLoadMoreFooter();

  @override
  Widget build(BuildContext context) {
    final skeletonColor = Theme.of(context).colorScheme.surfaceContainerHighest;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        return Column(
          children: List.generate(
            3,
            (index) => Container(
              margin: EdgeInsets.only(bottom: DesignTokens.spacingL),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(
                  DesignTokens.cornerRadiusCard,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  DesignTokens.cornerRadiusCard,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: SkeletonBox(
                        width: availableWidth,
                        height: availableWidth / (16 / 9),
                        color: skeletonColor,
                        borderRadius: 0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(DesignTokens.spacingM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SkeletonBox(
                                width: 60,
                                height: 20,
                                color: skeletonColor,
                                borderRadius: 12,
                              ),
                              const SizedBox(width: DesignTokens.spacingS),
                              SkeletonBox(
                                width: 80,
                                height: 20,
                                color: skeletonColor,
                                borderRadius: 12,
                              ),
                            ],
                          ),
                      const SizedBox(height: DesignTokens.spacingS),
                      SkeletonBox(
                        width: availableWidth - (DesignTokens.spacingM * 2),
                        height: 20,
                        color: skeletonColor,
                      ),
                      const SizedBox(height: DesignTokens.spacingS),
                          SkeletonBox(
                            width: availableWidth - (DesignTokens.spacingM * 2),
                            height: 16,
                            color: skeletonColor,
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
      },
    );
  }
}


