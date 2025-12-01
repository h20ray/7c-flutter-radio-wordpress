import '../../domain/entities/lyrics_entity.dart';

class LyricsModel extends LyricsEntity {
  const LyricsModel({
    required super.lyrics,
    required super.artist,
    required super.title,
    required super.source,
  });

  factory LyricsModel.fromEntity(LyricsEntity entity) {
    return LyricsModel(
      lyrics: entity.lyrics,
      artist: entity.artist,
      title: entity.title,
      source: entity.source,
    );
  }

  factory LyricsModel.fromMap(Map<String, dynamic> map) {
    return LyricsModel(
      lyrics: map['lyrics'] as String,
      artist: map['artist'] as String,
      title: map['title'] as String,
      source: map['source'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lyrics': lyrics,
      'artist': artist,
      'title': title,
      'source': source,
    };
  }
}

