import 'package:equatable/equatable.dart';

enum NotificationKind { requestPlayed }

class NotificationItem extends Equatable {
  final String id;
  final NotificationKind kind;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String? artist;
  final String? trackTitle;
  final String? requestId;

  const NotificationItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.artist,
    this.trackTitle,
    this.requestId,
  });

  NotificationItem copyWith({
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
    return NotificationItem(
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

  @override
  List<Object?> get props => [
    id,
    kind,
    title,
    body,
    createdAt,
    isRead,
    artist,
    trackTitle,
    requestId,
  ];
}
