import 'package:hive/hive.dart';
import '../models/post_model.dart';

abstract class WordPressLocalDataSource {
  Future<List<PostModel>?> getCachedPosts();
  Future<void> cachePosts(List<PostModel> posts);
  Future<DateTime?> getCacheTimestamp();
}

class WordPressLocalDataSourceImpl implements WordPressLocalDataSource {
  static const _boxName = 'wordpress_posts_box';
  static const _postsKey = 'posts';
  static const _timestampKey = 'timestamp';
  static const _cacheDurationMinutes = 10;

  Future<Box> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return Hive.openBox(_boxName);
  }

  @override
  Future<List<PostModel>?> getCachedPosts() async {
    try {
      final box = await _openBox();
      final timestamp = box.get(_timestampKey) as int?;
      
      if (timestamp == null) return null;
      
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(cacheTime);
      
      if (difference.inMinutes > _cacheDurationMinutes) {
        return null;
      }
      
      final raw = box.get(_postsKey);
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
  Future<void> cachePosts(List<PostModel> posts) async {
    try {
      final box = await _openBox();
      final postsJson = posts.map((post) => post.toJson()).toList();
      await box.put(_postsKey, postsJson);
      await box.put(_timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silently fail cache write - app can continue without cache
    }
  }

  @override
  Future<DateTime?> getCacheTimestamp() async {
    try {
      final box = await _openBox();
      final timestamp = box.get(_timestampKey) as int?;
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

