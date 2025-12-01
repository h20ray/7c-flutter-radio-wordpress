import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final int id;
  final String title;
  final String content;
  final String excerpt;
  final String link;
  final String? featuredImageUrl;
  final DateTime? date;
  final String? categoryName;
  final List<int> categoryIds;
  final String? authorName;

  const PostEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.link,
    this.featuredImageUrl,
    this.date,
    this.categoryName,
    this.categoryIds = const [],
    this.authorName,
  });

  @override
  List<Object?> get props =>
      [id, title, content, excerpt, link, featuredImageUrl, date, categoryName, categoryIds, authorName];
}

