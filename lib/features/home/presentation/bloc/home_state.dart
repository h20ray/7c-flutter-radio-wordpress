part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = _Loading;
  const factory HomeState.loaded({
    required int selectedTabIndex,
    required String? selectedCategory,
    required NowPlayingEntity nowPlaying,
    String? nowPlayingError,
    @Default([]) List<CategoryEntity> availableCategories,
    @Default([]) List<CategoryEntity> filterChipCategories,
    int? selectedCategoryId,
  }) = _Loaded;
  const factory HomeState.error(String message) = _Error;
}
