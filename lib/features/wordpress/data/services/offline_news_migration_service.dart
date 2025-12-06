import 'package:hive/hive.dart';
import '../datasources/offline_news_local_data_source.dart';
import '../models/post_model.dart';

class OfflineNewsMigrationService {
  final OfflineNewsLocalDataSource offlineDataSource;
  static const String _oldBoxName = 'wordpress_posts_box';

  OfflineNewsMigrationService({required this.offlineDataSource});

  Future<bool> hasMigrated() async {
    try {
      final box = await Hive.openBox('settingsBox');
      return box.get('offline_news_migrated', defaultValue: false) as bool;
    } catch (e) {
      return false;
    }
  }

  Future<void> markAsMigrated() async {
    try {
      final box = await Hive.openBox('settingsBox');
      await box.put('offline_news_migrated', true);
    } catch (e) {
      // Silently fail
    }
  }

  Future<int> migrateOldCache() async {
    if (await hasMigrated()) {
      return 0;
    }

    try {
      if (!Hive.isBoxOpen(_oldBoxName)) {
        await Hive.openBox(_oldBoxName);
      }
      final oldBox = Hive.box(_oldBoxName);
      
      final allKeys = oldBox.keys.toList();
      final postKeys = allKeys
          .where((key) => key.toString().startsWith('posts_'))
          .toList();

      int migratedCount = 0;
      final Set<int> migratedPostIds = {};

      for (final key in postKeys) {
        try {
          final raw = oldBox.get(key);
          if (raw is List) {
            for (final item in raw) {
              if (item is Map) {
                try {
                  final post = PostModel.fromJson(
                      Map<String, dynamic>.from(item));
                  
                  if (!migratedPostIds.contains(post.id)) {
                    final isAlreadyOffline =
                        await offlineDataSource.isPostOffline(post.id);
                    if (!isAlreadyOffline) {
                      await offlineDataSource.savePost(post);
                      migratedPostIds.add(post.id);
                      migratedCount++;
                    }
                  }
                } catch (e) {
                  // Skip invalid post data
                  continue;
                }
              }
            }
          }
        } catch (e) {
          // Skip invalid cache entry
          continue;
        }
      }

      await markAsMigrated();
      return migratedCount;
    } catch (e) {
      return 0;
    }
  }

  Future<void> cleanupOldCache() async {
    try {
      if (Hive.isBoxOpen(_oldBoxName)) {
        final oldBox = Hive.box(_oldBoxName);
        await oldBox.clear();
        await oldBox.close();
        await Hive.deleteBoxFromDisk(_oldBoxName);
      }
    } catch (e) {
      // Silently fail cleanup
    }
  }
}

