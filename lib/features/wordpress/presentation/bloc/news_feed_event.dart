part of 'news_feed_bloc.dart';

@freezed
class NewsFeedEvent with _$NewsFeedEvent {
  const factory NewsFeedEvent.getPosts({
    @Default(false) bool forceRefresh,
    int? categoryId,
    @Default(false) bool useNewsPageLimit,
  }) = GetPostsEvent;
  
  const factory NewsFeedEvent.loadMorePosts({
    int? categoryId,
  }) = LoadMorePostsEvent;
  
  const factory NewsFeedEvent.loadCachedData() = LoadCachedDataEvent;
  
  const factory NewsFeedEvent.savePostOffline(PostEntity post) = SavePostOfflineEvent;
  
  const factory NewsFeedEvent.removePostOffline(int postId) = RemovePostOfflineEvent;
  
  const factory NewsFeedEvent.checkPostOfflineStatus(int postId) = CheckPostOfflineStatusEvent;
}
