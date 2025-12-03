import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatarUrl,
    super.listenerId,
    super.currentLevel,
    super.preferences,
  });

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      avatarUrl: entity.avatarUrl,
      listenerId: entity.listenerId,
      currentLevel: entity.currentLevel,
      preferences: entity.preferences,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String? avatarUrl;
    if (json['avatar_urls'] != null && json['avatar_urls'] is Map) {
      final avatars = json['avatar_urls'] as Map<String, dynamic>;
      avatarUrl = avatars['96'] as String? ??
          avatars['48'] as String? ??
          avatars['24'] as String?;
    } else if (json['avatar'] != null) {
      avatarUrl = json['avatar'] as String?;
    }

    Map<String, dynamic>? preferences;
    if (json['meta'] != null && json['meta'] is Map) {
      preferences = Map<String, dynamic>.from(json['meta'] as Map);
    }

    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? json['display_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatarUrl: avatarUrl,
      listenerId: json['listener_id'] as String? ??
          preferences?['listener_id'] as String?,
      currentLevel: json['current_level'] as String? ??
          preferences?['current_level'] as String?,
      preferences: preferences,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatarUrl,
      'listener_id': listenerId,
      'current_level': currentLevel,
      'meta': preferences,
    };
  }
}

