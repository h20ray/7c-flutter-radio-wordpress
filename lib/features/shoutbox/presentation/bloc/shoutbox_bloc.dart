import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/shoutbox_message_entity.dart';
import '../../domain/usecases/get_shoutbox_messages.dart';
import '../../domain/usecases/send_shoutbox_message.dart';
import '../../domain/usecases/delete_shoutbox_message.dart';

part 'shoutbox_bloc.freezed.dart';
part 'shoutbox_event.dart';
part 'shoutbox_state.dart';

class ShoutboxBloc extends Bloc<ShoutboxEvent, ShoutboxState> {
  final GetShoutboxMessages getMessages;
  final SendShoutboxMessage sendMessage;
  final DeleteShoutboxMessage deleteMessage;

  ShoutboxBloc({
    required this.getMessages,
    required this.sendMessage,
    required this.deleteMessage,
  }) : super(const ShoutboxState.initial()) {
    on<GetMessagesEvent>(_onGetMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<DeleteMessageEvent>(_onDeleteMessage);
  }

  Future<void> _onGetMessages(
    GetMessagesEvent event,
    Emitter<ShoutboxState> emit,
  ) async {
    emit(const ShoutboxState.loading());
    final result = await getMessages(afterId: event.afterId, limit: event.limit);
    result.fold(
      (failure) => emit(ShoutboxState.error(failure)),
      (messages) => emit(ShoutboxState.loaded(messages)),
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ShoutboxState> emit,
  ) async {
    final result = await sendMessage(
      username: event.username,
      message: event.message,
    );
    result.fold(
      (failure) => emit(ShoutboxState.error(failure)),
      (message) {
        state.maybeWhen(
          loaded: (currentMessages) {
            emit(ShoutboxState.loaded([message, ...currentMessages]));
          },
          orElse: () {
            emit(ShoutboxState.loaded([message]));
          },
        );
      },
    );
  }

  Future<void> _onDeleteMessage(
    DeleteMessageEvent event,
    Emitter<ShoutboxState> emit,
  ) async {
    final result = await deleteMessage(event.id);
    result.fold(
      (failure) => emit(ShoutboxState.error(failure)),
      (unit) {
        state.maybeWhen(
          loaded: (currentMessages) {
            final updatedMessages = currentMessages.where((m) => m.id != event.id).toList();
            emit(ShoutboxState.loaded(updatedMessages));
          },
          orElse: () {},
        );
      },
    );
  }
}

