import 'package:rxdart/rxdart.dart';

import '../models/notification_item_model.dart';

class NotificationLocalDataSource {
  final int maxItems;
  final BehaviorSubject<List<NotificationItemModel>> _subject =
      BehaviorSubject.seeded(const []);

  NotificationLocalDataSource({this.maxItems = 30});

  Stream<List<NotificationItemModel>> watch() => _subject.stream;

  List<NotificationItemModel> get _items => _subject.value;

  void add(NotificationItemModel item) {
    final updated = [item, ..._items];
    _subject.add(updated.take(maxItems).toList());
  }

  void markRead(String id) {
    final updated = _items
        .map((item) => item.id == id ? item.copyWithModel(isRead: true) : item)
        .toList();
    _subject.add(updated);
  }

  void markAllRead() {
    final updated = _items
        .map((item) => item.copyWithModel(isRead: true))
        .toList();
    _subject.add(updated);
  }

  void clear() {
    _subject.add(const []);
  }
}
