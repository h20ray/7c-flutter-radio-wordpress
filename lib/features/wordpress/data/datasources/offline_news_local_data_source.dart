import 'package:hive/hive.dart';
import '../models/post_model.dart';

abstract class OfflineNewsLocalDataSource {
  Future<void> savePost(PostModel post);
  Future<void> removePost(int postId);
  Future<PostModel?> getPost(int postId);
  Future<List<PostModel>> getAllPosts();
  Future<bool> isPostOffline(int postId);
  Future<int> getOfflinePostCount();
  Future<int> getEstimatedSizeBytes();
  Future<List<int>> getOfflinePostIds();
  Future<void> clearAll();
  Future<void> evictOldestPosts(int count);
}

class OfflineNewsLocalDataSourceImpl implements OfflineNewsLocalDataSource {
  static const String _boxName = 'offline_news_box';
  static const String _metadataKey = 'offline_news_metadata';
  
  Future<Box> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return Hive.openBox(_boxName);
  }
  
  Map<String, dynamic> _getMetadata(Box box) {
    final raw = box.get(_metadataKey);
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    return {
      'postIds': <int>[],
      'postSizes': <int, int>{},
      'savedDates': <int, int>{},
    };
  }
  
  Future<void> _saveMetadata(Box box, Map<String, dynamic> metadata) async {
    await box.put(_metadataKey, metadata);
  }
  
  int _estimatePostSize(PostModel post) {
    int size = 0;
    size += post.id.toString().length;
    size += post.title.length * 2;
    size += post.content.length * 2;
    size += post.excerpt.length * 2;
    size += post.link.length * 2;
    size += (post.featuredImageUrl?.length ?? 0) * 2;
    size += (post.categoryName?.length ?? 0) * 2;
    size += (post.authorName?.length ?? 0) * 2;
    size += post.categoryIds.length * 4;
    size += 100;
    return size;
  }
  
  @override
  Future<void> savePost(PostModel post) async {
    try {
      final box = await _openBox();
      final metadata = _getMetadata(box);
      final postIds = List<int>.from(metadata['postIds'] as List? ?? []);
      final postSizes = Map<int, int>.from(metadata['postSizes'] as Map? ?? {});
      final savedDates = Map<int, int>.from(metadata['savedDates'] as Map? ?? {});
      
      final postSize = _estimatePostSize(post);
      final postKey = 'post_${post.id}';
      
      if (!postIds.contains(post.id)) {
        postIds.add(post.id);
      }
      
      postSizes[post.id] = postSize;
      savedDates[post.id] = DateTime.now().millisecondsSinceEpoch;
      
      await box.put(postKey, post.toJson());
      
      metadata['postIds'] = postIds;
      metadata['postSizes'] = postSizes;
      metadata['savedDates'] = savedDates;
      
      await _saveMetadata(box, metadata);
    } catch (e) {
      throw Exception('Failed to save post offline: $e');
    }
  }
  
  @override
  Future<void> removePost(int postId) async {
    try {
      final box = await _openBox();
      final metadata = _getMetadata(box);
      final postIds = List<int>.from(metadata['postIds'] as List? ?? []);
      final postSizes = Map<int, int>.from(metadata['postSizes'] as Map? ?? {});
      final savedDates = Map<int, int>.from(metadata['savedDates'] as Map? ?? {});
      
      postIds.remove(postId);
      postSizes.remove(postId);
      savedDates.remove(postId);
      
      final postKey = 'post_$postId';
      await box.delete(postKey);
      
      metadata['postIds'] = postIds;
      metadata['postSizes'] = postSizes;
      metadata['savedDates'] = savedDates;
      
      await _saveMetadata(box, metadata);
    } catch (e) {
      throw Exception('Failed to remove post from offline: $e');
    }
  }
  
  @override
  Future<PostModel?> getPost(int postId) async {
    try {
      final box = await _openBox();
      final postKey = 'post_$postId';
      final raw = box.get(postKey);
      
      if (raw is Map) {
        return PostModel.fromJson(Map<String, dynamic>.from(raw));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<List<PostModel>> getAllPosts() async {
    try {
      final box = await _openBox();
      final metadata = _getMetadata(box);
      final postIds = List<int>.from(metadata['postIds'] as List? ?? []);
      
      final posts = <PostModel>[];
      for (final postId in postIds) {
        final post = await getPost(postId);
        if (post != null) {
          posts.add(post);
        }
      }
      
      return posts;
    } catch (e) {
      return [];
    }
  }
  
  @override
  Future<bool> isPostOffline(int postId) async {
    try {
      final box = await _openBox();
      final metadata = _getMetadata(box);
      final postIds = List<int>.from(metadata['postIds'] as List? ?? []);
      return postIds.contains(postId);
    } catch (e) {
      return false;
    }
  }
  
  @override
  Future<int> getOfflinePostCount() async {
    try {
      final box = await _openBox();
      final metadata = _getMetadata(box);
      final postIds = List<int>.from(metadata['postIds'] as List? ?? []);
      return postIds.length;
    } catch (e) {
      return 0;
    }
  }
  
  @override
  Future<int> getEstimatedSizeBytes() async {
    try {
      final box = await _openBox();
      final metadata = _getMetadata(box);
      final postSizes = Map<int, int>.from(metadata['postSizes'] as Map? ?? {});
      
      int totalSize = 0;
      for (final size in postSizes.values) {
        totalSize += size;
      }
      
      return totalSize;
    } catch (e) {
      return 0;
    }
  }
  
  @override
  Future<List<int>> getOfflinePostIds() async {
    try {
      final box = await _openBox();
      final metadata = _getMetadata(box);
      final postIds = List<int>.from(metadata['postIds'] as List? ?? []);
      return postIds;
    } catch (e) {
      return [];
    }
  }
  
  @override
  Future<void> clearAll() async {
    try {
      final box = await _openBox();
      final metadata = _getMetadata(box);
      final postIds = List<int>.from(metadata['postIds'] as List? ?? []);
      
      for (final postId in postIds) {
        final postKey = 'post_$postId';
        await box.delete(postKey);
      }
      
      await box.delete(_metadataKey);
    } catch (e) {
      throw Exception('Failed to clear offline posts: $e');
    }
  }
  
  @override
  Future<void> evictOldestPosts(int count) async {
    try {
      final box = await _openBox();
      final metadata = _getMetadata(box);
      final postIds = List<int>.from(metadata['postIds'] as List? ?? []);
      final savedDates = Map<int, int>.from(metadata['savedDates'] as Map? ?? {});
      
      if (postIds.length <= count) {
        await clearAll();
        return;
      }
      
      final sortedPosts = postIds.toList()
        ..sort((a, b) {
          final dateA = savedDates[a] ?? 0;
          final dateB = savedDates[b] ?? 0;
          return dateA.compareTo(dateB);
        });
      
      final postsToRemove = sortedPosts.take(count).toList();
      
      for (final postId in postsToRemove) {
        await removePost(postId);
      }
    } catch (e) {
      throw Exception('Failed to evict oldest posts: $e');
    }
  }
}

