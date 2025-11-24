import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../config/radio_config.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../domain/entities/now_playing_entity.dart';
import '../../domain/repositories/home_radio_repository.dart';
import '../datasources/home_radio_metadata_datasource.dart';

class HomeRadioRepositoryImpl implements HomeRadioRepository {
  final HomeRadioMetadataDataSource metadataDataSource;

  const HomeRadioRepositoryImpl({required this.metadataDataSource});

  @override
  Stream<Either<Failure, NowPlayingEntity>> watchNowPlaying() async* {
    try {
      await for (final player in metadataDataSource.watchNowPlaying()) {
        final title =
            _sanitize(player.currentTitle) ?? RadioConfig.fallbackTitle;
        final artist =
            _sanitize(player.currentArtist) ?? RadioConfig.fallbackArtist;
        final entity = NowPlayingEntity(
          title: title,
          artist: artist,
          albumArtUrl: _sanitize(player.currentAlbumArtUrl),
          isPlaying: player.isPlaying,
          hasFreshMetadata: player.hasMetadata,
        );
        yield Right(entity);
      }
    } catch (error, stackTrace) {
      DebugLogger.logError(
        'HomeRadioRepositoryImpl.watchNowPlaying failed',
        error: error,
        stackTrace: stackTrace,
        tag: 'HomeRadioRepository',
      );
      yield Left(ServerFailure(error.toString()));
    }
  }

  String? _sanitize(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
