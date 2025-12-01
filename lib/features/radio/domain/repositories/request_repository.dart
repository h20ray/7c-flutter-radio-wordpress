import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

class RequestableTrackEntity {
  final String requestId;
  final String title;
  final String artist;
  final String? albumArtUrl;

  RequestableTrackEntity({
    required this.requestId,
    required this.title,
    required this.artist,
    this.albumArtUrl,
  });
}

abstract class RequestRepository {
  Future<Either<Failure, List<RequestableTrackEntity>>> listRequestableTracks({
    required String streamUrl,
    String? query,
    int page = 1,
    int limit = 20,
    bool random = false,
  });

  Future<Either<Failure, Unit>> submitRequest({
    required String streamUrl,
    required String requestId,
    String? title,
    String? artist,
  });
}

