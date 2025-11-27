import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../config/radio_config.dart';
import '../../domain/entities/now_playing_entity.dart';
import '../../domain/usecases/watch_home_now_playing.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/debug_logger.dart';
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
    _fallbackNowPlaying = NowPlayingEntity(
      title: RadioConfig.fallbackTitle,
      artist: RadioConfig.fallbackArtist,
      albumArtUrl: null,
      isPlaying: false,
      hasFreshMetadata: false,
    );

    on<TabChangedEvent>(_onTabChanged);
    on<FilterChipSelectedEvent>(_onFilterChipSelected);
    on<LoadFeaturedContentEvent>(_onLoadFeaturedContent);
    on<NowPlayingUpdatedEvent>(_onNowPlayingUpdated);
    on<NowPlayingErrorEvent>(_onNowPlayingError);
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<CategorySelectedEvent>(_onCategorySelected);

    _subscribeNowPlaying();
  }

  void _onTabChanged(TabChangedEvent event, Emitter<HomeState> emit) {
    state.maybeWhen(
      loaded:
          (selectedTabIndex, selectedCategory, nowPlaying, nowPlayingError, availableCategories, filterChipCategories, selectedCategoryId) {
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
      loaded: (selectedTabIndex, _, nowPlaying, nowPlayingError, availableCategories, filterChipCategories, selectedCategoryId) {
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
            selectedCategoryId: selectedCategoryId,
          ),
        );
      },
      orElse: () {
        emit(const HomeState.loading());
      },
    );
    await Future.delayed(const Duration(milliseconds: 500));
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
  }

  void _onNowPlayingUpdated(
    NowPlayingUpdatedEvent event,
    Emitter<HomeState> emit,
  ) {
    state.maybeWhen(
      loaded: (selectedTabIndex, selectedCategory, _, nowPlayingError, availableCategories, filterChipCategories, selectedCategoryId) {
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
      loaded: (selectedTabIndex, selectedCategory, nowPlaying, _, availableCategories, filterChipCategories, selectedCategoryId) {
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
    final availableCategoriesResult = await categoryRepository.getAvailableCategories();
    final filterChipCategoriesResult = await categoryRepository.getFilterChipCategories();

    availableCategoriesResult.fold(
      (failure) {
        DebugLogger.log('Failed to load available categories: ${failure.message}', tag: 'HomeBloc');
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
      (availableCategories) {
        DebugLogger.log('Loaded ${availableCategories.length} available categories', tag: 'HomeBloc');
        filterChipCategoriesResult.fold(
          (failure) {
            DebugLogger.log('Failed to load filter chip categories: ${failure.message}', tag: 'HomeBloc');
            state.maybeWhen(
              loaded: (selectedTabIndex, selectedCategory, nowPlaying, nowPlayingError, availableCategoriesParam, filterChipCategories, selectedCategoryId) {
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
                    availableCategories: availableCategories,
                    filterChipCategories: [],
                  ),
                );
              },
            );
          },
          (filterChipCategories) {
            DebugLogger.log('Loaded ${filterChipCategories.length} filter chip categories', tag: 'HomeBloc');
            state.maybeWhen(
              loaded: (selectedTabIndex, selectedCategory, nowPlaying, nowPlayingError, availableCategoriesParam, filterChipCategoriesParam, selectedCategoryId) {
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
                    availableCategories: availableCategories,
                    filterChipCategories: filterChipCategories,
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
      loaded: (selectedTabIndex, selectedCategory, nowPlaying, nowPlayingError, availableCategories, filterChipCategories, _) {
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
