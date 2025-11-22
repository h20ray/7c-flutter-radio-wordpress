part of 'shoutbox_bloc.dart';

@freezed
class ShoutboxEvent with _$ShoutboxEvent {
  const factory ShoutboxEvent.getMessages({
    @Default(0) int afterId,
    @Default(50) int limit,
  }) = GetMessagesEvent;
  const factory ShoutboxEvent.sendMessage({
    required String username,
    required String message,
  }) = SendMessageEvent;
  const factory ShoutboxEvent.deleteMessage(int id) = DeleteMessageEvent;
}

