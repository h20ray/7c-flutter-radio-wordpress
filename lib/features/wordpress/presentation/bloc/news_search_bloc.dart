import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/cache/cache_strategy.dart';
import '../../../../config/news_config.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_posts.dart';

part 'news_search_event.dart';
part 'news_search_state.dart';
part 'news_search_bloc.freezed.dart';

class NewsSearchBloc extends Bloc<NewsSearchEvent, NewsSearchState> {
  final GetPosts getPosts;

  NewsSearchBloc({required this.getPosts}) : super(const NewsSearchState.initial()) {
    on<SearchPostsEvent>(_onSearchPosts);
    on<LoadMoreSearchResultsEvent>(_onLoadMoreSearchResults);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchPosts(
    SearchPostsEvent event,
    Emitter<NewsSearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      add(const ClearSearchEvent());
      return;
    }

    // Initial loading state
    emit(const NewsSearchState.loading());

    final strategy = _SearchCacheStrategy(
      getPosts: getPosts,
      query: query,
      page: 1,
    );

    await strategy.execute(
      onCacheHit: (data) async {
        emit(NewsSearchState.loaded(
          results: data,
          query: query,
          page: 1,
          hasMore: data.length >= NewsConfig.newsPageListLimit,
        ));
      },
      onNetworkSuccess: (data) async {
        emit(NewsSearchState.loaded(
          results: data,
          query: query,
          page: 1,
          hasMore: data.length >= NewsConfig.newsPageListLimit,
        ));
      },
      onNetworkError: (failure) async {
        // If we already have cached data (emitted in onCacheHit), we might want to show a snackbar or keep the data.
        // But if we are in 'loading' state (no cache), we show error.
        if (state is _Loaded) {
           // We have cache, maybe update error field?
           // For now, let's just keep the cached data and maybe log error?
           // Or emit state with error?
           final currentState = state as _Loaded;
           emit(currentState.copyWith(error: failure));
        } else {
           emit(NewsSearchState.error(failure: failure));
        }
      },
    );
  }

  Future<void> _onLoadMoreSearchResults(
    LoadMoreSearchResultsEvent event,
    Emitter<NewsSearchState> emit,
  ) async {
    final currentState = state;
    if (currentState is! _Loaded) return;
    if (currentState.isLoadingMore || !currentState.hasMore) return;

    final nextPage = currentState.page + 1;
    
    emit(currentState.copyWith(isLoadingMore: true, error: null));

    final strategy = _SearchCacheStrategy(
      getPosts: getPosts,
      query: currentState.query,
      page: nextPage,
    );

    await strategy.execute(
      onCacheHit: (data) async {
        final newResults = [...currentState.results, ...data];
        emit(currentState.copyWith(
          results: newResults,
          page: nextPage,
          hasMore: data.length >= NewsConfig.newsPageListLimit,
          isLoadingMore: false, // Keep loading for network? No, usually we show cache and wait.
          // But for pagination, "Cache First" means we append cached data.
          // Then network comes and we might replace/append?
          // If network returns same data, no change.
          // If network returns different data, we update.
        ));
      },
      onNetworkSuccess: (data) async {
        // If we already appended cache, we need to be careful not to duplicate or mess up order.
        // Simplest approach: If cache was hit, we already have data.
        // If cache was NOT hit, we append network data.
        // If cache WAS hit, network data replaces it?
        // For pagination, usually we just append.
        
        // Let's check if we already have these posts (from cache).
        // If we emitted cache, 'currentState.results' already includes them.
        // So we should probably re-calculate from 'currentState' which might have changed?
        // No, 'emit' runs sequentially in Bloc? No, async.
        
        // Actually, if onCacheHit ran, we emitted a new state.
        // So 'state' is updated.
        // But inside this callback, 'currentState' variable is stale.
        // We should use 'state' or just emit based on latest.
        
        // However, standard CacheStrategy usage for pagination is tricky.
        // Usually we just want "Network" for pagination to avoid "jumping" content.
        // But the requirement says "Cache-First".
        
        // If we use CacheStrategy for pagination:
        // 1. Cache Hit -> Append Cache.
        // 2. Network Success -> Replace the appended part with Network data?
        
        // For simplicity and robustness, let's just use the data we got.
        // If cache hit, we used it.
        // If network success, we use it (it might be fresher).
        
        // We need to know if we already appended cache.
        // If we did, we should replace the last chunk?
        // Or just ignore network if cache was good?
        // "Background Update" implies we use network if available.
        
        // Let's rebuild the list.
        // We know the previous results (before this page load).
        // But we don't have them easily accessible if we already emitted cache.
        
        // Alternative: Don't use CacheStrategy for pagination?
        // Or use it but handle the merge carefully.
        
        // Let's assume for now we just emit the new state with network data appended to the *original* list?
        // We need the original list.
        // Wait, if onCacheHit executed, 'state' has changed.
        // So 'currentState' (captured at start) is the list BEFORE loading more.
        // So we can safely use 'currentState.results + data'.
        
        final newResults = [...currentState.results, ...data];
        emit(currentState.copyWith(
          results: newResults,
          page: nextPage,
          hasMore: data.length >= NewsConfig.newsPageListLimit,
          isLoadingMore: false,
        ));
      },
      onNetworkError: (failure) async {
        // If cache was hit, we are fine, just stop loading.
        // If cache missed, we show error.
        // We can check if state has changed (cache hit).
        if (state is _Loaded && (state as _Loaded).page == nextPage) {
           // Cache was hit and page updated.
           emit((state as _Loaded).copyWith(isLoadingMore: false));
        } else {
           emit(currentState.copyWith(isLoadingMore: false, error: failure));
        }
      },
    );
  }

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<NewsSearchState> emit,
  ) async {
    emit(const NewsSearchState.initial());
  }
}

class _SearchCacheStrategy extends CacheStrategy<List<PostEntity>> {
  final GetPosts getPosts;
  final String query;
  final int page;

  _SearchCacheStrategy({
    required this.getPosts,
    required this.query,
    required this.page,
  });

  @override
  Future<List<PostEntity>?> loadFromCache() async {
    return getPosts.getCachedPosts(search: query, page: page);
  }

  @override
  Future<Either<Failure, List<PostEntity>>> fetchFromNetwork() async {
    return getPosts(search: query, page: page, forceRefresh: true);
  }

  @override
  Future<void> saveToCache(List<PostEntity> data) async {
    // Repository handles saving when forceRefresh is true (based on my refactor)
    // But wait, my refactor of Repository:
    // "3. Save to cache (only for first page or search results)"
    // Yes, it saves.
  }
}
