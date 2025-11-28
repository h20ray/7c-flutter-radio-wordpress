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

  WordPressBloc({required this.getPosts})
    : super(const WordPressState.initial()) {
    on<GetPostsEvent>(_onGetPosts);
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
  ) async {
    final existingPosts = postsByCategory[categoryId] ?? [];
    
    if (event.forceRefresh) {
      final updatedLoading = Map<int?, bool>.from(isLoadingByCategory);
      updatedLoading[categoryId] = true;
      final updatedErrors = Map<int?, Failure?>.from(errorsByCategory);
      updatedErrors[categoryId] = null;
      
      emit(WordPressState.loaded(
        posts: currentPosts,
        postsByCategory: postsByCategory,
        selectedCategoryId: categoryId,
        hasMoreByCategory: hasMoreByCategory,
        isLoadingByCategory: updatedLoading,
        errorsByCategory: updatedErrors,
      ));
      
      final result = await getPosts(forceRefresh: true, categoryId: categoryId);
      await result.fold((failure) async {
        final fallback = await getPosts.getCachedPosts(categoryId: categoryId);
        final updatedPostsByCategory = Map<int?, List<PostEntity>>.from(postsByCategory);
        final updatedLoading2 = Map<int?, bool>.from(isLoadingByCategory);
        final updatedErrors2 = Map<int?, Failure?>.from(errorsByCategory);
        
        if (fallback != null && fallback.isNotEmpty) {
          updatedPostsByCategory[categoryId] = fallback;
          updatedLoading2[categoryId] = false;
          updatedErrors2[categoryId] = null;
          emit(WordPressState.loaded(
            posts: fallback,
            postsByCategory: updatedPostsByCategory,
            selectedCategoryId: categoryId,
            hasMoreByCategory: hasMoreByCategory,
            isLoadingByCategory: updatedLoading2,
            errorsByCategory: updatedErrors2,
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
          ));
        }
      }, (posts) async {
        final updatedPostsByCategory = Map<int?, List<PostEntity>>.from(postsByCategory);
        updatedPostsByCategory[categoryId] = posts;
        final updatedLoading = Map<int?, bool>.from(isLoadingByCategory);
        updatedLoading[categoryId] = false;
        final updatedErrors = Map<int?, Failure?>.from(errorsByCategory);
        updatedErrors[categoryId] = null;
        
        emit(WordPressState.loaded(
          posts: posts,
          postsByCategory: updatedPostsByCategory,
          selectedCategoryId: categoryId,
          hasMoreByCategory: hasMoreByCategory,
          isLoadingByCategory: updatedLoading,
          errorsByCategory: updatedErrors,
        ));
      });
      return;
    }

    final cacheTimestamp = await getPosts.getCacheTimestamp(categoryId: categoryId);
    final isCacheFresh = _isCacheFresh(cacheTimestamp);
    
    if (isCacheFresh && existingPosts.isNotEmpty) {
      final updatedPostsByCategory = Map<int?, List<PostEntity>>.from(postsByCategory);
      if (!updatedPostsByCategory.containsKey(categoryId)) {
        updatedPostsByCategory[categoryId] = existingPosts;
      }
      emit(WordPressState.loaded(
        posts: existingPosts,
        postsByCategory: updatedPostsByCategory,
        selectedCategoryId: categoryId,
        hasMoreByCategory: hasMoreByCategory,
        isLoadingByCategory: isLoadingByCategory,
        errorsByCategory: errorsByCategory,
      ));
      
      _fetchAndUpdateCacheInBackground(categoryId: categoryId);
      return;
    }

    final cachedPosts = await getPosts.getCachedPosts(categoryId: categoryId);

    if (cachedPosts != null && cachedPosts.isNotEmpty) {
      final updatedPostsByCategory = Map<int?, List<PostEntity>>.from(postsByCategory);
      updatedPostsByCategory[categoryId] = cachedPosts;
      
      emit(WordPressState.loaded(
        posts: cachedPosts,
        postsByCategory: updatedPostsByCategory,
        selectedCategoryId: categoryId,
        hasMoreByCategory: hasMoreByCategory,
        isLoadingByCategory: isLoadingByCategory,
        errorsByCategory: errorsByCategory,
      ));
      
      if (isCacheFresh) {
        return;
      }
      
      final result = await getPosts(forceRefresh: true, categoryId: categoryId);
      result.fold((failure) {
        final updatedErrors = Map<int?, Failure?>.from(errorsByCategory);
        updatedErrors[categoryId] = failure;
        emit(WordPressState.loaded(
          posts: cachedPosts,
          postsByCategory: updatedPostsByCategory,
          selectedCategoryId: categoryId,
          hasMoreByCategory: hasMoreByCategory,
          isLoadingByCategory: isLoadingByCategory,
          errorsByCategory: updatedErrors,
        ));
      }, (posts) {
        if (_hasNewPosts(cachedPosts, posts)) {
          final updatedPostsByCategory2 = Map<int?, List<PostEntity>>.from(updatedPostsByCategory);
          updatedPostsByCategory2[categoryId] = posts;
          emit(WordPressState.loaded(
            posts: posts,
            postsByCategory: updatedPostsByCategory2,
            selectedCategoryId: categoryId,
            hasMoreByCategory: hasMoreByCategory,
            isLoadingByCategory: isLoadingByCategory,
            errorsByCategory: errorsByCategory,
          ));
        }
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
    ));
    
    final result = await getPosts(categoryId: categoryId);
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
        ));
      },
      (posts) {
        final updatedPostsByCategory = Map<int?, List<PostEntity>>.from(postsByCategory);
        updatedPostsByCategory[categoryId] = posts;
        final updatedLoading2 = Map<int?, bool>.from(updatedLoading);
        updatedLoading2[categoryId] = false;
        final updatedErrors2 = Map<int?, Failure?>.from(updatedErrors);
        updatedErrors2[categoryId] = null;
        emit(WordPressState.loaded(
          posts: posts,
          postsByCategory: updatedPostsByCategory,
          selectedCategoryId: categoryId,
          hasMoreByCategory: hasMoreByCategory,
          isLoadingByCategory: updatedLoading2,
          errorsByCategory: updatedErrors2,
        ));
      },
    );
  }

  void _fetchAndUpdateCacheInBackground({int? categoryId}) async {
    try {
      final posts = await getPosts(forceRefresh: true, categoryId: categoryId);
      posts.fold((_) {}, (_) {});
    } catch (e) {
      // Silently fail background cache update
    }
  }

  bool _isCacheFresh(DateTime? timestamp) {
    if (timestamp == null) return false;
    return DateTime.now().difference(timestamp) < NewsConfig.newsCacheTTL;
  }

  bool _hasNewPosts(List<PostEntity> previous, List<PostEntity> next) {
    if (previous.length != next.length) {
      return true;
    }
    final previousIds = previous.map((post) => post.id).toSet();
    final nextIds = next.map((post) => post.id).toSet();
    if (previousIds.length != nextIds.length) {
      return true;
    }
    for (final id in previousIds) {
      if (!nextIds.contains(id)) {
        return true;
      }
    }
    return false;
  }
}
