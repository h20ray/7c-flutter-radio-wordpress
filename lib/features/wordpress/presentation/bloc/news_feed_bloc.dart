import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartz/dartz.dart';
import '../../../../config/news_config.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/cache/cache_strategy.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_posts.dart';

part 'news_feed_event.dart';
part 'news_feed_state.dart';
part 'news_feed_bloc.freezed.dart';

class NewsFeedBloc extends Bloc<NewsFeedEvent, NewsFeedState> {
  final GetPosts getPosts;
  bool _hasLoadedCache = false;

  NewsFeedBloc({required this.getPosts}) : super(const NewsFeedState.initial()) {
    on<GetPostsEvent>(_onGetPosts);
    on<LoadMorePostsEvent>(_onLoadMorePosts);
    on<LoadCachedDataEvent>(_onLoadCachedData);
  }

  Future<void> _onLoadCachedData(
    LoadCachedDataEvent event,
    Emitter<NewsFeedState> emit,
  ) async {
    if (_hasLoadedCache) return;
    _hasLoadedCache = true;
    
    // Initial load for "All" category (null)
    add(const GetPostsEvent(categoryId: null));
  }

  Future<void> _onGetPosts(
    GetPostsEvent event,
    Emitter<NewsFeedState> emit,
  ) async {
    final categoryId = event.categoryId;
    
    // Determine current state values
    List<PostEntity> currentPosts = [];
    Map<int?, List<PostEntity>> postsByCategory = {};
    Map<int?, bool> hasMoreByCategory = {};
    Map<int?, bool> isLoadingByCategory = {};
    Map<int?, Failure?> errorsByCategory = {};
    Map<int?, int> currentPageByCategory = {};
    
    state.maybeWhen(
      loaded: (p, pbc, sc, hmbc, ilbc, ebc, cpbc) {
        currentPosts = p;
        postsByCategory = Map.from(pbc);
        hasMoreByCategory = Map.from(hmbc);
        isLoadingByCategory = Map.from(ilbc);
        errorsByCategory = Map.from(ebc);
        currentPageByCategory = Map.from(cpbc);
      },
      orElse: () {},
    );

    // Prevent duplicate loading
    if (isLoadingByCategory[categoryId] == true && !event.forceRefresh) {
      return;
    }

    // Update loading state
    isLoadingByCategory[categoryId] = true;
    errorsByCategory[categoryId] = null;
    
    // If we are switching categories or initial load, we might want to emit loading/loaded immediately
    if (state is! _Loaded) {
      // First time load
      emit(NewsFeedState.loading(categoryId: categoryId));
    } else {
      emit(NewsFeedState.loaded(
        posts: currentPosts,
        postsByCategory: postsByCategory,
        selectedCategoryId: categoryId,
        hasMoreByCategory: hasMoreByCategory,
        isLoadingByCategory: isLoadingByCategory,
        errorsByCategory: errorsByCategory,
        currentPageByCategory: currentPageByCategory,
      ));
    }

    final strategy = _FeedCacheStrategy(
      getPosts: getPosts,
      categoryId: categoryId,
      page: 1,
      useNewsPageLimit: event.useNewsPageLimit,
    );

    await strategy.execute(
      forceRefresh: event.forceRefresh,
      onCacheHit: (data) async {
        postsByCategory[categoryId] = data;
        hasMoreByCategory[categoryId] = data.length >= (event.useNewsPageLimit ? NewsConfig.newsPageListLimit : NewsConfig.homeNewsListLimit);
        currentPageByCategory[categoryId] = 1;
        // Note: We keep isLoading=true because we are still fetching network in background
        // But for UI responsiveness, we might want to show data immediately.
        // The CacheStrategy runs onNetworkSuccess after this.
        
        emit(NewsFeedState.loaded(
          posts: categoryId == null ? data : currentPosts, // Update main posts if category is null (Home)
          postsByCategory: postsByCategory,
          selectedCategoryId: categoryId,
          hasMoreByCategory: hasMoreByCategory,
          isLoadingByCategory: isLoadingByCategory,
          errorsByCategory: errorsByCategory,
          currentPageByCategory: currentPageByCategory,
        ));
      },
      onNetworkSuccess: (data) async {
        postsByCategory[categoryId] = data;
        hasMoreByCategory[categoryId] = data.length >= (event.useNewsPageLimit ? NewsConfig.newsPageListLimit : NewsConfig.homeNewsListLimit);
        currentPageByCategory[categoryId] = 1;
        isLoadingByCategory[categoryId] = false;
        
        emit(NewsFeedState.loaded(
          posts: categoryId == null ? data : currentPosts,
          postsByCategory: postsByCategory,
          selectedCategoryId: categoryId,
          hasMoreByCategory: hasMoreByCategory,
          isLoadingByCategory: isLoadingByCategory,
          errorsByCategory: errorsByCategory,
          currentPageByCategory: currentPageByCategory,
        ));
      },
      onNetworkError: (failure) async {
        isLoadingByCategory[categoryId] = false;
        errorsByCategory[categoryId] = failure;
        
        // If we have cached data (postsByCategory has entry), we keep it.
        // If not, we show error.
        
        if (state is! _Loaded && postsByCategory[categoryId] == null) {
           emit(NewsFeedState.error(failure: failure, categoryId: categoryId));
        } else {
           emit(NewsFeedState.loaded(
            posts: currentPosts,
            postsByCategory: postsByCategory,
            selectedCategoryId: categoryId,
            hasMoreByCategory: hasMoreByCategory,
            isLoadingByCategory: isLoadingByCategory,
            errorsByCategory: errorsByCategory,
            currentPageByCategory: currentPageByCategory,
          ));
        }
      },
    );
  }

  Future<void> _onLoadMorePosts(
    LoadMorePostsEvent event,
    Emitter<NewsFeedState> emit,
  ) async {
    final currentState = state;
    if (currentState is! _Loaded) return;
    
    final categoryId = event.categoryId ?? currentState.selectedCategoryId;
    
    final isLoading = currentState.isLoadingByCategory[categoryId] ?? false;
    final hasMore = currentState.hasMoreByCategory[categoryId] ?? false;
    
    if (isLoading || !hasMore) return;
    
    final currentPage = currentState.currentPageByCategory[categoryId] ?? 1;
    final nextPage = currentPage + 1;
    
    // Update loading state

    final newIsLoading = Map<int?, bool>.from(currentState.isLoadingByCategory);
    newIsLoading[categoryId] = true;
    
    emit(currentState.copyWith(isLoadingByCategory: newIsLoading));
    
    final strategy = _FeedCacheStrategy(
      getPosts: getPosts,
      categoryId: categoryId,
      page: nextPage,
      useNewsPageLimit: true, // Pagination always uses page limit
    );
    
    await strategy.execute(
      onCacheHit: (data) async {
        // Append cache
        final currentList = currentState.postsByCategory[categoryId] ?? [];
        final newList = [...currentList, ...data];
        
        final newPostsByCategory = Map<int?, List<PostEntity>>.from(currentState.postsByCategory);
        newPostsByCategory[categoryId] = newList;
        
        final newHasMore = Map<int?, bool>.from(currentState.hasMoreByCategory);
        newHasMore[categoryId] = data.length >= NewsConfig.newsPageListLimit;
        
        final newPages = Map<int?, int>.from(currentState.currentPageByCategory);
        newPages[categoryId] = nextPage;
        
        emit(currentState.copyWith(
          postsByCategory: newPostsByCategory,
          hasMoreByCategory: newHasMore,
          currentPageByCategory: newPages,
          // Keep loading true for network
        ));
      },
      onNetworkSuccess: (data) async {
        // Append network (or replace if cache was appended?)
        // As discussed, we append. If cache was already appended, this might duplicate?
        // No, because we don't track "cache appended".
        // If onCacheHit ran, 'currentState' in THIS callback is stale?
        // No, 'currentState' is captured at start of method.
        // But 'emit' uses 'currentState.copyWith'.
        // If we use 'state' inside callback, we get the latest.
        
        // Let's use the latest state to get the base list.
        // BUT, if onCacheHit ran, the base list now includes the cached page.
        // We don't want to append network page to cached page (duplicates).
        // We want to replace the cached page with network page.
        
        // This is getting complex.
        // Simplification: For pagination, maybe we don't use CacheStrategy fully?
        // Or we just accept that we might show cached data then update it.
        
        // If we want to replace:
        // We need to know where the new page starts.
        // It starts after (nextPage - 1) * limit? No, variable item heights/counts.
        
        // Let's assume for pagination we just use standard "Network Only" or "Cache OR Network".
        // The `CacheStrategy` I wrote does "Cache THEN Network".
        // If I use it for pagination, I get double emission.
        
        // If I just want "Cache OR Network" for pagination:
        // I can check if cache exists. If so, use it and STOP.
        // But we want "Background Update"? Maybe not for old pages.
        
        // Let's stick to: Use CacheStrategy.
        // In onNetworkSuccess, we need to reconstruct the list.
        // We can't easily identify which part was the "cached page".
        
        // Alternative:
        // In onCacheHit: Emit.
        // In onNetworkSuccess: Re-fetch the WHOLE list? No.
        
        // Let's just use the data from network and append it to the list *as it was before this page load*.
        // We captured `currentState` at the start.
        // `currentState.postsByCategory[categoryId]` is the list before this page.
        // So `[...currentState.postsByCategory[categoryId], ...data]` is correct!
        // Even if onCacheHit ran and updated the state, we ignore that intermediate state and build from the original `currentState`.
        
        final currentList = currentState.postsByCategory[categoryId] ?? [];
        final newList = [...currentList, ...data];
        
        final newPostsByCategory = Map<int?, List<PostEntity>>.from(currentState.postsByCategory);
        newPostsByCategory[categoryId] = newList;
        
        final newHasMore = Map<int?, bool>.from(currentState.hasMoreByCategory);
        newHasMore[categoryId] = data.length >= NewsConfig.newsPageListLimit;
        
        final newPages = Map<int?, int>.from(currentState.currentPageByCategory);
        newPages[categoryId] = nextPage;
        

        // We need to be careful not to overwrite other categories' loading state if they changed.
        // So we should take `state.isLoadingByCategory` and update it.
        
        final latestState = state as _Loaded;
        final latestLoading = Map<int?, bool>.from(latestState.isLoadingByCategory);
        latestLoading[categoryId] = false;
        
        emit(latestState.copyWith(
          postsByCategory: newPostsByCategory,
          hasMoreByCategory: newHasMore,
          currentPageByCategory: newPages,
          isLoadingByCategory: latestLoading,
        ));
      },
      onNetworkError: (failure) async {
        final latestState = state as _Loaded;
        final latestLoading = Map<int?, bool>.from(latestState.isLoadingByCategory);
        latestLoading[categoryId] = false;
        
        // If we successfully loaded from cache, we don't show error?
        // Or we show snackbar?
        // For now, just stop loading.
        emit(latestState.copyWith(isLoadingByCategory: latestLoading));
      },
    );
  }
}

class _FeedCacheStrategy extends CacheStrategy<List<PostEntity>> {
  final GetPosts getPosts;
  final int? categoryId;
  final int page;
  final bool useNewsPageLimit;

  _FeedCacheStrategy({
    required this.getPosts,
    required this.categoryId,
    required this.page,
    required this.useNewsPageLimit,
  });

  @override
  Future<List<PostEntity>?> loadFromCache() async {
    return getPosts.getCachedPosts(categoryId: categoryId, page: page);
  }

  @override
  Future<Either<Failure, List<PostEntity>>> fetchFromNetwork() async {
    return getPosts(
      categoryId: categoryId,
      page: page,
      forceRefresh: true,
      useNewsPageLimit: useNewsPageLimit,
    );
  }

  @override
  Future<void> saveToCache(List<PostEntity> data) async {
    // Repository handles saving
  }
}
