import '../../domain/entities/auth_token_entity.dart';

class AuthTokenModel extends AuthTokenEntity {
  const AuthTokenModel({
    required super.accessToken,
    super.refreshToken,
    required super.expiresAt,
    super.tokenType,
  });

  factory AuthTokenModel.fromEntity(AuthTokenEntity entity) {
    return AuthTokenModel(
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
      expiresAt: entity.expiresAt,
      tokenType: entity.tokenType,
    );
  }

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    final expiresIn = json['expires_in'] as int? ?? 604800;
    final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));

    return AuthTokenModel(
      accessToken: json['token'] as String? ?? json['access_token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String?,
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'] as String) ?? expiresAt
          : expiresAt,
      tokenType: json['token_type'] as String? ?? 'Bearer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt.toIso8601String(),
      'token_type': tokenType,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
      'tokenType': tokenType,
    };
  }

  factory AuthTokenModel.fromMap(Map<String, dynamic> map) {
    return AuthTokenModel(
      accessToken: map['accessToken'] as String,
      refreshToken: map['refreshToken'] as String?,
      expiresAt: DateTime.parse(map['expiresAt'] as String),
      tokenType: map['tokenType'] as String? ?? 'Bearer',
    );
  }
}

