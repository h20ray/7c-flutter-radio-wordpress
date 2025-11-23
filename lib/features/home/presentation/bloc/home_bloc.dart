import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState.initial()) {
    on<TabChangedEvent>(_onTabChanged);
    on<FilterChipSelectedEvent>(_onFilterChipSelected);
    on<LoadFeaturedContentEvent>(_onLoadFeaturedContent);
  }

  void _onTabChanged(
    TabChangedEvent event,
    Emitter<HomeState> emit,
  ) {
    state.maybeWhen(
      loaded: (selectedTabIndex, selectedCategory) {
        emit(HomeState.loaded(
          selectedTabIndex: event.tabIndex,
          selectedCategory: selectedCategory,
        ));
      },
      orElse: () {
        emit(HomeState.loaded(
          selectedTabIndex: event.tabIndex,
          selectedCategory: null,
        ));
      },
    );
  }

  void _onFilterChipSelected(
    FilterChipSelectedEvent event,
    Emitter<HomeState> emit,
  ) {
    state.maybeWhen(
      loaded: (selectedTabIndex, _) {
        emit(HomeState.loaded(
          selectedTabIndex: selectedTabIndex,
          selectedCategory: event.category,
        ));
      },
      orElse: () {
        emit(HomeState.loaded(
          selectedTabIndex: 0,
          selectedCategory: event.category,
        ));
      },
    );
  }

  Future<void> _onLoadFeaturedContent(
    LoadFeaturedContentEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeState.loading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(const HomeState.loaded(
      selectedTabIndex: 0,
      selectedCategory: null,
    ));
  }
}

