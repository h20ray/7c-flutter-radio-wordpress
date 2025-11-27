import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.slug,
    super.thumbnailUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    String? thumbnailUrl;
    if (json['thumbnail'] != null && json['thumbnail'] is String) {
      final thumbnail = json['thumbnail'] as String;
      if (thumbnail.isNotEmpty) {
        thumbnailUrl = thumbnail;
      }
    }

    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      thumbnailUrl: thumbnailUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'thumbnail': thumbnailUrl,
    };
  }
}

