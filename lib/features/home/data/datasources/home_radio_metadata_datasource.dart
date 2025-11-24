import '../../../radio/domain/entities/radio_player_entity.dart';
import '../../../radio/domain/repositories/radio_player_repository.dart';

abstract class HomeRadioMetadataDataSource {
  Stream<RadioPlayerEntity> watchNowPlaying();
}

class HomeRadioMetadataDataSourceImpl implements HomeRadioMetadataDataSource {
  final RadioPlayerRepository radioPlayerRepository;

  const HomeRadioMetadataDataSourceImpl({required this.radioPlayerRepository});

  @override
  Stream<RadioPlayerEntity> watchNowPlaying() {
    return radioPlayerRepository.watchPlayerState();
  }
}
