import 'package:dio/dio.dart';
import 'dart:convert';
import '../../../../config/radio_config.dart';
import '../../../../core/utils/debug_logger.dart';

/// Abstract class for album art remote data source
abstract class AlbumArtRemoteDataSource {
  Future<String?> getAlbumArtUrl(String artist, String title);
}

/// AzuraCast album art data source
class AzuraCastAlbumArtDataSource implements AlbumArtRemoteDataSource {
  final Dio dio;
  final String baseUrl;
  final String stationId;

  AzuraCastAlbumArtDataSource({
    required this.dio,
    required this.baseUrl,
    required this.stationId,
  });

  @override
  Future<String?> getAlbumArtUrl(String artist, String title) async {
    try {
      // Try without cache-busting first for MediaSession compatibility
      final staticArtUrl = '$baseUrl/api/nowplaying/$stationId/art.jpg';
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final artUrl = '$baseUrl/api/nowplaying/$stationId/art/$timestamp.jpg';

      // Try static URL first (better for MediaSession)
      var response = await dio.head(
        staticArtUrl,
        options: Options(
          receiveTimeout: const Duration(milliseconds: RadioConfig.albumArtRequestTimeoutMs),
          sendTimeout: const Duration(milliseconds: RadioConfig.albumArtRequestTimeoutMs),
          followRedirects: true,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      String urlToUse = staticArtUrl;

      // If static URL fails, try timestamped URL
      if (response.statusCode != 200 && response.statusCode != 302) {
        response = await dio.head(
          artUrl,
          options: Options(
            receiveTimeout: const Duration(milliseconds: RadioConfig.albumArtRequestTimeoutMs),
            sendTimeout: const Duration(milliseconds: RadioConfig.albumArtRequestTimeoutMs),
            followRedirects: true,
            validateStatus: (status) {
              return status != null && status < 500;
            },
          ),
        );
        urlToUse = artUrl;
      }

      if (response.statusCode == 200 || response.statusCode == 302) {
        // Get the final URL after redirects for MediaSession compatibility
        String finalUrl = urlToUse;
        if (response.statusCode == 302) {
          final location = response.headers['location']?.first;
          if (location != null) {
            finalUrl = location;
          }
        }

        // For MediaSession compatibility, try to get a direct image URL
        // by making a GET request to resolve any final redirects
        try {
          final getResponse = await dio.get(
            finalUrl,
            options: Options(
              receiveTimeout: const Duration(milliseconds: RadioConfig.albumArtRequestTimeoutMs ~/ 2),
              sendTimeout: const Duration(milliseconds: RadioConfig.albumArtRequestTimeoutMs ~/ 2),
              followRedirects: true,
              validateStatus: (status) => status != null && status < 500,
            ),
          );

          if (getResponse.statusCode == 200) {
            // If we get a 200, the URL is accessible and should work in MediaSession
            DebugLogger.log('[AzuraCastAlbumArt] Album art URL verified: $finalUrl', tag: 'AlbumArtDataSource');
          }
        } catch (e) {
          DebugLogger.log('[AzuraCastAlbumArt] Verification failed, but URL may still work: $finalUrl', tag: 'AlbumArtDataSource');
        }

        return finalUrl;
      }
    } catch (e) {
      DebugLogger.logError('Error fetching AzuraCast album art', error: e, tag: 'AlbumArtDataSource');
    }

    return null;
  }
}

/// Apple Music/iTunes album art data source
class AppleMusicAlbumArtDataSource implements AlbumArtRemoteDataSource {
  final Dio dio;

  AppleMusicAlbumArtDataSource({required this.dio});

  @override
  Future<String?> getAlbumArtUrl(String artist, String title) async {
    try {
      // Clean and encode search terms
      final cleanArtist = Uri.encodeComponent(artist.trim());
      final cleanTitle = Uri.encodeComponent(title.trim());

      // iTunes Search API endpoint
      final url =
          'https://itunes.apple.com/search?term=$cleanArtist+$cleanTitle&media=music&limit=1';

      final response = await dio.get(
        url,
        options: Options(
          receiveTimeout: const Duration(milliseconds: RadioConfig.albumArtRequestTimeoutMs),
          sendTimeout: const Duration(milliseconds: RadioConfig.albumArtRequestTimeoutMs),
        ),
      );

      if (response.statusCode == 200) {
        // Parse the response data - it might be a String or already a Map
        Map<String, dynamic> data;
        if (response.data is String) {
          data = json.decode(response.data as String) as Map<String, dynamic>;
        } else {
          data = response.data as Map<String, dynamic>;
        }

        final results = data['results'] as List?;

        if (results != null && results.isNotEmpty) {
          final track = results.first as Map<String, dynamic>?;

          if (track != null) {
            final artworkUrl = track['artworkUrl100'] as String?;

            if (artworkUrl != null && artworkUrl.isNotEmpty) {
              // Convert to higher resolution (600x600)
              final highResUrl = artworkUrl.replaceAll('100x100', '600x600');
              DebugLogger.log('[AppleMusicAlbumArt] Found album art: $highResUrl', tag: 'AlbumArtDataSource');
              return highResUrl;
            }
          }
        }
      }
    } catch (e) {
      DebugLogger.logError('Error fetching Apple Music album art', error: e, tag: 'AlbumArtDataSource');
    }
    return null;
  }
}

