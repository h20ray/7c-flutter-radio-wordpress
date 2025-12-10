import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/notification_item.dart';
import '../../domain/repositories/notification_center_repository.dart';
import 'notification_center_state.dart';

class NotificationCenterCubit extends Cubit<NotificationCenterState> {
  final NotificationCenterRepository repository;
  StreamSubscription<List<NotificationItem>>? _subscription;

  NotificationCenterCubit({required this.repository})
    : super(const NotificationCenterState()) {
    _subscription = repository.watch().listen((items) {
      emit(state.copyWith(items: items));
    });
  }

  Future<void> markRead(String id) async {
    await repository.markRead(id);
  }

  Future<void> markAllRead() async {
    await repository.markAllRead();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
