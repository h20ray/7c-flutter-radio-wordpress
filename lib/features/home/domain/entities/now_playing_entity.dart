import 'package:equatable/equatable.dart';

class NowPlayingEntity extends Equatable {
  final String title;
  final String artist;
  final String? albumArtUrl;
  final bool isPlaying;
  final bool hasFreshMetadata;

  const NowPlayingEntity({
    required this.title,
    required this.artist,
    this.albumArtUrl,
    required this.isPlaying,
    required this.hasFreshMetadata,
  });

  NowPlayingEntity copyWith({
    String? title,
    String? artist,
    String? albumArtUrl,
    bool? isPlaying,
    bool? hasFreshMetadata,
  }) {
    return NowPlayingEntity(
      title: title ?? this.title,
      artist: artist ?? this.artist,
      albumArtUrl: albumArtUrl ?? this.albumArtUrl,
      isPlaying: isPlaying ?? this.isPlaying,
      hasFreshMetadata: hasFreshMetadata ?? this.hasFreshMetadata,
    );
  }

  @override
  List<Object?> get props => [
    title,
    artist,
    albumArtUrl,
    isPlaying,
    hasFreshMetadata,
  ];
}
