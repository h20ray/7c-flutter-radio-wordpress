import 'package:equatable/equatable.dart';

class RequestEntity extends Equatable {
  final String songTitle;
  final String artist;
  final String? requesterName;
  final String? message;

  const RequestEntity({
    required this.songTitle,
    required this.artist,
    this.requesterName,
    this.message,
  });

  @override
  List<Object?> get props => [songTitle, artist, requesterName, message];
}

