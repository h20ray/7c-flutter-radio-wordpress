import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/component_tokens.dart';
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
  late ScrollController _scrollController;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    final state = context.read<WordPressBloc>().state;
    state.maybeWhen(
      loaded: (_, _, _, _, _, _, _, _, _, _, _, _, _) {},
      loading: (_) {},
      orElse: () {
        context.read<WordPressBloc>().add(const GetPostsEvent(useNewsPageLimit: true));
      },
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    
    if (maxScroll > 0 && currentScroll >= maxScroll - 200) {
      final state = context.read<WordPressBloc>().state;
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
          if (searchQuery != null && searchQuery.isNotEmpty) {
            if (hasMoreSearchResults && !isLoadingSearch) {
              context.read<WordPressBloc>().add(
                const WordPressEvent.loadMoreSearchResults(),
              );
            }
          } else {
            final categoryId = selectedCategoryId;
            final hasMore = hasMoreByCategory[categoryId] ?? false;
            final isLoading = isLoadingByCategory[categoryId] ?? false;
            if (hasMore && !isLoading) {
              context.read<WordPressBloc>().add(
                WordPressEvent.loadMorePosts(categoryId: categoryId),
              );
            }
          }
        },
        orElse: () {},
      );
    }
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
            controller: _scrollController,
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
                        _showSearchDialog(context);
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
                            return SizedBox(
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
                                          ? 'No results found'
                                          : 'No news available',
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
                              if (isSearchMode) ...[
                                SizedBox(height: DesignTokens.spacingL),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: DesignTokens.spacingS,
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
                                          context.read<WordPressBloc>().add(
                                            const WordPressEvent.clearSearch(),
                                          );
                                        },
                                        icon: const Icon(Icons.close, size: 16),
                                        label: const Text('Clear'),
                                      ),
                                    ],
                                  ),
                                ),
                              ] else
                                SizedBox(height: DesignTokens.spacingL),
                              ...displayPosts.map((post) => _buildNewsCard(context, post, colors)),
                              if (isLoadingMore) ...[
                                SizedBox(height: DesignTokens.spacingL),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(DesignTokens.spacingL),
                                    child: CircularProgressIndicator(
                                      color: colors.gradientStart,
                                    ),
                                  ),
                                ),
                              ],
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
    final chipTokens = NewsFilterChipTokens.of(context);

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
              padding: EdgeInsets.all(DesignTokens.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: DesignTokens.spacingS,
                    runSpacing: DesignTokens.spacingS,
                    children: [
                      if (post.categoryName != null && post.categoryName!.isNotEmpty)
                        _buildPillChip(
                          text: post.categoryName!,
                          chipTokens: chipTokens,
                          colors: colors,
                        ),
                      if (post.date != null)
                        _buildPillChip(
                          text: _formatDateForSearch(post.date!, context),
                          chipTokens: chipTokens,
                          colors: colors,
                        ),
                    ],
                  ),
                  SizedBox(height: DesignTokens.spacingS),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillChip({
    required String text,
    required NewsFilterChipTokens chipTokens,
    required AppSemanticColors colors,
  }) {
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

  void _showSearchDialog(BuildContext context) {
    final colors = context.appColors;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SearchDialogContent(colors: colors),
    );
  }
}

Widget _buildNewsCardForSearch(BuildContext context, PostEntity post, AppSemanticColors colors) {
  final hasImage = post.featuredImageUrl != null && post.featuredImageUrl!.isNotEmpty;
  final chipTokens = NewsFilterChipTokens.of(context);

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
            padding: EdgeInsets.all(DesignTokens.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: DesignTokens.spacingXs,
                  runSpacing: DesignTokens.spacingXs,
                  children: [
                    if (post.categoryName != null && post.categoryName!.isNotEmpty)
                      _buildPillChipForSearch(
                        text: post.categoryName!,
                        chipTokens: chipTokens,
                        context: context,
                        colors: colors,
                      ),
                    if (post.date != null)
                      _buildPillChipForSearch(
                        text: _formatDateForSearch(post.date!, context),
                        chipTokens: chipTokens,
                        context: context,
                        colors: colors,
                      ),
                  ],
                ),
                SizedBox(height: DesignTokens.spacingS),
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
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildPillChipForSearch({
  required String text,
  required NewsFilterChipTokens chipTokens,
  required BuildContext context,
  required AppSemanticColors colors,
}) {
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

String _formatDateForSearch(DateTime date, BuildContext context) {
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

class _SearchDialogContent extends StatefulWidget {
  final AppSemanticColors colors;

  const _SearchDialogContent({required this.colors});

  @override
  State<_SearchDialogContent> createState() => _SearchDialogContentState();
}

class _SearchDialogContentState extends State<_SearchDialogContent> {
  late TextEditingController _searchController;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchTextChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        context.read<WordPressBloc>().add(
          WordPressEvent.searchPosts(query: query),
        );
      } else {
        context.read<WordPressBloc>().add(
          const WordPressEvent.clearSearch(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: widget.colors.primaryBackground,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignTokens.cornerRadiusCard),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(DesignTokens.spacingL),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search news...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _searchController,
                        builder: (context, value, child) {
                          return value.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    context.read<WordPressBloc>().add(
                                      const WordPressEvent.clearSearch(),
                                    );
                                  },
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.cornerRadiusCard,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: DesignTokens.spacingS),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<WordPressBloc, WordPressState>(
              builder: (context, state) {
                final colors = widget.colors;
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
                    if (searchQuery == null || searchQuery.isEmpty) {
                      return Center(
                        child: Text(
                          'Enter a search term',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeBody,
                            color: colors.textSecondary,
                          ),
                        ),
                      );
                    }
                    
                    if (isLoadingSearch && (searchResults == null || searchResults.isEmpty)) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (searchError != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: colors.textSecondary,
                            ),
                            SizedBox(height: DesignTokens.spacingM),
                            Text(
                              'Search failed',
                              style: TextStyle(
                                fontSize: DesignTokens.fontSizeH2,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    if (searchResults == null || searchResults.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: colors.textSecondary,
                            ),
                            SizedBox(height: DesignTokens.spacingM),
                            Text(
                              'No results found',
                              style: TextStyle(
                                fontSize: DesignTokens.fontSizeH2,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollEndNotification) {
                          final scrollController = notification.metrics;
                          if (scrollController.pixels >=
                              scrollController.maxScrollExtent - 200) {
                            if (hasMoreSearchResults && !isLoadingSearch) {
                              context.read<WordPressBloc>().add(
                                const WordPressEvent.loadMoreSearchResults(),
                              );
                            }
                          }
                        }
                        return false;
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.all(DesignTokens.spacingL),
                        itemCount: searchResults.length + (isLoadingSearch ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == searchResults.length) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(DesignTokens.spacingL),
                                child: CircularProgressIndicator(
                                  color: colors.gradientStart,
                                ),
                              ),
                            );
                          }
                          return _buildNewsCardForSearch(context, searchResults[index], widget.colors);
                        },
                      ),
                    );
                  },
                  orElse: () => const Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}

