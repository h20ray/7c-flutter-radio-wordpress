import 'dart:convert';
import 'package:hive/hive.dart';
import '../../../../config/news_config.dart';
import '../../../../core/utils/cache_key_generator.dart';
import '../../../../core/utils/debug_logger.dart';
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
  Future<bool> isPostCached(int postId);
  Future<int> getCachedPostsCount();
  Future<int> getCachedPostsSizeBytes();
}

class WordPressLocalDataSourceImpl implements WordPressLocalDataSource {
  static const _boxName = 'wordpress_posts_box';
  static const int _maxCachedQueries = 50;
  
  String _getPostsKey({int? categoryId, int page = 1, String? search}) {
    return CacheKeyGenerator.generatePostsKey(
      categoryId: categoryId,
      page: page,
      search: search,
    );
  }
  
  String _getTimestampKey({int? categoryId, int page = 1, String? search}) {
    return CacheKeyGenerator.generateTimestampKey(
      categoryId: categoryId,
      page: page,
      search: search,
    );
  }
  
  Future<void> _cleanupOldCache(Box box) async {
    try {
      final allKeys = box.keys.toList();
      final timestampKeys = allKeys
          .where((key) => key.toString().startsWith('timestamp_'))
          .toList();
      
      if (timestampKeys.length <= _maxCachedQueries) {
        return;
      }
      
      final timestamps = <String, int>{};
      for (final key in timestampKeys) {
        final timestamp = box.get(key) as int?;
        if (timestamp != null) {
          timestamps[key.toString()] = timestamp;
        }
      }
      
      final sortedKeys = timestamps.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));
      
      final keysToRemove = sortedKeys
          .take(timestampKeys.length - _maxCachedQueries)
          .map((e) => e.key)
          .toList();
      
      for (final timestampKey in keysToRemove) {
        final postsKey = timestampKey.replaceFirst('timestamp_', 'posts_');
        await box.delete(timestampKey);
        await box.delete(postsKey);
      }
      
      DebugLogger.log(
        'Cache cleanup: removed ${keysToRemove.length} old entries',
        tag: 'WordPressLocalDataSource',
      );
    } catch (e, stackTrace) {
      DebugLogger.logError(
        'Failed to cleanup old cache',
        error: e,
        stackTrace: stackTrace,
        tag: 'WordPressLocalDataSource',
      );
    }
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
    } catch (e, stackTrace) {
      DebugLogger.logError(
        'Failed to get cached posts',
        error: e,
        stackTrace: stackTrace,
        tag: 'WordPressLocalDataSource',
      );
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
      await _cleanupOldCache(box);
      final postsKey = _getPostsKey(categoryId: categoryId, page: page, search: search);
      final timestampKey = _getTimestampKey(categoryId: categoryId, page: page, search: search);
      final postsJson = posts.map((post) => post.toJson()).toList();
      await box.put(postsKey, postsJson);
      await box.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
      
      DebugLogger.log(
        'Cached posts: key=$postsKey, count=${posts.length}',
        tag: 'WordPressLocalDataSource',
      );
    } catch (e, stackTrace) {
      DebugLogger.logError(
        'Failed to cache posts',
        error: e,
        stackTrace: stackTrace,
        tag: 'WordPressLocalDataSource',
      );
      // Don't throw - app can continue without cache
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

  @override
  Future<bool> isPostCached(int postId) async {
    try {
      final box = await _openBox();
      final allKeys = box.keys.toList();
      final postKeys = allKeys.where((key) => key.toString().startsWith('posts_')).toList();
      
      for (final key in postKeys) {
        final raw = box.get(key);
        if (raw is List) {
          for (final item in raw) {
            if (item is Map) {
              final postIdFromCache = item['id'] as int?;
              if (postIdFromCache == postId) {
                // Check if cache is still valid (not expired)
                final timestampKey = key.toString().replaceFirst('posts_', 'timestamp_');
                final timestamp = box.get(timestampKey) as int?;
                if (timestamp != null) {
                  final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
                  final now = DateTime.now();
                  final difference = now.difference(cacheTime);
                  if (difference <= NewsConfig.newsCacheTTL) {
                    return true; // Post is cached and available offline
                  }
                }
              }
            }
          }
        }
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<int> getCachedPostsCount() async {
    try {
      final box = await _openBox();
      final allKeys = box.keys.toList();
      final postKeys = allKeys.where((key) => key.toString().startsWith('posts_')).toList();
      
      final Set<int> uniquePostIds = {};
      final now = DateTime.now();
      
      for (final key in postKeys) {
        // Check if cache is still valid (not expired)
        final timestampKey = key.toString().replaceFirst('posts_', 'timestamp_');
        final timestamp = box.get(timestampKey) as int?;
        if (timestamp != null) {
          final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
          final difference = now.difference(cacheTime);
          if (difference > NewsConfig.newsCacheTTL) {
            continue; // Skip expired cache
          }
        }
        
        final raw = box.get(key);
        if (raw is List) {
          for (final item in raw) {
            if (item is Map) {
              final postId = item['id'] as int?;
              if (postId != null) {
                uniquePostIds.add(postId);
              }
            }
          }
        }
      }
      
      return uniquePostIds.length;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<int> getCachedPostsSizeBytes() async {
    try {
      final box = await _openBox();
      final allKeys = box.keys.toList();
      final postKeys = allKeys.where((key) => key.toString().startsWith('posts_')).toList();
      
      int totalSize = 0;
      final now = DateTime.now();
      
      for (final key in postKeys) {
        // Check if cache is still valid (not expired)
        final timestampKey = key.toString().replaceFirst('posts_', 'timestamp_');
        final timestamp = box.get(timestampKey) as int?;
        if (timestamp != null) {
          final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
          final difference = now.difference(cacheTime);
          if (difference > NewsConfig.newsCacheTTL) {
            continue; // Skip expired cache
          }
        }
        
        final raw = box.get(key);
        if (raw is List) {
          for (final item in raw) {
            if (item is Map) {
              // Estimate size: convert to JSON string and count bytes
              final jsonString = item.toString();
              totalSize += utf8.encode(jsonString).length;
            }
          }
        }
      }
      
      return totalSize;
    } catch (e) {
      return 0;
    }
  }
}

