import 'package:equatable/equatable.dart';

class ShoutboxMessageEntity extends Equatable {
  final int id;
  final String username;
  final String message;
  final DateTime createdAt;

  const ShoutboxMessageEntity({
    required this.id,
    required this.username,
    required this.message,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, username, message, createdAt];
}

