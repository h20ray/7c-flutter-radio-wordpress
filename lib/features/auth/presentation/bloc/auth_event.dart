part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginWithEmail({
    required String email,
    required String password,
  }) = _LoginWithEmail;

  const factory AuthEvent.loginWithGoogle({
    required String idToken,
    required String accessToken,
  }) = _LoginWithGoogle;

  const factory AuthEvent.logout() = _Logout;

  const factory AuthEvent.refreshToken({
    required String refreshToken,
  }) = _RefreshToken;

  const factory AuthEvent.getCurrentUser() = _GetCurrentUser;

  const factory AuthEvent.checkAuthStatus() = _CheckAuthStatus;

  const factory AuthEvent.tokenExpired() = _TokenExpired;
}

