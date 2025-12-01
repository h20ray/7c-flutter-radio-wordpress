import 'package:equatable/equatable.dart';

class SongHistoryEntity extends Equatable {
  final String id;
  final String artist;
  final String title;
  final DateTime timestamp;
  final String? albumArtUrl;

  const SongHistoryEntity({
    required this.id,
    required this.artist,
    required this.title,
    required this.timestamp,
    this.albumArtUrl,
  });

  @override
  List<Object?> get props => [id, artist, title, timestamp, albumArtUrl];
}

