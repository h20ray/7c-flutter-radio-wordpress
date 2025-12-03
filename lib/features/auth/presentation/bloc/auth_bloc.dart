import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/check_auth_status.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login_with_email.dart';
import '../../domain/usecases/login_with_google.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/refresh_token.dart';
import '../../../gamification/domain/usecases/merge_guest_stats_to_user.dart';
import '../../../gamification/domain/usecases/flush_listening_stats_to_guest.dart';
import '../../../gamification/domain/usecases/sync_listening_stats_with_server.dart';
import '../../../gamification/domain/entities/user_listening_stats_entity.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmail loginWithEmail;
  final LoginWithGoogle loginWithGoogle;
  final Logout logout;
  final RefreshToken refreshToken;
  final GetCurrentUser getCurrentUser;
  final CheckAuthStatus checkAuthStatus;
  final MergeGuestStatsToUser? mergeGuestStatsToUser;
  final FlushListeningStatsToGuest? flushListeningStatsToGuest;
  final SyncListeningStatsWithServer? syncListeningStatsWithServer;

  AuthBloc({
    required this.loginWithEmail,
    required this.loginWithGoogle,
    required this.logout,
    required this.refreshToken,
    required this.getCurrentUser,
    required this.checkAuthStatus,
    this.mergeGuestStatsToUser,
    this.flushListeningStatsToGuest,
    this.syncListeningStatsWithServer,
  }) : super(const AuthState.initial()) {
    on<_LoginWithEmail>(_onLoginWithEmail);
    on<_LoginWithGoogle>(_onLoginWithGoogle);
    on<_Logout>(_onLogout);
    on<_RefreshToken>(_onRefreshToken);
    on<_GetCurrentUser>(_onGetCurrentUser);
    on<_CheckAuthStatus>(_onCheckAuthStatus);
    on<_TokenExpired>(_onTokenExpired);
  }

  Future<void> _onLoginWithEmail(
    _LoginWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await loginWithEmail(
      email: event.email,
      password: event.password,
      rememberMe: true,
    );
    await result.fold(
      (failure) async => emit(AuthState.error(failure)),
      (user) async {
        await _handleStatsMigrationOnLogin(user);
        emit(AuthState.authenticated(user));
      },
    );
  }

  Future<void> _onLoginWithGoogle(
    _LoginWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await loginWithGoogle(
      idToken: event.idToken,
      accessToken: event.accessToken,
    );
    await result.fold(
      (failure) async => emit(AuthState.error(failure)),
      (user) async {
        await _handleStatsMigrationOnLogin(user);
        emit(AuthState.authenticated(user));
      },
    );
  }

  Future<void> _onLogout(
    _Logout event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await logout();
    await result.fold(
      (failure) async => emit(AuthState.error(failure)),
      (_) async {
        await _handleStatsMigrationOnLogout();
        emit(const AuthState.unauthenticated());
      },
    );
  }

  Future<void> _onRefreshToken(
    _RefreshToken event,
    Emitter<AuthState> emit,
  ) async {
    final result = await refreshToken(refreshToken: event.refreshToken);
    result.fold(
      (failure) {
        if (failure is TokenExpiredFailure) {
          emit(const AuthState.unauthenticated());
        } else {
          emit(AuthState.error(failure));
        }
      },
      (_) {
        add(const AuthEvent.getCurrentUser());
      },
    );
  }

  Future<void> _onGetCurrentUser(
    _GetCurrentUser event,
    Emitter<AuthState> emit,
  ) async {
    final result = await getCurrentUser();
    await result.fold(
      (failure) async {
        if (failure is TokenExpiredFailure) {
          await _handleStatsMigrationOnLogout();
          emit(const AuthState.unauthenticated());
        } else {
          emit(AuthState.error(failure));
        }
      },
      (user) async {
        await _handleStatsMigrationOnLogin(user);
        emit(AuthState.authenticated(user));
      },
    );
  }

  Future<void> _onCheckAuthStatus(
    _CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final result = await checkAuthStatus();
    result.fold(
      (failure) => emit(AuthState.error(failure)),
      (isAuthenticated) {
        if (isAuthenticated) {
          add(const AuthEvent.getCurrentUser());
        } else {
          emit(const AuthState.unauthenticated());
        }
      },
    );
  }

  Future<void> _onTokenExpired(
    _TokenExpired event,
    Emitter<AuthState> emit,
  ) async {
    await _handleStatsMigrationOnLogout();
    emit(const AuthState.unauthenticated());
  }

  Future<void> _handleStatsMigrationOnLogin(UserEntity user) async {
    if (mergeGuestStatsToUser == null) return;

    try {
      final userId = user.id.toString();

      // Step 1: Sync with server stats first (to get latest server data)
      final serverStats = _extractServerStats(user);
      if (serverStats != null && syncListeningStatsWithServer != null) {
        await syncListeningStatsWithServer!(
          userId: userId,
          serverStats: serverStats,
        );
      }

      // Step 2: Merge guest stats to user (adds guest time to user time)
      // This ensures guest listening time is preserved and added to user stats
      await mergeGuestStatsToUser!(userId);
    } catch (e) {
      // Ignore stats migration errors - non-critical
      // Stats migration failure should not block login
    }
  }

  Future<void> _handleStatsMigrationOnLogout() async {
    if (flushListeningStatsToGuest == null) return;

    try {
      await flushListeningStatsToGuest!();
    } catch (e) {
      // Ignore stats migration errors - non-critical
    }
  }

  UserListeningStatsEntity? _extractServerStats(UserEntity user) {
    if (user.preferences == null) return null;

    final totalSeconds = user.preferences!['total_listening_seconds'] as int?;
    final level = user.currentLevel ?? user.preferences!['current_level'] as String?;

    if (totalSeconds == null) return null;

    return UserListeningStatsEntity(
      userId: user.id.toString(),
      totalListeningSeconds: totalSeconds,
      currentLevel: level ?? 'level_1',
      lastUpdatedAt: DateTime.now(),
    );
  }
}

