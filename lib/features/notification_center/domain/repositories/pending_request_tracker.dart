import '../entities/pending_request.dart';

abstract class PendingRequestTracker {
  void record(PendingRequest request);
  PendingRequest? matchPlayed({
    String? requestId,
    required String artist,
    required String title,
    bool isExplicitRequest,
  });
}
