import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../config/news_config.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_posts.dart';

part 'wordpress_bloc.freezed.dart';
part 'wordpress_event.dart';
part 'wordpress_state.dart';

class WordPressBloc extends Bloc<WordPressEvent, WordPressState> {
  final GetPosts getPosts;
  bool _hasLoadedCache = false;

  WordPressBloc({required this.getPosts})
    : super(const WordPressState.initial()) {
    on<GetPostsEvent>(_onGetPosts);
    on<LoadMorePostsEvent>(_onLoadMorePosts);
    on<SearchPostsEvent>(_onSearchPosts);
    on<LoadMoreSearchResultsEvent>(_onLoadMoreSearchResults);
    on<ClearSearchEvent>(_onClearSearch);
    on<LoadCachedDataEvent>(_onLoadCachedData);
  }

  Future<void> _loadCachedDataIfNeeded(Emitter<WordPressState> emit) async {
    if (_hasLoadedCache) return;
    _hasLoadedCache = true;
    
    try {
      final cachedPosts = await getPosts.getCachedPosts(categoryId: null, page: 1);
      if (cachedPosts != null && cachedPosts.isNotEmpty) {
        final cacheTimestamp = await getPosts.getCacheTimestamp(categoryId: null, page: 1);
        final isCacheFresh = _isCacheFresh(cacheTimestamp);
        
        emit(WordPressState.loaded(
          posts: cachedPosts,
          postsByCategory: {null: cachedPosts},
          selectedCategoryId: null,
          hasMoreByCategory: {null: cachedPosts.length >= NewsConfig.homeNewsListLimit},
          isLoadingByCategory: {},
          errorsByCategory: {},
          currentPageByCategory: {null: 1},
          searchResults: null,
          searchQuery: null,
          searchPage: 1,
          hasMoreSearchResults: false,
          isLoadingSearch: false,
          searchError: null,
        ));
        
        if (!isCacheFresh) {
          add(const GetPostsEvent(forceRefresh: true));
        } else {
          _fetchAndUpdateCacheInBackground(categoryId: null, page: 1);
        }
      }
    } catch (e) {
      // Silently fail cache load, will fetch from network
    }
  }

  Future<void> _onLoadCachedData(
    LoadCachedDataEvent event,
    Emitter<WordPressState> emit,
  ) async {
    await _loadCachedDataIfNeeded(emit);
  }

  Future<void> _onGetPosts(
    GetPostsEvent event,
    Emitter<WordPressState> emit,
  ) async {
    final categoryId = event.categoryId;
    
    await state.maybeWhen(
      loaded: (
        posts,
        postsByCategory,
        selectedCategoryId,
        hasMoreByCategory,
        isLoadingByCategory,
        errorsByCategory,
        currentPageByCategory,
        searchResults,
        searchQuery,
        searchPage,
        hasMoreSearchResults,
        isLoadingSearch,
        searchError,
      ) async {
        await _handleGetPostsForCategory(
          event,
          emit,
          categoryId,
          posts,
          postsByCategory,
          selectedCategoryId,
          hasMoreByCategory,
          isLoadingByCategory,
          errorsByCategory,
          currentPageByCategory,
          searchResults,
          searchQuery,
          searchPage,
          hasMoreSearchResults,
          isLoadingSearch,
          searchError,
        );
      },
      orElse: () async {
        if (!_hasLoadedCache) {
          await _loadCachedDataIfNeeded(emit);
        }
        
        await state.maybeWhen(
          loaded: (
            posts,
            postsByCategory,
            selectedCategoryId,
            hasMoreByCategory,
            isLoadingByCategory,
            errorsByCategory,
            currentPageByCategory,
            searchResults,
            searchQuery,
            searchPage,
            hasMoreSearchResults,
            isLoadingSearch,
            searchError,
          ) async {
            await _handleGetPostsForCategory(
              event,
              emit,
              categoryId,
              posts,
              postsByCategory,
              selectedCategoryId,
              hasMoreByCategory,
              isLoadingByCategory,
              errorsByCategory,
              currentPageByCategory,
              searchResults,
              searchQuery,
              searchPage,
              hasMoreSearchResults,
              isLoadingSearch,
              searchError,
            );
          },
          orElse: () async {
            await _handleGetPostsForCategory(
              event,
              emit,
              categoryId,
              [],
              {},
              null,
              {},
              {},
              {},
              {},
              null,
              null,
              1,
              false,
              false,
              null,
            );
          },
        );
      },
    );
  }

  Future<void> _handleGetPostsForCategory(
    GetPostsEvent event,
    Emitter<WordPressState> emit,
    int? categoryId,
    List<PostEntity> currentPosts,
    Map<int?, List<PostEntity>> postsByCategory,
    int? selectedCategoryId,
    Map<int?, bool> hasMoreByCategory,
    Map<int?, bool> isLoadingByCategory,
    Map<int?, Failure?> errorsByCategory,
    Map<int?, int> currentPageByCategory,
    List<PostEntity>? searchResults,
    String? searchQuery,
    int searchPage,
    bool hasMoreSearchResults,
    bool isLoadingSearch,
    Failure? searchError,
  ) async {
    final existingPosts = postsByCategory[categoryId] ?? [];
    final alreadyLoading = isLoadingByCategory[categoryId] ?? false;
    if (alreadyLoading && !event.forceRefresh) {
      // Prevent parallel identical fetches for the same category unless
      // the caller explicitly requests a refresh.
      return;
    }
    
    if (event.forceRefresh) {
      final updatedLoading = Map<int?, bool>.from(isLoadingByCategory);
      updatedLoading[categoryId] = true;
      final updatedErrors = Map<int?, Failure?>.from(errorsByCategory);
      updatedErrors[categoryId] = null;
      final updatedPages = Map<int?, int>.from(currentPageByCategory);
      updatedPages[categoryId] = 1;
      
      emit(WordPressState.loaded(
        posts: currentPosts,
        postsByCategory: postsByCategory,
        selectedCategoryId: categoryId,
        hasMoreByCategory: hasMoreByCategory,
        isLoadingByCategory: updatedLoading,
        errorsByCategory: updatedErrors,
        currentPageByCategory: updatedPages,
        searchResults: searchResults,
        searchQuery: searchQuery,
        searchPage: searchPage,
        hasMoreSearchResults: hasMoreSearchResults,
        isLoadingSearch: isLoadingSearch,
        searchError: searchError,
      ));
      
      final result = await getPosts(forceRefresh: true, categoryId: categoryId, page: 1, useNewsPageLimit: event.useNewsPageLimit);
      await result.fold((failure) async {
        final fallback = await getPosts.getCachedPosts(categoryId: categoryId, page: 1);
        final updatedPostsByCategory = Map<int?, List<PostEntity>>.from(postsByCategory);
        final updatedLoading2 = Map<int?, bool>.from(isLoadingByCategory);
        final updatedErrors2 = Map<int?, Failure?>.from(errorsByCategory);
        final updatedPages2 = Map<int?, int>.from(currentPageByCategory);
        final updatedHasMore = Map<int?, bool>.from(hasMoreByCategory);
        
        if (fallback != null && fallback.isNotEmpty) {
          updatedPostsByCategory[categoryId] = fallback;
          updatedLoading2[categoryId] = false;
          updatedErrors2[categoryId] = null;
          updatedPages2[categoryId] = 1;
          updatedHasMore[categoryId] = fallback.length >= NewsConfig.newsPageListLimit;
          emit(WordPressState.loaded(
            posts: fallback,
            postsByCategory: updatedPostsByCategory,
            selectedCategoryId: categoryId,
            hasMoreByCategory: updatedHasMore,
            isLoadingByCategory: updatedLoading2,
            errorsByCategory: updatedErrors2,
            currentPageByCategory: updatedPages2,
            searchResults: searchResults,
            searchQuery: searchQuery,
            searchPage: searchPage,
            hasMoreSearchResults: hasMoreSearchResults,
            isLoadingSearch: isLoadingSearch,
            searchError: searchError,
          ));
        } else {
          updatedLoading2[categoryId] = false;
          updatedErrors2[categoryId] = failure;
          emit(WordPressState.loaded(
            posts: existingPosts.isNotEmpty ? existingPosts : currentPosts,
            postsByCategory: postsByCategory,
            selectedCategoryId: categoryId,
            hasMoreByCategory: hasMoreByCategory,
            isLoadingByCategory: updatedLoading2,
            errorsByCategory: updatedErrors2,
            currentPageByCategory: updatedPages2,
            searchResults: searchResults,
            searchQuery: searchQuery,
            searchPage: searchPage,
            hasMoreSearchResults: hasMoreSearchResults,
            isLoadingSearch: isLoadingSearch,
            searchError: searchError,
          ));
        }
      }, (posts) async {
        final updatedPostsByCategory = Map<int?, List<PostEntity>>.from(postsByCategory);
        updatedPostsByCategory[categoryId] = posts;
        final updatedLoading = Map<int?, bool>.from(isLoadingByCategory);
        updatedLoading[categoryId] = false;
        final updatedErrors = Map<int?, Failure?>.from(errorsByCategory);
        updatedErrors[categoryId] = null;
        final updatedPages = Map<int?, int>.from(currentPageByCategory);
        updatedPages[categoryId] = 1;
        final updatedHasMore = Map<int?, bool>.from(hasMoreByCategory);
        updatedHasMore[categoryId] = posts.length >= NewsConfig.newsPageListLimit;
        
        emit(WordPressState.loaded(
          posts: posts,
          postsByCategory: updatedPostsByCategory,
          selectedCategoryId: categoryId,
          hasMoreByCategory: updatedHasMore,
          isLoadingByCategory: updatedLoading,
          errorsByCategory: updatedErrors,
          currentPageByCategory: updatedPages,
          searchResults: searchResults,
          searchQuery: searchQuery,
          searchPage: searchPage,
          hasMoreSearchResults: hasMoreSearchResults,
          isLoadingSearch: isLoadingSearch,
          searchError: searchError,
        ));
      });
      return;
    }

    final cacheTimestamp = await getPosts.getCacheTimestamp(categoryId: categoryId, page: 1);
    final isCacheFresh = _isCacheFresh(cacheTimestamp);
    
    if (isCacheFresh && existingPosts.isNotEmpty) {
      final updatedPostsByCategory = Map<int?, List<PostEntity>>.from(postsByCategory);
      if (!updatedPostsByCategory.containsKey(categoryId)) {
        updatedPostsByCategory[categoryId] = existingPosts;
      }
      final updatedPages = Map<int?, int>.from(currentPageByCategory);
      if (!updatedPages.containsKey(categoryId)) {
        updatedPages[categoryId] = 1;
      }
      emit(WordPressState.loaded(
        posts: existingPosts,
        postsByCategory: updatedPostsByCategory,
        selectedCategoryId: categoryId,
        hasMoreByCategory: hasMoreByCategory,
        isLoadingByCategory: isLoadingByCategory,
        errorsByCategory: errorsByCategory,
        currentPageByCategory: updatedPages,
        searchResults: searchResults,
        searchQuery: searchQuery,
        searchPage: searchPage,
        hasMoreSearchResults: hasMoreSearchResults,
        isLoadingSearch: isLoadingSearch,
        searchError: searchError,
      ));
      
      _fetchAndUpdateCacheInBackground(categoryId: categoryId, page: 1, useNewsPageLimit: event.useNewsPageLimit);
      return;
    }

    final cachedPosts = await getPosts.getCachedPosts(categoryId: categoryId, page: 1);

    if (cachedPosts != null && cachedPosts.isNotEmpty) {
      final shouldForceRefresh = event.useNewsPageLimit && 
          cachedPosts.length < NewsConfig.newsPageListLimit;
      
      final updatedPostsByCategory = Map<int?, List<PostEntity>>.from(postsByCategory);
      updatedPostsByCategory[categoryId] = cachedPosts;
      final updatedPages = Map<int?, int>.from(currentPageByCategory);
      updatedPages[categoryId] = 1;
      final updatedHasMore = Map<int?, bool>.from(hasMoreByCategory);
      updatedHasMore[categoryId] = cachedPosts.length >= NewsConfig.newsPageListLimit;
      
      if (!shouldForceRefresh) {
        emit(WordPressState.loaded(
          posts: cachedPosts,
          postsByCategory: updatedPostsByCategory,
          selectedCategoryId: categoryId,
          hasMoreByCategory: updatedHasMore,
          isLoadingByCategory: isLoadingByCategory,
          errorsByCategory: errorsByCategory,
          currentPageByCategory: updatedPages,
          searchResults: searchResults,
          searchQuery: searchQuery,
          searchPage: searchPage,
          hasMoreSearchResults: hasMoreSearchResults,
          isLoadingSearch: isLoadingSearch,
          searchError: searchError,
        ));
        
        if (isCacheFresh) {
          return;
        }
      } else {
        final updatedLoading = Map<int?, bool>.from(isLoadingByCategory);
        updatedLoading[categoryId] = true;
        
        emit(WordPressState.loaded(
          posts: cachedPosts,
          postsByCategory: updatedPostsByCategory,
          selectedCategoryId: categoryId,
          hasMoreByCategory: updatedHasMore,
          isLoadingByCategory: updatedLoading,
          errorsByCategory: errorsByCategory,
          currentPageByCategory: updatedPages,
          searchResults: searchResults,
          searchQuery: searchQuery,
          searchPage: searchPage,
          hasMoreSearchResults: hasMoreSearchResults,
          isLoadingSearch: isLoadingSearch,
          searchError: searchError,
        ));
      }
      
      final result = await getPosts(forceRefresh: shouldForceRefresh || !isCacheFresh, categoryId: categoryId, page: 1, useNewsPageLimit: event.useNewsPageLimit);
      result.fold((failure) {
        final updatedLoading2 = Map<int?, bool>.from(isLoadingByCategory);
        updatedLoading2[categoryId] = false;
        final updatedErrors = Map<int?, Failure?>.from(errorsByCategory);
        updatedErrors[categoryId] = failure;
        emit(WordPressState.loaded(
          posts: cachedPosts,
          postsByCategory: updatedPostsByCategory,
          selectedCategoryId: categoryId,
          hasMoreByCategory: updatedHasMore,
          isLoadingByCategory: updatedLoading2,
          errorsByCategory: updatedErrors,
          currentPageByCategory: updatedPages,
          searchResults: searchResults,
          searchQuery: searchQuery,
          searchPage: searchPage,
          hasMoreSearchResults: hasMoreSearchResults,
          isLoadingSearch: isLoadingSearch,
          searchError: searchError,
        ));
      }, (posts) {
        final updatedLoading2 = Map<int?, bool>.from(isLoadingByCategory);
        updatedLoading2[categoryId] = false;
        
        if (_arePostsEqual(cachedPosts, posts)) {
          if (isLoadingByCategory[categoryId] == true) {
            emit(WordPressState.loaded(
              posts: cachedPosts,
              postsByCategory: updatedPostsByCategory,
              selectedCategoryId: categoryId,
              hasMoreByCategory: updatedHasMore,
              isLoadingByCategory: updatedLoading2,
              errorsByCategory: errorsByCategory,
              currentPageByCategory: updatedPages,
              searchResults: searchResults,
              searchQuery: searchQuery,
              searchPage: searchPage,
              hasMoreSearchResults: hasMoreSearchResults,
              isLoadingSearch: isLoadingSearch,
              searchError: searchError,
            ));
          }
          return;
        }
        
        final updatedPostsByCategory2 = Map<int?, List<PostEntity>>.from(updatedPostsByCategory);
        updatedPostsByCategory2[categoryId] = posts;
        final updatedHasMore2 = Map<int?, bool>.from(updatedHasMore);
        updatedHasMore2[categoryId] = posts.length >= NewsConfig.newsPageListLimit;
        emit(WordPressState.loaded(
          posts: posts,
          postsByCategory: updatedPostsByCategory2,
          selectedCategoryId: categoryId,
          hasMoreByCategory: updatedHasMore2,
          isLoadingByCategory: updatedLoading2,
          errorsByCategory: errorsByCategory,
          currentPageByCategory: updatedPages,
          searchResults: searchResults,
          searchQuery: searchQuery,
          searchPage: searchPage,
          hasMoreSearchResults: hasMoreSearchResults,
          isLoadingSearch: isLoadingSearch,
          searchError: searchError,
        ));
      });
      return;
    }

    final updatedLoading = Map<int?, bool>.from(isLoadingByCategory);
    updatedLoading[categoryId] = true;
    final updatedErrors = Map<int?, Failure?>.from(errorsByCategory);
    updatedErrors[categoryId] = null;
    
    emit(WordPressState.loaded(
      posts: existingPosts.isNotEmpty ? existingPosts : currentPosts,
      postsByCategory: postsByCategory,
      selectedCategoryId: categoryId,
      hasMoreByCategory: hasMoreByCategory,
      isLoadingByCategory: updatedLoading,
      errorsByCategory: updatedErrors,
      currentPageByCategory: currentPageByCategory,
      searchResults: searchResults,
      searchQuery: searchQuery,
      searchPage: searchPage,
      hasMoreSearchResults: hasMoreSearchResults,
      isLoadingSearch: isLoadingSearch,
      searchError: searchError,
    ));
    
    final result = await getPosts(categoryId: categoryId, page: 1, useNewsPageLimit: event.useNewsPageLimit);
    result.fold(
      (failure) {
        final updatedLoading2 = Map<int?, bool>.from(updatedLoading);
        updatedLoading2[categoryId] = false;
        final updatedErrors2 = Map<int?, Failure?>.from(updatedErrors);
        updatedErrors2[categoryId] = failure;
        emit(WordPressState.loaded(
          posts: existingPosts.isNotEmpty ? existingPosts : currentPosts,
          postsByCategory: postsByCategory,
          selectedCategoryId: categoryId,
          hasMoreByCategory: hasMoreByCategory,
          isLoadingByCategory: updatedLoading2,
          errorsByCategory: updatedErrors2,
          currentPageByCategory: currentPageByCategory,
          searchResults: searchResults,
          searchQuery: searchQuery,
          searchPage: searchPage,
          hasMoreSearchResults: hasMoreSearchResults,
          isLoadingSearch: isLoadingSearch,
          searchError: searchError,
        ));
      },
      (posts) {
        final updatedPostsByCategory = Map<int?, List<PostEntity>>.from(postsByCategory);
        updatedPostsByCategory[categoryId] = posts;
        final updatedLoading2 = Map<int?, bool>.from(updatedLoading);
        updatedLoading2[categoryId] = false;
        final updatedErrors2 = Map<int?, Failure?>.from(updatedErrors);
        updatedErrors2[categoryId] = null;
        final updatedPages = Map<int?, int>.from(currentPageByCategory);
        updatedPages[categoryId] = 1;
        final updatedHasMore = Map<int?, bool>.from(hasMoreByCategory);
        updatedHasMore[categoryId] = posts.length >= NewsConfig.newsPageListLimit;
        emit(WordPressState.loaded(
          posts: posts,
          postsByCategory: updatedPostsByCategory,
          selectedCategoryId: categoryId,
          hasMoreByCategory: updatedHasMore,
          isLoadingByCategory: updatedLoading2,
          errorsByCategory: updatedErrors2,
          currentPageByCategory: updatedPages,
          searchResults: searchResults,
          searchQuery: searchQuery,
          searchPage: searchPage,
          hasMoreSearchResults: hasMoreSearchResults,
          isLoadingSearch: isLoadingSearch,
          searchError: searchError,
        ));
      },
    );
  }

  Future<void> _onLoadMorePosts(
    LoadMorePostsEvent event,
    Emitter<WordPressState> emit,
  ) async {
    await state.maybeWhen(
      loaded: (
        posts,
        postsByCategory,
        selectedCategoryId,
        hasMoreByCategory,
        isLoadingByCategory,
        errorsByCategory,
        currentPageByCategory,
        searchResults,
        searchQuery,
        searchPage,
        hasMoreSearchResults,
        isLoadingSearch,
        searchError,
      ) async {
        final categoryId = event.categoryId ?? selectedCategoryId;
        if (categoryId == null) return;
        
        final currentPage = currentPageByCategory[categoryId] ?? 1;
        final hasMore = hasMoreByCategory[categoryId] ?? false;
        final isLoading = isLoadingByCategory[categoryId] ?? false;
        
        if (!hasMore || isLoading) return;
        
        final nextPage = currentPage + 1;
        final existingPosts = postsByCategory[categoryId] ?? [];
        
        final updatedLoading = Map<int?, bool>.from(isLoadingByCategory);
        updatedLoading[categoryId] = true;
        
        emit(WordPressState.loaded(
          posts: posts,
          postsByCategory: postsByCategory,
          selectedCategoryId: selectedCategoryId,
          hasMoreByCategory: hasMoreByCategory,
          isLoadingByCategory: updatedLoading,
          errorsByCategory: errorsByCategory,
          currentPageByCategory: currentPageByCategory,
          searchResults: searchResults,
          searchQuery: searchQuery,
          searchPage: searchPage,
          hasMoreSearchResults: hasMoreSearchResults,
          isLoadingSearch: isLoadingSearch,
          searchError: searchError,
        ));
        
        final cachedNextPage = await getPosts.getCachedPosts(
          categoryId: categoryId,
          page: nextPage,
        );
        
        if (cachedNextPage != null && cachedNextPage.isNotEmpty) {
          final mergedPosts = [...existingPosts, ...cachedNextPage];
          final updatedPostsByCategory = Map<int?, List<PostEntity>>.from(postsByCategory);
          updatedPostsByCategory[categoryId] = mergedPosts;
          final updatedPages = Map<int?, int>.from(currentPageByCategory);
          updatedPages[categoryId] = nextPage;
          final updatedHasMore = Map<int?, bool>.from(hasMoreByCategory);
          updatedHasMore[categoryId] = cachedNextPage.length >= NewsConfig.newsPageListLimit;
          final updatedLoading2 = Map<int?, bool>.from(updatedLoading);
          updatedLoading2[categoryId] = false;
          
          emit(WordPressState.loaded(
            posts: mergedPosts,
            postsByCategory: updatedPostsByCategory,
            selectedCategoryId: selectedCategoryId,
            hasMoreByCategory: updatedHasMore,
            isLoadingByCategory: updatedLoading2,
            errorsByCategory: errorsByCategory,
            currentPageByCategory: updatedPages,
            searchResults: searchResults,
            searchQuery: searchQuery,
            searchPage: searchPage,
            hasMoreSearchResults: hasMoreSearchResults,
            isLoadingSearch: isLoadingSearch,
            searchError: searchError,
          ));
          
          _fetchAndUpdateCacheInBackground(categoryId: categoryId, page: nextPage, useNewsPageLimit: true);
        }
        
        final result = await getPosts(categoryId: categoryId, page: nextPage, useNewsPageLimit: true);
        result.fold(
          (failure) {
            final updatedLoading2 = Map<int?, bool>.from(updatedLoading);
            updatedLoading2[categoryId] = false;
            final updatedErrors = Map<int?, Failure?>.from(errorsByCategory);
            updatedErrors[categoryId] = failure;
            emit(WordPressState.loaded(
              posts: posts,
              postsByCategory: postsByCategory,
              selectedCategoryId: selectedCategoryId,
              hasMoreByCategory: hasMoreByCategory,
              isLoadingByCategory: updatedLoading2,
              errorsByCategory: updatedErrors,
              currentPageByCategory: currentPageByCategory,
              searchResults: searchResults,
              searchQuery: searchQuery,
              searchPage: searchPage,
              hasMoreSearchResults: hasMoreSearchResults,
              isLoadingSearch: isLoadingSearch,
              searchError: searchError,
            ));
          },
          (newPosts) {
            final mergedPosts = [...existingPosts, ...newPosts];
            final updatedPostsByCategory = Map<int?, List<PostEntity>>.from(postsByCategory);
            updatedPostsByCategory[categoryId] = mergedPosts;
            final updatedPages = Map<int?, int>.from(currentPageByCategory);
            updatedPages[categoryId] = nextPage;
            final updatedHasMore = Map<int?, bool>.from(hasMoreByCategory);
            updatedHasMore[categoryId] = newPosts.length >= NewsConfig.newsPageListLimit;
            final updatedLoading2 = Map<int?, bool>.from(updatedLoading);
            updatedLoading2[categoryId] = false;
            final updatedErrors = Map<int?, Failure?>.from(errorsByCategory);
            updatedErrors[categoryId] = null;
            
            emit(WordPressState.loaded(
              posts: mergedPosts,
              postsByCategory: updatedPostsByCategory,
              selectedCategoryId: selectedCategoryId,
              hasMoreByCategory: updatedHasMore,
              isLoadingByCategory: updatedLoading2,
              errorsByCategory: updatedErrors,
              currentPageByCategory: updatedPages,
              searchResults: searchResults,
              searchQuery: searchQuery,
              searchPage: searchPage,
              hasMoreSearchResults: hasMoreSearchResults,
              isLoadingSearch: isLoadingSearch,
              searchError: searchError,
            ));
          },
        );
      },
      orElse: () async {},
    );
  }

  Future<void> _onSearchPosts(
    SearchPostsEvent event,
    Emitter<WordPressState> emit,
  ) async {
    final query = event.query.trim();
    
    if (query.isEmpty) {
      await _onClearSearch(ClearSearchEvent(), emit);
      return;
    }
    
    await state.maybeWhen(
      loaded: (
        posts,
        postsByCategory,
        selectedCategoryId,
        hasMoreByCategory,
        isLoadingByCategory,
        errorsByCategory,
        currentPageByCategory,
        searchResults,
        searchQuery,
        searchPage,
        hasMoreSearchResults,
        isLoadingSearch,
        searchError,
      ) async {
        emit(WordPressState.loaded(
          posts: posts,
          postsByCategory: postsByCategory,
          selectedCategoryId: selectedCategoryId,
          hasMoreByCategory: hasMoreByCategory,
          isLoadingByCategory: isLoadingByCategory,
          errorsByCategory: errorsByCategory,
          currentPageByCategory: currentPageByCategory,
          searchResults: searchResults,
          searchQuery: query,
          searchPage: 1,
          hasMoreSearchResults: false,
          isLoadingSearch: true,
          searchError: null,
        ));
        
        final cachedResults = await getPosts.getCachedPosts(search: query, page: 1);
        
        if (cachedResults != null && cachedResults.isNotEmpty) {
          final updatedHasMore = cachedResults.length >= NewsConfig.newsPageListLimit;
          emit(WordPressState.loaded(
            posts: posts,
            postsByCategory: postsByCategory,
            selectedCategoryId: selectedCategoryId,
            hasMoreByCategory: hasMoreByCategory,
            isLoadingByCategory: isLoadingByCategory,
            errorsByCategory: errorsByCategory,
            currentPageByCategory: currentPageByCategory,
            searchResults: cachedResults,
            searchQuery: query,
            searchPage: 1,
            hasMoreSearchResults: updatedHasMore,
            isLoadingSearch: false,
            searchError: null,
          ));
          
          _fetchAndUpdateCacheInBackground(search: query, page: 1);
        }
        
        final result = await getPosts(search: query, page: 1);
        result.fold(
          (failure) {
            emit(WordPressState.loaded(
              posts: posts,
              postsByCategory: postsByCategory,
              selectedCategoryId: selectedCategoryId,
              hasMoreByCategory: hasMoreByCategory,
              isLoadingByCategory: isLoadingByCategory,
              errorsByCategory: errorsByCategory,
              currentPageByCategory: currentPageByCategory,
              searchResults: cachedResults ?? [],
              searchQuery: query,
              searchPage: 1,
              hasMoreSearchResults: false,
              isLoadingSearch: false,
              searchError: failure,
            ));
          },
          (results) {
            final updatedHasMore = results.length >= NewsConfig.newsPageListLimit;
            emit(WordPressState.loaded(
              posts: posts,
              postsByCategory: postsByCategory,
              selectedCategoryId: selectedCategoryId,
              hasMoreByCategory: hasMoreByCategory,
              isLoadingByCategory: isLoadingByCategory,
              errorsByCategory: errorsByCategory,
              currentPageByCategory: currentPageByCategory,
              searchResults: results,
              searchQuery: query,
              searchPage: 1,
              hasMoreSearchResults: updatedHasMore,
              isLoadingSearch: false,
              searchError: null,
            ));
          },
        );
      },
      orElse: () async {
        emit(const WordPressState.loading(categoryId: null));
        final result = await getPosts(search: query, page: 1);
        result.fold(
          (failure) {
            emit(WordPressState.error(failure: failure, categoryId: null));
          },
          (results) {
            final updatedHasMore = results.length >= NewsConfig.newsPageListLimit;
            emit(WordPressState.loaded(
              posts: [],
              postsByCategory: {},
              selectedCategoryId: null,
              searchResults: results,
              searchQuery: query,
              searchPage: 1,
              hasMoreSearchResults: updatedHasMore,
            ));
          },
        );
      },
    );
  }

  Future<void> _onLoadMoreSearchResults(
    LoadMoreSearchResultsEvent event,
    Emitter<WordPressState> emit,
  ) async {
    await state.maybeWhen(
      loaded: (
        posts,
        postsByCategory,
        selectedCategoryId,
        hasMoreByCategory,
        isLoadingByCategory,
        errorsByCategory,
        currentPageByCategory,
        searchResults,
        searchQuery,
        searchPage,
        hasMoreSearchResults,
        isLoadingSearch,
        searchError,
      ) async {
        if (searchQuery == null || searchQuery.isEmpty) return;
        if (!hasMoreSearchResults || isLoadingSearch) return;
        
        final nextPage = searchPage + 1;
        final existingResults = searchResults ?? [];
        
        emit(WordPressState.loaded(
          posts: posts,
          postsByCategory: postsByCategory,
          selectedCategoryId: selectedCategoryId,
          hasMoreByCategory: hasMoreByCategory,
          isLoadingByCategory: isLoadingByCategory,
          errorsByCategory: errorsByCategory,
          currentPageByCategory: currentPageByCategory,
          searchResults: existingResults,
          searchQuery: searchQuery,
          searchPage: searchPage,
          hasMoreSearchResults: hasMoreSearchResults,
          isLoadingSearch: true,
          searchError: null,
        ));
        
        final cachedNextPage = await getPosts.getCachedPosts(search: searchQuery, page: nextPage);
        
        if (cachedNextPage != null && cachedNextPage.isNotEmpty) {
          final mergedResults = [...existingResults, ...cachedNextPage];
          final updatedHasMore = cachedNextPage.length >= NewsConfig.newsPageListLimit;
          emit(WordPressState.loaded(
            posts: posts,
            postsByCategory: postsByCategory,
            selectedCategoryId: selectedCategoryId,
            hasMoreByCategory: hasMoreByCategory,
            isLoadingByCategory: isLoadingByCategory,
            errorsByCategory: errorsByCategory,
            currentPageByCategory: currentPageByCategory,
            searchResults: mergedResults,
            searchQuery: searchQuery,
            searchPage: nextPage,
            hasMoreSearchResults: updatedHasMore,
            isLoadingSearch: false,
            searchError: null,
          ));
          
          _fetchAndUpdateCacheInBackground(search: searchQuery, page: nextPage);
        }
        
        final result = await getPosts(search: searchQuery, page: nextPage);
        result.fold(
          (failure) {
            emit(WordPressState.loaded(
              posts: posts,
              postsByCategory: postsByCategory,
              selectedCategoryId: selectedCategoryId,
              hasMoreByCategory: hasMoreByCategory,
              isLoadingByCategory: isLoadingByCategory,
              errorsByCategory: errorsByCategory,
              currentPageByCategory: currentPageByCategory,
              searchResults: existingResults,
              searchQuery: searchQuery,
              searchPage: searchPage,
              hasMoreSearchResults: hasMoreSearchResults,
              isLoadingSearch: false,
              searchError: failure,
            ));
          },
          (newResults) {
            final mergedResults = [...existingResults, ...newResults];
            final updatedHasMore = newResults.length >= NewsConfig.newsPageListLimit;
            emit(WordPressState.loaded(
              posts: posts,
              postsByCategory: postsByCategory,
              selectedCategoryId: selectedCategoryId,
              hasMoreByCategory: hasMoreByCategory,
              isLoadingByCategory: isLoadingByCategory,
              errorsByCategory: errorsByCategory,
              currentPageByCategory: currentPageByCategory,
              searchResults: mergedResults,
              searchQuery: searchQuery,
              searchPage: nextPage,
              hasMoreSearchResults: updatedHasMore,
              isLoadingSearch: false,
              searchError: null,
            ));
          },
        );
      },
      orElse: () async {},
    );
  }

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<WordPressState> emit,
  ) async {
    await state.maybeWhen(
      loaded: (
        posts,
        postsByCategory,
        selectedCategoryId,
        hasMoreByCategory,
        isLoadingByCategory,
        errorsByCategory,
        currentPageByCategory,
        searchResults,
        searchQuery,
        searchPage,
        hasMoreSearchResults,
        isLoadingSearch,
        searchError,
      ) async {
        emit(WordPressState.loaded(
          posts: posts,
          postsByCategory: postsByCategory,
          selectedCategoryId: selectedCategoryId,
          hasMoreByCategory: hasMoreByCategory,
          isLoadingByCategory: isLoadingByCategory,
          errorsByCategory: errorsByCategory,
          currentPageByCategory: currentPageByCategory,
          searchResults: null,
          searchQuery: null,
          searchPage: 1,
          hasMoreSearchResults: false,
          isLoadingSearch: false,
          searchError: null,
        ));
      },
      orElse: () async {},
    );
  }

  void _fetchAndUpdateCacheInBackground({
    int? categoryId,
    int page = 1,
    String? search,
    bool useNewsPageLimit = false,
  }) async {
    try {
      final posts = await getPosts(
        forceRefresh: true,
        categoryId: categoryId,
        page: page,
        search: search,
        useNewsPageLimit: useNewsPageLimit,
      );
      posts.fold((failure) {}, (posts) {});
    } catch (e) {
      // Silently fail background cache update
    }
  }

  bool _isCacheFresh(DateTime? timestamp) {
    if (timestamp == null) return false;
    return DateTime.now().difference(timestamp) < NewsConfig.newsCacheTTL;
  }

  bool _arePostsEqual(List<PostEntity> list1, List<PostEntity> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}
