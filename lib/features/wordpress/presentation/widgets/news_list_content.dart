import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/news_list_skeleton.dart';
import '../bloc/news_bloc.dart';
import '../widgets/news_card.dart';
import '../widgets/news_empty_states.dart';
import '../widgets/news_search_results_header.dart';
import '../../domain/entities/post_entity.dart';
import 'news_load_more_footer.dart';

class NewsListContent extends StatelessWidget {
  const NewsListContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      buildWhen: (previous, current) {
        final prevData = _extractData(previous);
        final currData = _extractData(current);

        if (prevData.$4 != currData.$4) return true;
        if (prevData.$2 != currData.$2 || prevData.$3 != currData.$3) return true;

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
            final hasActiveSearch = searchQuery != null && searchQuery.isNotEmpty;
            final regularPosts = selectedCategoryId != null
                ? postsByCategory[selectedCategoryId] ?? posts
                : posts;
            final isLoadingMore = isLoadingByCategory[selectedCategoryId] ?? false;

            if (hasActiveSearch) {
              return _buildSearchContent(
                context: context,
                isLoadingSearch: isLoadingSearch,
                searchResults: searchResults,
                searchQuery: searchQuery,
                hasMoreSearchResults: hasMoreSearchResults,
                onClear: () {
                  context.read<NewsBloc>().add(const NewsEvent.clearSearch());
                },
              );
            }

            return _buildRegularContent(
              context: context,
              posts: regularPosts,
              isLoadingMore: isLoadingMore,
              hasActiveSearch: hasActiveSearch,
            );
          },
          loading: (categoryId) => SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
              child: const NewsListSkeleton(),
            ),
          ),
          error: (failure, categoryId) => SliverToBoxAdapter(
            child: const NewsErrorState(),
          ),
          orElse: () => SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
              child: const NewsListSkeleton(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchContent({
    required BuildContext context,
    required bool isLoadingSearch,
    required List<PostEntity>? searchResults,
    required String searchQuery,
    required bool hasMoreSearchResults,
    required VoidCallback onClear,
  }) {
    // Show skeleton when loading and no results (or when starting a new search)
    if (isLoadingSearch && (searchResults == null || searchResults.isEmpty)) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
        sliver: SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: DesignTokens.spacingL),
            child: const NewsListSkeleton(itemCount: 1),
          ),
        ),
      );
    }

    if (searchResults != null) {
      if (searchResults.isEmpty) {
        return const SliverToBoxAdapter(
          child: NewsEmptyState(isSearch: true),
        );
      }

      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == 0) {
                return NewsSearchResultsHeader(
                  searchQuery: searchQuery,
                  onClear: onClear,
                );
              }

              final postIndex = index - 1;

              if (postIndex < searchResults.length) {
                final post = searchResults[postIndex];
                return NewsCard(
                  key: ValueKey('search-${post.id}'),
                  post: post,
                  compact: true,
                );
              }

              if (isLoadingSearch && hasMoreSearchResults) {
                return const NewsLoadMoreFooter();
              }

              return const SizedBox.shrink();
            },
            childCount: searchResults.length + 1 + (isLoadingSearch && hasMoreSearchResults ? 1 : 0),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
      sliver: SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: DesignTokens.spacingL),
          child: const NewsListSkeleton(itemCount: 1),
        ),
      ),
    );
  }

  Widget _buildRegularContent({
    required BuildContext context,
    required List<PostEntity> posts,
    required bool isLoadingMore,
    required bool hasActiveSearch,
  }) {
    if (posts.isEmpty && !isLoadingMore) {
      return const SliverToBoxAdapter(
        child: NewsEmptyState(isSearch: false),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == 0) {
              return const SizedBox(height: DesignTokens.spacingL);
            }

            final postIndex = index - 1;

            if (postIndex < posts.length) {
              final post = posts[postIndex];
              return Opacity(
                opacity: hasActiveSearch ? 0.5 : 1.0,
                child: NewsCard(
                  key: ValueKey('regular-${post.id}'),
                  post: post,
                  compact: false,
                ),
              );
            }

            if (isLoadingMore) {
              return const NewsLoadMoreFooter();
            }

            return const SizedBox.shrink();
          },
          childCount: posts.length + 1 + (isLoadingMore ? 1 : 0),
        ),
      ),
    );
  }

  (List<PostEntity>, bool, bool, String?) _extractData(NewsState state) {
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
        final hasError = isShowingSearchResults
            ? searchError != null
            : errorsByCategory[selectedCategoryId] != null;
        return (displayPosts, isLoadingMore, hasError, searchQuery);
      },
      orElse: () => (<PostEntity>[], false, false, null),
    );
  }
}

