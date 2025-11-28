import 'package:hive/hive.dart';
import '../../../../config/news_config.dart';
import '../models/post_model.dart';

abstract class WordPressLocalDataSource {
  Future<List<PostModel>?> getCachedPosts({int? categoryId});
  Future<void> cachePosts(List<PostModel> posts, {int? categoryId});
  Future<DateTime?> getCacheTimestamp({int? categoryId});
}

class WordPressLocalDataSourceImpl implements WordPressLocalDataSource {
  static const _boxName = 'wordpress_posts_box';
  String _getPostsKey(int? categoryId) => categoryId == null ? 'posts' : 'posts_$categoryId';
  String _getTimestampKey(int? categoryId) => categoryId == null ? 'timestamp' : 'timestamp_$categoryId';

  Future<Box> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return Hive.openBox(_boxName);
  }

  @override
  Future<List<PostModel>?> getCachedPosts({int? categoryId}) async {
    try {
      final box = await _openBox();
      final postsKey = _getPostsKey(categoryId);
      final timestampKey = _getTimestampKey(categoryId);
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
  Future<void> cachePosts(List<PostModel> posts, {int? categoryId}) async {
    try {
      final box = await _openBox();
      final postsKey = _getPostsKey(categoryId);
      final timestampKey = _getTimestampKey(categoryId);
      final postsJson = posts.map((post) => post.toJson()).toList();
      await box.put(postsKey, postsJson);
      await box.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silently fail cache write - app can continue without cache
    }
  }

  @override
  Future<DateTime?> getCacheTimestamp({int? categoryId}) async {
    try {
      final box = await _openBox();
      final timestampKey = _getTimestampKey(categoryId);
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

