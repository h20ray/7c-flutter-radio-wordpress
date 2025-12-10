import 'dart:async';

import 'package:dio/dio.dart';

import '../../../../core/utils/debug_logger.dart';

class NowPlayingPollResult {
  final String? artist;
  final String? title;
  final String? artworkUrl;
  final bool isRequest;
  final String? requestId;

  const NowPlayingPollResult({
    this.artist,
    this.title,
    this.artworkUrl,
    this.isRequest = false,
    this.requestId,
  });
}

typedef NowPlayingCallback = void Function(NowPlayingPollResult result);

class NowPlayingPollingService {
  final Dio _dio;
  final Duration interval;
  Timer? _timer;
  String? _baseUrl;
  String? _stationId;
  NowPlayingCallback? _callback;

  NowPlayingPollingService({
    Dio? dio,
    this.interval = const Duration(seconds: 30),
  }) : _dio = dio ?? Dio();

  void start({
    required String baseUrl,
    required String stationId,
    required NowPlayingCallback onMetadata,
  }) {
    if (baseUrl.isEmpty || stationId.isEmpty) {
      DebugLogger.log(
        '[NowPlayingPolling] Missing base URL or station ID',
        tag: 'NowPlayingPolling',
      );
      return;
    }

    stop();
    _baseUrl = baseUrl;
    _stationId = stationId;
    _callback = onMetadata;

    _pollOnce();
    _timer = Timer.periodic(interval, (timer) => _pollOnce());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _callback = null;
  }

  Future<void> _pollOnce() async {
    if (_baseUrl == null || _stationId == null || _callback == null) {
      return;
    }

    try {
      final url =
          '$_baseUrl/api/nowplaying/${Uri.encodeComponent(_stationId!)}';
      final response = await _dio.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final nowPlaying = data['now_playing'] as Map<String, dynamic>?;
        final song = nowPlaying?['song'] as Map<String, dynamic>?;
        final artist = song?['artist'] as String?;
        final title =
            song?['title'] as String? ?? song?['text'] as String? ?? '';
        final art = song?['art'] as String?;
        final isRequest =
            nowPlaying?['is_request'] == true ||
            song?['is_request'] == true ||
            (song?['request_id'] != null);
        final requestId =
            nowPlaying?['request_id']?.toString() ??
            song?['request_id']?.toString();

        if ((artist != null && artist.isNotEmpty) || title.isNotEmpty) {
          _callback?.call(
            NowPlayingPollResult(
              artist: artist,
              title: title,
              artworkUrl: art,
              isRequest: isRequest,
              requestId: requestId,
            ),
          );
        }
      }
    } catch (error) {
      // Swallow polling errors silently to avoid spamming logs.
    }
  }
}
