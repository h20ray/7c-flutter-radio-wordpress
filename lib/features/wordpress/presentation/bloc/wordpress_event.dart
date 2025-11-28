part of 'wordpress_bloc.dart';

@freezed
abstract class WordPressEvent with _$WordPressEvent {
  const WordPressEvent._();
  const factory WordPressEvent.getPosts({
    @Default(false) bool forceRefresh,
    int? categoryId,
    @Default(false) bool useNewsPageLimit,
  }) = GetPostsEvent;
  const factory WordPressEvent.loadMorePosts({
    int? categoryId,
  }) = LoadMorePostsEvent;
  const factory WordPressEvent.searchPosts({
    required String query,
  }) = SearchPostsEvent;
  const factory WordPressEvent.loadMoreSearchResults() = LoadMoreSearchResultsEvent;
  const factory WordPressEvent.clearSearch() = ClearSearchEvent;
}

