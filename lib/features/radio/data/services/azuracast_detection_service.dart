import 'package:dio/dio.dart';
import '../../../../core/utils/debug_logger.dart';

/// Service to detect AzuraCast configuration from stream URL
class AzuraCastDetectionService {
  static AzuraCastDetectionService? _instance;
  final Dio _dio;

  AzuraCastDetectionService._internal() : _dio = Dio();

  static AzuraCastDetectionService get instance {
    _instance ??= AzuraCastDetectionService._internal();
    return _instance!;
  }

  /// Detect AzuraCast configuration from stream URL
  /// Returns a map with 'base_url' and 'station_id' keys
  Future<Map<String, String>> detectFromStreamUrl(String streamUrl) async {
    final result = <String, String>{
      'base_url': '',
      'station_id': '',
    };

    if (streamUrl.isEmpty) {
      return result;
    }

    try {
      final uri = Uri.parse(streamUrl);
      if (!uri.hasScheme || !uri.hasAuthority) {
        return result;
      }

      final host = uri.host;
      final path = uri.path;
      final scheme = uri.scheme;
      final port = uri.hasPort ? ':${uri.port}' : '';

      // Construct base URL
      final baseUrl = '$scheme://$host$port';

      // Validate that this looks like an AzuraCast instance
      final azuraIndicators = [
        'azuracast',
        'radio',
        'stream',
        'live',
        'listen',
        'broadcast'
      ];

      bool isLikelyAzuraCast = false;
      final hostLower = host.toLowerCase();
      for (final indicator in azuraIndicators) {
        if (hostLower.contains(indicator)) {
          isLikelyAzuraCast = true;
          break;
        }
      }

      // Also check if the path structure suggests AzuraCast
      if (RegExp(r'/(radio|stream|live|listen)').hasMatch(path)) {
        isLikelyAzuraCast = true;
      }

      // If this doesn't look like AzuraCast, return empty result
      if (!isLikelyAzuraCast) {
        return result;
      }

      // For AzuraCast, extract the station short name from the URL path
      // Pattern: /listen/{station_short_name}/...
      final listenPattern = RegExp(r'^/listen/([^/]+)(?:/.*)?$');
      final match = listenPattern.firstMatch(path);

      if (match != null) {
        final stationShortName = match.group(1)!;

        // Test if this station exists by trying the art endpoint
        final artUrl =
            '$baseUrl/api/nowplaying/${Uri.encodeComponent(stationShortName)}/art';

        try {
          final response = await _dio.head(
            artUrl,
            options: Options(
              receiveTimeout: const Duration(seconds: 3),
              sendTimeout: const Duration(seconds: 3),
            ),
          );

          if (response.statusCode == 200 || response.statusCode == 302) {
            // Station exists, return the configuration
            result['base_url'] = baseUrl;
            result['station_id'] = stationShortName;

            DebugLogger.log('[AzuraCastDetection] Detected station: $stationShortName', tag: 'AzuraCastDetection');
          }
        } catch (e) {
          DebugLogger.log('[AzuraCastDetection] Failed to validate station', tag: 'AzuraCastDetection');
        }
      }
    } catch (e) {
      DebugLogger.logError('Error parsing stream URL', error: e, tag: 'AzuraCastDetection');
    }

    return result;
  }

  /// Check if a URL looks like an AzuraCast stream URL
  bool isLikelyAzuraCastUrl(String streamUrl) {
    if (streamUrl.isEmpty) return false;

    try {
      final uri = Uri.parse(streamUrl);
      final host = uri.host.toLowerCase();
      final path = uri.path;

      // Check host indicators
      final azuraIndicators = [
        'azuracast',
        'radio',
        'stream',
        'live',
        'listen',
        'broadcast'
      ];

      for (final indicator in azuraIndicators) {
        if (host.contains(indicator)) {
          return true;
        }
      }

      // Check path indicators
      if (RegExp(r'/(radio|stream|live|listen)').hasMatch(path)) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}

