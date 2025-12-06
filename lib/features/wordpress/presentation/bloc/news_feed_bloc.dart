import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartz/dartz.dart';
import '../../../../config/news_config.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/cache/cache_strategy.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_posts.dart';
import '../../domain/repositories/wordpress_repository.dart';
import 'news_feed_state_helper.dart';

part 'news_feed_event.dart';
part 'news_feed_state.dart';
part 'news_feed_bloc.freezed.dart';

class NewsFeedBloc extends Bloc<NewsFeedEvent, NewsFeedState> {
  final GetPosts getPosts;
  final WordPressRepository repository;
  bool _hasLoadedCache = false;

  NewsFeedBloc({
    required this.getPosts,
    required this.repository,
  }) : super(const NewsFeedState.initial()) {
    on<GetPostsEvent>(_onGetPosts);
    on<LoadMorePostsEvent>(_onLoadMorePosts);
    on<LoadCachedDataEvent>(_onLoadCachedData);
    on<SavePostOfflineEvent>(_onSavePostOffline);
    on<RemovePostOfflineEvent>(_onRemovePostOffline);
    on<CheckPostOfflineStatusEvent>(_onCheckPostOfflineStatus);
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
    final currentValues = NewsFeedStateHelper.extractStateValues(state);

    // Prevent duplicate loading (race condition fix)
    if (currentValues.isLoadingByCategory[categoryId] == true && !event.forceRefresh) {
      return;
    }

    // Update loading and error state
    if (state is! _Loaded) {
      emit(NewsFeedState.loading(categoryId: categoryId));
    } else {
      final updatedState = NewsFeedStateHelper.updateCategoryLoadingAndError(
        currentValues,
        categoryId,
        true, // isLoading
        null, // clear error
      );
      emit(updatedState);
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
        // Get latest state to ensure we're working with current data (race condition fix)
        final latestValues = NewsFeedStateHelper.extractStateValues(state);
        
        // Update posts but keep loading=true since network is still fetching
        final updatedState = NewsFeedStateHelper.updateCategoryPosts(
          latestValues,
          categoryId,
          data,
          event.useNewsPageLimit,
        );
        
        // Ensure loading state remains true for background network fetch
        final finalState = NewsFeedStateHelper.updateCategoryLoading(
          NewsFeedStateHelper.extractStateValues(updatedState),
          categoryId,
          true,
        );
        
        emit(finalState);
      },
      onNetworkSuccess: (data) async {
        // Get latest state to ensure we're working with current data (race condition fix)
        final latestValues = NewsFeedStateHelper.extractStateValues(state);
        
        // Update posts and clear loading state
        final updatedState = NewsFeedStateHelper.updateCategoryPosts(
          latestValues,
          categoryId,
          data,
          event.useNewsPageLimit,
        );
        
        final finalState = NewsFeedStateHelper.updateCategoryLoading(
          NewsFeedStateHelper.extractStateValues(updatedState),
          categoryId,
          false,
        );
        
        emit(finalState);
      },
      onNetworkError: (failure) async {
        // Get latest state to ensure we're working with current data (race condition fix)
        final latestValues = NewsFeedStateHelper.extractStateValues(state);
        
        // If we have cached data, keep it and show error. Otherwise, emit error state.
        if (state is! _Loaded && latestValues.postsByCategory[categoryId] == null) {
          emit(NewsFeedState.error(failure: failure, categoryId: categoryId));
        } else {
          final updatedState = NewsFeedStateHelper.updateCategoryLoadingAndError(
            latestValues,
            categoryId,
            false, // isLoading
            failure, // error
          );
          emit(updatedState);
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
    
    final currentValues = NewsFeedStateHelper.extractStateValues(currentState);
    final categoryId = event.categoryId ?? currentValues.selectedCategoryId;
    
    // Prevent duplicate pagination requests (race condition fix)
    final isLoading = currentValues.isLoadingByCategory[categoryId] ?? false;
    final hasMore = currentValues.hasMoreByCategory[categoryId] ?? false;
    
    if (isLoading || !hasMore) return;
    
    final currentPage = currentValues.currentPageByCategory[categoryId] ?? 1;
    final nextPage = currentPage + 1;
    
    // Update loading state
    final updatedState = NewsFeedStateHelper.updateCategoryLoading(
      currentValues,
      categoryId,
      true,
    );
    emit(updatedState);
    
    final strategy = _FeedCacheStrategy(
      getPosts: getPosts,
      categoryId: categoryId,
      page: nextPage,
      useNewsPageLimit: true, // Pagination always uses page limit
    );
    
    await strategy.execute(
      onCacheHit: (data) async {
        // Get latest state to avoid race conditions
        final latestValues = NewsFeedStateHelper.extractStateValues(state);
        
        // Append cached posts
        final updatedState = NewsFeedStateHelper.appendCategoryPosts(
          latestValues,
          categoryId,
          data,
          nextPage,
        );
        
        // Keep loading true for network fetch
        final finalState = NewsFeedStateHelper.updateCategoryLoading(
          NewsFeedStateHelper.extractStateValues(updatedState),
          categoryId,
          true,
        );
        
        emit(finalState);
      },
      onNetworkSuccess: (data) async {
        // Get latest state to avoid race conditions
        // If onCacheHit ran, the list already includes cached data
        // We need to append network data to the list as it was BEFORE this pagination request
        // to avoid duplicates. We use the original currentState captured at method start.
        final latestValues = NewsFeedStateHelper.extractStateValues(state);
        
        // For pagination, we append network data to the list as it was before this request
        // This avoids duplicates if cache was already appended in onCacheHit
        // We use the original list length from currentValues (captured at method start)
        final currentList = latestValues.postsByCategory[categoryId] ?? [];
        final originalListLength = currentValues.postsByCategory[categoryId]?.length ?? 0;
        
        // If cache was appended (list grew), we need to replace the cached page with network data
        // Otherwise, just append network data to the original list
        List<PostEntity> newList;
        if (currentList.length > originalListLength) {
          // Cache was appended, remove the cached page and replace with network data
          newList = [
            ...currentList.take(originalListLength),
            ...data,
          ];
        } else {
          // No cache was appended, append network data to current list
          newList = [...currentList, ...data];
        }
        
        // Update state with new list
        final newPostsByCategory = Map<int?, List<PostEntity>>.from(latestValues.postsByCategory);
        newPostsByCategory[categoryId] = newList;
        
        final newHasMoreByCategory = Map<int?, bool>.from(latestValues.hasMoreByCategory);
        newHasMoreByCategory[categoryId] = data.length >= NewsConfig.newsPageListLimit;
        
        final newCurrentPageByCategory = Map<int?, int>.from(latestValues.currentPageByCategory);
        newCurrentPageByCategory[categoryId] = nextPage;
        
        final newIsLoadingByCategory = Map<int?, bool>.from(latestValues.isLoadingByCategory);
        newIsLoadingByCategory[categoryId] = false;
        
        emit(NewsFeedState.loaded(
          posts: latestValues.posts,
          postsByCategory: newPostsByCategory,
          selectedCategoryId: latestValues.selectedCategoryId,
          hasMoreByCategory: newHasMoreByCategory,
          isLoadingByCategory: newIsLoadingByCategory,
          errorsByCategory: latestValues.errorsByCategory,
          currentPageByCategory: newCurrentPageByCategory,
        ));
      },
      onNetworkError: (failure) async {
        // Get latest state and clear loading state
        final latestValues = NewsFeedStateHelper.extractStateValues(state);
        final updatedState = NewsFeedStateHelper.updateCategoryLoading(
          latestValues,
          categoryId,
          false,
        );
        emit(updatedState);
        // Note: We don't show error for pagination failures if cache was loaded
        // The UI can show a snackbar if needed
      },
    );
  }

  Future<void> _onSavePostOffline(
    SavePostOfflineEvent event,
    Emitter<NewsFeedState> emit,
  ) async {
    final result = await repository.savePostOffline(event.post);
    result.fold(
      (failure) {
        // Error saving - could emit error state or show snackbar
      },
      (_) {
        // Success - post saved offline
      },
    );
  }

  Future<void> _onRemovePostOffline(
    RemovePostOfflineEvent event,
    Emitter<NewsFeedState> emit,
  ) async {
    final result = await repository.removePostOffline(event.postId);
    result.fold(
      (failure) {
        // Error removing - could emit error state or show snackbar
      },
      (_) {
        // Success - post removed from offline
      },
    );
  }

  Future<void> _onCheckPostOfflineStatus(
    CheckPostOfflineStatusEvent event,
    Emitter<NewsFeedState> emit,
  ) async {
    final result = await repository.isPostOffline(event.postId);
    result.fold(
      (failure) {
        // Error checking status
      },
      (isOffline) {
        // Post offline status checked - could update UI state if needed
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
