import '../../domain/entities/shoutbox_message_entity.dart';

class ShoutboxMessageModel extends ShoutboxMessageEntity {
  const ShoutboxMessageModel({
    required super.id,
    required super.username,
    required super.message,
    required super.createdAt,
  });

  factory ShoutboxMessageModel.fromJson(Map<String, dynamic> json) {
    return ShoutboxMessageModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      message: json['message'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'message': message,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

