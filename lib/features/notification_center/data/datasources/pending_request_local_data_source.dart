import '../../domain/entities/pending_request.dart';
import '../../domain/repositories/pending_request_tracker.dart';

class PendingRequestLocalDataSource implements PendingRequestTracker {
  final List<PendingRequest> _pending = [];
  final int maxEntries;

  PendingRequestLocalDataSource({this.maxEntries = 20});

  @override
  void record(PendingRequest request) {
    _pending.insert(0, request);
    if (_pending.length > maxEntries) {
      _pending.removeRange(maxEntries, _pending.length);
    }
  }

  @override
  PendingRequest? matchPlayed({
    String? requestId,
    required String artist,
    required String title,
    bool isExplicitRequest = false,
  }) {
    final normalizedArtist = _normalize(artist);
    final normalizedTitle = _normalize(title);

    PendingRequest? matched;

    if (requestId != null && requestId.isNotEmpty) {
      matched = _pending.firstWhere(
        (item) => item.requestId != null && item.requestId == requestId,
        orElse: () => PendingRequest(
          requestId: null,
          artist: '',
          title: '',
          submittedAt: DateTime.fromMillisecondsSinceEpoch(0),
        ),
      );
      if (matched.requestId != null && matched.requestId!.isNotEmpty) {
        _pending.remove(matched);
        return matched;
      }
    }

    matched = _pending.firstWhere(
      (item) =>
          _normalize(item.artist) == normalizedArtist &&
          _normalize(item.title) == normalizedTitle,
      orElse: () => PendingRequest(
        requestId: null,
        artist: '',
        title: '',
        submittedAt: DateTime.fromMillisecondsSinceEpoch(0),
      ),
    );

    if (matched.artist.isNotEmpty && matched.title.isNotEmpty) {
      _pending.remove(matched);
      return matched;
    }

    if (isExplicitRequest && _pending.isNotEmpty) {
      final fallback = _pending.removeAt(0);
      return fallback;
    }

    return null;
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('\n', ' ')
        .replaceAll('\t', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
