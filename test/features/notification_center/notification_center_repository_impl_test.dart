import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tujuhcahaya_wprs/features/notification_center/data/datasources/notification_local_data_source.dart';
import 'package:tujuhcahaya_wprs/features/notification_center/data/repositories/notification_center_repository_impl.dart';
import 'package:tujuhcahaya_wprs/features/notification_center/data/services/system_notification_service.dart';
import 'package:tujuhcahaya_wprs/features/notification_center/domain/entities/notification_item.dart';

class _FakeSystemNotificationService extends SystemNotificationService {
  int showCount = 0;

  _FakeSystemNotificationService()
    : super(plugin: FlutterLocalNotificationsPlugin());

  @override
  Future<void> initialize() async {}

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
  }) async {
    showCount += 1;
  }
}

void main() {
  test(
    'adds notification and forwards to system notification service',
    () async {
      final localDataSource = NotificationLocalDataSource(maxItems: 5);
      final systemService = _FakeSystemNotificationService();
      final repository = NotificationCenterRepositoryImpl(
        localDataSource: localDataSource,
        systemNotificationService: systemService,
      );

      final item = NotificationItem(
        id: '1',
        kind: NotificationKind.requestPlayed,
        title: 'Now playing',
        body: 'Artist - Title',
        createdAt: DateTime.now(),
      );

      final futureItems = repository.watch().skip(1).first;
      await repository.add(item, pushToSystem: true);

      final items = await futureItems;
      expect(items.length, 1);
      expect(items.first.title, 'Now playing');
      expect(systemService.showCount, 1);
    },
  );
}
