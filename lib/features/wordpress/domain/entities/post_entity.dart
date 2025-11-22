import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final int id;
  final String title;
  final String content;
  final String excerpt;

  const PostEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
  });

  @override
  List<Object> get props => [id, title, content, excerpt];
}

