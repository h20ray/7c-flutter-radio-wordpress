import 'dart:math' as math;
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../services/azuracast_detection_service.dart';

abstract class RequestAzuracastDataSource {
  Future<List<RequestableTrackModel>> listRequestableTracks({
    required String streamUrl,
    String? query,
    int page = 1,
    int limit = 20,
    bool random = false,
  });

  Future<void> submitRequest({
    required String streamUrl,
    required String requestId,
    String? title,
    String? artist,
  });
}

class RequestAzuracastDataSourceImpl implements RequestAzuracastDataSource {
  final Dio dio;

  RequestAzuracastDataSourceImpl({required this.dio});

  @override
  Future<List<RequestableTrackModel>> listRequestableTracks({
    required String streamUrl,
    String? query,
    int page = 1,
    int limit = 20,
    bool random = false,
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
      
      final url = '$cleanBaseUrl/api/station/$stationId/requests';

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
        
        if (data is! List) {
          throw const ServerException('Invalid response format from Azuracast API');
        }
        
        List<dynamic> items = data;
        
        if (items.isEmpty) {
          return [];
        }
        
        if (query != null && query.trim().isNotEmpty && !random) {
          final queryLower = query.toLowerCase().trim();
          items = items.where((item) {
            if (item is! Map<String, dynamic>) return false;
            final song = item['song'] as Map<String, dynamic>?;
            if (song == null) return false;
            
            final title = (song['title']?.toString() ?? '').toLowerCase();
            final artist = (song['artist']?.toString() ?? '').toLowerCase();
            
            return title.contains(queryLower) || artist.contains(queryLower);
          }).toList();
        } else if (random) {
          final random = math.Random();
          for (int i = items.length - 1; i > 0; i--) {
            final j = random.nextInt(i + 1);
            final temp = items[i];
            items[i] = items[j];
            items[j] = temp;
          }
        }
        
        final total = items.length;
        final offset = (page - 1) * limit;
        final paginatedItems = offset < total 
            ? items.sublist(offset, (offset + limit).clamp(0, total))
            : <dynamic>[];
        
        return paginatedItems.map((item) {
          if (item is! Map<String, dynamic>) return null;
          
          final song = item['song'] as Map<String, dynamic>?;
          if (song == null) return null;
          
          final id = item['request_id']?.toString() ?? '';
          final title = song['title']?.toString() ?? '';
          final artist = song['artist']?.toString() ?? '';
          final art = song['art']?.toString();
          
          if (id.isEmpty || (title.isEmpty && artist.isEmpty)) {
            return null;
          }
          
          return RequestableTrackModel(
            requestId: id,
            title: title,
            artist: artist,
            albumArtUrl: art,
          );
        }).whereType<RequestableTrackModel>().toList();
      } else if (response.statusCode == 403) {
        throw const ServerException('Requests are disabled for this station.');
      } else {
        throw ServerException('Failed to fetch requestable tracks: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final errorData = e.response?.data;
        
        if (statusCode == 403) {
          throw const ServerException('Requests are disabled for this station.');
        } else if (statusCode == 404) {
          throw const ServerException('Azuracast station not found. Please check your station ID.');
        } else {
          throw ServerException(
            'Failed to fetch requestable tracks: $statusCode - ${errorData?.toString() ?? e.message}',
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

  @override
  Future<void> submitRequest({
    required String streamUrl,
    required String requestId,
    String? title,
    String? artist,
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
      
      final url = '$cleanBaseUrl/api/station/$stationId/request/$requestId';

      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'User-Agent': 'RadioPlayerFlutter/1.0.0',
          },
        ),
      );

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return;
      } else {
        final errorData = response.data;
        final message = errorData is Map && errorData['message'] != null
            ? errorData['message'].toString()
            : 'Request failed';
        throw ServerException(message);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final errorData = e.response?.data;
        
        final message = errorData is Map && errorData['message'] != null
            ? errorData['message'].toString()
            : 'Request failed: ${statusCode ?? e.message}';
        throw ServerException(message);
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

class RequestableTrackModel {
  final String requestId;
  final String title;
  final String artist;
  final String? albumArtUrl;

  RequestableTrackModel({
    required this.requestId,
    required this.title,
    required this.artist,
    this.albumArtUrl,
  });
}

