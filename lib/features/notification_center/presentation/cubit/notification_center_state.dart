import 'package:equatable/equatable.dart';

import '../../domain/entities/notification_item.dart';

class NotificationCenterState extends Equatable {
  final List<NotificationItem> items;

  const NotificationCenterState({this.items = const []});

  NotificationCenterState copyWith({List<NotificationItem>? items}) {
    return NotificationCenterState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
