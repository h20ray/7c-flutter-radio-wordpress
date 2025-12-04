part of 'news_search_bloc.dart';

@freezed
class NewsSearchEvent with _$NewsSearchEvent {
  const factory NewsSearchEvent.searchPosts({
    required String query,
  }) = SearchPostsEvent;
  
  const factory NewsSearchEvent.loadMoreSearchResults() = LoadMoreSearchResultsEvent;
  
  const factory NewsSearchEvent.clearSearch() = ClearSearchEvent;
}
