import 'package:flutter_test/flutter_test.dart';
import 'package:tujuhcahaya_wprs/features/radio/data/utils/radio_retry_strategy.dart';

void main() {
  group('RadioRetryStrategy', () {
    group('initialization', () {
      test('creates strategy with single URL', () {
        final strategy = RadioRetryStrategy(urls: ['https://stream.example.com']);

        expect(strategy.urls.length, 1);
        expect(strategy.currentUrl, 'https://stream.example.com');
        expect(strategy.currentAttempt, 0);
        expect(strategy.currentUrlIndex, 0);
      });

      test('creates strategy from primary and backup URLs', () {
        final strategy = RadioRetryStrategy.fromPrimaryAndBackups(
          primaryUrl: 'https://primary.example.com',
          backupUrls: [
            'https://backup1.example.com',
            'https://backup2.example.com',
          ],
        );

        expect(strategy.urls.length, 3);
        expect(strategy.currentUrl, 'https://primary.example.com');
        expect(strategy.totalUrls, 3);
      });

      test('throws when created with empty URLs list', () {
        expect(
          () => RadioRetryStrategy(urls: []),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('uses custom max attempts and backoff delays', () {
        final strategy = RadioRetryStrategy(
          urls: ['https://stream.example.com'],
          maxAttempts: 2,
          backoffDelays: [100, 200],
        );

        expect(strategy.maxAttempts, 2);
        expect(strategy.backoffDelays, [100, 200]);
      });
    });

    group('exponential backoff', () {
      test('returns correct delay for each attempt', () {
        final strategy = RadioRetryStrategy(
          urls: ['https://stream.example.com'],
          backoffDelays: [1000, 2000, 4000, 8000],
        );

        expect(strategy.currentDelayMs, 1000);

        // Simulate scheduling retries to advance attempts
        strategy.scheduleRetry(onRetry: () {});
        expect(strategy.currentAttempt, 1);
        expect(strategy.currentDelayMs, 2000);

        strategy.scheduleRetry(onRetry: () {});
        expect(strategy.currentAttempt, 2);
        expect(strategy.currentDelayMs, 4000);

        strategy.scheduleRetry(onRetry: () {});
        expect(strategy.currentAttempt, 3);
        expect(strategy.currentDelayMs, 8000);

        strategy.cancel();
      });

      test('returns last delay when beyond backoff delays length', () {
        final strategy = RadioRetryStrategy(
          urls: ['https://stream.example.com'],
          backoffDelays: [100, 200],
          maxAttempts: 5,
        );

        // Advance beyond backoff delays
        strategy.scheduleRetry(onRetry: () {});
        strategy.scheduleRetry(onRetry: () {});
        strategy.scheduleRetry(onRetry: () {});

        // Should use last delay
        expect(strategy.currentDelayMs, 200);
        strategy.cancel();
      });
    });

    group('onFailure and URL cycling', () {
      test('returns retryable when more attempts available', () {
        final strategy = RadioRetryStrategy(
          urls: ['https://stream.example.com'],
          maxAttempts: 3,
          backoffDelays: [100, 200, 400],
        );

        expect(strategy.onFailure(), RetryResult.retryable);
        expect(strategy.hasMoreAttempts, true);
      });

      test('returns exhaustedAttempts and advances URL when attempts exhausted', () {
        final strategy = RadioRetryStrategy(
          urls: [
            'https://primary.example.com',
            'https://backup.example.com',
          ],
          maxAttempts: 2,
          backoffDelays: [100, 200],
        );

        // Exhaust attempts for first URL
        strategy.scheduleRetry(onRetry: () {});
        strategy.scheduleRetry(onRetry: () {});

        expect(strategy.hasMoreAttempts, false);
        expect(strategy.hasMoreUrls, true);

        final result = strategy.onFailure();

        expect(result, RetryResult.exhaustedAttempts);
        expect(strategy.currentUrlIndex, 1);
        expect(strategy.currentAttempt, 0);
        expect(strategy.currentUrl, 'https://backup.example.com');

        strategy.cancel();
      });

      test('returns exhaustedUrls when all URLs and attempts exhausted', () {
        final strategy = RadioRetryStrategy(
          urls: ['https://stream.example.com'],
          maxAttempts: 2,
          backoffDelays: [100, 200],
        );

        // Exhaust all attempts
        strategy.scheduleRetry(onRetry: () {});
        strategy.scheduleRetry(onRetry: () {});

        expect(strategy.hasMoreAttempts, false);
        expect(strategy.hasMoreUrls, false);

        final result = strategy.onFailure();
        expect(result, RetryResult.exhaustedUrls);

        strategy.cancel();
      });
    });

    group('scheduleRetry', () {
      test('returns delay and increments attempt', () {
        var callbackCalled = false;
        final strategy = RadioRetryStrategy(
          urls: ['https://stream.example.com'],
          backoffDelays: [100, 200],
        );

        final delayMs = strategy.scheduleRetry(
          onRetry: () => callbackCalled = true,
        );

        expect(delayMs, 100);
        expect(strategy.currentAttempt, 1);
        expect(strategy.isRetrying, true);

        strategy.cancel();
        expect(callbackCalled, false); // Cancelled before callback
      });

      test('returns 0 when beyond max backoff delays', () {
        final strategy = RadioRetryStrategy(
          urls: ['https://stream.example.com'],
          backoffDelays: [100],
          maxAttempts: 3,
        );

        // Use all backoff delays
        strategy.scheduleRetry(onRetry: () {});

        // Now beyond backoff delays length
        final delayMs = strategy.scheduleRetry(onRetry: () {});

        expect(delayMs, 0);
        strategy.cancel();
      });
    });

    group('canRetry', () {
      test('returns true when more attempts available', () {
        final strategy = RadioRetryStrategy(
          urls: ['https://stream.example.com'],
          maxAttempts: 3,
          backoffDelays: [100, 200, 400],
        );

        expect(strategy.canRetry, true);
      });

      test('returns true when more URLs available even if attempts exhausted', () {
        final strategy = RadioRetryStrategy(
          urls: [
            'https://primary.example.com',
            'https://backup.example.com',
          ],
          maxAttempts: 1,
          backoffDelays: [100],
        );

        // Exhaust attempts for first URL
        strategy.scheduleRetry(onRetry: () {});
        expect(strategy.hasMoreAttempts, false);
        expect(strategy.canRetry, true); // Still has more URLs

        strategy.cancel();
      });

      test('returns false when all exhausted', () {
        final strategy = RadioRetryStrategy(
          urls: ['https://stream.example.com'],
          maxAttempts: 1,
          backoffDelays: [100],
        );

        // Exhaust everything
        strategy.scheduleRetry(onRetry: () {});
        strategy.onFailure();

        expect(strategy.canRetry, false);
        strategy.cancel();
      });
    });

    group('reset and onSuccess', () {
      test('reset clears all state', () {
        final strategy = RadioRetryStrategy(
          urls: [
            'https://primary.example.com',
            'https://backup.example.com',
          ],
          maxAttempts: 3,
          backoffDelays: [100, 200, 400],
        );

        // Advance state
        strategy.scheduleRetry(onRetry: () {});
        strategy.scheduleRetry(onRetry: () {});
        strategy.advanceToNextUrl();

        // After advanceToNextUrl, currentAttempt is reset to 0, urlIndex is 1
        expect(strategy.currentAttempt, 0);
        expect(strategy.currentUrlIndex, 1);

        strategy.reset();

        expect(strategy.currentAttempt, 0);
        expect(strategy.currentUrlIndex, 0);
        expect(strategy.isRetrying, false);
      });

      test('onSuccess resets state', () {
        final strategy = RadioRetryStrategy(
          urls: ['https://stream.example.com'],
          maxAttempts: 3,
          backoffDelays: [100, 200, 400],
        );

        strategy.scheduleRetry(onRetry: () {});
        strategy.scheduleRetry(onRetry: () {});

        expect(strategy.currentAttempt, 2);

        strategy.onSuccess();

        expect(strategy.currentAttempt, 0);
        expect(strategy.isRetrying, false);
      });
    });

    group('advanceToNextUrl', () {
      test('advances to next URL and resets attempts', () {
        final strategy = RadioRetryStrategy(
          urls: [
            'https://primary.example.com',
            'https://backup.example.com',
          ],
          maxAttempts: 3,
          backoffDelays: [100, 200, 400],
        );

        strategy.scheduleRetry(onRetry: () {});
        expect(strategy.currentAttempt, 1);

        final advanced = strategy.advanceToNextUrl();

        expect(advanced, true);
        expect(strategy.currentUrlIndex, 1);
        expect(strategy.currentAttempt, 0);
        expect(strategy.currentUrl, 'https://backup.example.com');

        strategy.cancel();
      });

      test('returns false when no more URLs', () {
        final strategy = RadioRetryStrategy(
          urls: ['https://stream.example.com'],
        );

        final advanced = strategy.advanceToNextUrl();

        expect(advanced, false);
        expect(strategy.currentUrlIndex, 0);
      });
    });

    group('remaining counts', () {
      test('remainingUrls returns correct count', () {
        final strategy = RadioRetryStrategy(
          urls: [
            'https://primary.example.com',
            'https://backup1.example.com',
            'https://backup2.example.com',
          ],
        );

        expect(strategy.remainingUrls, 3);

        strategy.advanceToNextUrl();
        expect(strategy.remainingUrls, 2);

        strategy.advanceToNextUrl();
        expect(strategy.remainingUrls, 1);
      });

      test('remainingAttempts returns correct count', () {
        final strategy = RadioRetryStrategy(
          urls: ['https://stream.example.com'],
          maxAttempts: 4,
          backoffDelays: [100, 200, 400, 800],
        );

        expect(strategy.remainingAttempts, 4);

        strategy.scheduleRetry(onRetry: () {});
        expect(strategy.remainingAttempts, 3);

        strategy.scheduleRetry(onRetry: () {});
        expect(strategy.remainingAttempts, 2);

        strategy.cancel();
      });
    });

    group('toString', () {
      test('returns readable representation', () {
        final strategy = RadioRetryStrategy(
          urls: [
            'https://primary.example.com',
            'https://backup.example.com',
          ],
          maxAttempts: 3,
        );

        expect(
          strategy.toString(),
          'RadioRetryStrategy(url=1/2, attempt=1/3, isRetrying=false)',
        );
      });
    });
  });
}
