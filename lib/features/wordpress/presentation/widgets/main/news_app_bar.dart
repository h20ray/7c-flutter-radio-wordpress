import 'dart:async';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/themes/design_tokens.dart';
import '../../../../../core/widgets/glass_app_bar_background.dart';
import '../../../../../core/widgets/haptic_widgets.dart';
import '../../bloc/news_search_bloc.dart';
import 'news_search_box.dart';
import 'news_theme_switcher.dart';

class NewsAppBar extends StatefulWidget {
  final TextEditingController searchController;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  const NewsAppBar({
    super.key,
    required this.searchController,
    required this.onSearch,
    required this.onClear,
  });

  @override
  State<NewsAppBar> createState() => NewsAppBarState();

  static NewsAppBarState? of(BuildContext context) {
    return context.findAncestorStateOfType<NewsAppBarState>();
  }
}

class NewsAppBarState extends State<NewsAppBar> {
  bool _isSearchFocused = false;
  final GlobalKey<NewsSearchBoxState> _searchBoxKey =
      GlobalKey<NewsSearchBoxState>();

  bool get isSearchFocused => _isSearchFocused;

  String _getSearchButtonText() {
    final hint = 'news_search_hint'.tr();
    if (hint.contains('Search')) {
      return 'Search';
    } else if (hint.contains('Cari')) {
      return 'Cari';
    }
    return 'Search';
  }

  void unfocusSearch() {
    _searchBoxKey.currentState?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsSearchBloc, NewsSearchState>(
      builder: (context, state) {
        final isLoadingSearch = state.maybeWhen(
          loaded: (results, query, page, hasMore, isLoading, error) =>
              isLoading,
          loading: () => true,
          orElse: () => false,
        );

        return SliverAppBar(
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
          leading: IconButton(
            icon: const Icon(LucideIcons.arrow_left),
            onPressed: () { 
              unawaited(Navigator.pushReplacementNamed(context, AppRoutes.home));
            },
          ),
          title: NewsSearchBox(
            key: _searchBoxKey,
            controller: widget.searchController,
            onSearch: widget.onSearch,
            onClear: widget.onClear,
            isLoading: isLoadingSearch,
            onFocusChanged: (isFocused) {
              setState(() {
                _isSearchFocused = isFocused;
              });
            },
          ),
          actions: [
            AnimatedOpacity(
              opacity: _isSearchFocused ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: _isSearchFocused
                    ? Padding(
                        padding: const EdgeInsets.only(right: DesignTokens.spacingS),
                        child: HapticFilledButton(
                          onPressed: isLoadingSearch ? null : widget.onSearch,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.spacingM,
                              vertical: DesignTokens.spacingS,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            _getSearchButtonText(),
                            style: const TextStyle(
                              fontSize: DesignTokens.fontSizeBody,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            const NewsThemeSwitcher(),
            const SizedBox(width: DesignTokens.spacingS),
          ],
          flexibleSpace: GlassAppBarBackground(child: Container()),
        );
      },
    );
  }
}

