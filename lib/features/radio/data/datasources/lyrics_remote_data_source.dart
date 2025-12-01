import 'package:dio/dio.dart';
import '../../../../config/radio_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/lyrics_model.dart';

abstract class LyricsRemoteDataSource {
  Future<LyricsModel> getLyrics(String artist, String title);
}

class LyricsRemoteDataSourceImpl implements LyricsRemoteDataSource {
  final ApiClient apiClient;
  final Dio dio;

  LyricsRemoteDataSourceImpl({
    required this.apiClient,
    required this.dio,
  });

  @override
  Future<LyricsModel> getLyrics(String artist, String title) async {
    final provider = RadioConfig.lyricsApiProvider;

    switch (provider) {
      case 'proxy':
        return _getLyricsFromProxy(artist, title);
      case 'wordpress':
        return _getLyricsFromWordPress(artist, title);
      case 'musixmatch':
        return _getLyricsFromMusixmatchDirect(artist, title);
      default:
        throw Exception('Unknown lyrics provider: $provider');
    }
  }

  /// Get lyrics using proxy API with fallback chain (matches WordPress plugin)
  Future<LyricsModel> _getLyricsFromProxy(
    String artist,
    String title,
  ) async {
    final baseUrl = RadioConfig.lyricsProxyApiBaseUrl;
    final fallbackChain = RadioConfig.lyricsProviderFallbackChain;

    Exception? lastError;

    for (final provider in fallbackChain) {
      try {
        final url = '$baseUrl/$provider/lyrics';
        final response = await dio.get(
          url,
          queryParameters: {
            'title': title,
            'artist': artist,
          },
          options: Options(
            headers: {
              'User-Agent': 'RadioPlayerFlutter/1.0.0',
              'Accept': 'application/json',
            },
            receiveTimeout: const Duration(seconds: 10),
          ),
        );

        if (response.statusCode == 200) {
          final data = response.data as Map<String, dynamic>;
          final lyricsData = data['data'] as Map<String, dynamic>?;

          if (lyricsData != null &&
              lyricsData['lyrics'] != null &&
              (lyricsData['lyrics'] as String).trim().isNotEmpty) {
            return LyricsModel(
              lyrics: lyricsData['lyrics'] as String,
              artist: lyricsData['artistName'] as String? ?? artist,
              title: lyricsData['trackName'] as String? ?? title,
              source: lyricsData['searchEngine'] as String? ?? provider,
            );
          }
        }
      } on DioException catch (e) {
        lastError = ServerException('Failed to fetch from $provider: ${e.message}');
        continue;
      } catch (e) {
        lastError = ServerException('Failed to fetch from $provider: $e');
        continue;
      }
    }

    throw lastError ?? ServerException('All lyrics providers failed');
  }

  Future<LyricsModel> _getLyricsFromWordPress(
    String artist,
    String title,
  ) async {
    final response = await apiClient.get(
      '/wp-json/tujuhcahaya/radio/lyrics',
      queryParameters: {
        'artist': artist,
        'title': title,
      },
    );

    final data = response.data as Map<String, dynamic>;
    return LyricsModel(
      lyrics: data['lyrics'] as String,
      artist: artist,
      title: title,
      source: data['source'] as String? ?? 'wordpress',
    );
  }

  Future<LyricsModel> _getLyricsFromMusixmatchDirect(
    String artist,
    String title,
  ) async {
    final apiKey = RadioConfig.lyricsApiKey;
    if (apiKey == null || apiKey.isEmpty) {
      throw ServerException('Musixmatch API key is required for direct API access');
    }

    final url = 'https://api.musixmatch.com/ws/1.1/matcher.lyrics.get';

    try {
      final response = await dio.get(
        url,
        queryParameters: {
          'apikey': apiKey,
          'q_track': title,
          'q_artist': artist,
          'format': 'json',
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      final data = response.data as Map<String, dynamic>;
      final message = data['message'] as Map<String, dynamic>?;
      final body = message?['body'] as Map<String, dynamic>?;
      final lyricsObj = body?['lyrics'] as Map<String, dynamic>?;
      final lyricsText = lyricsObj?['lyrics_body'] as String? ?? '';

      if (lyricsText.isEmpty || lyricsText.contains('***')) {
        throw ServerException('Lyrics not found');
      }

      return LyricsModel(
        lyrics: lyricsText,
        artist: artist,
        title: title,
        source: 'musixmatch',
      );
    } on DioException catch (e) {
      throw ServerException('Failed to fetch lyrics from Musixmatch: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to fetch lyrics: $e');
    }
  }
}

