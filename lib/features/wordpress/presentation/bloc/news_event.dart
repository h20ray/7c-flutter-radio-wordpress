part of 'news_bloc.dart';

@freezed
abstract class NewsEvent with _$NewsEvent {
  const NewsEvent._();
  const factory NewsEvent.getPosts({
    @Default(false) bool forceRefresh,
    int? categoryId,
    @Default(false) bool useNewsPageLimit,
  }) = GetNewsPostsEvent;
  const factory NewsEvent.loadMorePosts({
    int? categoryId,
  }) = LoadMoreNewsPostsEvent;
  const factory NewsEvent.searchPosts({
    required String query,
  }) = SearchNewsPostsEvent;
  const factory NewsEvent.loadMoreSearchResults() = LoadMoreNewsSearchResultsEvent;
  const factory NewsEvent.clearSearch() = ClearNewsSearchEvent;
}
