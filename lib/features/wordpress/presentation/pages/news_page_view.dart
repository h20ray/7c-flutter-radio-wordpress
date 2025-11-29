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
import '../../../../core/widgets/skeleton_box.dart';
import '../bloc/news_bloc.dart';
import '../widgets/news_card.dart';

class NewsPageView extends StatelessWidget {
  const NewsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NewsBloc>(),
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
  late final NewsBloc _newsBloc;
  bool _didInitialAutoLoadCheck = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _newsBloc = context.read<NewsBloc>();

    final state = _newsBloc.state;
    state.maybeWhen(
      loaded: (_, _, _, _, _, _, _, _, _, _, _, _, _) {},
      loading: (_) {},
      orElse: () {
        if (!_newsBloc.isClosed) {
          _newsBloc.add(const NewsEvent.getPosts(useNewsPageLimit: true));
        }
      },
    );
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
    if (_newsBloc.isClosed) return;
    
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    
    if (currentScroll < maxScroll - 200) return;

    final state = _newsBloc.state;
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
        final isSearchMode = searchQuery != null && searchQuery.isNotEmpty;

        if (isSearchMode) {
          if (hasMoreSearchResults && !isLoadingSearch && !_newsBloc.isClosed) {
            _newsBloc.add(const NewsEvent.loadMoreSearchResults());
          }
          return;
        }

        final categoryId = selectedCategoryId;
        final hasMore = hasMoreByCategory[categoryId] ?? false;
        final isLoading = isLoadingByCategory[categoryId] ?? false;

        if (hasMore && !isLoading && !_newsBloc.isClosed) {
          _newsBloc.add(
            NewsEvent.loadMorePosts(categoryId: categoryId),
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
    if (_newsBloc.isClosed) return;

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

        final isSearchMode = searchQuery != null && searchQuery.isNotEmpty;

        if (isSearchMode) {
          if (hasMoreSearchResults && !isLoadingSearch && !_newsBloc.isClosed) {
            _didInitialAutoLoadCheck = true;
            _newsBloc.add(const NewsEvent.loadMoreSearchResults());
          }
          return;
        }

        final categoryId = selectedCategoryId;
        final hasMore = hasMoreByCategory[categoryId] ?? false;
        final isLoading = isLoadingByCategory[categoryId] ?? false;

        if (hasMore && !isLoading && !_newsBloc.isClosed) {
          _didInitialAutoLoadCheck = true;
          _newsBloc.add(
            NewsEvent.loadMorePosts(categoryId: categoryId),
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
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
                          final isSearchMode = searchQuery != null && searchQuery.isNotEmpty;
                          final displayPosts = isSearchMode
                              ? (searchResults ?? [])
                              : (selectedCategoryId != null
                                  ? postsByCategory[selectedCategoryId] ?? posts
                                  : posts);
                          
                          final isLoadingMore = isSearchMode
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
                                        isSearchMode
                                            ? Icons.search_off
                                            : Icons.article_outlined,
                                        size: 64,
                                        color: colors.textSecondary,
                                      ),
                                      SizedBox(height: DesignTokens.spacingM),
                                      Text(
                                        isSearchMode
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
                                    if (isSearchMode) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          top: DesignTokens.spacingL,
                                          bottom: DesignTokens.spacingS,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Search results for "$searchQuery"',
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
                                              label: const Text('Clear'),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return SizedBox(height: DesignTokens.spacingL);
                                    }
                                  }
                                  
                                  final postIndex = index - 1;
                                  
                                  if (postIndex < displayPosts.length) {
                                    return NewsCard(
                                      post: displayPosts[postIndex],
                                      compact: isSearchMode,
                                    );
                                  }
                                  
                                  if (isLoadingMore) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: DesignTokens.spacingL,
                                      ),
                                      child: _NewsLoadMoreFooter(
                                        isSearchMode: isSearchMode,
                                      ),
                                    );
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
                  SliverToBoxAdapter(
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
  final bool isSearchMode;

  const _NewsLoadMoreFooter({
    required this.isSearchMode,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final skeletonColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    final label = isSearchMode
        ? 'Loading more results…'
        : 'Loading more articles…';

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SkeletonBox(
            width: 32,
            height: 32,
            color: skeletonColor,
            borderRadius: 16,
          ),
          SizedBox(width: DesignTokens.spacingM),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(
                width: 120,
                height: 14,
                color: skeletonColor,
              ),
              SizedBox(height: DesignTokens.spacingXs),
              Text(
                label,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeCaption,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

