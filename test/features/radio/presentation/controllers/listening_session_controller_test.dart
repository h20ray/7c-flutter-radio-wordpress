import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tujuhcahaya_wprs/features/gamification/domain/entities/user_listening_stats_entity.dart';
import 'package:tujuhcahaya_wprs/features/gamification/domain/usecases/record_listening_session.dart';
import 'package:tujuhcahaya_wprs/features/radio/domain/entities/radio_entity.dart';
import 'package:tujuhcahaya_wprs/features/radio/presentation/controllers/listening_session_controller.dart';

class MockRecordListeningSession extends Mock
    implements RecordListeningSession {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Duration());
  });
  late MockRecordListeningSession recordListeningSession;
  late ListeningSessionController controller;
  late UserListeningStatsEntity stats;
  late RadioEntity config;

  setUp(() {
    stats = UserListeningStatsEntity(
      userId: 'u1',
      totalListeningSeconds: 0,
      currentLevel: '1',
      lastUpdatedAt: DateTime(2024),
    );
    config = RadioEntity(
      enabled: true,
      streamUrl: 'stream-1',
      autoplay: false,
      showAlbumCover: true,
      textScrolling: false,
      metadataUrl: '',
      logoNetworkUrl: '',
      albumArtSource: 0,
      lastUpdated: DateTime(2024),
    );
    recordListeningSession = MockRecordListeningSession();
    when(() => recordListeningSession(any<Duration>()))
        .thenAnswer((_) async => Right(stats));
    controller = ListeningSessionController(
      recordListeningSession: recordListeningSession,
      tamtamaBloc: null,
      minFlushDelta: Duration.zero,
      flushInterval: const Duration(seconds: 60),
      metadataFlushDebounceDelay: const Duration(milliseconds: 10),
    );
  });

  test('starts and stops sessions flush listening', () async {
    controller.handlePlayback(true, config);
    await Future.delayed(const Duration(milliseconds: 1200));
    controller.handlePlayback(false, config);
    await untilCalled(() => recordListeningSession(any<Duration>()));

    verify(() => recordListeningSession(any<Duration>())).called(1);
  });

  test('flushes on metadata change while playing', () async {
    controller.handlePlayback(true, config);
    await Future.delayed(const Duration(milliseconds: 1200));
    controller.handleMetadataChange('artist', 'title', true, config);
    await untilCalled(() => recordListeningSession(any<Duration>()));

    verify(() => recordListeningSession(any<Duration>()))
        .called(greaterThanOrEqualTo(1));
  });
}
