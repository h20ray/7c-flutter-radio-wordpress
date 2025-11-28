import 'package:hive/hive.dart';
import '../../../../config/news_config.dart';
import '../models/post_model.dart';

abstract class WordPressLocalDataSource {
  Future<List<PostModel>?> getCachedPosts({
    int? categoryId,
    int page = 1,
    String? search,
  });
  Future<void> cachePosts(
    List<PostModel> posts, {
    int? categoryId,
    int page = 1,
    String? search,
  });
  Future<DateTime?> getCacheTimestamp({
    int? categoryId,
    int page = 1,
    String? search,
  });
}

class WordPressLocalDataSourceImpl implements WordPressLocalDataSource {
  static const _boxName = 'wordpress_posts_box';
  
  String _getPostsKey({int? categoryId, int page = 1, String? search}) {
    final categoryPart = categoryId == null ? 'all' : 'cat_$categoryId';
    final searchPart = search != null && search.isNotEmpty ? '_search_${search.hashCode}' : '';
    final pagePart = page > 1 ? '_page_$page' : '';
    return 'posts_$categoryPart$searchPart$pagePart';
  }
  
  String _getTimestampKey({int? categoryId, int page = 1, String? search}) {
    final categoryPart = categoryId == null ? 'all' : 'cat_$categoryId';
    final searchPart = search != null && search.isNotEmpty ? '_search_${search.hashCode}' : '';
    final pagePart = page > 1 ? '_page_$page' : '';
    return 'timestamp_$categoryPart$searchPart$pagePart';
  }

  Future<Box> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return Hive.openBox(_boxName);
  }

  @override
  Future<List<PostModel>?> getCachedPosts({
    int? categoryId,
    int page = 1,
    String? search,
  }) async {
    try {
      final box = await _openBox();
      final postsKey = _getPostsKey(categoryId: categoryId, page: page, search: search);
      final timestampKey = _getTimestampKey(categoryId: categoryId, page: page, search: search);
      final timestamp = box.get(timestampKey) as int?;
      
      if (timestamp == null) return null;
      
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(cacheTime);
      
      if (difference > NewsConfig.newsCacheTTL) {
        return null;
      }
      
      final raw = box.get(postsKey);
      if (raw is List) {
        return raw.map((item) {
          if (item is Map) {
            return PostModel.fromJson(Map<String, dynamic>.from(item));
          }
          return null;
        }).whereType<PostModel>().toList();
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cachePosts(
    List<PostModel> posts, {
    int? categoryId,
    int page = 1,
    String? search,
  }) async {
    try {
      final box = await _openBox();
      final postsKey = _getPostsKey(categoryId: categoryId, page: page, search: search);
      final timestampKey = _getTimestampKey(categoryId: categoryId, page: page, search: search);
      final postsJson = posts.map((post) => post.toJson()).toList();
      await box.put(postsKey, postsJson);
      await box.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silently fail cache write - app can continue without cache
    }
  }

  @override
  Future<DateTime?> getCacheTimestamp({
    int? categoryId,
    int page = 1,
    String? search,
  }) async {
    try {
      final box = await _openBox();
      final timestampKey = _getTimestampKey(categoryId: categoryId, page: page, search: search);
      final timestamp = box.get(timestampKey) as int?;
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

