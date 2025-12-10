import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import '../../../../config/radio_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/request_repository.dart';
import '../../presentation/bloc/radio_bloc.dart';
import '../datasources/request_azuracast_data_source.dart';
import '../datasources/request_remote_data_source.dart';
import '../services/azuracast_detection_service.dart';
import '../../../notification_center/domain/entities/pending_request.dart';
import '../../../notification_center/domain/repositories/pending_request_tracker.dart';

class RequestRepositoryImpl implements RequestRepository {
  final RequestRemoteDataSource remoteDataSource;
  final RequestAzuracastDataSource? azuracastDataSource;
  final PendingRequestTracker pendingRequestTracker;

  RequestRepositoryImpl({
    required this.remoteDataSource,
    this.azuracastDataSource,
    required this.pendingRequestTracker,
  });

  String? _getStreamUrl() {
    try {
      final radioBloc = GetIt.instance<RadioBloc>();
      final radioState = radioBloc.state;

      String? streamUrl;
      radioState.maybeWhen(
        loaded: (radioEntity) {
          streamUrl = radioEntity.streamUrl;
        },
        orElse: () {},
      );

      return streamUrl;
    } catch (e) {
      return null;
    }
  }

  bool _shouldUseAzuracast() {
    const mode = RadioConfig.requestMode;
    if (mode == 'webview') return false;
    if (mode == 'azuracast') return true;

    final streamUrl = _getStreamUrl();
    if (streamUrl == null || streamUrl.isEmpty) return false;

    final detectionService = AzuraCastDetectionService.instance;
    return detectionService.isLikelyAzuraCastUrl(streamUrl);
  }

  @override
  Future<Either<Failure, List<RequestableTrackEntity>>> listRequestableTracks({
    required String streamUrl,
    String? query,
    int page = 1,
    int limit = 20,
    bool random = false,
  }) async {
    if (!_shouldUseAzuracast() || azuracastDataSource == null) {
      return const Left(
        UnsupportedFailure(
          'Azuracast request mode is not available. Please use WebView mode.',
        ),
      );
    }

    try {
      final tracks = await azuracastDataSource!.listRequestableTracks(
        streamUrl: streamUrl,
        query: query,
        page: page,
        limit: limit,
        random: random,
      );

      final entities = tracks
          .map(
            (track) => RequestableTrackEntity(
              requestId: track.requestId,
              title: track.title,
              artist: track.artist,
              albumArtUrl: track.albumArtUrl,
            ),
          )
          .toList();

      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> submitRequest({
    required String streamUrl,
    required String requestId,
    String? title,
    String? artist,
  }) async {
    if (!_shouldUseAzuracast() || azuracastDataSource == null) {
      return const Left(
        UnsupportedFailure(
          'Azuracast request mode is not available. Please use WebView mode.',
        ),
      );
    }

    try {
      await azuracastDataSource!.submitRequest(
        streamUrl: streamUrl,
        requestId: requestId,
        title: title,
        artist: artist,
      );
      pendingRequestTracker.record(
        PendingRequest(
          requestId: requestId,
          artist: artist ?? '',
          title: title ?? '',
          submittedAt: DateTime.now(),
        ),
      );
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
