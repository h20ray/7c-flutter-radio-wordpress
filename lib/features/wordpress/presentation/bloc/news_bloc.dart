import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../config/news_config.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_posts.dart';

part 'news_bloc.freezed.dart';
part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetPosts getPosts;

  NewsBloc({required this.getPosts})
    : super(const NewsState.initial()) {
    on<GetNewsPostsEvent>(_onGetPosts);
    on<LoadMoreNewsPostsEvent>(_onLoadMorePosts);
    on<SearchNewsPostsEvent>(_onSearchPosts);
    on<LoadMoreNewsSearchResultsEvent>(_onLoadMoreSearchResults);
    on<ClearNewsSearchEvent>(_onClearSearch);
  }

  Future<void> _onGetPosts(
    GetNewsPostsEvent event,
    Emitter<NewsState> emit,
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
          event: event,
          emit: emit,
          categoryId: categoryId,
          posts: posts,
          postsByCategory: postsByCategory,
          selectedCategoryId: selectedCategoryId,
          hasMoreByCategory: hasMoreByCategory,
          isLoadingByCategory: isLoadingByCategory,
          errorsByCategory: errorsByCategory,
          currentPageByCategory: currentPageByCategory,
          searchResults: searchResults,
          searchQuery: searchQuery,
          searchPage: searchPage,
          hasMoreSearchResults: hasMoreSearchResults,
          isLoadingSearch: isLoadingSearch,
          searchError: searchError,
        );
      },
      orElse: () async {
        await _handleGetPostsForCategory(
          event: event,
          emit: emit,
          categoryId: categoryId,
          posts: const [],
          postsByCategory: const {},
          selectedCategoryId: null,
          hasMoreByCategory: const {},
          isLoadingByCategory: const {},
          errorsByCategory: const {},
          currentPageByCategory: const {},
          searchResults: null,
          searchQuery: null,
          searchPage: 1,
          hasMoreSearchResults: false,
          isLoadingSearch: false,
          searchError: null,
        );
      },
    );
  }

  Future<void> _handleGetPostsForCategory({
    required GetNewsPostsEvent event,
    required Emitter<NewsState> emit,
    required int? categoryId,
    required List<PostEntity> posts,
    required Map<int?, List<PostEntity>> postsByCategory,
    int? selectedCategoryId,
    required Map<int?, bool> hasMoreByCategory,
    required Map<int?, bool> isLoadingByCategory,
    required Map<int?, Failure?> errorsByCategory,
    required Map<int?, int> currentPageByCategory,
    List<PostEntity>? searchResults,
    String? searchQuery,
    required int searchPage,
    required bool hasMoreSearchResults,
    required bool isLoadingSearch,
    Failure? searchError,
  }) async {
    final existingPosts = postsByCategory[categoryId] ?? [];
    
    if (event.forceRefresh) {
      final updatedLoading = Map<int?, bool>.from(isLoadingByCategory);
      updatedLoading[categoryId] = true;
      final updatedErrors = Map<int?, Failure?>.from(errorsByCategory);
      updatedErrors[categoryId] = null;
      final updatedPages = Map<int?, int>.from(currentPageByCategory);
      updatedPages[categoryId] = 1;
      
      emit(_buildLoadedState(
        posts: posts,
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
          emit(_buildLoadedState(
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
          emit(_buildLoadedState(
            posts: existingPosts.isNotEmpty ? existingPosts : posts,
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
        
        emit(_buildLoadedState(
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
      
      final updatedHasMore = Map<int?, bool>.from(hasMoreByCategory);
      updatedHasMore[categoryId] = existingPosts.length >= NewsConfig.newsPageListLimit;
      
      emit(_buildLoadedState(
        posts: existingPosts,
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
        emit(_buildLoadedState(
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
        
        emit(_buildLoadedState(
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
        emit(_buildLoadedState(
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
        final updatedPostsByCategory2 = Map<int?, List<PostEntity>>.from(updatedPostsByCategory);
        updatedPostsByCategory2[categoryId] = posts;
        final updatedHasMore2 = Map<int?, bool>.from(updatedHasMore);
        updatedHasMore2[categoryId] = posts.length >= NewsConfig.newsPageListLimit;
        final updatedLoading2 = Map<int?, bool>.from(isLoadingByCategory);
        updatedLoading2[categoryId] = false;
        emit(_buildLoadedState(
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
    
    emit(_buildLoadedState(
      posts: existingPosts.isNotEmpty ? existingPosts : posts,
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
        emit(_buildLoadedState(
          posts: existingPosts.isNotEmpty ? existingPosts : posts,
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
        emit(_buildLoadedState(
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
    LoadMoreNewsPostsEvent event,
    Emitter<NewsState> emit,
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
        

        
        final currentPage = currentPageByCategory[categoryId] ?? 1;
        final hasMore = hasMoreByCategory[categoryId] ?? false;
        final isLoading = isLoadingByCategory[categoryId] ?? false;
        
        if (!hasMore || isLoading) {
           return;
        }
        
        final nextPage = currentPage + 1;
        final existingPosts = postsByCategory[categoryId] ?? [];
        
        emit(_updateCategoryLoading(
          posts: posts,
          postsByCategory: postsByCategory,
          selectedCategoryId: selectedCategoryId,
          hasMoreByCategory: hasMoreByCategory,
          isLoadingByCategory: isLoadingByCategory,
          errorsByCategory: errorsByCategory,
          currentPageByCategory: currentPageByCategory,
          searchResults: searchResults,
          searchQuery: searchQuery,
          searchPage: searchPage,
          hasMoreSearchResults: hasMoreSearchResults,
          isLoadingSearch: isLoadingSearch,
          searchError: searchError,
          categoryId: categoryId,
          isLoading: true,
        ));
        
        final cachedNextPage = await getPosts.getCachedPosts(
          categoryId: categoryId,
          page: nextPage,
        );
        
        if (cachedNextPage != null && cachedNextPage.isNotEmpty) {
          final mergedPosts = [...existingPosts, ...cachedNextPage];
          final updatedHasMore = cachedNextPage.length >= NewsConfig.newsPageListLimit;
          
          emit(_updateCategoryPosts(
            postsByCategory: postsByCategory,
            selectedCategoryId: selectedCategoryId,
            hasMoreByCategory: hasMoreByCategory,
            isLoadingByCategory: isLoadingByCategory,
            errorsByCategory: errorsByCategory,
            currentPageByCategory: currentPageByCategory,
            searchResults: searchResults,
            searchQuery: searchQuery,
            searchPage: searchPage,
            hasMoreSearchResults: hasMoreSearchResults,
            isLoadingSearch: isLoadingSearch,
            searchError: searchError,
            categoryId: categoryId,
            newPosts: mergedPosts,
            page: nextPage,
            hasMore: updatedHasMore,
            isLoading: false,
            error: null,
          ));
          
          _fetchAndUpdateCacheInBackground(categoryId: categoryId, page: nextPage, useNewsPageLimit: true);
          return;
        }
        
        final result = await getPosts(categoryId: categoryId, page: nextPage, useNewsPageLimit: true);
        result.fold(
          (failure) {
            emit(_updateCategoryError(
              posts: posts,
              postsByCategory: postsByCategory,
              selectedCategoryId: selectedCategoryId,
              hasMoreByCategory: hasMoreByCategory,
              isLoadingByCategory: isLoadingByCategory,
              errorsByCategory: errorsByCategory,
              currentPageByCategory: currentPageByCategory,
              searchResults: searchResults,
              searchQuery: searchQuery,
              searchPage: searchPage,
              hasMoreSearchResults: hasMoreSearchResults,
              isLoadingSearch: isLoadingSearch,
              searchError: searchError,
              categoryId: categoryId,
              isLoading: false,
              error: failure,
            ));
          },
          (newPosts) {
            final mergedPosts = [...existingPosts, ...newPosts];
            final updatedHasMore = newPosts.length >= NewsConfig.newsPageListLimit;
            
            emit(_updateCategoryPosts(
              postsByCategory: postsByCategory,
              selectedCategoryId: selectedCategoryId,
              hasMoreByCategory: hasMoreByCategory,
              isLoadingByCategory: isLoadingByCategory,
              errorsByCategory: errorsByCategory,
              currentPageByCategory: currentPageByCategory,
              searchResults: searchResults,
              searchQuery: searchQuery,
              searchPage: searchPage,
              hasMoreSearchResults: hasMoreSearchResults,
              isLoadingSearch: isLoadingSearch,
              searchError: searchError,
              categoryId: categoryId,
              newPosts: mergedPosts,
              page: nextPage,
              hasMore: updatedHasMore,
              isLoading: false,
              error: null,
            ));
          },
        );
      },
      orElse: () async {},
    );
  }

  Future<void> _onSearchPosts(
    SearchNewsPostsEvent event,
    Emitter<NewsState> emit,
  ) async {
    final query = event.query.trim();
    
    if (query.isEmpty) {
      await _onClearSearch(ClearNewsSearchEvent(), emit);
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
        emit(_updateSearchLoading(
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
          searchError: null,
        ));
        
        final cachedResults = await getPosts.getCachedPosts(search: query, page: 1);
        
        if (cachedResults != null && cachedResults.isNotEmpty) {
          final updatedHasMore = cachedResults.length >= NewsConfig.newsPageListLimit;
          emit(_updateSearchResults(
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
            searchError: null,
          ));
          
          _fetchAndUpdateCacheInBackground(search: query, page: 1);
        }
        
        final result = await getPosts(search: query, page: 1);
        result.fold(
          (failure) {
            emit(_updateSearchError(
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
              searchError: failure,
            ));
          },
          (results) {
            final updatedHasMore = results.length >= NewsConfig.newsPageListLimit;
            emit(_updateSearchResults(
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
              searchError: null,
            ));
          },
        );
      },
      orElse: () async {
        emit(const NewsState.loading(categoryId: null));
        final result = await getPosts(search: query, page: 1);
        result.fold(
          (failure) {
            emit(NewsState.error(failure: failure, categoryId: null));
          },
          (results) {
            final updatedHasMore = results.length >= NewsConfig.newsPageListLimit;
            emit(_buildLoadedState(
              posts: const [],
              postsByCategory: const {},
              selectedCategoryId: null,
              hasMoreByCategory: const {},
              isLoadingByCategory: const {},
              errorsByCategory: const {},
              currentPageByCategory: const {},
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
    );
  }

  Future<void> _onLoadMoreSearchResults(
    LoadMoreNewsSearchResultsEvent event,
    Emitter<NewsState> emit,
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
        
        emit(_updateSearchLoading(
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
          searchError: null,
        ));
        
        final cachedNextPage = await getPosts.getCachedPosts(search: searchQuery, page: nextPage);
        
        if (cachedNextPage != null && cachedNextPage.isNotEmpty) {
          final mergedResults = [...existingResults, ...cachedNextPage];
          final updatedHasMore = cachedNextPage.length >= NewsConfig.newsPageListLimit;
          
          emit(_updateSearchResults(
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
            searchError: null,
          ));
          
          _fetchAndUpdateCacheInBackground(search: searchQuery, page: nextPage);
          return;
        }
        
        final result = await getPosts(search: searchQuery, page: nextPage);
        result.fold(
          (failure) {
            emit(_updateSearchError(
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
              searchError: failure,
            ));
          },
          (newResults) {
            final mergedResults = [...existingResults, ...newResults];
            final updatedHasMore = newResults.length >= NewsConfig.newsPageListLimit;
            
            emit(_updateSearchResults(
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
              searchError: null,
            ));
          },
        );
      },
      orElse: () async {},
    );
  }

  Future<void> _onClearSearch(
    ClearNewsSearchEvent event,
    Emitter<NewsState> emit,
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
        emit(_buildLoadedState(
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
    String? search,
    required int page,
    bool useNewsPageLimit = false,
  }) {
    getPosts(
      forceRefresh: true,
      categoryId: categoryId,
      search: search,
      page: page,
      useNewsPageLimit: useNewsPageLimit,
    ).then((result) {
      result.fold(
        (failure) {
          // Background errors are ignored
        },
        (posts) {
          // Successful fetch updates the cache via the repository
        },
      );
    });
  }

  NewsState _updateCategoryLoading({
    required List<PostEntity> posts,
    required Map<int?, List<PostEntity>> postsByCategory,
    int? selectedCategoryId,
    required Map<int?, bool> hasMoreByCategory,
    required Map<int?, bool> isLoadingByCategory,
    required Map<int?, Failure?> errorsByCategory,
    required Map<int?, int> currentPageByCategory,
    List<PostEntity>? searchResults,
    String? searchQuery,
    required int searchPage,
    required bool hasMoreSearchResults,
    required bool isLoadingSearch,
    Failure? searchError,
    required int? categoryId,
    required bool isLoading,
  }) {
    final updatedLoading = Map<int?, bool>.from(isLoadingByCategory);
    updatedLoading[categoryId] = isLoading;
    
    return _buildLoadedState(
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
    );
  }

  NewsState _updateCategoryPosts({
    required Map<int?, List<PostEntity>> postsByCategory,
    int? selectedCategoryId,
    required Map<int?, bool> hasMoreByCategory,
    required Map<int?, bool> isLoadingByCategory,
    required Map<int?, Failure?> errorsByCategory,
    required Map<int?, int> currentPageByCategory,
    List<PostEntity>? searchResults,
    String? searchQuery,
    required int searchPage,
    required bool hasMoreSearchResults,
    required bool isLoadingSearch,
    Failure? searchError,
    required int? categoryId,
    required List<PostEntity> newPosts,
    required int page,
    required bool hasMore,
    required bool isLoading,
    Failure? error,
  }) {
    final updatedPostsByCategory = Map<int?, List<PostEntity>>.from(postsByCategory);
    updatedPostsByCategory[categoryId] = newPosts;
    final updatedPages = Map<int?, int>.from(currentPageByCategory);
    updatedPages[categoryId] = page;
    final updatedHasMore = Map<int?, bool>.from(hasMoreByCategory);
    updatedHasMore[categoryId] = hasMore;
    final updatedLoading = Map<int?, bool>.from(isLoadingByCategory);
    updatedLoading[categoryId] = isLoading;
    final updatedErrors = Map<int?, Failure?>.from(errorsByCategory);
    updatedErrors[categoryId] = error;
    
    return _buildLoadedState(
      posts: newPosts,
      postsByCategory: updatedPostsByCategory,
      selectedCategoryId: selectedCategoryId,
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
    );
  }

  NewsState _updateCategoryError({
    required List<PostEntity> posts,
    required Map<int?, List<PostEntity>> postsByCategory,
    int? selectedCategoryId,
    required Map<int?, bool> hasMoreByCategory,
    required Map<int?, bool> isLoadingByCategory,
    required Map<int?, Failure?> errorsByCategory,
    required Map<int?, int> currentPageByCategory,
    List<PostEntity>? searchResults,
    String? searchQuery,
    required int searchPage,
    required bool hasMoreSearchResults,
    required bool isLoadingSearch,
    Failure? searchError,
    required int? categoryId,
    required bool isLoading,
    required Failure? error,
  }) {
    final updatedLoading = Map<int?, bool>.from(isLoadingByCategory);
    updatedLoading[categoryId] = isLoading;
    final updatedErrors = Map<int?, Failure?>.from(errorsByCategory);
    updatedErrors[categoryId] = error;
    
    return _buildLoadedState(
      posts: posts,
      postsByCategory: postsByCategory,
      selectedCategoryId: selectedCategoryId,
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
    );
  }

  NewsState _buildLoadedState({
    required List<PostEntity> posts,
    required Map<int?, List<PostEntity>> postsByCategory,
    int? selectedCategoryId,
    required Map<int?, bool> hasMoreByCategory,
    required Map<int?, bool> isLoadingByCategory,
    required Map<int?, Failure?> errorsByCategory,
    required Map<int?, int> currentPageByCategory,
    List<PostEntity>? searchResults,
    String? searchQuery,
    required int searchPage,
    required bool hasMoreSearchResults,
    required bool isLoadingSearch,
    Failure? searchError,
  }) {
    return NewsState.loaded(
      posts: posts,
      postsByCategory: postsByCategory,
      selectedCategoryId: selectedCategoryId,
      hasMoreByCategory: hasMoreByCategory,
      isLoadingByCategory: isLoadingByCategory,
      errorsByCategory: errorsByCategory,
      currentPageByCategory: currentPageByCategory,
      searchResults: searchResults,
      searchQuery: searchQuery,
      searchPage: searchPage,
      hasMoreSearchResults: hasMoreSearchResults,
      isLoadingSearch: isLoadingSearch,
      searchError: searchError,
    );
  }

  NewsState _updateSearchLoading({
    required List<PostEntity> posts,
    required Map<int?, List<PostEntity>> postsByCategory,
    int? selectedCategoryId,
    required Map<int?, bool> hasMoreByCategory,
    required Map<int?, bool> isLoadingByCategory,
    required Map<int?, Failure?> errorsByCategory,
    required Map<int?, int> currentPageByCategory,
    List<PostEntity>? searchResults,
    String? searchQuery,
    required int searchPage,
    required bool hasMoreSearchResults,
    Failure? searchError,
  }) {
    return _buildLoadedState(
      posts: posts,
      postsByCategory: postsByCategory,
      selectedCategoryId: selectedCategoryId,
      hasMoreByCategory: hasMoreByCategory,
      isLoadingByCategory: isLoadingByCategory,
      errorsByCategory: errorsByCategory,
      currentPageByCategory: currentPageByCategory,
      searchResults: searchResults,
      searchQuery: searchQuery,
      searchPage: searchPage,
      hasMoreSearchResults: hasMoreSearchResults,
      isLoadingSearch: true,
      searchError: searchError,
    );
  }

  NewsState _updateSearchResults({
    required List<PostEntity> posts,
    required Map<int?, List<PostEntity>> postsByCategory,
    int? selectedCategoryId,
    required Map<int?, bool> hasMoreByCategory,
    required Map<int?, bool> isLoadingByCategory,
    required Map<int?, Failure?> errorsByCategory,
    required Map<int?, int> currentPageByCategory,
    List<PostEntity>? searchResults,
    String? searchQuery,
    required int searchPage,
    required bool hasMoreSearchResults,
    Failure? searchError,
  }) {
    return _buildLoadedState(
      posts: posts,
      postsByCategory: postsByCategory,
      selectedCategoryId: selectedCategoryId,
      hasMoreByCategory: hasMoreByCategory,
      isLoadingByCategory: isLoadingByCategory,
      errorsByCategory: errorsByCategory,
      currentPageByCategory: currentPageByCategory,
      searchResults: searchResults,
      searchQuery: searchQuery,
      searchPage: searchPage,
      hasMoreSearchResults: hasMoreSearchResults,
      isLoadingSearch: false,
      searchError: searchError,
    );
  }

  NewsState _updateSearchError({
    required List<PostEntity> posts,
    required Map<int?, List<PostEntity>> postsByCategory,
    int? selectedCategoryId,
    required Map<int?, bool> hasMoreByCategory,
    required Map<int?, bool> isLoadingByCategory,
    required Map<int?, Failure?> errorsByCategory,
    required Map<int?, int> currentPageByCategory,
    List<PostEntity>? searchResults,
    String? searchQuery,
    required int searchPage,
    required bool hasMoreSearchResults,
    required Failure? searchError,
  }) {
    return _buildLoadedState(
      posts: posts,
      postsByCategory: postsByCategory,
      selectedCategoryId: selectedCategoryId,
      hasMoreByCategory: hasMoreByCategory,
      isLoadingByCategory: isLoadingByCategory,
      errorsByCategory: errorsByCategory,
      currentPageByCategory: currentPageByCategory,
      searchResults: searchResults,
      searchQuery: searchQuery,
      searchPage: searchPage,
      hasMoreSearchResults: hasMoreSearchResults,
      isLoadingSearch: false,
      searchError: searchError,
    );
  }

  bool _isCacheFresh(DateTime? cacheTimestamp) {
    if (cacheTimestamp == null) return false;
    final now = DateTime.now();
    final difference = now.difference(cacheTimestamp);
    return difference.inMinutes < 5;
  }
}
