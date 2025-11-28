part of 'wordpress_bloc.dart';

@freezed
abstract class WordPressEvent with _$WordPressEvent {
  const WordPressEvent._();
  const factory WordPressEvent.getPosts({
    @Default(false) bool forceRefresh,
    int? categoryId,
  }) = GetPostsEvent;
}

