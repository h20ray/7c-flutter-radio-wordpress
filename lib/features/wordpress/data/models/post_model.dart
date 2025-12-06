import '../../../../config/news_config.dart';
import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  final int? featuredMediaId;
  final int? authorId;

  /// Decodes HTML entities in text (e.g., &amp; -> &, &#39; -> ')
  /// Handles both named entities and numeric character references
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
    
    // Handle numeric character references (e.g., &#8217;)
    result = result.replaceAllMapped(RegExp(r'&#(\d+);'), (match) {
      final code = int.tryParse(match.group(1) ?? '');
      if (code != null) {
        return String.fromCharCode(code);
      }
      return match.group(0) ?? '';
    });
    
    return result;
  }

  /// Strips HTML tags from text and normalizes whitespace
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
    super.authorName,
    this.featuredMediaId,
    this.authorId,
  });

  /// Creates a PostModel from JSON
  /// Handles both minimal payload mode (enriched) and full payload mode (with _embedded)
  factory PostModel.fromJson(Map<String, dynamic> json) {
    // Extract featured image URL and media ID
    // Priority: featuredImageUrl (enriched) > _embedded > featured_media ID
    String? featuredImageUrl;
    int? featuredMediaId;

    if (json['featuredImageUrl'] != null) {
      featuredImageUrl = json['featuredImageUrl'] as String?;
    } else if (!NewsConfig.useMinimalNewsPayload &&
        json['_embedded'] != null &&
        json['_embedded']['wp:featuredmedia'] != null &&
        json['_embedded']['wp:featuredmedia'].isNotEmpty) {
      final media = json['_embedded']['wp:featuredmedia'][0];
      featuredImageUrl = media['source_url'] as String?;
      if (media['id'] is int) {
        featuredMediaId = media['id'] as int;
      }
    } else if (json['featured_media'] is int) {
      featuredMediaId = json['featured_media'] as int;
    }

    // Parse date - simplified logic (removed redundant null check)
    DateTime? date;
    if (json['date'] is String) {
      try {
        date = DateTime.parse(json['date'] as String);
      } catch (e) {
        date = null;
      }
    }

    // Extract and clean text fields (title, content, excerpt)
    // Handles both simple string format and WordPress rendered format
    final titleRaw = json['title'] is String 
        ? json['title'] as String 
        : json['title']?['rendered'] ?? '';
    final title = _stripHtmlTags(_decodeHtmlEntities(titleRaw));

    final contentRaw = json['content'] is String 
        ? json['content'] as String 
        : json['content']?['rendered'] ?? '';
    final content = _decodeHtmlEntities(contentRaw);

    final excerptRaw = json['excerpt'] is String 
        ? json['excerpt'] as String 
        : json['excerpt']?['rendered'] ?? '';
    final excerpt = _stripHtmlTags(_decodeHtmlEntities(excerptRaw));
    
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
    } else if (!NewsConfig.useMinimalNewsPayload &&
        json['_embedded'] != null &&
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

    int? authorId;
    if (json['authorId'] is int) {
      authorId = json['authorId'] as int;
    } else if (json['author'] is int) {
      authorId = json['author'] as int;
    }

    String? authorName;
    if (json['authorName'] is String) {
      authorName = json['authorName'] as String;
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
      featuredMediaId: featuredMediaId,
      authorId: authorId,
      authorName: authorName,
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
      'featured_media': featuredMediaId,
      'authorId': authorId,
      'authorName': authorName,
    };
  }
}

