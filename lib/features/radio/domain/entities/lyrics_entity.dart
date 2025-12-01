import 'package:equatable/equatable.dart';

class LyricsEntity extends Equatable {
  final String lyrics;
  final String artist;
  final String title;
  final String source;

  const LyricsEntity({
    required this.lyrics,
    required this.artist,
    required this.title,
    required this.source,
  });

  @override
  List<Object?> get props => [lyrics, artist, title, source];
}

