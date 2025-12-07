import '../../../../config/offline_news_config.dart';
import '../datasources/offline_news_local_data_source.dart';
import '../models/post_model.dart';

class OfflineNewsService {
  final OfflineNewsLocalDataSource localDataSource;
  
  int _maxPosts = OfflineNewsConfig.defaultMaxPosts;
  int _maxSizeMB = OfflineNewsConfig.defaultMaxSizeMB;
  
  OfflineNewsService({required this.localDataSource});
  
  void updateLimits({int? maxPosts, int? maxSizeMB}) {
    if (maxPosts != null) {
      _maxPosts = maxPosts;
    }
    if (maxSizeMB != null) {
      _maxSizeMB = maxSizeMB;
    }
  }
  
  Future<void> savePost(PostModel post) async {
    final currentCount = await localDataSource.getOfflinePostCount();
    final currentSizeBytes = await localDataSource.getEstimatedSizeBytes();
    final currentSizeMB = currentSizeBytes ~/ (1024 * 1024);
    final postSizeBytes = _estimatePostSize(post);
    final postSizeMB = postSizeBytes ~/ (1024 * 1024);
    
    final isAlreadyOffline = await localDataSource.isPostOffline(post.id);
    
    if (isAlreadyOffline) {
      await localDataSource.removePost(post.id);
      return;
    }
    
    if (currentCount >= _maxPosts) {
      await _evictOldestPost();
    }
    
    if ((currentSizeMB + postSizeMB) > _maxSizeMB) {
      await _evictUntilSizeFits(postSizeMB);
    }
    
    await localDataSource.savePost(post);
  }
  
  Future<void> removePost(int postId) async {
    await localDataSource.removePost(postId);
  }
  
  Future<PostModel?> getPost(int postId) async {
    return await localDataSource.getPost(postId);
  }
  
  Future<List<PostModel>> getAllPosts() async {
    return await localDataSource.getAllPosts();
  }
  
  Future<bool> isPostOffline(int postId) async {
    return await localDataSource.isPostOffline(postId);
  }
  
  Future<int> getOfflinePostCount() async {
    return await localDataSource.getOfflinePostCount();
  }
  
  Future<int> getEstimatedSizeMB() async {
    final bytes = await localDataSource.getEstimatedSizeBytes();
    return bytes ~/ (1024 * 1024);
  }
  
  Future<void> clearAll() async {
    await localDataSource.clearAll();
  }
  
  Future<void> _evictOldestPost() async {
    await localDataSource.evictOldestPosts(1);
  }
  
  Future<void> _evictUntilSizeFits(int requiredMB) async {
    final currentSizeMB = await getEstimatedSizeMB();
    final targetSizeMB = _maxSizeMB - requiredMB;
    
    if (currentSizeMB <= targetSizeMB) {
      return;
    }
    
    final postIds = await localDataSource.getOfflinePostIds();
    if (postIds.isEmpty) return;
    
    final posts = await localDataSource.getAllPosts();
    final postsWithDates = <Map<String, dynamic>>[];
    
    for (final post in posts) {
      final postSizeBytes = _estimatePostSize(post);
      final postSizeMB = postSizeBytes ~/ (1024 * 1024);
      postsWithDates.add({
        'id': post.id,
        'sizeMB': postSizeMB,
        'date': (post.date?.millisecondsSinceEpoch) ?? 0,
      });
    }
    
    postsWithDates.sort((a, b) {
      final dateA = a['date'] as int;
      final dateB = b['date'] as int;
      return dateA.compareTo(dateB);
    });
    
    int currentSize = currentSizeMB;
    final postsToRemove = <int>[];
    
    for (final postData in postsWithDates) {
      if (currentSize <= targetSizeMB) {
        break;
      }
      final postSizeMB = postData['sizeMB'] as int;
      currentSize -= postSizeMB;
      postsToRemove.add(postData['id'] as int);
    }
    
    for (final postId in postsToRemove) {
      await localDataSource.removePost(postId);
    }
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
}

