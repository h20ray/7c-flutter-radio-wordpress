import 'package:hive/hive.dart';
import '../../../../config/radio_config.dart';
import '../models/song_history_model.dart';

abstract class SongHistoryLocalDataSource {
  Future<List<SongHistoryModel>> getSongHistory({int limit = 100});
  Future<void> addSong(SongHistoryModel song);
  Future<void> clearHistory();
  Future<void> updateAlbumArt({
    required String artist,
    required String title,
    required String albumArtUrl,
  });
}

class SongHistoryLocalDataSourceImpl implements SongHistoryLocalDataSource {
  static const _boxName = 'song_history_box';
  static const _songsKey = 'songs';

  Future<Box> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return Hive.openBox(_boxName);
  }

  @override
  Future<List<SongHistoryModel>> getSongHistory({int limit = 100}) async {
    final box = await _openBox();
    final raw = box.get(_songsKey);
    
    if (raw == null) {
      return [];
    }

    final List<dynamic> songsList = raw as List<dynamic>;
    final songs = songsList
        .map((item) => SongHistoryModel.fromMap(
              Map<String, dynamic>.from(item),
            ))
        .toList();

    songs.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return songs.take(limit).toList();
  }

  @override
  Future<void> addSong(SongHistoryModel song) async {
    final box = await _openBox();
    final raw = box.get(_songsKey);
    
    List<Map<String, dynamic>> songsList;
    if (raw == null) {
      songsList = [];
    } else {
      songsList = (raw as List<dynamic>)
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    final duplicatePreventionSeconds = RadioConfig.songHistoryDuplicatePreventionSeconds;
    final now = DateTime.now();
    final cutoffTime = now.subtract(Duration(seconds: duplicatePreventionSeconds));

    final normalizedArtist = song.artist.toLowerCase().trim();
    final normalizedTitle = song.title.toLowerCase().trim();

    bool isDuplicate = false;
    for (final item in songsList) {
      final existingSong = SongHistoryModel.fromMap(item);
      final existingArtist = existingSong.artist.toLowerCase().trim();
      final existingTitle = existingSong.title.toLowerCase().trim();
      
      if (existingArtist == normalizedArtist &&
          existingTitle == normalizedTitle &&
          existingSong.timestamp.isAfter(cutoffTime)) {
        isDuplicate = true;
        
        if (song.albumArtUrl != null && existingSong.albumArtUrl == null) {
          item['albumArtUrl'] = song.albumArtUrl;
          await box.put(_songsKey, songsList);
        }
        break;
      }
    }

    if (!isDuplicate) {
      songsList.insert(0, song.toMap());

      final maxEntries = RadioConfig.songHistoryMaxEntries;
      if (songsList.length > maxEntries) {
        songsList = songsList.take(maxEntries).toList();
      }

      await box.put(_songsKey, songsList);
    }
  }

  @override
  Future<void> clearHistory() async {
    final box = await _openBox();
    await box.delete(_songsKey);
  }

  @override
  Future<void> updateAlbumArt({
    required String artist,
    required String title,
    required String albumArtUrl,
  }) async {
    final box = await _openBox();
    final raw = box.get(_songsKey);
    
    if (raw == null) {
      return;
    }

    final List<dynamic> songsList = raw as List<dynamic>;
    final normalizedArtist = artist.toLowerCase().trim();
    final normalizedTitle = title.toLowerCase().trim();

    bool updated = false;
    for (int i = 0; i < songsList.length; i++) {
      final item = Map<String, dynamic>.from(songsList[i]);
      final existingArtist = (item['artist'] as String).toLowerCase().trim();
      final existingTitle = (item['title'] as String).toLowerCase().trim();
      
      if (existingArtist == normalizedArtist &&
          existingTitle == normalizedTitle &&
          (item['albumArtUrl'] == null || (item['albumArtUrl'] as String).isEmpty)) {
        item['albumArtUrl'] = albumArtUrl;
        songsList[i] = item;
        updated = true;
        break;
      }
    }

    if (updated) {
      await box.put(_songsKey, songsList);
    }
  }
}

