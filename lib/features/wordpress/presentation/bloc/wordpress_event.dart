part of 'wordpress_bloc.dart';

@freezed
class WordPressEvent with _$WordPressEvent {
  const factory WordPressEvent.getPosts() = GetPostsEvent;
}

