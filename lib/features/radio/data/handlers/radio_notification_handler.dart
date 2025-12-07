import 'dart:async';
import '../../../../config/radio_config.dart';
import '../../../../core/models/notification_update_state.dart';
import '../../../../core/utils/exponential_backoff.dart';
import '../../../../core/utils/debug_logger.dart';

/// Callback type for the actual notification update operation
typedef NotificationUpdateAction = Future<void> Function({
  required String artist,
  required String title,
  String? artworkUrl,
});

/// Handler for managing notification updates with exponential backoff retry logic.
///
/// This class encapsulates the notification update logic that was previously
/// embedded in RadioPlayerRepositoryImpl, making it testable and reusable.
class RadioNotificationHandler {
  /// Current notification state
  NotificationUpdateState _state = NotificationUpdateState.initial();

  /// Timer for pending notification updates
  Timer? _updateTimer;

  /// The action to perform for updating notifications
  final NotificationUpdateAction _updateAction;

  /// Creates a new notification handler with the given update action.
  RadioNotificationHandler({
    required NotificationUpdateAction updateAction,
  }) : _updateAction = updateAction;

  /// Current notification state
  NotificationUpdateState get state => _state;

  /// Whether a notification update is currently in progress
  bool get isUpdating => _state.isUpdating;

  /// Whether the last update failed
  bool get hasFailed => _state.hasFailed;

  /// Updates the notification with exponential backoff retry logic.
  ///
  /// Returns `true` if the update was successful, `false` otherwise.
  Future<bool> updateNotification({
    required String artist,
    required String title,
    String? artworkUrl,
  }) async {
    // Create new notification state
    final newNotificationState = NotificationUpdateState(
      artist: artist,
      title: title,
      artworkUrl: artworkUrl,
    );

    // Check if this is the same content as current state
    if (_state.isSameContent(newNotificationState) && !_state.isStale) {
      if (RadioConfig.logNotificationUpdates) {
        DebugLogger.log(
          '[RadioNotificationHandler] Skipping update - same content and not stale',
          tag: 'RadioNotificationHandler',
        );
      }
      return true;
    }

    // Cancel any pending notification update
    _updateTimer?.cancel();

    // Start new notification update with exponential backoff
    _state = NotificationUpdateState.updating(
      artist: artist,
      title: title,
      artworkUrl: artworkUrl,
      maxAttempts: RadioConfig.notificationMaxRetries,
    );

    final backoff = ExponentialBackoff(
      maxRetries: RadioConfig.notificationMaxRetries,
      initialDelayMs: RadioConfig.notificationInitialDelayMs,
      multiplier: RadioConfig.notificationBackoffMultiplier,
      maxDelayMs: RadioConfig.notificationMaxDelayMs,
    );

    try {
      await backoff.execute(
        () async {
          if (RadioConfig.logNotificationUpdates) {
            DebugLogger.log(
              '[RadioNotificationHandler] Updating notification (attempt ${_state.attemptCount + 1}):',
              tag: 'RadioNotificationHandler',
            );
            DebugLogger.log('  - Artist: $artist', tag: 'RadioNotificationHandler');
            DebugLogger.log('  - Title: $title', tag: 'RadioNotificationHandler');
            DebugLogger.log('  - Artwork URL: $artworkUrl', tag: 'RadioNotificationHandler');
          }

          await _updateAction(
            artist: artist,
            title: title,
            artworkUrl: artworkUrl,
          );

          if (RadioConfig.logNotificationUpdates) {
            DebugLogger.log(
              '[RadioNotificationHandler] Notification update successful',
              tag: 'RadioNotificationHandler',
            );
          }
        },
        shouldRetry: (error) {
          // Retry on network errors, timeouts, but not on validation errors
          return error.toString().contains('timeout') ||
              error.toString().contains('network') ||
              error.toString().contains('connection');
        },
        onRetry: (attempt, error) {
          if (RadioConfig.logNotificationUpdates) {
            DebugLogger.log(
              '[RadioNotificationHandler] Notification update failed (attempt $attempt): $error',
              tag: 'RadioNotificationHandler',
            );
            DebugLogger.log(
              '[RadioNotificationHandler] Retrying in ${backoff.getDelayForAttempt(attempt - 1)}ms...',
              tag: 'RadioNotificationHandler',
            );
          }

          _state = _state.copyWith(
            attemptCount: attempt,
            lastError: error.toString(),
            isUpdating: true,
            hasFailed: false,
          );
        },
      );

      // Success
      _state = NotificationUpdateState.success(
        artist: artist,
        title: title,
        artworkUrl: artworkUrl,
        attemptCount: _state.attemptCount,
        maxAttempts: RadioConfig.notificationMaxRetries,
        lastAttemptTime: _state.lastAttemptTime,
      );

      if (RadioConfig.logNotificationUpdates) {
        DebugLogger.log(
          '[RadioNotificationHandler] Notification update completed successfully',
          tag: 'RadioNotificationHandler',
        );
      }

      return true;
    } catch (error) {
      // Final failure
      _state = NotificationUpdateState.failed(
        artist: artist,
        title: title,
        artworkUrl: artworkUrl,
        attemptCount: _state.attemptCount,
        maxAttempts: RadioConfig.notificationMaxRetries,
        error: error.toString(),
        lastAttemptTime: _state.lastAttemptTime,
      );

      if (RadioConfig.logNotificationUpdates) {
        DebugLogger.log(
          '[RadioNotificationHandler] Notification update failed after all retries: $error',
          tag: 'RadioNotificationHandler',
        );
      }

      return false;
    }
  }

  /// Cancels any pending notification update
  void cancel() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }

  /// Resets the handler state
  void reset() {
    cancel();
    _state = NotificationUpdateState.initial();
  }

  /// Disposes of resources
  void dispose() {
    cancel();
  }
}
