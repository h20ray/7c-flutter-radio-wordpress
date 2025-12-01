import '../../../../core/network/api_client.dart';
import '../models/song_history_model.dart';

abstract class SongHistoryRemoteDataSource {
  Future<void> syncSongHistory(List<SongHistoryModel> songs);
}

class SongHistoryRemoteDataSourceImpl implements SongHistoryRemoteDataSource {
  final ApiClient apiClient;

  SongHistoryRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<void> syncSongHistory(List<SongHistoryModel> songs) async {
    final songsData = songs.map((song) => song.toMap()).toList();
    
    await apiClient.post(
      '/wp-json/tujuhcahaya/radio/song-history',
      data: {'songs': songsData},
    );
  }
}

