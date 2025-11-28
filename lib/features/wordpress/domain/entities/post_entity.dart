import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final int id;
  final String title;
  final String content;
  final String excerpt;
  final String? featuredImageUrl;
  final DateTime? date;
  final String? categoryName;
  final List<int> categoryIds;

  const PostEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    this.featuredImageUrl,
    this.date,
    this.categoryName,
    this.categoryIds = const [],
  });

  @override
  List<Object?> get props => [id, title, content, excerpt, featuredImageUrl, date, categoryName, categoryIds];
}

