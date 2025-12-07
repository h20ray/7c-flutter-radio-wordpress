import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/song_history_model.dart';
import '../services/azuracast_detection_service.dart';

abstract class SongHistoryAzuracastDataSource {
  Future<List<SongHistoryModel>> getSongHistory({
    required String streamUrl,
    int limit = 100,
  });
}

class SongHistoryAzuracastDataSourceImpl
    implements SongHistoryAzuracastDataSource {
  final Dio dio;

  SongHistoryAzuracastDataSourceImpl({required this.dio});

  @override
  Future<List<SongHistoryModel>> getSongHistory({
    required String streamUrl,
    int limit = 100,
  }) async {
    if (streamUrl.isEmpty) {
      throw const ServerException('Stream URL is required to detect Azuracast configuration');
    }

    final detectionService = AzuraCastDetectionService.instance;
    
    if (!detectionService.isLikelyAzuraCastUrl(streamUrl)) {
      throw const ServerException('Stream URL does not appear to be from an Azuracast instance');
    }

    final detection = await detectionService.detectFromStreamUrl(streamUrl);
    final baseUrl = detection['base_url'];
    final stationId = detection['station_id'];

    if (baseUrl == null || baseUrl.isEmpty || stationId == null || stationId.isEmpty) {
      throw const ServerException(
        'Failed to detect Azuracast configuration from stream URL. '
        'Please ensure the stream URL is from a valid Azuracast instance.',
      );
    }

    try {
      final cleanBaseUrl = baseUrl.endsWith('/') 
          ? baseUrl.substring(0, baseUrl.length - 1) 
          : baseUrl;
      
      // Use /nowplaying endpoint like WordPress plugin - it includes song_history
      // WordPress uses: {api_base_url}/station/{station_short_name}/nowplaying
      // If api_base_url includes /api, use it directly, otherwise add /api
      // Based on WordPress plugin, the structure is: /api/station/{id}/nowplaying
      final url = '$cleanBaseUrl/api/station/$stationId/nowplaying';

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'User-Agent': 'RadioPlayerFlutter/1.0.0',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is! Map<String, dynamic>) {
          throw const ServerException('Invalid response format from Azuracast API');
        }
        
        // The /nowplaying endpoint returns song_history array directly (not nested in 'data')
        // Note: /nowplaying typically returns 5-10 recent songs (configurable in Azuracast)
        // We apply the limit client-side since the endpoint doesn't support a limit parameter
        final List<dynamic> history = data['song_history'] ?? [];
        
        if (history.isEmpty) {
          return [];
        }
        
        // Apply limit client-side (take first N items)
        final limitedHistory = history.take(limit).toList();
        
        return limitedHistory.map((item) {
          if (item is! Map<String, dynamic>) {
            return null;
          }
          
          String artist = '';
          String title = '';
          String? art;
          DateTime timestamp = DateTime.now();
          
          final song = item['song'] as Map<String, dynamic>?;
          
          if (song != null) {
            artist = song['artist']?.toString() ?? '';
            title = song['title']?.toString() ?? '';
            art = song['art']?.toString();
          }
          
          // Handle timestamp - can be numeric or string
          final playedAt = item['played_at'];
          if (playedAt != null) {
            if (playedAt is int) {
              timestamp = DateTime.fromMillisecondsSinceEpoch(playedAt * 1000);
            } else if (playedAt is String) {
              timestamp = DateTime.tryParse(playedAt) ?? DateTime.now();
            }
          }
          
          if (artist.isEmpty && title.isEmpty) {
            return null;
          }
          
          final id = '${artist}_${title}_${timestamp.millisecondsSinceEpoch}';

          return SongHistoryModel(
            id: id,
            artist: artist,
            title: title,
            timestamp: timestamp,
            albumArtUrl: art,
          );
        }).whereType<SongHistoryModel>().toList();
      } else {
        throw ServerException('Failed to fetch song history: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final errorData = e.response?.data;
        
        if (statusCode == 404) {
          throw const ServerException('Azuracast station not found. Please check your station ID.');
        } else {
          throw ServerException(
            'Failed to fetch song history: $statusCode - ${errorData?.toString() ?? e.message}',
          );
        }
      } else {
        throw ServerException('Network error: ${e.message}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }
}

