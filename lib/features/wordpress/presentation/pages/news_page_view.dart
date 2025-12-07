import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/utils/search_query_helper.dart';
import '../../../../core/routes/app_routes.dart';

import '../../../../core/widgets/floating_bottom_nav_bar.dart';
import '../../../../core/widgets/floating_play_fab.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/news_feed_bloc.dart';
import '../bloc/news_search_bloc.dart';
import '../widgets/main/news_app_bar.dart';
import '../widgets/main/news_list_content.dart';
import '../widgets/main/news_search_overlay.dart';

class NewsPageView extends StatefulWidget {
  const NewsPageView({super.key});

  @override
  State<NewsPageView> createState() => _NewsPageViewState();
}

class _NewsPageViewState extends State<NewsPageView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final feedBloc = context.read<NewsFeedBloc>();
      if (feedBloc.state == const NewsFeedState.initial()) {
        feedBloc.add(const NewsFeedEvent.getPosts(useNewsPageLimit: true));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Blocs are already provided by NewsPage
    return const _NewsPageViewContent();
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
    final searchBloc = context.read<NewsSearchBloc>();
    final state = searchBloc.state;
    
    state.maybeWhen(
      loaded: (results, query, page, hasMore, isLoadingMore, error) {
        // If loading (initial search), we might want to wait? No, user can update query.
        
        if (sanitizedQuery.isNotEmpty) {
          if (sanitizedQuery != _lastSearchQuery && sanitizedQuery != query) {
            _lastSearchQuery = sanitizedQuery;
            searchBloc.add(NewsSearchEvent.searchPosts(query: sanitizedQuery));
          }
        } else {
          if (query.isNotEmpty) {
            _lastSearchQuery = null;
            searchBloc.add(const NewsSearchEvent.clearSearch());
          }
        }
      },
      orElse: () {
        if (sanitizedQuery.isNotEmpty && sanitizedQuery != _lastSearchQuery) {
          _lastSearchQuery = sanitizedQuery;
          searchBloc.add(NewsSearchEvent.searchPosts(query: sanitizedQuery));
        }
      },
    );
  }

  void _onClearSearch() {
    _searchController.clear();
    _lastSearchQuery = null;
    if (mounted) {
      context.read<NewsSearchBloc>().add(const NewsSearchEvent.clearSearch());
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

    final searchBloc = context.read<NewsSearchBloc>();
    final searchState = searchBloc.state;
    
    // Check search first
    bool isSearchActive = false;
    searchState.maybeWhen(
      loaded: (results, query, page, hasMore, isLoadingMore, error) {
        if (query.isNotEmpty) {
          isSearchActive = true;
          if (hasMore && !isLoadingMore) {
            searchBloc.add(const NewsSearchEvent.loadMoreSearchResults());
          }
        }
      },
      orElse: () {},
    );
    
    if (isSearchActive) return;

    // Check feed
    final feedBloc = context.read<NewsFeedBloc>();
    final feedState = feedBloc.state;
    
    feedState.maybeWhen(
      loaded: (
        posts,
        postsByCategory,
        selectedCategoryId,
        hasMoreByCategory,
        isLoadingByCategory,
        errorsByCategory,
        currentPageByCategory,
        offlinePostIds,
      ) {
        final hasMore = hasMoreByCategory[selectedCategoryId] ?? false;
        final isLoading = isLoadingByCategory[selectedCategoryId] ?? false;

        if (hasMore && !isLoading) {
          feedBloc.add(
            NewsFeedEvent.loadMorePosts(categoryId: selectedCategoryId),
          );
        }
      },
      orElse: () {},
    );
  }

  void _checkFillViewportIfNeeded() {
    if (_didInitialAutoLoadCheck) return;
    if (!mounted) return;
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final canScroll = position.maxScrollExtent > 0;
    if (canScroll) return;

    final searchBloc = context.read<NewsSearchBloc>();
    final searchState = searchBloc.state;
    
    bool isSearchActive = false;
    searchState.maybeWhen(
      loaded: (results, query, page, hasMore, isLoadingMore, error) {
        if (query.isNotEmpty) {
          isSearchActive = true;
          if (hasMore && !isLoadingMore) {
            _didInitialAutoLoadCheck = true;
            searchBloc.add(const NewsSearchEvent.loadMoreSearchResults());
          }
        }
      },
      orElse: () {},
    );
    
    if (isSearchActive) return;

    final feedBloc = context.read<NewsFeedBloc>();
    final feedState = feedBloc.state;

    feedState.maybeWhen(
      loaded: (
        posts,
        postsByCategory,
        selectedCategoryId,
        hasMoreByCategory,
        isLoadingByCategory,
        errorsByCategory,
        currentPageByCategory,
        offlinePostIds,
      ) {
        final hasMore = hasMoreByCategory[selectedCategoryId] ?? false;
        final isLoading = isLoadingByCategory[selectedCategoryId] ?? false;

        if (hasMore && !isLoading) {
          _didInitialAutoLoadCheck = true;
          feedBloc.add(
            NewsFeedEvent.loadMorePosts(categoryId: selectedCategoryId),
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
        
        await Navigator.pushReplacementNamed(context, AppRoutes.home);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: colors.primaryBackground,
        body: Stack(
          children: [
            BlocListener<AuthBloc, AuthState>(
              listenWhen: (previous, current) {
                return previous.maybeWhen(
                  unauthenticated: () => current.maybeWhen(
                    authenticated: (_) => true,
                    orElse: () => false,
                  ),
                  orElse: () => false,
                );
              },
              listener: (context, authState) {
                if (!mounted) return;
                
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  
                  final feedBloc = context.read<NewsFeedBloc>();
                  final feedState = feedBloc.state;
                  
                  final shouldRefresh = feedState.maybeWhen(
                    loaded: (
                      posts,
                      postsByCategory,
                      selectedCategoryId,
                      hasMoreByCategory,
                      isLoadingByCategory,
                      errorsByCategory,
                      currentPageByCategory,
                      offlinePostIds,
                    ) {
                      if (isLoadingByCategory[selectedCategoryId] == true) return false;
                      final currentPosts = selectedCategoryId != null
                          ? (postsByCategory[selectedCategoryId] ?? [])
                          : posts;
                      return currentPosts.isEmpty;
                    },
                    error: (failure, categoryId) => true,
                    initial: () => true,
                    orElse: () => false,
                  );
                  
                  if (shouldRefresh) {
                    feedBloc.add(const NewsFeedEvent.getPosts(useNewsPageLimit: true, forceRefresh: true));
                  }
                });
              },
              child: MultiBlocListener(
                listeners: [
                  BlocListener<NewsFeedBloc, NewsFeedState>(
                    listener: (context, state) {
                      WidgetsBinding.instance.addPostFrameCallback((duration) {
                        _checkFillViewportIfNeeded();
                      });
                    },
                  ),
                  BlocListener<NewsSearchBloc, NewsSearchState>(
                    listener: (context, state) {
                      state.maybeWhen(
                        loaded: (results, query, page, hasMore, isLoadingMore, error) {
                          // Don't sync if user is actively typing (prevents text reset while typing)
                          if (_isUserTyping) return;
                          
                          // Sync search controller with bloc state only when user is not typing
                          if (query.isEmpty) {
                            // Clear controller if bloc has no search query
                            if (_searchController.text.isNotEmpty) {
                              _searchController.clear();
                              _lastSearchQuery = null;
                            }
                          } else {
                            // Update controller if bloc search query differs from controller text
                            final sanitizedControllerText = SearchQueryHelper.sanitize(_searchController.text.trim());
                            if (sanitizedControllerText != query) {
                              _searchController.value = TextEditingValue(
                                text: query,
                                selection: TextSelection.collapsed(offset: query.length),
                              );
                              _lastSearchQuery = query;
                            }
                          }
                        },
                        orElse: () {},
                      );
                    },
                  ),
                ],
                child: Stack(
                children: [
                  const NewsSearchOverlay(),
                  RefreshIndicator(
                    onRefresh: () async {
                      final feedBloc = context.read<NewsFeedBloc>();
                      final feedState = feedBloc.state;
                      
                      feedState.maybeWhen(
                        loaded: (
                          posts,
                          postsByCategory,
                          selectedCategoryId,
                          hasMoreByCategory,
                          isLoadingByCategory,
                          errorsByCategory,
                          currentPageByCategory,
                          offlinePostIds,
                        ) {
                          // Refresh current category
                          feedBloc.add(NewsFeedEvent.getPosts(
                            categoryId: selectedCategoryId,
                            useNewsPageLimit: true,
                            forceRefresh: true,
                          ));
                        },
                        orElse: () {
                          // Initial load
                          feedBloc.add(const NewsFeedEvent.getPosts(
                            useNewsPageLimit: true,
                            forceRefresh: true,
                          ));
                        },
                      );
                      
                      // Wait for loading to complete (with timeout)
                      try {
                        await feedBloc.stream.timeout(
                          const Duration(seconds: 10),
                        ).firstWhere(
                          (state) => state.maybeWhen(
                            loaded: (
                              posts,
                              postsByCategory,
                              selectedCategoryId,
                              hasMoreByCategory,
                              isLoadingByCategory,
                              errorsByCategory,
                              currentPageByCategory,
                              offlinePostIds,
                            ) => !(isLoadingByCategory[selectedCategoryId] ?? false),
                            orElse: () => true,
                          ),
                        );
                      } catch (e) {
                        // Timeout or error - refresh indicator will complete anyway
                      }
                    },
                    child: CustomScrollView(
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
                  ),
                ],
              ),
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



