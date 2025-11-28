part of 'wordpress_bloc.dart';

@freezed
class WordPressState with _$WordPressState {
  const factory WordPressState.initial() = _Initial;
  const factory WordPressState.loading({
    int? categoryId,
  }) = _Loading;
  const factory WordPressState.loaded({
    required List<PostEntity> posts,
    required Map<int?, List<PostEntity>> postsByCategory,
    int? selectedCategoryId,
    @Default({}) Map<int?, bool> hasMoreByCategory,
    @Default({}) Map<int?, bool> isLoadingByCategory,
    @Default({}) Map<int?, Failure?> errorsByCategory,
  }) = _Loaded;
  const factory WordPressState.error({
    required Failure failure,
    int? categoryId,
  }) = _Error;
}

