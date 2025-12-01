import 'package:hive/hive.dart';
import '../../../../config/radio_config.dart';
import '../models/lyrics_model.dart';

abstract class LyricsLocalDataSource {
  Future<LyricsModel?> getCachedLyrics(String artist, String title);
  Future<void> cacheLyrics(LyricsModel lyrics);
}

class LyricsLocalDataSourceImpl implements LyricsLocalDataSource {
  static const _boxName = 'lyrics_box';

  Future<Box> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return Hive.openBox(_boxName);
  }

  String _getCacheKey(String artist, String title) {
    final normalized = '${artist.toLowerCase().trim()}_${title.toLowerCase().trim()}';
    return normalized.replaceAll(RegExp(r'\s+'), '_');
  }

  @override
  Future<LyricsModel?> getCachedLyrics(String artist, String title) async {
    final box = await _openBox();
    final key = _getCacheKey(artist, title);
    final raw = box.get(key);
    
    if (raw == null) {
      return null;
    }

    final data = Map<String, dynamic>.from(raw);
    
    // Check expiration (TTL support)
    final expiresAt = data['expires_at'] as int?;
    if (expiresAt != null) {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      if (now > expiresAt) {
        // Cache expired, remove it
        await box.delete(key);
        return null;
      }
    }

    // Extract payload (matching WordPress cache structure)
    final payload = data['payload'] as Map<String, dynamic>?;
    if (payload != null) {
      return LyricsModel(
        lyrics: payload['lyrics'] as String,
        artist: payload['artistName'] as String? ?? artist,
        title: payload['trackName'] as String? ?? title,
        source: payload['searchEngine'] as String? ?? data['source'] as String? ?? 'unknown',
      );
    }

    // Fallback to old format (for backward compatibility)
    return LyricsModel.fromMap(data);
  }

  @override
  Future<void> cacheLyrics(LyricsModel lyrics) async {
    final box = await _openBox();
    final key = _getCacheKey(lyrics.artist, lyrics.title);
    
    // Calculate TTL (days to seconds)
    final ttlDays = RadioConfig.lyricsCacheTtlDays;
    final ttlSeconds = ttlDays * 86400;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    
    // Store in WordPress-compatible format
    final cacheEntry = {
      'type': 'lyrics',
      'title': lyrics.title,
      'artist': lyrics.artist,
      'source': lyrics.source,
      'payload': {
        'lyrics': lyrics.lyrics,
        'trackName': lyrics.title,
        'artistName': lyrics.artist,
        'searchEngine': lyrics.source,
      },
      'created_at': now,
      'ttl': ttlSeconds,
      'expires_at': now + ttlSeconds,
    };
    
    await box.put(key, cacheEntry);
  }
}

