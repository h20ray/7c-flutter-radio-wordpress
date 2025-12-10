import 'package:equatable/equatable.dart';

class PendingRequest extends Equatable {
  final String? requestId;
  final String artist;
  final String title;
  final DateTime submittedAt;

  const PendingRequest({
    required this.requestId,
    required this.artist,
    required this.title,
    required this.submittedAt,
  });

  @override
  List<Object?> get props => [requestId, artist, title, submittedAt];
}
