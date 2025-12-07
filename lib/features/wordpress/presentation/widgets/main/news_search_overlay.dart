import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/themes/app_color_system.dart';
import '../../bloc/news_search_bloc.dart';

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
            
            final hasResults = results.isNotEmpty;
            
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
          error: (failure) => const SizedBox.shrink(),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}

