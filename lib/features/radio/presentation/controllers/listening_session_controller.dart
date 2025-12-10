import 'dart:async';

import '../../../../config/app_config.dart';
import '../../../gamification/domain/usecases/record_listening_session.dart';
import '../../../tamtama/presentation/bloc/tamtama_bloc.dart';
import '../../domain/entities/radio_entity.dart';

class ListeningSessionController {
  final RecordListeningSession recordListeningSession;
  final TamtamaBloc? tamtamaBloc;
  final Duration minFlushDelta;
  final Duration flushInterval;
  final Duration metadataFlushDebounceDelay;

  DateTime? _sessionStart;
  Timer? _flushTimer;
  Timer? _metadataFlushDebounceTimer;
  String? _lastMetadataArtist;
  String? _lastMetadataTitle;
  bool _isFlushing = false;

  ListeningSessionController({
    required this.recordListeningSession,
    this.tamtamaBloc,
    this.minFlushDelta = const Duration(seconds: 5),
    this.flushInterval = AppConfig.listeningFlushInterval,
    this.metadataFlushDebounceDelay = const Duration(seconds: 2),
  });

  void handlePlayback(bool isPlaying, RadioEntity? config) {
    if (isPlaying) {
      final hadSession = _sessionStart != null;
      _sessionStart ??= DateTime.now();
      if (!hadSession) {
        _startFlushTimer(config);
        tamtamaBloc?.add(const TamtamaEvent.setListening(true));
      }
    } else {
      _stopFlushTimer();
      _metadataFlushDebounceTimer?.cancel();
      _lastMetadataArtist = null;
      _lastMetadataTitle = null;
      unawaited(_flushListeningSession(config: config));
      tamtamaBloc?.add(const TamtamaEvent.setListening(false));
    }
  }

  void handleMetadataChange(
    String? artist,
    String? title,
    bool isPlaying,
    RadioEntity? config,
  ) {
    if (!isPlaying || _sessionStart == null) {
      return;
    }
    if (_lastMetadataArtist == artist && _lastMetadataTitle == title) {
      return;
    }
    _lastMetadataArtist = artist;
    _lastMetadataTitle = title;
    _metadataFlushDebounceTimer?.cancel();
    _metadataFlushDebounceTimer =
        Timer(metadataFlushDebounceDelay, () => unawaited(_flushListeningSession(config: config, keepSessionActive: true)));
  }

  Future<void> dispose() async {
    _stopFlushTimer();
    _metadataFlushDebounceTimer?.cancel();
    await _flushListeningSession();
  }

  void _startFlushTimer(RadioEntity? config) {
    _flushTimer?.cancel();
    _flushTimer = Timer.periodic(
      flushInterval,
      (_) => unawaited(_flushListeningSession(config: config, keepSessionActive: true)),
    );
  }

  void _stopFlushTimer() {
    _flushTimer?.cancel();
    _flushTimer = null;
  }

  Future<void> _flushListeningSession({
    RadioEntity? config,
    bool keepSessionActive = false,
  }) async {
    if (_isFlushing) {
      return;
    }
    final start = _sessionStart;
    if (start == null) {
      return;
    }
    final now = DateTime.now();
    final duration = now.difference(start);
    if (keepSessionActive && duration < minFlushDelta) {
      return;
    }
    _isFlushing = true;
    try {
      if (duration.inSeconds <= 0) {
        if (!keepSessionActive) {
          _sessionStart = null;
        }
        return;
      }
      final result = await recordListeningSession(duration);
      result.fold(
        (_) {},
        (_) {},
      );
      final minutes = duration.inMinutes;
      if (minutes > 0 && tamtamaBloc != null) {
        final stationId = config?.streamUrl ?? 'unknown';
        tamtamaBloc!.add(TamtamaEvent.onListeningTick(minutes, stationId));
      }
      _sessionStart = keepSessionActive ? now : null;
    } finally {
      _isFlushing = false;
    }
  }
}
