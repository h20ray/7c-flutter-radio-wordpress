import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? listenerId;
  final String? currentLevel;
  final Map<String, dynamic>? preferences;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.listenerId,
    this.currentLevel,
    this.preferences,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        avatarUrl,
        listenerId,
        currentLevel,
        preferences,
      ];
}

