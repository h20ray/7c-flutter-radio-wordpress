import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../config/radio_config.dart';
import '../../domain/entities/now_playing_entity.dart';
import '../../domain/usecases/watch_home_now_playing.dart';
import '../../../../core/error/failures.dart';
import '../../../categories/domain/repositories/category_repository.dart';
import '../../../categories/domain/entities/category_entity.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WatchHomeNowPlaying watchHomeNowPlaying;
  final CategoryRepository categoryRepository;

  late final NowPlayingEntity _fallbackNowPlaying;
  StreamSubscription<Either<Failure, NowPlayingEntity>>?
  _nowPlayingSubscription;

  HomeBloc({
    required this.watchHomeNowPlaying,
    required this.categoryRepository,
  }) : super(const HomeState.initial()) {
    _fallbackNowPlaying = const NowPlayingEntity(
      title: RadioConfig.fallbackTitle,
      artist: RadioConfig.fallbackArtist,
      albumArtUrl: null,
      isPlaying: false,
      hasFreshMetadata: false,
    );

    on<TabChangedEvent>(_onTabChanged, transformer: debounce(const Duration(milliseconds: 300)));
    on<FilterChipSelectedEvent>(_onFilterChipSelected, transformer: debounce(const Duration(milliseconds: 300)));
    on<LoadFeaturedContentEvent>(_onLoadFeaturedContent);
    on<NowPlayingUpdatedEvent>(_onNowPlayingUpdated);
    on<NowPlayingErrorEvent>(_onNowPlayingError);
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<CategorySelectedEvent>(_onCategorySelected);

    _subscribeNowPlaying();
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  void _onTabChanged(TabChangedEvent event, Emitter<HomeState> emit) {
    state.maybeWhen(
      loaded:
          (selectedTabIndex, selectedCategory, nowPlaying, nowPlayingError, availableCategories, filterChipCategories, selectedCategoryId) {
            if (selectedTabIndex == event.tabIndex) return;
            emit(
              HomeState.loaded(
                selectedTabIndex: event.tabIndex,
                selectedCategory: selectedCategory,
                nowPlaying: nowPlaying,
                nowPlayingError: nowPlayingError,
                availableCategories: availableCategories,
                filterChipCategories: filterChipCategories,
                selectedCategoryId: selectedCategoryId,
              ),
            );
          },
      orElse: () {
        emit(
          HomeState.loaded(
            selectedTabIndex: event.tabIndex,
            selectedCategory: null,
            nowPlaying: _fallbackNowPlaying,
            availableCategories: [],
            filterChipCategories: [],
          ),
        );
      },
    );
  }

  void _onFilterChipSelected(
    FilterChipSelectedEvent event,
    Emitter<HomeState> emit,
  ) {
    state.maybeWhen(
      loaded: (selectedTabIndex, selectedCategory, nowPlaying, nowPlayingError, availableCategories, filterChipCategories, selectedCategoryId) {
        emit(
          HomeState.loaded(
            selectedTabIndex: selectedTabIndex,
            selectedCategory: event.category,
            nowPlaying: nowPlaying,
            nowPlayingError: nowPlayingError,
            availableCategories: availableCategories,
            filterChipCategories: filterChipCategories,
            selectedCategoryId: selectedCategoryId,
          ),
        );
      },
      orElse: () {
        emit(
          HomeState.loaded(
            selectedTabIndex: 0,
            selectedCategory: event.category,
            nowPlaying: _fallbackNowPlaying,
            availableCategories: [],
            filterChipCategories: [],
          ),
        );
      },
    );
  }

  Future<void> _onLoadFeaturedContent(
    LoadFeaturedContentEvent event,
    Emitter<HomeState> emit,
  ) async {
    // Immediately transition to loaded state if not already loaded.
    // We remove the artificial delay to improve perceived performance.
    state.maybeWhen(
      loaded: (selectedTabIndex, selectedCategory, nowPlaying, nowPlayingError, availableCategories, filterChipCategories, selectedCategoryId) {
        // Already loaded, do nothing
      },
      orElse: () {
        emit(
          HomeState.loaded(
            selectedTabIndex: 0,
            selectedCategory: null,
            nowPlaying: _fallbackNowPlaying,
            availableCategories: [],
            filterChipCategories: [],
          ),
        );
      },
    );
  }

  void _onNowPlayingUpdated(
    NowPlayingUpdatedEvent event,
    Emitter<HomeState> emit,
  ) {
    state.maybeWhen(
      loaded: (selectedTabIndex, selectedCategory, nowPlaying, nowPlayingError, availableCategories, filterChipCategories, selectedCategoryId) {
        emit(
          HomeState.loaded(
            selectedTabIndex: selectedTabIndex,
            selectedCategory: selectedCategory,
            nowPlaying: event.nowPlaying,
            nowPlayingError: null,
            availableCategories: availableCategories,
            filterChipCategories: filterChipCategories,
            selectedCategoryId: selectedCategoryId,
          ),
        );
      },
      orElse: () {
        emit(
          HomeState.loaded(
            selectedTabIndex: 0,
            selectedCategory: null,
            nowPlaying: event.nowPlaying,
            availableCategories: [],
            filterChipCategories: [],
          ),
        );
      },
    );
  }

  void _onNowPlayingError(NowPlayingErrorEvent event, Emitter<HomeState> emit) {
    state.maybeWhen(
      loaded: (selectedTabIndex, selectedCategory, nowPlaying, nowPlayingError, availableCategories, filterChipCategories, selectedCategoryId) {
        emit(
          HomeState.loaded(
            selectedTabIndex: selectedTabIndex,
            selectedCategory: selectedCategory,
            nowPlaying: nowPlaying,
            nowPlayingError: event.message,
            availableCategories: availableCategories,
            filterChipCategories: filterChipCategories,
            selectedCategoryId: selectedCategoryId,
          ),
        );
      },
      orElse: () {},
    );
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<HomeState> emit,
  ) async {
    // Check if we already have data to prevent unnecessary re-fetching
    final bool hasData = state.maybeWhen(
      loaded: (selectedTabIndex, selectedCategory, nowPlaying, nowPlayingError, availableCategories, filterChipCategories, selectedCategoryId) {
        return availableCategories.isNotEmpty && filterChipCategories.isNotEmpty;
      },
      orElse: () => false,
    );

    if (hasData) {
      return;
    }

    final availableCategoriesResult = await categoryRepository.getAvailableCategories();
    final filterChipCategoriesResult = await categoryRepository.getFilterChipCategories();

    availableCategoriesResult.fold(
      (failure) {
        state.maybeWhen(
          loaded: (selectedTabIndex, selectedCategory, nowPlaying, nowPlayingError, availableCategories, filterChipCategories, selectedCategoryId) {
            // Keep existing data on failure if possible
            emit(
              HomeState.loaded(
                selectedTabIndex: selectedTabIndex,
                selectedCategory: selectedCategory,
                nowPlaying: nowPlaying,
                nowPlayingError: nowPlayingError,
                availableCategories: availableCategories,
                filterChipCategories: filterChipCategories,
                selectedCategoryId: selectedCategoryId,
              ),
            );
          },
          orElse: () {
            emit(
              HomeState.loaded(
                selectedTabIndex: 0,
                selectedCategory: null,
                nowPlaying: _fallbackNowPlaying,
                availableCategories: [],
                filterChipCategories: [],
              ),
            );
          },
        );
      },
      (newAvailableCategories) {
        filterChipCategoriesResult.fold(
          (failure) {
            state.maybeWhen(
              loaded: (selectedTabIndex, selectedCategory, nowPlaying, nowPlayingError, availableCategoriesParam, filterChipCategories, selectedCategoryId) {
                 emit(
                  HomeState.loaded(
                    selectedTabIndex: selectedTabIndex,
                    selectedCategory: selectedCategory,
                    nowPlaying: nowPlaying,
                    nowPlayingError: nowPlayingError,
                    availableCategories: newAvailableCategories,
                    filterChipCategories: filterChipCategories,
                    selectedCategoryId: selectedCategoryId,
                  ),
                );
              },
              orElse: () {
                emit(
                  HomeState.loaded(
                    selectedTabIndex: 0,
                    selectedCategory: null,
                    nowPlaying: _fallbackNowPlaying,
                    availableCategories: newAvailableCategories,
                    filterChipCategories: [],
                  ),
                );
              },
            );
          },
          (newFilterChipCategories) {
            state.maybeWhen(
              loaded: (selectedTabIndex, selectedCategory, nowPlaying, nowPlayingError, availableCategoriesParam, filterChipCategoriesParam, selectedCategoryId) {
                // Only emit if data actually changed to prevent rebuilds
                // Note: This is a simple reference check. For deep equality, we'd need more logic.
                // But since we get new lists from repo, they are likely different references.
                // However, since we want to avoid "always reload", we rely on the repo to return cached data fast.
                emit(
                  HomeState.loaded(
                    selectedTabIndex: selectedTabIndex,
                    selectedCategory: selectedCategory,
                    nowPlaying: nowPlaying,
                    nowPlayingError: nowPlayingError,
                    availableCategories: newAvailableCategories,
                    filterChipCategories: newFilterChipCategories,
                    selectedCategoryId: selectedCategoryId,
                  ),
                );
              },
              orElse: () {
                emit(
                  HomeState.loaded(
                    selectedTabIndex: 0,
                    selectedCategory: null,
                    nowPlaying: _fallbackNowPlaying,
                    availableCategories: newAvailableCategories,
                    filterChipCategories: newFilterChipCategories,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _onCategorySelected(
    CategorySelectedEvent event,
    Emitter<HomeState> emit,
  ) {
    state.maybeWhen(
      loaded: (selectedTabIndex, selectedCategory, nowPlaying, nowPlayingError, availableCategories, filterChipCategories, selectedCategoryId) {
        emit(
          HomeState.loaded(
            selectedTabIndex: selectedTabIndex,
            selectedCategory: selectedCategory,
            nowPlaying: nowPlaying,
            nowPlayingError: nowPlayingError,
            availableCategories: availableCategories,
            filterChipCategories: filterChipCategories,
            selectedCategoryId: event.categoryId,
          ),
        );
      },
      orElse: () {
        emit(
          HomeState.loaded(
            selectedTabIndex: 0,
            selectedCategory: null,
            nowPlaying: _fallbackNowPlaying,
            availableCategories: [],
            filterChipCategories: [],
            selectedCategoryId: event.categoryId,
          ),
        );
      },
    );
  }

  void _subscribeNowPlaying() {
    _nowPlayingSubscription = watchHomeNowPlaying().listen((result) {
      result.fold(
        (failure) => add(HomeEvent.nowPlayingError(failure.message)),
        (nowPlaying) => add(HomeEvent.nowPlayingUpdated(nowPlaying)),
      );
    });
  }

  @override
  Future<void> close() {
    _nowPlayingSubscription?.cancel();
    return super.close();
  }
}
