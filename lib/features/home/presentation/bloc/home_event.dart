part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.tabChanged(int tabIndex) = TabChangedEvent;
  const factory HomeEvent.filterChipSelected(String category) =
      FilterChipSelectedEvent;
  const factory HomeEvent.loadFeaturedContent() = LoadFeaturedContentEvent;
  const factory HomeEvent.nowPlayingUpdated(NowPlayingEntity nowPlaying) =
      NowPlayingUpdatedEvent;
  const factory HomeEvent.nowPlayingError(String message) =
      NowPlayingErrorEvent;
  const factory HomeEvent.loadCategories() = LoadCategoriesEvent;
  const factory HomeEvent.categorySelected(int? categoryId) =
      CategorySelectedEvent;
}
