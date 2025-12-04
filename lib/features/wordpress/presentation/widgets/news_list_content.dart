import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/news_list_skeleton.dart';
import '../bloc/news_feed_bloc.dart';
import '../bloc/news_search_bloc.dart';
import '../widgets/news_card.dart';
import '../widgets/news_empty_states.dart';
import '../widgets/news_search_results_header.dart';
import '../../domain/entities/post_entity.dart';
import 'news_load_more_footer.dart';

class NewsListContent extends StatelessWidget {
  const NewsListContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsSearchBloc, NewsSearchState>(
      builder: (context, searchState) {
        return searchState.maybeWhen(
          loaded: (results, query, page, hasMore, isLoadingMore, error) {
            if (query.isNotEmpty) {
              return _buildSearchContent(
                context: context,
                isLoadingSearch: false, // Loaded means not initial loading
                searchResults: results,
                searchQuery: query,
                hasMoreSearchResults: hasMore,
                isLoadingMore: isLoadingMore,
                onClear: () {
                  context.read<NewsSearchBloc>().add(const NewsSearchEvent.clearSearch());
                },
              );
            }
            return _buildFeedContent(context);
          },
          loading: () => _buildSearchContent(
            context: context,
            isLoadingSearch: true,
            searchResults: null,
            searchQuery: '', // Query is not available in loading state? Actually we can pass it if we want, but loading state is simple.
            hasMoreSearchResults: false,
            isLoadingMore: false,
            onClear: () {
               context.read<NewsSearchBloc>().add(const NewsSearchEvent.clearSearch());
            },
          ),
          error: (failure) => _buildSearchContent(
            context: context,
            isLoadingSearch: false,
            searchResults: [], // Error state, show empty or error?
            searchQuery: '', // We should probably preserve query in error state too
            hasMoreSearchResults: false,
            isLoadingMore: false,
            onClear: () {
               context.read<NewsSearchBloc>().add(const NewsSearchEvent.clearSearch());
            },
          ), // TODO: Show error properly
          orElse: () => _buildFeedContent(context),
        );
      },
    );
  }

  Widget _buildFeedContent(BuildContext context) {
    return BlocBuilder<NewsFeedBloc, NewsFeedState>(
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
          ) {
            // Always prefer the category-specific list (including the "all" category with null key)
            final regularPosts =
                postsByCategory[selectedCategoryId] ?? posts;
            final isLoadingMore = isLoadingByCategory[selectedCategoryId] ?? false;
            // We need to distinguish between initial loading and loading more.
            // If posts are empty and loading, it's initial loading.
            
            if (regularPosts.isEmpty && isLoadingMore) {
               return SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
                  child: const NewsListSkeleton(),
                ),
              );
            }

            return _buildRegularContent(
              context: context,
              posts: regularPosts,
              isLoadingMore: isLoadingMore,
              hasActiveSearch: false,
            );
          },
          loading: (categoryId) => SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
              child: const NewsListSkeleton(),
            ),
          ),
          error: (failure, categoryId) => const SliverToBoxAdapter(
            child: NewsErrorState(),
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
    required bool isLoadingMore,
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

              if (isLoadingMore) { // Use isLoadingMore from arguments
                return const NewsLoadMoreFooter();
              }

              return const SizedBox.shrink();
            },
            childCount: searchResults.length + 1 + (isLoadingMore ? 1 : 0),
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
}


