import '../../domain/entities/notification_item.dart';
import '../../domain/repositories/notification_center_repository.dart';
import '../datasources/notification_local_data_source.dart';
import '../models/notification_item_model.dart';
import '../services/system_notification_service.dart';

class NotificationCenterRepositoryImpl implements NotificationCenterRepository {
  final NotificationLocalDataSource localDataSource;
  final SystemNotificationService systemNotificationService;

  NotificationCenterRepositoryImpl({
    required this.localDataSource,
    required this.systemNotificationService,
  });

  @override
  Stream<List<NotificationItem>> watch() {
    return localDataSource.watch();
  }

  @override
  Future<void> add(NotificationItem item, {bool pushToSystem = false}) async {
    final model = NotificationItemModel(
      id: item.id,
      kind: item.kind,
      title: item.title,
      body: item.body,
      createdAt: item.createdAt,
      isRead: item.isRead,
      artist: item.artist,
      trackTitle: item.trackTitle,
      requestId: item.requestId,
    );
    localDataSource.add(model);

    if (pushToSystem) {
      await systemNotificationService.show(
        id: item.createdAt.millisecondsSinceEpoch % 100000,
        title: item.title,
        body: item.body,
      );
    }
  }

  @override
  Future<void> markRead(String id) async {
    localDataSource.markRead(id);
  }

  @override
  Future<void> markAllRead() async {
    localDataSource.markAllRead();
  }

  @override
  Future<void> clear() async {
    localDataSource.clear();
  }
}
