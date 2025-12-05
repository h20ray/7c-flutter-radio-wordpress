part of 'shoutbox_bloc.dart';

@freezed
class ShoutboxEvent with _$ShoutboxEvent {
  /// Full reload - fetches all messages from the beginning
  /// Used for initial load and pull-to-refresh
  const factory ShoutboxEvent.getMessages({
    @Default(50) int limit,
  }) = GetMessagesEvent;

  /// Incremental refresh - fetches only new messages after lastId
  /// Used for auto-refresh polling (silent background updates)
  const factory ShoutboxEvent.refreshMessages({
    @Default(50) int limit,
  }) = RefreshMessagesEvent;

  /// Send a new message
  const factory ShoutboxEvent.sendMessage({
    required String username,
    required String message,
  }) = SendMessageEvent;

  /// Delete a message (admin only)
  const factory ShoutboxEvent.deleteMessage(int id) = DeleteMessageEvent;
}
