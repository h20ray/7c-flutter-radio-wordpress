import 'package:hive/hive.dart';

import '../models/user_listening_stats_model.dart';

abstract class ListeningStatsLocalDataSource {
  Future<UserListeningStatsModel> fetch(String userId);
  Future<void> save(UserListeningStatsModel stats);
}

class ListeningStatsLocalDataSourceImpl
    implements ListeningStatsLocalDataSource {
  static const _boxName = 'user_listening_stats_box';

  Future<Box> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return Hive.openBox(_boxName);
  }

  @override
  Future<UserListeningStatsModel> fetch(String userId) async {
    final box = await _openBox();
    final raw = box.get(userId);
    if (raw is Map) {
      return UserListeningStatsModel.fromMap(
        Map<String, dynamic>.from(raw),
      );
    }
    return UserListeningStatsModel.initial(userId);
  }

  @override
  Future<void> save(UserListeningStatsModel stats) async {
    final box = await _openBox();
    await box.put(stats.userId, stats.toMap());
  }
}

