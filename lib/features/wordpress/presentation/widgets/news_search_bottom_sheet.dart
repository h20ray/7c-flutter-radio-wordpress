import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../domain/entities/post_entity.dart';
import '../bloc/news_bloc.dart';
import 'news_card.dart';

class NewsSearchBottomSheet extends StatefulWidget {
  final AppSemanticColors colors;

  const NewsSearchBottomSheet({
    super.key,
    required this.colors,
  });

  @override
  State<NewsSearchBottomSheet> createState() => _NewsSearchBottomSheetState();
}

class _NewsSearchBottomSheetState extends State<NewsSearchBottomSheet> {
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
        context.read<NewsBloc>().add(
              NewsEvent.searchPosts(query: query),
            );
      } else {
        context.read<NewsBloc>().add(
              const NewsEvent.clearSearch(),
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
                      hintText: 'news_search_hint'.tr(),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _searchController,
                        builder: (context, value, child) {
                          if (value.text.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              context.read<NewsBloc>().add(
                                    const NewsEvent.clearSearch(),
                                  );
                            },
                          );
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
                  child: Text('dialog_cancel'.tr()),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
                final colors = widget.colors;
                return state.maybeWhen(
                  loaded: (
                    List<PostEntity> posts,
                    Map<int?, List<PostEntity>> postsByCategory,
                    int? selectedCategoryId,
                    Map<int?, bool> hasMoreByCategory,
                    Map<int?, bool> isLoadingByCategory,
                    Map<int?, Failure?> errorsByCategory,
                    Map<int?, int> currentPageByCategory,
                    List<PostEntity>? searchResults,
                    String? searchQuery,
                    int searchPage,
                    bool hasMoreSearchResults,
                    bool isLoadingSearch,
                    Failure? searchError,
                  ) {
                    if (searchQuery == null || searchQuery.isEmpty) {
                      return Center(
                        child: Text(
                          'news_search_enter_term'.tr(),
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeBody,
                            color: colors.textSecondary,
                          ),
                        ),
                      );
                    }

                    if (isLoadingSearch &&
                        (searchResults == null || searchResults.isEmpty)) {
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
                              'news_search_failed'.tr(),
                              style: TextStyle(
                                fontSize: DesignTokens.fontSizeH2,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final results = searchResults ?? [];
                    if (results.isEmpty) {
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
                              'news_search_no_results'.tr(),
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
                      onNotification: (scrollInfo) {
                        final metrics = scrollInfo.metrics;
                        if (metrics.pixels == metrics.maxScrollExtent) {
                          if (hasMoreSearchResults && !isLoadingSearch) {
                            context.read<NewsBloc>().add(
                                  const NewsEvent.loadMoreSearchResults(),
                                );
                          }
                        }
                        return false;
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.all(DesignTokens.spacingL),
                        itemCount: results.length + (isLoadingSearch ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == results.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return NewsCard(
                            post: results[index],
                            compact: true,
                          );
                        },
                      ),
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showNewsSearchBottomSheet(
  BuildContext context, {
  required AppSemanticColors colors,
  required NewsBloc newsBloc,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (bottomSheetContext) => BlocProvider<NewsBloc>.value(
      value: newsBloc,
      child: NewsSearchBottomSheet(colors: colors),
    ),
  );
}


