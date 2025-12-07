import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../../config/news_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../../../core/utils/performance_monitor.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/wordpress_repository.dart';
import '../datasources/wordpress_remote_datasource.dart';
import '../datasources/wordpress_local_data_source.dart';
import '../services/offline_news_service.dart';
import '../models/post_model.dart';

class WordPressRepositoryImpl implements WordPressRepository {
  final WordPressRemoteDataSource remoteDataSource;
  final WordPressLocalDataSource localDataSource;
  final OfflineNewsService offlineNewsService;

  WordPressRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.offlineNewsService,
  });

  @override
  Future<List<PostEntity>?> getCachedPosts({
    int? categoryId,
    int page = 1,
    String? search,
  }) async {
    final cachedPosts = await localDataSource.getCachedPosts(
      categoryId: categoryId,
      page: page,
      search: search,
    );
    if (cachedPosts != null && cachedPosts.isNotEmpty) {
      return cachedPosts;
    }
    return null;
  }

  @override
  Future<DateTime?> getCacheTimestamp({
    int? categoryId,
    int page = 1,
    String? search,
  }) async {
    return localDataSource.getCacheTimestamp(
      categoryId: categoryId,
      page: page,
      search: search,
    );
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts({
    bool forceRefresh = false,
    int? categoryId,
    int page = 1,
    String? search,
    bool useNewsPageLimit = false,
  }) async {
    try {
      // 1. If not forcing refresh, try to get from cache first
      if (!forceRefresh) {
        try {
          final stopwatch = Stopwatch()..start();
          final cachedPosts = await localDataSource.getCachedPosts(
            categoryId: categoryId,
            page: page,
            search: search,
          );
          stopwatch.stop();

          if (cachedPosts != null && cachedPosts.isNotEmpty) {
            PerformanceMonitor.trackCacheHit('getPosts');
            PerformanceMonitor.trackApiCall('getPosts_cache', stopwatch.elapsed);
            DebugLogger.log(
              'Cache hit for posts: categoryId=$categoryId, page=$page, search=$search',
              tag: 'WordPressRepository',
            );
            return Right(cachedPosts);
          } else {
            PerformanceMonitor.trackCacheMiss('getPosts');
          }
        } catch (e, stackTrace) {
          PerformanceMonitor.trackCacheMiss('getPosts');
          DebugLogger.logError(
            'Failed to load cached posts',
            error: e,
            stackTrace: stackTrace,
            tag: 'WordPressRepository',
          );
          // Continue to network fetch if cache fails
        }
      }

      // 2. Fetch from network with retry
      final perPage = search != null && search.isNotEmpty
          ? NewsConfig.newsPageListLimit
          : (useNewsPageLimit || page > 1
              ? NewsConfig.newsPageListLimit
              : NewsConfig.homeNewsListLimit);
      
      DebugLogger.log(
        'Fetching posts from network: categoryId=$categoryId, page=$page, perPage=$perPage, search=$search',
        tag: 'WordPressRepository',
      );
      
      final stopwatch = Stopwatch()..start();
      final posts = await _fetchWithRetry(
        () => remoteDataSource.getPosts(
          categoryId: categoryId,
          page: page,
          perPage: perPage,
          search: search,
        ),
        operation: 'getPosts',
      );
      stopwatch.stop();
      PerformanceMonitor.trackApiCall('getPosts_network', stopwatch.elapsed);

      final enrichedPosts = await _enrichPosts(posts);
      
      // 3. Save to offline storage (auto-save behavior)
      // This unifies "Cache" and "Offline Saved" - everything viewed is available offline
      try {
        // We save one by one or batch if service supports it. Service saves one by one mostly.
        // We can optimize this if needed, but for now we iterate.
        // Also cache to localDataSource for legacy reasons (or if we want to keep that dual layer)
        // But the primary "Offline News" feature relies on offlineNewsService.
        
        // Cache to localDataSource (fast, simple cache) - Keep existing logic for Page 1 but maybe expand?
        // The user specifically asked for "Offline News" feature integration.
        if (page == 1 || search != null) {
          await localDataSource.cachePosts(
            enrichedPosts,
            categoryId: categoryId,
            page: page,
            search: search,
          );
        }

        // Save to OfflineNewsService (User visible "Offline News")
        // We do this for ALL pages now.
        for (final post in enrichedPosts) {
          await savePostOffline(post);
        }
        
        DebugLogger.log(
          'Auto-saved posts to offline storage: count=${enrichedPosts.length}',
          tag: 'WordPressRepository',
        );
      } catch (e, stackTrace) {
        DebugLogger.logError(
          'Failed to auto-save posts offline',
          error: e,
          stackTrace: stackTrace,
          tag: 'WordPressRepository',
        );
        // Don't fail the request if caching fails
      }
      
      return Right(enrichedPosts.cast<PostEntity>());
    } on ServerException catch (e, stackTrace) {
      PerformanceMonitor.trackError('getPosts', 'ServerException');
      DebugLogger.logError(
        'Server error fetching posts',
        error: e,
        stackTrace: stackTrace,
        tag: 'WordPressRepository',
      );
      return Left(ServerFailure('Failed to load posts: ${e.message}'));
    } on NetworkException catch (e, stackTrace) {
      PerformanceMonitor.trackError('getPosts', 'NetworkException');
      DebugLogger.logError(
        'Network error fetching posts',
        error: e,
        stackTrace: stackTrace,
        tag: 'WordPressRepository',
      );
      return Left(NetworkFailure('Network error: ${e.message}. Please check your connection.'));
    } on TimeoutException catch (e, stackTrace) {
      PerformanceMonitor.trackError('getPosts', 'TimeoutException');
      DebugLogger.logError(
        'Timeout fetching posts',
        error: e,
        stackTrace: stackTrace,
        tag: 'WordPressRepository',
      );
      return Left(TimeoutFailure('Request timed out: ${e.message}. Please try again.'));
    } catch (e, stackTrace) {
      PerformanceMonitor.trackError('getPosts', 'UnexpectedException');
      DebugLogger.logError(
        'Unexpected error fetching posts',
        error: e,
        stackTrace: stackTrace,
        tag: 'WordPressRepository',
      );
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> getPostById(int id) async {
    try {
      final post = await remoteDataSource.getPostById(id);
      if (post == null) {
        return const Left(ServerFailure('Post not found'));
      }
      final enrichedPost = await _enrichPosts([post]);
      if (enrichedPost.isEmpty) {
        return const Left(ServerFailure('Post not found'));
      }
      return Right(enrichedPost.first);
    } on ServerException catch (e) {
      return Left(ServerFailure('Failed to load post: ${e.message}'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure('Network error: ${e.message}'));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure('Request timed out: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> getPostBySlug(String slug) async {
    try {
      final post = await remoteDataSource.getPostBySlug(slug);
      if (post == null) {
        return const Left(ServerFailure('Post not found'));
      }
      final enrichedPost = await _enrichPosts([post]);
      if (enrichedPost.isEmpty) {
        return const Left(ServerFailure('Post not found'));
      }
      return Right(enrichedPost.first);
    } on ServerException catch (e) {
      return Left(ServerFailure('Failed to load post: ${e.message}'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure('Network error: ${e.message}'));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure('Request timed out: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  /// Fetches data with exponential backoff retry mechanism
  Future<T> _fetchWithRetry<T>(
    Future<T> Function() fetch, {
    String operation = 'fetch',
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;
    
    while (attempt < maxRetries) {
      try {
        return await fetch();
      } on NetworkException catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          DebugLogger.logError(
            'Max retries reached for $operation',
            error: e,
            tag: 'WordPressRepository',
          );
          rethrow;
        }
        
        DebugLogger.log(
          'Retrying $operation (attempt $attempt/$maxRetries) after ${delay.inSeconds}s',
          tag: 'WordPressRepository',
        );
        
        await Future.delayed(delay);
        delay = Duration(seconds: delay.inSeconds * 2); // Exponential backoff
      } on ServerException {
        // Don't retry server errors (4xx, 5xx)
        rethrow;
      } on TimeoutException {
        // Don't retry timeouts immediately, but allow one retry
        if (attempt >= maxRetries - 1) {
          rethrow;
        }
        attempt++;
        await Future.delayed(delay);
        delay = Duration(seconds: delay.inSeconds * 2);
      }
    }
    
    throw Exception('Failed after $maxRetries attempts');
  }

  Future<List<PostModel>> _enrichPosts(List<PostModel> posts) async {
    if (!NewsConfig.useMinimalNewsPayload) {
      return posts;
    }

    try {
      // Collect unique IDs (deduplication)
      final mediaIds = <int>{};
      final categoryIds = <int>{};
      final authorIds = <int>{};

      for (final post in posts) {
        if (post.featuredMediaId != null && post.featuredMediaId! > 0) {
          mediaIds.add(post.featuredMediaId!);
        }
        for (final id in post.categoryIds) {
          if (id > 0) {
            categoryIds.add(id);
          }
        }
        if (post.authorId != null && post.authorId! > 0) {
          authorIds.add(post.authorId!);
        }
      }

      // Parallelize API calls using Future.wait for better performance
      DebugLogger.log(
        'Enriching posts: mediaIds=${mediaIds.length}, categoryIds=${categoryIds.length}, authorIds=${authorIds.length}',
        tag: 'WordPressRepository',
      );
      
      final results = await Future.wait([
        if (mediaIds.isNotEmpty)
          _fetchWithRetry(
            () => remoteDataSource.getMediaByIds(mediaIds.toList()),
            operation: 'getMediaByIds',
            maxRetries: 2, // Fewer retries for enrichment
          ).catchError((e) {
            DebugLogger.logError(
              'Failed to fetch media',
              error: e,
              tag: 'WordPressRepository',
            );
            return <int, String>{};
          })
        else
          Future.value(<int, String>{}),
        if (categoryIds.isNotEmpty)
          _fetchWithRetry(
            () => remoteDataSource.getCategoriesByIds(categoryIds.toList()),
            operation: 'getCategoriesByIds',
            maxRetries: 2,
          ).catchError((e) {
            DebugLogger.logError(
              'Failed to fetch categories',
              error: e,
              tag: 'WordPressRepository',
            );
            return <int, String>{};
          })
        else
          Future.value(<int, String>{}),
        if (authorIds.isNotEmpty)
          _fetchWithRetry(
            () => remoteDataSource.getUsersByIds(authorIds.toList()),
            operation: 'getUsersByIds',
            maxRetries: 2,
          ).catchError((e) {
            DebugLogger.logError(
              'Failed to fetch users',
              error: e,
              tag: 'WordPressRepository',
            );
            return <int, String>{};
          })
        else
          Future.value(<int, String>{}),
      ]);

      final resolvedMedia = results[0];
      final resolvedCategories = results[1];
      final resolvedUsers = results[2];
      
      DebugLogger.log(
        'Enrichment complete: resolvedMedia=${resolvedMedia.length}, resolvedCategories=${resolvedCategories.length}, resolvedUsers=${resolvedUsers.length}',
        tag: 'WordPressRepository',
      );

      return posts
          .map(
            (post) => PostModel(
              id: post.id,
              title: post.title,
              content: post.content,
              excerpt: post.excerpt,
              link: post.link,
              featuredImageUrl: post.featuredMediaId != null
                  ? resolvedMedia[post.featuredMediaId] ?? post.featuredImageUrl
                  : post.featuredImageUrl,
              date: post.date,
              categoryName: post.categoryIds.isNotEmpty
                  ? resolvedCategories[post.categoryIds.first] ??
                      post.categoryName
                  : post.categoryName,
              categoryIds: post.categoryIds,
              featuredMediaId: post.featuredMediaId,
              authorId: post.authorId,
              authorName: post.authorId != null
                  ? resolvedUsers[post.authorId] ?? post.authorName
                  : post.authorName,
            ),
          )
          .toList();
    } catch (e, stackTrace) {
      DebugLogger.logError(
        'Error enriching posts',
        error: e,
        stackTrace: stackTrace,
        tag: 'WordPressRepository',
      );
      // Return posts without enrichment if enrichment fails
      return posts;
    }
  }

  @override
  Future<Either<Failure, Unit>> savePostOffline(PostEntity post) async {
    try {
      final postModel = PostModel(
        id: post.id,
        title: post.title,
        content: post.content,
        excerpt: post.excerpt,
        link: post.link,
        featuredImageUrl: post.featuredImageUrl,
        date: post.date,
        categoryName: post.categoryName,
        categoryIds: post.categoryIds,
        authorName: post.authorName,
      );
      await offlineNewsService.savePost(postModel);
      DebugLogger.log(
        'Post saved offline: id=${post.id}, title=${post.title}',
        tag: 'WordPressRepository',
      );
      return const Right(unit);
    } catch (e, stackTrace) {
      DebugLogger.logError(
        'Failed to save post offline',
        error: e,
        stackTrace: stackTrace,
        tag: 'WordPressRepository',
      );
      return Left(CacheFailure('Failed to save post offline: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> removePostOffline(int postId) async {
    try {
      await offlineNewsService.removePost(postId);
      DebugLogger.log(
        'Post removed from offline: id=$postId',
        tag: 'WordPressRepository',
      );
      return const Right(unit);
    } catch (e, stackTrace) {
      DebugLogger.logError(
        'Failed to remove post from offline',
        error: e,
        stackTrace: stackTrace,
        tag: 'WordPressRepository',
      );
      return Left(
          CacheFailure('Failed to remove post from offline: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getOfflinePosts() async {
    try {
      final posts = await offlineNewsService.getAllPosts();
      DebugLogger.log(
        'Retrieved offline posts: count=${posts.length}',
        tag: 'WordPressRepository',
      );
      return Right(posts.cast<PostEntity>());
    } catch (e, stackTrace) {
      DebugLogger.logError(
        'Failed to get offline posts',
        error: e,
        stackTrace: stackTrace,
        tag: 'WordPressRepository',
      );
      return Left(
          CacheFailure('Failed to get offline posts: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isPostOffline(int postId) async {
    try {
      // Check if post is in offline storage (explicitly saved)
      final isExplicitlyOffline = await offlineNewsService.isPostOffline(postId);
      if (isExplicitlyOffline) {
        return const Right(true);
      }
      
      // Check if post is in cache (automatically available offline)
      // All cached posts are automatically available offline
      final isCached = await localDataSource.isPostCached(postId);
      return Right(isCached);
    } catch (e, stackTrace) {
      DebugLogger.logError(
        'Failed to check if post is offline',
        error: e,
        stackTrace: stackTrace,
        tag: 'WordPressRepository',
      );
      return Left(
          CacheFailure('Failed to check if post is offline: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<int>>> getOfflinePostIds() async {
    try {
      // 1. Get explicitly saved offline posts
      final offlineIds = await offlineNewsService.localDataSource.getOfflinePostIds(); // Accessing hidden property if not exposed?
      // Wait, offlineNewsService doesn't expose getOfflinePostIds directly in public API in step 17?
      // checking step 17... It does: `Future<int> getOfflinePostCount()`... 
      // It DOES NOT expose getOfflinePostIds. It has `_evictUntilSizeFits` which uses it internally.
      // I need to update OfflineNewsService first or access localDataSource.
      // localDataSource IS public in the class `final OfflineNewsLocalDataSource localDataSource;` so I can access it.
      
      // 2. Get cached posts (implicitly offline)
      // Since we are now saving everything to offline storage, (1) covers everything.
      // But if we kept the "Cache" separate, we'd need to merge.
      // Our implementation plan says we unify them. So `offlineNewsService` should have them all.
      
      return Right(offlineIds);
    } catch (e, stackTrace) {
      DebugLogger.logError(
        'Failed to get offline post IDs',
        error: e,
        stackTrace: stackTrace,
        tag: 'WordPressRepository',
      );
      return Left(CacheFailure('Failed to get offline post IDs: ${e.toString()}'));
    }
  }
}
