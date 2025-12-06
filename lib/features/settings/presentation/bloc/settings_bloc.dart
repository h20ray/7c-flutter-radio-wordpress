import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/offline_news_settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/get_offline_news_settings.dart';
import '../../domain/usecases/save_offline_news_settings.dart';
import '../../domain/usecases/get_offline_news_stats.dart';
import '../../domain/usecases/clear_all_offline_posts.dart';

part 'settings_event.dart';
part 'settings_state.dart';
part 'settings_bloc.freezed.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetOfflineNewsSettings getOfflineNewsSettings;
  final SaveOfflineNewsSettings saveOfflineNewsSettings;
  final GetOfflineNewsStats getOfflineNewsStats;
  final ClearAllOfflinePosts clearAllOfflinePosts;

  OfflineNewsSettingsEntity? _currentSettings;

  SettingsBloc({
    required this.getOfflineNewsSettings,
    required this.saveOfflineNewsSettings,
    required this.getOfflineNewsStats,
    required this.clearAllOfflinePosts,
  }) : super(const SettingsState.initial()) {
    on<LoadOfflineNewsSettingsEvent>(_onLoadOfflineNewsSettings);
    on<UpdateMaxPostsEvent>(_onUpdateMaxPosts);
    on<UpdateMaxSizeMBEvent>(_onUpdateMaxSizeMB);
    on<ToggleAutoSaveEvent>(_onToggleAutoSave);
    on<LoadOfflineNewsStatsEvent>(_onLoadOfflineNewsStats);
    on<ClearAllOfflinePostsEvent>(_onClearAllOfflinePosts);
    on<SaveSettingsEvent>(_onSaveSettings);
  }

  Future<void> _onLoadOfflineNewsSettings(
    LoadOfflineNewsSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsState.loading());

    final settingsResult = await getOfflineNewsSettings();
    final statsResult = await getOfflineNewsStats();

    settingsResult.fold(
      (failure) => emit(SettingsState.error(failure: failure)),
      (settings) {
        _currentSettings = settings;
        statsResult.fold(
          (failure) => emit(SettingsState.loaded(
            settings: settings,
            stats: null,
            error: failure,
          )),
          (stats) => emit(SettingsState.loaded(
            settings: settings,
            stats: stats,
          )),
        );
      },
    );
  }

  Future<void> _onUpdateMaxPosts(
    UpdateMaxPostsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! _Loaded) return;

    _currentSettings = OfflineNewsSettingsEntity(
      maxPosts: event.maxPosts,
      maxSizeMB: currentState.settings.maxSizeMB,
      autoSaveEnabled: currentState.settings.autoSaveEnabled,
    );

    emit(currentState.copyWith(settings: _currentSettings!));
  }

  Future<void> _onUpdateMaxSizeMB(
    UpdateMaxSizeMBEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! _Loaded) return;

    _currentSettings = OfflineNewsSettingsEntity(
      maxPosts: currentState.settings.maxPosts,
      maxSizeMB: event.maxSizeMB,
      autoSaveEnabled: currentState.settings.autoSaveEnabled,
    );

    emit(currentState.copyWith(settings: _currentSettings!));
  }

  Future<void> _onToggleAutoSave(
    ToggleAutoSaveEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! _Loaded) return;

    _currentSettings = OfflineNewsSettingsEntity(
      maxPosts: currentState.settings.maxPosts,
      maxSizeMB: currentState.settings.maxSizeMB,
      autoSaveEnabled: event.enabled,
    );

    emit(currentState.copyWith(settings: _currentSettings!));
  }

  Future<void> _onLoadOfflineNewsStats(
    LoadOfflineNewsStatsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    if (currentState is _Loaded) {
      final result = await getOfflineNewsStats();
      result.fold(
        (failure) => emit(currentState.copyWith(error: failure)),
        (stats) => emit(currentState.copyWith(stats: stats, error: null)),
      );
    }
  }

  Future<void> _onClearAllOfflinePosts(
    ClearAllOfflinePostsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    if (currentState is _Loaded) {
      emit(currentState.copyWith(isSaving: true));
      
      final result = await clearAllOfflinePosts();
      result.fold(
        (failure) => emit(currentState.copyWith(
          isSaving: false,
          error: failure,
        )),
        (_) async {
          final statsResult = await getOfflineNewsStats();
          statsResult.fold(
            (failure) => emit(currentState.copyWith(
              isSaving: false,
              stats: null,
              error: failure,
            )),
            (stats) => emit(currentState.copyWith(
              isSaving: false,
              stats: stats,
              error: null,
            )),
          );
        },
      );
    }
  }

  Future<void> _onSaveSettings(
    SaveSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! _Loaded || _currentSettings == null) return;

    emit(currentState.copyWith(isSaving: true));

    final result = await saveOfflineNewsSettings(_currentSettings!);
    result.fold(
      (failure) => emit(currentState.copyWith(
        isSaving: false,
        error: failure,
      )),
      (_) async {
        final statsResult = await getOfflineNewsStats();
        statsResult.fold(
          (failure) => emit(currentState.copyWith(
            isSaving: false,
            stats: null,
            error: failure,
          )),
          (stats) => emit(currentState.copyWith(
            isSaving: false,
            stats: stats,
            error: null,
          )),
        );
      },
    );
  }
}

