import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/app_color_system.dart';
import '../bloc/news_search_bloc.dart';

class NewsSearchOverlay extends StatelessWidget {
  const NewsSearchOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocBuilder<NewsSearchBloc, NewsSearchState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (results, query, page, hasMore, isLoadingMore, error) {
            if (query.isEmpty) return const SizedBox.shrink();
            
            // If we have results, we don't show overlay (we show results list).
            // But maybe overlay is for "loading" or "dimming"?
            // Original code:
            // ignoring: !isLoadingSearch && searchResults.isNotEmpty
            // color: alpha: isLoadingSearch ? 0.7 : 0.5
            
            // If loading (initial search), show overlay?
            // The original logic seems to be: Show overlay if search is active.
            // Ignore pointer if NOT loading AND has results (so user can click results).
            // Block pointer if loading OR no results (so user can't click feed behind?).
            
            final hasResults = results.isNotEmpty;
            // We don't have explicit "isLoadingSearch" in loaded state, but we have "isLoadingMore".
            // Initial loading is handled by _Loading state.
            
            return Positioned.fill(
              child: IgnorePointer(
                ignoring: hasResults,
                child: Container(
                  color: colors.primaryBackground.withValues(alpha: 0.5),
                ),
              ),
            );
          },
          loading: () => Positioned.fill(
            child: Container(
              color: colors.primaryBackground.withValues(alpha: 0.7),
            ),
          ),
          error: (failure) => const SizedBox.shrink(), // Error usually shown in list
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}

