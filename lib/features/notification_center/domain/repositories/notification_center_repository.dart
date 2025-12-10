import '../entities/notification_item.dart';

abstract class NotificationCenterRepository {
  Stream<List<NotificationItem>> watch();
  Future<void> add(NotificationItem item, {bool pushToSystem = false});
  Future<void> markRead(String id);
  Future<void> markAllRead();
  Future<void> clear();
}
