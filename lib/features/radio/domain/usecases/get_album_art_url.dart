import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../repositories/album_art_repository.dart';

/// Use case for getting album art URL
class GetAlbumArtUrl {
  final AlbumArtRepository repository;

  GetAlbumArtUrl(this.repository);

  /// Get album art URL for the given artist and title
  /// Returns Either[Failure, String?] where String? is the album art URL
  /// or null if no album art is found (will use fallback)
  Future<Either<Failure, String?>> call(String artist, String title) async {
    try {
      final albumArtUrl = await repository.getAlbumArtUrl(artist, title);
      return Right(albumArtUrl);
    } catch (e) {
      return Left(ServerFailure('Failed to get album art: ${e.toString()}'));
    }
  }
}

