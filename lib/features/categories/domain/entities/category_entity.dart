import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String? thumbnailUrl;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.thumbnailUrl,
  });

  @override
  List<Object?> get props => [id, name, slug, thumbnailUrl];
}

