import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/utils/search_query_helper.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/floating_bottom_nav_bar.dart';
import '../../../../core/widgets/floating_play_fab.dart';
import '../bloc/news_bloc.dart';
import '../widgets/news_app_bar.dart';
import '../widgets/news_list_content.dart';
import '../widgets/news_search_overlay.dart';

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
  late TextEditingController _searchController;
  bool _didInitialAutoLoadCheck = false;
  String? _lastSearchQuery;
  bool _isUserTyping = false;
  Timer? _typingDebounce;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    if (!mounted) return;
    
    _isUserTyping = true;
    _typingDebounce?.cancel();
    _typingDebounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        _isUserTyping = false;
      }
    });
  }

  void _performSearch() {
    if (!mounted) return;
    
    final rawQuery = _searchController.text.trim();
    final sanitizedQuery = SearchQueryHelper.sanitize(rawQuery);
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
        currentSearchQuery,
        searchPage,
        hasMoreSearchResults,
        isLoadingSearch,
        searchError,
      ) {
        if (isLoadingSearch) return;
        
        if (sanitizedQuery.isNotEmpty) {
          if (sanitizedQuery != _lastSearchQuery && sanitizedQuery != currentSearchQuery) {
            _lastSearchQuery = sanitizedQuery;
            bloc.add(NewsEvent.searchPosts(query: sanitizedQuery));
          }
        } else {
          if (currentSearchQuery != null && currentSearchQuery.isNotEmpty) {
            _lastSearchQuery = null;
            bloc.add(const NewsEvent.clearSearch());
          }
        }
      },
      orElse: () {
        // Even if state is not loaded yet, we can still trigger search
        // The search will be preserved when news list finishes loading
        if (sanitizedQuery.isNotEmpty && sanitizedQuery != _lastSearchQuery) {
          _lastSearchQuery = sanitizedQuery;
          bloc.add(NewsEvent.searchPosts(query: sanitizedQuery));
        }
      },
    );
  }

  void _onClearSearch() {
    _searchController.clear();
    _lastSearchQuery = null;
    if (mounted) {
      context.read<NewsBloc>().add(const NewsEvent.clearSearch());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    _typingDebounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || !_scrollController.hasClients) return;
    
    // Unfocus search box when user starts scrolling
    final appBarState = NewsAppBar.of(context);
    if (appBarState != null && appBarState.isSearchFocused) {
      appBarState.unfocusSearch();
    }
    
    // Also unfocus any focused text field using FocusScope
    final currentFocus = FocusScope.of(context);
    if (currentFocus.hasFocus) {
      currentFocus.unfocus();
    }
    
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
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final bottomSpacing = DesignTokens.spacingS;
    final extraSpacing = DesignTokens.spacingXl;
    final totalBottomSpacing = FloatingBottomNavBar.totalHeight + bottomSpacing + safeAreaBottom + extraSpacing;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        
        // Always unfocus search box and any focused field when back button is pressed
        final appBarState = NewsAppBar.of(context);
        if (appBarState != null && appBarState.isSearchFocused) {
          appBarState.unfocusSearch();
        }
        
        // Also unfocus any focused text field using FocusScope
        final currentFocus = FocusScope.of(context);
        if (currentFocus.hasFocus) {
          currentFocus.unfocus();
          return; // Don't navigate if something was focused, just unfocus
        }
        
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: colors.primaryBackground,
        body: Stack(
          children: [
            BlocListener<NewsBloc, NewsState>(
              listener: (context, state) {
                WidgetsBinding.instance.addPostFrameCallback((duration) {
                  _checkFillViewportIfNeeded(state);
                });
                
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
                    // Don't sync if user is actively typing (prevents text reset while typing)
                    if (_isUserTyping) return;
                    
                    // Sync search controller with bloc state only when user is not typing
                    if (searchQuery == null || searchQuery.isEmpty) {
                      // Clear controller if bloc has no search query
                      if (_searchController.text.isNotEmpty) {
                        _searchController.clear();
                        _lastSearchQuery = null;
                      }
                    } else {
                      // Update controller if bloc search query differs from controller text
                      final sanitizedControllerText = SearchQueryHelper.sanitize(_searchController.text.trim());
                      if (sanitizedControllerText != searchQuery) {
                        _searchController.value = TextEditingValue(
                          text: searchQuery,
                          selection: TextSelection.collapsed(offset: searchQuery.length),
                        );
                        _lastSearchQuery = searchQuery;
                      }
                    }
                  },
                  orElse: () {},
                );
              },
              child: Stack(
                children: [
                  const NewsSearchOverlay(),
                  CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      NewsAppBar(
                        searchController: _searchController,
                        onSearch: _performSearch,
                        onClear: _onClearSearch,
                      ),
                      const NewsListContent(),
                      SliverToBoxAdapter(
                        child: SizedBox(height: totalBottomSpacing),
                      ),
                    ],
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



