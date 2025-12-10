import '../../domain/entities/notification_item.dart';

class NotificationItemModel extends NotificationItem {
  const NotificationItemModel({
    required super.id,
    required super.kind,
    required super.title,
    required super.body,
    required super.createdAt,
    super.isRead = false,
    super.artist,
    super.trackTitle,
    super.requestId,
  });

  NotificationItemModel copyWithModel({
    String? id,
    NotificationKind? kind,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? isRead,
    String? artist,
    String? trackTitle,
    String? requestId,
  }) {
    return NotificationItemModel(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      artist: artist ?? this.artist,
      trackTitle: trackTitle ?? this.trackTitle,
      requestId: requestId ?? this.requestId,
    );
  }
}
