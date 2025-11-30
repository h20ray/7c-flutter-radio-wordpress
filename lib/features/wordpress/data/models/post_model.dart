import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  static String _decodeHtmlEntities(String text) {
    String result = text
        .replaceAll('&#038;', '&')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&apos;', "'")
        .replaceAll('&nbsp;', ' ');
    
    result = result.replaceAllMapped(RegExp(r'&#(\d+);'), (match) {
      final code = int.tryParse(match.group(1) ?? '');
      if (code != null) {
        return String.fromCharCode(code);
      }
      return match.group(0) ?? '';
    });
    
    return result;
  }

  static String _stripHtmlTags(String text) {
    return text
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
  const PostModel({
    required super.id,
    required super.title,
    required super.content,
    required super.excerpt,
    required super.link,
    super.featuredImageUrl,
    super.date,
    super.categoryName,
    super.categoryIds,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    String? featuredImageUrl;
    
    if (json['featuredImageUrl'] != null) {
      featuredImageUrl = json['featuredImageUrl'] as String?;
    } else if (json['_embedded'] != null && 
        json['_embedded']['wp:featuredmedia'] != null &&
        json['_embedded']['wp:featuredmedia'].isNotEmpty) {
      final media = json['_embedded']['wp:featuredmedia'][0];
      featuredImageUrl = media['source_url'] as String?;
    }

    DateTime? date;
    if (json['date'] != null) {
      if (json['date'] is String) {
        try {
          date = DateTime.parse(json['date'] as String);
        } catch (e) {
          date = null;
        }
      }
    } else if (json['date'] == null && json['date'] is String) {
      try {
        date = DateTime.parse(json['date'] as String);
      } catch (e) {
        date = null;
      }
    }

    String title;
    if (json['title'] is String) {
      title = json['title'] as String;
    } else {
      title = json['title']?['rendered'] ?? '';
    }
    title = _decodeHtmlEntities(title);
    title = _stripHtmlTags(title);

    String content;
    if (json['content'] is String) {
      content = json['content'] as String;
    } else {
      content = json['content']?['rendered'] ?? '';
    }
    content = _decodeHtmlEntities(content);

    String excerpt;
    if (json['excerpt'] is String) {
      excerpt = json['excerpt'] as String;
    } else {
      excerpt = json['excerpt']?['rendered'] ?? '';
    }
    excerpt = _decodeHtmlEntities(excerpt);
    
    String link = json['link'] as String? ?? '';

    List<int> categoryIds = [];
    if (json['categories'] != null && json['categories'] is List) {
      final categories = json['categories'] as List<dynamic>;
      categoryIds = categories
          .map((e) => e is int ? e : (e is String ? int.tryParse(e) : null))
          .whereType<int>()
          .toList();
    }

    String? categoryName;
    if (json['categoryName'] != null) {
      categoryName = json['categoryName'] as String?;
    } else if (json['_embedded'] != null && 
        json['_embedded']['wp:term'] != null) {
      final terms = json['_embedded']['wp:term'] as List<dynamic>?;
      if (terms != null) {
        for (final termGroup in terms) {
          if (termGroup is List) {
            for (final term in termGroup) {
              if (term is Map && term['taxonomy'] == 'category') {
                categoryName = term['name'] as String?;
                if (categoryName != null && categoryName.isNotEmpty) {
                  break;
                }
              }
            }
            if (categoryName != null && categoryName.isNotEmpty) {
              break;
            }
          }
        }
      }
    }

    return PostModel(
      id: json['id'] ?? 0,
      title: title,
      content: content,
      excerpt: excerpt,
      link: link,
      featuredImageUrl: featuredImageUrl,
      date: date,
      categoryName: categoryName,
      categoryIds: categoryIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': {'rendered': title},
      'content': {'rendered': content},
      'excerpt': {'rendered': excerpt},
      'link': link,
      'featuredImageUrl': featuredImageUrl,
      'date': date?.toIso8601String(),
      'categoryName': categoryName,
      'categories': categoryIds,
    };
  }
}

