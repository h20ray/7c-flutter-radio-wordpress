part of 'news_search_bloc.dart';

@freezed
class NewsSearchState with _$NewsSearchState {
  const factory NewsSearchState.initial() = _Initial;
  
  const factory NewsSearchState.loading() = _Loading;
  
  const factory NewsSearchState.loaded({
    required List<PostEntity> results,
    required String query,
    @Default(1) int page,
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
    Failure? error,
  }) = _Loaded;
  
  const factory NewsSearchState.error({
    required Failure failure,
  }) = _Error;
}
