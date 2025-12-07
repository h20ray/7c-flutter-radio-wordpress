import '../../../../config/news_config.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/post_entity.dart';
import 'news_feed_bloc.dart';

/// Helper class to extract and manage NewsFeedBloc state values
/// Reduces code duplication and simplifies state management
class NewsFeedStateHelper {
  /// Extracts all state values from a NewsFeedState
  static NewsFeedStateValues extractStateValues(NewsFeedState state) {
    return state.maybeWhen(
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
        return NewsFeedStateValues(
          posts: posts,
          postsByCategory: Map.from(postsByCategory),
          selectedCategoryId: selectedCategoryId,
          hasMoreByCategory: Map.from(hasMoreByCategory),
          isLoadingByCategory: Map.from(isLoadingByCategory),
          errorsByCategory: Map.from(errorsByCategory),
          currentPageByCategory: Map.from(currentPageByCategory),
          offlinePostIds: Set.from(offlinePostIds),
        );
      },
      orElse: () => NewsFeedStateValues.empty(),
    );
  }

  /// Creates a new state with updated category posts
  static NewsFeedState updateCategoryPosts(
    NewsFeedStateValues current,
    int? categoryId,
    List<PostEntity> newPosts,
    bool useNewsPageLimit,
  ) {
    final newPostsByCategory = Map<int?, List<PostEntity>>.from(current.postsByCategory);
    newPostsByCategory[categoryId] = newPosts;

    final newHasMoreByCategory = Map<int?, bool>.from(current.hasMoreByCategory);
    final limit = useNewsPageLimit
        ? NewsConfig.newsPageListLimit
        : NewsConfig.homeNewsListLimit;
    newHasMoreByCategory[categoryId] = newPosts.length >= limit;

    final newCurrentPageByCategory = Map<int?, int>.from(current.currentPageByCategory);
    newCurrentPageByCategory[categoryId] = 1;


    return NewsFeedState.loaded(
      posts: categoryId == null ? newPosts : current.posts,
      postsByCategory: newPostsByCategory,
      selectedCategoryId: categoryId,
      hasMoreByCategory: newHasMoreByCategory,
      isLoadingByCategory: current.isLoadingByCategory,
      errorsByCategory: current.errorsByCategory,
      currentPageByCategory: newCurrentPageByCategory,
      offlinePostIds: current.offlinePostIds,
    );
  }

  /// Creates a new state with appended posts for pagination
  static NewsFeedState appendCategoryPosts(
    NewsFeedStateValues current,
    int? categoryId,
    List<PostEntity> newPosts,
    int nextPage,
  ) {
    final currentList = current.postsByCategory[categoryId] ?? [];
    final newList = [...currentList, ...newPosts];

    final newPostsByCategory = Map<int?, List<PostEntity>>.from(current.postsByCategory);
    newPostsByCategory[categoryId] = newList;

    final newHasMoreByCategory = Map<int?, bool>.from(current.hasMoreByCategory);
    newHasMoreByCategory[categoryId] = newPosts.length >= NewsConfig.newsPageListLimit;

    final newCurrentPageByCategory = Map<int?, int>.from(current.currentPageByCategory);
    newCurrentPageByCategory[categoryId] = nextPage;

    return NewsFeedState.loaded(
      posts: current.posts,
      postsByCategory: newPostsByCategory,
      selectedCategoryId: current.selectedCategoryId,
      hasMoreByCategory: newHasMoreByCategory,
      isLoadingByCategory: current.isLoadingByCategory,
      errorsByCategory: current.errorsByCategory,
      currentPageByCategory: newCurrentPageByCategory,
      offlinePostIds: current.offlinePostIds,
    );
  }

  /// Updates loading state for a category
  static NewsFeedState updateCategoryLoading(
    NewsFeedStateValues current,
    int? categoryId,
    bool isLoading,
  ) {
    final newIsLoadingByCategory = Map<int?, bool>.from(current.isLoadingByCategory);
    newIsLoadingByCategory[categoryId] = isLoading;

    return NewsFeedState.loaded(
      posts: current.posts,
      postsByCategory: current.postsByCategory,
      selectedCategoryId: current.selectedCategoryId,
      hasMoreByCategory: current.hasMoreByCategory,
      isLoadingByCategory: newIsLoadingByCategory,
      errorsByCategory: current.errorsByCategory,
      currentPageByCategory: current.currentPageByCategory,
      offlinePostIds: current.offlinePostIds,
    );
  }

  /// Updates error state for a category
  static NewsFeedState updateCategoryError(
    NewsFeedStateValues current,
    int? categoryId,
    Failure? error,
  ) {
    final newErrorsByCategory = Map<int?, Failure?>.from(current.errorsByCategory);
    newErrorsByCategory[categoryId] = error;

    return NewsFeedState.loaded(
      posts: current.posts,
      postsByCategory: current.postsByCategory,
      selectedCategoryId: current.selectedCategoryId,
      hasMoreByCategory: current.hasMoreByCategory,
      isLoadingByCategory: current.isLoadingByCategory,
      errorsByCategory: newErrorsByCategory,
      currentPageByCategory: current.currentPageByCategory,
      offlinePostIds: current.offlinePostIds,
    );
  }

  /// Updates both loading and error state for a category
  static NewsFeedState updateCategoryLoadingAndError(
    NewsFeedStateValues current,
    int? categoryId,
    bool isLoading,
    Failure? error,
  ) {
    final newIsLoadingByCategory = Map<int?, bool>.from(current.isLoadingByCategory);
    newIsLoadingByCategory[categoryId] = isLoading;

    final newErrorsByCategory = Map<int?, Failure?>.from(current.errorsByCategory);
    newErrorsByCategory[categoryId] = error;

    return NewsFeedState.loaded(
      posts: current.posts,
      postsByCategory: current.postsByCategory,
      selectedCategoryId: current.selectedCategoryId,
      hasMoreByCategory: current.hasMoreByCategory,
      isLoadingByCategory: newIsLoadingByCategory,
      errorsByCategory: newErrorsByCategory,
      currentPageByCategory: current.currentPageByCategory,
      offlinePostIds: current.offlinePostIds,
    );
  }
}

/// Immutable container for NewsFeedState values
class NewsFeedStateValues {
  final List<PostEntity> posts;
  final Map<int?, List<PostEntity>> postsByCategory;
  final int? selectedCategoryId;
  final Map<int?, bool> hasMoreByCategory;
  final Map<int?, bool> isLoadingByCategory;
  final Map<int?, Failure?> errorsByCategory;
  final Map<int?, int> currentPageByCategory;
  final Set<int> offlinePostIds;

  NewsFeedStateValues({
    required this.posts,
    required this.postsByCategory,
    required this.selectedCategoryId,
    required this.hasMoreByCategory,
    required this.isLoadingByCategory,
    required this.errorsByCategory,
    required this.currentPageByCategory,
    required this.offlinePostIds,
  });

  factory NewsFeedStateValues.empty() {
    return NewsFeedStateValues(
      posts: [],
      postsByCategory: {},
      selectedCategoryId: null,
      hasMoreByCategory: {},
      isLoadingByCategory: {},
      errorsByCategory: {},
      currentPageByCategory: {},
      offlinePostIds: {},
    );
  }
}

