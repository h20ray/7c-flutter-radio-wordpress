import '../../domain/entities/song_history_entity.dart';

class SongHistoryModel extends SongHistoryEntity {
  const SongHistoryModel({
    required super.id,
    required super.artist,
    required super.title,
    required super.timestamp,
    super.albumArtUrl,
  });

  factory SongHistoryModel.fromEntity(SongHistoryEntity entity) {
    return SongHistoryModel(
      id: entity.id,
      artist: entity.artist,
      title: entity.title,
      timestamp: entity.timestamp,
      albumArtUrl: entity.albumArtUrl,
    );
  }

  factory SongHistoryModel.fromMap(Map<String, dynamic> map) {
    return SongHistoryModel(
      id: map['id'] as String,
      artist: map['artist'] as String,
      title: map['title'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      albumArtUrl: map['albumArtUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'artist': artist,
      'title': title,
      'timestamp': timestamp.toIso8601String(),
      'albumArtUrl': albumArtUrl,
    };
  }
}

