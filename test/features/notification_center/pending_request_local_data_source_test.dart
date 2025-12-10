import 'package:flutter_test/flutter_test.dart';
import 'package:tujuhcahaya_wprs/features/notification_center/data/datasources/pending_request_local_data_source.dart';
import 'package:tujuhcahaya_wprs/features/notification_center/domain/entities/pending_request.dart';

void main() {
  group('PendingRequestLocalDataSource', () {
    late PendingRequestLocalDataSource dataSource;
    final submittedAt = DateTime.fromMillisecondsSinceEpoch(0);

    setUp(() {
      dataSource = PendingRequestLocalDataSource();
    });

    test('matches by requestId and removes entry', () {
      // Arrange
      dataSource.record(
        PendingRequest(
          requestId: 'req-1',
          artist: 'Artist',
          title: 'Title',
          submittedAt: submittedAt,
        ),
      );

      // Act
      final matched = dataSource.matchPlayed(
        requestId: 'req-1',
        artist: 'Artist',
        title: 'Title',
        isExplicitRequest: true,
      );

      // Assert
      expect(matched?.requestId, 'req-1');
      expect(matched?.artist, 'Artist');
      expect(matched?.title, 'Title');
      expect(
        dataSource.matchPlayed(
          requestId: 'req-1',
          artist: 'Artist',
          title: 'Title',
          isExplicitRequest: true,
        ),
        isNull,
      );
    });

    test('matches by normalized artist and title', () {
      // Arrange
      dataSource.record(
        PendingRequest(
          requestId: null,
          artist: 'The Artist',
          title: 'My Song',
          submittedAt: submittedAt,
        ),
      );

      // Act
      final matched = dataSource.matchPlayed(
        requestId: null,
        artist: ' the  artist ',
        title: 'my   song',
        isExplicitRequest: false,
      );

      // Assert
      expect(matched?.artist, 'The Artist');
      expect(matched?.title, 'My Song');
    });
  });
}
