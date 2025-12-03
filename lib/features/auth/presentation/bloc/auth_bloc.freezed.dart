// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LoginWithEmail value)?  loginWithEmail,TResult Function( _LoginWithGoogle value)?  loginWithGoogle,TResult Function( _Logout value)?  logout,TResult Function( _RefreshToken value)?  refreshToken,TResult Function( _GetCurrentUser value)?  getCurrentUser,TResult Function( _CheckAuthStatus value)?  checkAuthStatus,TResult Function( _TokenExpired value)?  tokenExpired,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginWithEmail() when loginWithEmail != null:
return loginWithEmail(_that);case _LoginWithGoogle() when loginWithGoogle != null:
return loginWithGoogle(_that);case _Logout() when logout != null:
return logout(_that);case _RefreshToken() when refreshToken != null:
return refreshToken(_that);case _GetCurrentUser() when getCurrentUser != null:
return getCurrentUser(_that);case _CheckAuthStatus() when checkAuthStatus != null:
return checkAuthStatus(_that);case _TokenExpired() when tokenExpired != null:
return tokenExpired(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LoginWithEmail value)  loginWithEmail,required TResult Function( _LoginWithGoogle value)  loginWithGoogle,required TResult Function( _Logout value)  logout,required TResult Function( _RefreshToken value)  refreshToken,required TResult Function( _GetCurrentUser value)  getCurrentUser,required TResult Function( _CheckAuthStatus value)  checkAuthStatus,required TResult Function( _TokenExpired value)  tokenExpired,}){
final _that = this;
switch (_that) {
case _LoginWithEmail():
return loginWithEmail(_that);case _LoginWithGoogle():
return loginWithGoogle(_that);case _Logout():
return logout(_that);case _RefreshToken():
return refreshToken(_that);case _GetCurrentUser():
return getCurrentUser(_that);case _CheckAuthStatus():
return checkAuthStatus(_that);case _TokenExpired():
return tokenExpired(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LoginWithEmail value)?  loginWithEmail,TResult? Function( _LoginWithGoogle value)?  loginWithGoogle,TResult? Function( _Logout value)?  logout,TResult? Function( _RefreshToken value)?  refreshToken,TResult? Function( _GetCurrentUser value)?  getCurrentUser,TResult? Function( _CheckAuthStatus value)?  checkAuthStatus,TResult? Function( _TokenExpired value)?  tokenExpired,}){
final _that = this;
switch (_that) {
case _LoginWithEmail() when loginWithEmail != null:
return loginWithEmail(_that);case _LoginWithGoogle() when loginWithGoogle != null:
return loginWithGoogle(_that);case _Logout() when logout != null:
return logout(_that);case _RefreshToken() when refreshToken != null:
return refreshToken(_that);case _GetCurrentUser() when getCurrentUser != null:
return getCurrentUser(_that);case _CheckAuthStatus() when checkAuthStatus != null:
return checkAuthStatus(_that);case _TokenExpired() when tokenExpired != null:
return tokenExpired(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String email,  String password)?  loginWithEmail,TResult Function( String idToken,  String accessToken)?  loginWithGoogle,TResult Function()?  logout,TResult Function( String refreshToken)?  refreshToken,TResult Function()?  getCurrentUser,TResult Function()?  checkAuthStatus,TResult Function()?  tokenExpired,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginWithEmail() when loginWithEmail != null:
return loginWithEmail(_that.email,_that.password);case _LoginWithGoogle() when loginWithGoogle != null:
return loginWithGoogle(_that.idToken,_that.accessToken);case _Logout() when logout != null:
return logout();case _RefreshToken() when refreshToken != null:
return refreshToken(_that.refreshToken);case _GetCurrentUser() when getCurrentUser != null:
return getCurrentUser();case _CheckAuthStatus() when checkAuthStatus != null:
return checkAuthStatus();case _TokenExpired() when tokenExpired != null:
return tokenExpired();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String email,  String password)  loginWithEmail,required TResult Function( String idToken,  String accessToken)  loginWithGoogle,required TResult Function()  logout,required TResult Function( String refreshToken)  refreshToken,required TResult Function()  getCurrentUser,required TResult Function()  checkAuthStatus,required TResult Function()  tokenExpired,}) {final _that = this;
switch (_that) {
case _LoginWithEmail():
return loginWithEmail(_that.email,_that.password);case _LoginWithGoogle():
return loginWithGoogle(_that.idToken,_that.accessToken);case _Logout():
return logout();case _RefreshToken():
return refreshToken(_that.refreshToken);case _GetCurrentUser():
return getCurrentUser();case _CheckAuthStatus():
return checkAuthStatus();case _TokenExpired():
return tokenExpired();case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String email,  String password)?  loginWithEmail,TResult? Function( String idToken,  String accessToken)?  loginWithGoogle,TResult? Function()?  logout,TResult? Function( String refreshToken)?  refreshToken,TResult? Function()?  getCurrentUser,TResult? Function()?  checkAuthStatus,TResult? Function()?  tokenExpired,}) {final _that = this;
switch (_that) {
case _LoginWithEmail() when loginWithEmail != null:
return loginWithEmail(_that.email,_that.password);case _LoginWithGoogle() when loginWithGoogle != null:
return loginWithGoogle(_that.idToken,_that.accessToken);case _Logout() when logout != null:
return logout();case _RefreshToken() when refreshToken != null:
return refreshToken(_that.refreshToken);case _GetCurrentUser() when getCurrentUser != null:
return getCurrentUser();case _CheckAuthStatus() when checkAuthStatus != null:
return checkAuthStatus();case _TokenExpired() when tokenExpired != null:
return tokenExpired();case _:
  return null;

}
}

}

/// @nodoc


class _LoginWithEmail implements AuthEvent {
  const _LoginWithEmail({required this.email, required this.password});
  

 final  String email;
 final  String password;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginWithEmailCopyWith<_LoginWithEmail> get copyWith => __$LoginWithEmailCopyWithImpl<_LoginWithEmail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginWithEmail&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'AuthEvent.loginWithEmail(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class _$LoginWithEmailCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$LoginWithEmailCopyWith(_LoginWithEmail value, $Res Function(_LoginWithEmail) _then) = __$LoginWithEmailCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class __$LoginWithEmailCopyWithImpl<$Res>
    implements _$LoginWithEmailCopyWith<$Res> {
  __$LoginWithEmailCopyWithImpl(this._self, this._then);

  final _LoginWithEmail _self;
  final $Res Function(_LoginWithEmail) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(_LoginWithEmail(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _LoginWithGoogle implements AuthEvent {
  const _LoginWithGoogle({required this.idToken, required this.accessToken});
  

 final  String idToken;
 final  String accessToken;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginWithGoogleCopyWith<_LoginWithGoogle> get copyWith => __$LoginWithGoogleCopyWithImpl<_LoginWithGoogle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginWithGoogle&&(identical(other.idToken, idToken) || other.idToken == idToken)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken));
}


@override
int get hashCode => Object.hash(runtimeType,idToken,accessToken);

@override
String toString() {
  return 'AuthEvent.loginWithGoogle(idToken: $idToken, accessToken: $accessToken)';
}


}

/// @nodoc
abstract mixin class _$LoginWithGoogleCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$LoginWithGoogleCopyWith(_LoginWithGoogle value, $Res Function(_LoginWithGoogle) _then) = __$LoginWithGoogleCopyWithImpl;
@useResult
$Res call({
 String idToken, String accessToken
});




}
/// @nodoc
class __$LoginWithGoogleCopyWithImpl<$Res>
    implements _$LoginWithGoogleCopyWith<$Res> {
  __$LoginWithGoogleCopyWithImpl(this._self, this._then);

  final _LoginWithGoogle _self;
  final $Res Function(_LoginWithGoogle) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? idToken = null,Object? accessToken = null,}) {
  return _then(_LoginWithGoogle(
idToken: null == idToken ? _self.idToken : idToken // ignore: cast_nullable_to_non_nullable
as String,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Logout implements AuthEvent {
  const _Logout();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Logout);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.logout()';
}


}




/// @nodoc


class _RefreshToken implements AuthEvent {
  const _RefreshToken({required this.refreshToken});
  

 final  String refreshToken;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RefreshTokenCopyWith<_RefreshToken> get copyWith => __$RefreshTokenCopyWithImpl<_RefreshToken>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RefreshToken&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}


@override
int get hashCode => Object.hash(runtimeType,refreshToken);

@override
String toString() {
  return 'AuthEvent.refreshToken(refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class _$RefreshTokenCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$RefreshTokenCopyWith(_RefreshToken value, $Res Function(_RefreshToken) _then) = __$RefreshTokenCopyWithImpl;
@useResult
$Res call({
 String refreshToken
});




}
/// @nodoc
class __$RefreshTokenCopyWithImpl<$Res>
    implements _$RefreshTokenCopyWith<$Res> {
  __$RefreshTokenCopyWithImpl(this._self, this._then);

  final _RefreshToken _self;
  final $Res Function(_RefreshToken) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? refreshToken = null,}) {
  return _then(_RefreshToken(
refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _GetCurrentUser implements AuthEvent {
  const _GetCurrentUser();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetCurrentUser);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.getCurrentUser()';
}


}




/// @nodoc


class _CheckAuthStatus implements AuthEvent {
  const _CheckAuthStatus();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckAuthStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.checkAuthStatus()';
}


}




/// @nodoc


class _TokenExpired implements AuthEvent {
  const _TokenExpired();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokenExpired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.tokenExpired()';
}


}




/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Authenticated value)?  authenticated,TResult Function( _Unauthenticated value)?  unauthenticated,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Authenticated() when authenticated != null:
return authenticated(_that);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _Error() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Authenticated value)  authenticated,required TResult Function( _Unauthenticated value)  unauthenticated,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Authenticated():
return authenticated(_that);case _Unauthenticated():
return unauthenticated(_that);case _Error():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Authenticated value)?  authenticated,TResult? Function( _Unauthenticated value)?  unauthenticated,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Authenticated() when authenticated != null:
return authenticated(_that);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _Error() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( UserEntity user)?  authenticated,TResult Function()?  unauthenticated,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Authenticated() when authenticated != null:
return authenticated(_that.user);case _Unauthenticated() when unauthenticated != null:
return unauthenticated();case _Error() when error != null:
return error(_that.failure);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( UserEntity user)  authenticated,required TResult Function()  unauthenticated,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Authenticated():
return authenticated(_that.user);case _Unauthenticated():
return unauthenticated();case _Error():
return error(_that.failure);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( UserEntity user)?  authenticated,TResult? Function()?  unauthenticated,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Authenticated() when authenticated != null:
return authenticated(_that.user);case _Unauthenticated() when unauthenticated != null:
return unauthenticated();case _Error() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements AuthState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.initial()';
}


}




/// @nodoc


class _Loading implements AuthState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.loading()';
}


}




/// @nodoc


class _Authenticated implements AuthState {
  const _Authenticated(this.user);
  

 final  UserEntity user;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticatedCopyWith<_Authenticated> get copyWith => __$AuthenticatedCopyWithImpl<_Authenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Authenticated&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'AuthState.authenticated(user: $user)';
}


}

/// @nodoc
abstract mixin class _$AuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthenticatedCopyWith(_Authenticated value, $Res Function(_Authenticated) _then) = __$AuthenticatedCopyWithImpl;
@useResult
$Res call({
 UserEntity user
});




}
/// @nodoc
class __$AuthenticatedCopyWithImpl<$Res>
    implements _$AuthenticatedCopyWith<$Res> {
  __$AuthenticatedCopyWithImpl(this._self, this._then);

  final _Authenticated _self;
  final $Res Function(_Authenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(_Authenticated(
null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserEntity,
  ));
}


}

/// @nodoc


class _Unauthenticated implements AuthState {
  const _Unauthenticated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unauthenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.unauthenticated()';
}


}




/// @nodoc


class _Error implements AuthState {
  const _Error(this.failure);
  

 final  Failure failure;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'AuthState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(_Error(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
