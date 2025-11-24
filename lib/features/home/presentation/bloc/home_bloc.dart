import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../config/radio_config.dart';
import '../../domain/entities/now_playing_entity.dart';
import '../../domain/usecases/watch_home_now_playing.dart';
import '../../../../core/error/failures.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WatchHomeNowPlaying watchHomeNowPlaying;

  late final NowPlayingEntity _fallbackNowPlaying;
  StreamSubscription<Either<Failure, NowPlayingEntity>>?
  _nowPlayingSubscription;

  HomeBloc({required this.watchHomeNowPlaying})
    : super(const HomeState.initial()) {
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

    _subscribeNowPlaying();
  }

  void _onTabChanged(TabChangedEvent event, Emitter<HomeState> emit) {
    state.maybeWhen(
      loaded:
          (selectedTabIndex, selectedCategory, nowPlaying, nowPlayingError) {
            emit(
              HomeState.loaded(
                selectedTabIndex: event.tabIndex,
                selectedCategory: selectedCategory,
                nowPlaying: nowPlaying,
                nowPlayingError: nowPlayingError,
              ),
            );
          },
      orElse: () {
        emit(
          HomeState.loaded(
            selectedTabIndex: event.tabIndex,
            selectedCategory: null,
            nowPlaying: _fallbackNowPlaying,
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
      loaded: (selectedTabIndex, _, nowPlaying, nowPlayingError) {
        emit(
          HomeState.loaded(
            selectedTabIndex: selectedTabIndex,
            selectedCategory: event.category,
            nowPlaying: nowPlaying,
            nowPlayingError: nowPlayingError,
          ),
        );
      },
      orElse: () {
        emit(
          HomeState.loaded(
            selectedTabIndex: 0,
            selectedCategory: event.category,
            nowPlaying: _fallbackNowPlaying,
          ),
        );
      },
    );
  }

  Future<void> _onLoadFeaturedContent(
    LoadFeaturedContentEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeState.loading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(
      HomeState.loaded(
        selectedTabIndex: 0,
        selectedCategory: null,
        nowPlaying: _fallbackNowPlaying,
      ),
    );
  }

  void _onNowPlayingUpdated(
    NowPlayingUpdatedEvent event,
    Emitter<HomeState> emit,
  ) {
    state.maybeWhen(
      loaded: (selectedTabIndex, selectedCategory, _, nowPlayingError) {
        emit(
          HomeState.loaded(
            selectedTabIndex: selectedTabIndex,
            selectedCategory: selectedCategory,
            nowPlaying: event.nowPlaying,
            nowPlayingError: null,
          ),
        );
      },
      orElse: () {
        emit(
          HomeState.loaded(
            selectedTabIndex: 0,
            selectedCategory: null,
            nowPlaying: event.nowPlaying,
          ),
        );
      },
    );
  }

  void _onNowPlayingError(NowPlayingErrorEvent event, Emitter<HomeState> emit) {
    state.maybeWhen(
      loaded: (selectedTabIndex, selectedCategory, nowPlaying, _) {
        emit(
          HomeState.loaded(
            selectedTabIndex: selectedTabIndex,
            selectedCategory: selectedCategory,
            nowPlaying: nowPlaying,
            nowPlayingError: event.message,
          ),
        );
      },
      orElse: () {},
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
