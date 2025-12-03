import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/app_color_system.dart';
import '../bloc/news_bloc.dart';

class NewsSearchOverlay extends StatelessWidget {
  const NewsSearchOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocBuilder<NewsBloc, NewsState>(
      buildWhen: (previous, current) {
        final prevHasSearch = previous.maybeWhen(
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
          ) => searchQuery != null && searchQuery.isNotEmpty,
          orElse: () => false,
        );
        final currHasSearch = current.maybeWhen(
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
          ) => searchQuery != null && searchQuery.isNotEmpty,
          orElse: () => false,
        );
        return prevHasSearch != currHasSearch;
      },
      builder: (context, state) {
        final hasActiveSearch = state.maybeWhen(
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
          ) => searchQuery != null && searchQuery.isNotEmpty,
          orElse: () => false,
        );
        final isLoadingSearch = state.maybeWhen(
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
          ) => isLoadingSearch,
          orElse: () => false,
        );

        if (!hasActiveSearch) return const SizedBox.shrink();

        return Positioned.fill(
          child: IgnorePointer(
            ignoring: !isLoadingSearch && state.maybeWhen(
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
              ) => searchResults != null && searchResults.isNotEmpty,
              orElse: () => false,
            ),
            child: Container(
              color: colors.primaryBackground.withValues(alpha: isLoadingSearch ? 0.7 : 0.5),
            ),
          ),
        );
      },
    );
  }
}

