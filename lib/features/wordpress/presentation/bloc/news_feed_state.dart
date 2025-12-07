part of 'news_feed_bloc.dart';

@freezed
class NewsFeedState with _$NewsFeedState {
  const factory NewsFeedState.initial() = _Initial;
  
  const factory NewsFeedState.loading({
    int? categoryId,
  }) = _Loading;
  
  const factory NewsFeedState.loaded({
    required List<PostEntity> posts,
    required Map<int?, List<PostEntity>> postsByCategory,
    int? selectedCategoryId,
    @Default({}) Map<int?, bool> hasMoreByCategory,
    @Default({}) Map<int?, bool> isLoadingByCategory,
    @Default({}) Map<int?, Failure?> errorsByCategory,
    @Default({}) Map<int?, int> currentPageByCategory,
    @Default({}) Set<int> offlinePostIds,
  }) = _Loaded;
  
  const factory NewsFeedState.error({
    required Failure failure,
    int? categoryId,
  }) = _Error;
}
