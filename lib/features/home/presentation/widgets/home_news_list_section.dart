import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../config/news_config.dart';
import '../../../../core/themes/app_color_system.dart';
import '../../../../core/themes/component_tokens.dart';
import '../../../../core/themes/design_tokens.dart';
import '../../../../core/widgets/home_news_card_skeleton.dart';
import '../../../wordpress/domain/entities/post_entity.dart';
import '../../../wordpress/presentation/bloc/wordpress_bloc.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../bloc/home_bloc.dart';

class HomeNewsListSection extends StatelessWidget {
  const HomeNewsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final chipTokens = NewsFilterChipTokens.of(context);
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, homeState) {
        final data = homeState.maybeWhen(
          loaded:
              (
                selectedTabIndex,
                selectedCategory,
                nowPlaying,
                nowPlayingError,
                availableCategories,
                filterChipCategories,
                selectedCategoryId,
              ) => _HomeNewsData(
                categories: filterChipCategories,
                selectedCategoryId: selectedCategoryId,
              ),
          orElse: () =>
              const _HomeNewsData(categories: [], selectedCategoryId: null),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: DesignTokens.spacingS),
            if (data.categories.isNotEmpty)
              SizedBox(
                height: 40,
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingL,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(data.categories.length, (index) {
                        final category = data.categories[index];
                        final isSelected =
                            category.id == data.selectedCategoryId;
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == data.categories.length - 1
                                ? 0
                                : DesignTokens.spacingS,
                          ),
                          child: FilterChip(
                            selected: isSelected,
                            showCheckmark: false,
                            label: Text(category.name),
                            onSelected: (_) {
                              final nextId = isSelected ? null : category.id;
                              
                              context.read<HomeBloc>().add(
                                HomeEvent.categorySelected(nextId),
                              );

                              context.read<WordPressBloc>().add(
                                WordPressEvent.getPosts(
                                  categoryId: nextId,
                                ),
                              );
                            },
                            selectedColor: chipTokens.selectedBackground,
                            checkmarkColor: chipTokens.checkmark,
                            labelStyle: TextStyle(
                              fontSize: DesignTokens.fontSizeBody,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? chipTokens.selectedLabel
                                  : chipTokens.unselectedLabel,
                            ),
                            side: BorderSide(
                              color: isSelected
                                  ? chipTokens.selectedBackground
                                  : chipTokens.outline,
                            ),
                            backgroundColor: chipTokens.unselectedBackground,
                            padding: EdgeInsets.symmetric(
                              horizontal: DesignTokens.spacingM,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            SizedBox(height: DesignTokens.spacingM),
            BlocBuilder<WordPressBloc, WordPressState>(
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
                    final categoryId = data.selectedCategoryId;
                    final categoryPosts = categoryId != null
                        ? postsByCategory[categoryId] ?? []
                        : posts;
                    final isLoading = isLoadingByCategory[categoryId] ?? false;
                    final error = errorsByCategory[categoryId];
                    
                    if (isLoading && categoryPosts.isEmpty) {
                      return const HomeNewsCardSkeleton(itemCount: 3);
                    }
                    
                    if (error != null && categoryPosts.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingL,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Failed to load news',
                              style: TextStyle(
                                color: context.appColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: DesignTokens.spacingS),
                            TextButton(
                              onPressed: () {
                                context.read<WordPressBloc>().add(
                                  WordPressEvent.getPosts(
                                    categoryId: categoryId,
                                    forceRefresh: true,
                                  ),
                                );
                              },
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    final limitedPosts = categoryPosts
                        .take(NewsConfig.homeNewsListLimit)
                        .toList();
                    
                    if (limitedPosts.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingL,
                        ),
                        child: Text(
                          'news_empty_no_items'.tr(),
                          style: TextStyle(
                            color: context.appColors.textSecondary,
                          ),
                        ),
                      );
                    }
                    
                    return Column(
                      children: limitedPosts
                          .map((post) => _buildNewsCard(context, post))
                          .toList(),
                    );
                  },
                  loading: (categoryId) {
                    if (categoryId == data.selectedCategoryId) {
                      return const HomeNewsCardSkeleton(itemCount: 3);
                    }
                    return const SizedBox.shrink();
                  },
                  error: (failure, categoryId) {
                    if (categoryId == data.selectedCategoryId) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingL,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Failed to load news',
                              style: TextStyle(
                                color: context.appColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: DesignTokens.spacingS),
                            TextButton(
                              onPressed: () {
                                context.read<WordPressBloc>().add(
                                  WordPressEvent.getPosts(
                                    categoryId: categoryId,
                                    forceRefresh: true,
                                  ),
                                );
                              },
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  orElse: () => const HomeNewsCardSkeleton(itemCount: 3),
                );
              },
            ),
          ],
        );
      },
    );
  }


  Widget _buildNewsCard(BuildContext context, PostEntity post) {
    final colors = context.appColors;
    final chipTokens = NewsFilterChipTokens.of(context);
    final hasImage =
        post.featuredImageUrl != null && post.featuredImageUrl!.isNotEmpty;

    return Container(
      margin: EdgeInsets.fromLTRB(
        DesignTokens.spacingL,
        DesignTokens.spacingS,
        DesignTokens.spacingL,
        0,
      ),
      padding: EdgeInsets.all(DesignTokens.spacingM),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadiusCard),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: colors.borderSubtle,
              borderRadius: BorderRadius.circular(16),
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: post.featuredImageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: colors.borderSubtle,
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.image_not_supported,
                        color: colors.textSecondary,
                      ),
                    ),
                  )
                : Icon(Icons.image, color: colors.textSecondary),
          ),
          SizedBox(width: DesignTokens.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  post.title,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeCaption,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: DesignTokens.spacingS),
                _buildInfoPills(context, post, chipTokens),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPills(
    BuildContext context,
    PostEntity post,
    NewsFilterChipTokens chipTokens,
  ) {
    final pills = <Widget>[];
    if (post.categoryName != null && post.categoryName!.isNotEmpty) {
      pills.add(
        _buildInfoPill(text: post.categoryName!, chipTokens: chipTokens),
      );
    }
    if (post.date != null) {
      pills.add(
        _buildInfoPill(
          text: _formatDate(context, post.date!),
          chipTokens: chipTokens,
        ),
      );
    }

    if (pills.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: DesignTokens.spacingXs,
      runSpacing: DesignTokens.spacingXs,
      children: pills,
    );
  }

  Widget _buildInfoPill({
    required String text,
    required NewsFilterChipTokens chipTokens,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: chipTokens.unselectedBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipTokens.outline),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: chipTokens.unselectedLabel,
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'news_just_now'.tr();
    }
    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return 'news_minutes_ago'.tr(namedArgs: {'minutes': '$minutes'});
    }
    if (difference.inHours < 24) {
      return 'news_hours_ago'.tr(namedArgs: {'hours': '${difference.inHours}'});
    }
    if (difference.inDays < 7) {
      return 'news_days_ago'.tr(namedArgs: {'days': '${difference.inDays}'});
    }
    return 'news_days_ago'.tr(namedArgs: {'days': '${difference.inDays}'});
  }
}

class _HomeNewsData {
  final List<CategoryEntity> categories;
  final int? selectedCategoryId;

  const _HomeNewsData({
    required this.categories,
    required this.selectedCategoryId,
  });

  String? get selectedCategoryName {
    if (selectedCategoryId == null) {
      return null;
    }
    final match = categories
        .where((item) => item.id == selectedCategoryId)
        .toList();
    if (match.isEmpty) {
      return null;
    }
    return match.first.name;
  }
}
