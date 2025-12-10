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

  /// Maximum number of messages to keep in memory to prevent unbounded growth.
  /// Older messages are trimmed when this limit is exceeded.
  static const int _maxMessagesInMemory = 100;

  /// Track if a fetch is in progress to prevent duplicate requests
  bool _isFetching = false;

  /// Track if a send is in progress
  bool _isSending = false;

  ShoutboxBloc({
    required this.getMessages,
    required this.sendMessage,
    required this.deleteMessage,
  }) : super(const ShoutboxState.initial()) {
    on<GetMessagesEvent>(_onGetMessages);
    on<RefreshMessagesEvent>(_onRefreshMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<DeleteMessageEvent>(_onDeleteMessage);
    on<ClearMessagesEvent>(_onClearMessages);
  }

  /// Get current messages from any state
  List<ShoutboxMessageEntity> _getCurrentMessages() {
    return state.maybeWhen(
      loaded: (messages, _) => messages,
      refreshing: (messages, _) => messages,
      sending: (messages, _) => messages,
      orElse: () => [],
    );
  }

  /// Get current lastId from any state
  int _getCurrentLastId() {
    return state.maybeWhen(
      loaded: (_, lastId) => lastId,
      refreshing: (_, lastId) => lastId,
      sending: (_, lastId) => lastId,
      orElse: () => 0,
    );
  }

  /// Calculate max ID from a list of messages
  int _calculateMaxId(List<ShoutboxMessageEntity> messages) {
    if (messages.isEmpty) return 0;
    return messages.map((m) => m.id).reduce((a, b) => a > b ? a : b);
  }

  /// Merge new messages with existing, removing duplicates, sorting by ID asc,
  /// and trimming to [_maxMessagesInMemory] to prevent unbounded memory growth.
  List<ShoutboxMessageEntity> _mergeMessages(
    List<ShoutboxMessageEntity> existing,
    List<ShoutboxMessageEntity> newMessages,
  ) {
    final Map<int, ShoutboxMessageEntity> messageMap = {};
    
    // Add existing messages first
    for (final msg in existing) {
      messageMap[msg.id] = msg;
    }
    
    // Add/update with new messages
    for (final msg in newMessages) {
      messageMap[msg.id] = msg;
    }
    
    // Convert to list and sort by ID ascending (oldest first, newest last)
    final merged = messageMap.values.toList();
    merged.sort((a, b) => a.id.compareTo(b.id));
    
    // Trim oldest messages if exceeding limit (keep newest)
    if (merged.length > _maxMessagesInMemory) {
      return merged.sublist(merged.length - _maxMessagesInMemory);
    }
    return merged;
  }

  /// Full reload - replaces all messages (used for initial load and pull-to-refresh)
  Future<void> _onGetMessages(
    GetMessagesEvent event,
    Emitter<ShoutboxState> emit,
  ) async {
    // Prevent duplicate fetches
    if (_isFetching) return;
    _isFetching = true;

    try {
      // Show loading only if we have no messages yet
      final currentMessages = _getCurrentMessages();
      if (currentMessages.isEmpty) {
        emit(const ShoutboxState.loading());
      } else {
        emit(ShoutboxState.refreshing(currentMessages, lastId: _getCurrentLastId()));
      }

      final result = await getMessages(afterId: 0, limit: event.limit);
      
      result.fold(
        (failure) {
          // On error, keep existing messages if we have any
          if (currentMessages.isNotEmpty) {
            emit(ShoutboxState.loaded(currentMessages, lastId: _getCurrentLastId()));
          } else {
            emit(ShoutboxState.error(failure));
          }
        },
        (messages) {
          final lastId = _calculateMaxId(messages);
          emit(ShoutboxState.loaded(messages, lastId: lastId));
        },
      );
    } finally {
      _isFetching = false;
    }
  }

  /// Incremental refresh - fetches only new messages after lastId (used for auto-refresh)
  Future<void> _onRefreshMessages(
    RefreshMessagesEvent event,
    Emitter<ShoutboxState> emit,
  ) async {
    // Skip if already fetching or sending
    if (_isFetching || _isSending) return;
    
    final currentMessages = _getCurrentMessages();
    final currentLastId = _getCurrentLastId();
    
    // Skip if no messages yet (use full load instead)
    if (currentMessages.isEmpty || currentLastId == 0) {
      add(GetMessagesEvent(limit: event.limit));
      return;
    }

    _isFetching = true;

    try {
      // Don't change state during refresh - keep UI stable
      final result = await getMessages(afterId: currentLastId, limit: event.limit);
      
      result.fold(
        (failure) {
          // Silent failure for background refresh - keep current messages
          // Only log the error, don't update UI
        },
        (newMessages) {
          if (newMessages.isNotEmpty) {
            // Merge new messages with existing
            final merged = _mergeMessages(currentMessages, newMessages);
            final newLastId = _calculateMaxId(merged);
            emit(ShoutboxState.loaded(merged, lastId: newLastId));
          }
          // If no new messages, keep current state (no emit needed)
        },
      );
    } finally {
      _isFetching = false;
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ShoutboxState> emit,
  ) async {
    // Prevent duplicate sends
    if (_isSending) return;
    _isSending = true;

    final currentMessages = _getCurrentMessages();
    final currentLastId = _getCurrentLastId();

    try {
      // Show sending state with current messages
      emit(ShoutboxState.sending(currentMessages, lastId: currentLastId));

      final result = await sendMessage(
        username: event.username,
        message: event.message,
      );
      
      result.fold(
        (failure) {
          // On error, return to loaded state with current messages
          emit(ShoutboxState.loaded(currentMessages, lastId: currentLastId));
          // The UI should handle showing error via a separate mechanism (snackbar)
        },
        (newMessage) {
          // Append the new message (oldest first, newest last)
          final updatedMessages = [...currentMessages, newMessage];
          final newLastId = newMessage.id > currentLastId ? newMessage.id : currentLastId;
          emit(ShoutboxState.loaded(updatedMessages, lastId: newLastId));
        },
      );
    } finally {
      _isSending = false;
    }
  }

  Future<void> _onDeleteMessage(
    DeleteMessageEvent event,
    Emitter<ShoutboxState> emit,
  ) async {
    final currentMessages = _getCurrentMessages();
    final currentLastId = _getCurrentLastId();

    // Optimistic delete - remove from UI immediately
    final updatedMessages = currentMessages.where((m) => m.id != event.id).toList();
    emit(ShoutboxState.loaded(updatedMessages, lastId: currentLastId));

    final result = await deleteMessage(event.id);
    
    result.fold(
      (failure) {
        // Restore message on failure
        emit(ShoutboxState.loaded(currentMessages, lastId: currentLastId));
      },
      (_) {
        // Already updated optimistically, nothing to do
      },
    );
  }

  /// Clear all messages from memory (manual cleanup)
  void _onClearMessages(
    ClearMessagesEvent event,
    Emitter<ShoutboxState> emit,
  ) {
    emit(const ShoutboxState.initial());
  }
}
