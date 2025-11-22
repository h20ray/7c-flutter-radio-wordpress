import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_posts.dart';

part 'wordpress_bloc.freezed.dart';
part 'wordpress_event.dart';
part 'wordpress_state.dart';

class WordPressBloc extends Bloc<WordPressEvent, WordPressState> {
  final GetPosts getPosts;

  WordPressBloc({required this.getPosts}) : super(const WordPressState.initial()) {
    on<GetPostsEvent>(_onGetPosts);
  }

  Future<void> _onGetPosts(
    GetPostsEvent event,
    Emitter<WordPressState> emit,
  ) async {
    emit(const WordPressState.loading());
    final result = await getPosts();
    result.fold(
      (failure) => emit(WordPressState.error(failure)),
      (posts) => emit(WordPressState.loaded(posts)),
    );
  }
}

