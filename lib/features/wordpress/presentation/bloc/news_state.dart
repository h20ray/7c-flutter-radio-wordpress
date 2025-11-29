part of 'news_bloc.dart';

@freezed
class NewsState with _$NewsState {
  const factory NewsState.initial() = _Initial;
  const factory NewsState.loading({
    int? categoryId,
  }) = _Loading;
  const factory NewsState.loaded({
    required List<PostEntity> posts,
    required Map<int?, List<PostEntity>> postsByCategory,
    int? selectedCategoryId,
    @Default({}) Map<int?, bool> hasMoreByCategory,
    @Default({}) Map<int?, bool> isLoadingByCategory,
    @Default({}) Map<int?, Failure?> errorsByCategory,
    @Default({}) Map<int?, int> currentPageByCategory,
    List<PostEntity>? searchResults,
    String? searchQuery,
    @Default(1) int searchPage,
    @Default(false) bool hasMoreSearchResults,
    @Default(false) bool isLoadingSearch,
    Failure? searchError,
  }) = _Loaded;
  const factory NewsState.error({
    required Failure failure,
    int? categoryId,
  }) = _Error;
}
