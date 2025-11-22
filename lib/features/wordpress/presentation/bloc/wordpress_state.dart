part of 'wordpress_bloc.dart';

@freezed
class WordPressState with _$WordPressState {
  const factory WordPressState.initial() = _Initial;
  const factory WordPressState.loading() = _Loading;
  const factory WordPressState.loaded(List<PostEntity> posts) = _Loaded;
  const factory WordPressState.error(Failure failure) = _Error;
}

