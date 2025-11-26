import 'package:hive/hive.dart';

import '../models/tamtama_model.dart';

abstract class TamtamaLocalDataSource {
  Future<TamtamaModel> fetch(String userId);
  Future<void> save(TamtamaModel tamtama);
}

class TamtamaLocalDataSourceImpl implements TamtamaLocalDataSource {
  static const _boxName = 'tamtama_box';

  Future<Box> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return Hive.openBox(_boxName);
  }

  @override
  Future<TamtamaModel> fetch(String userId) async {
    final box = await _openBox();
    final raw = box.get(userId);
    if (raw is Map) {
      return TamtamaModel.fromMap(
        Map<String, dynamic>.from(raw),
      );
    }
    final initial = TamtamaModel.initial(userId);
    await save(initial);
    return initial;
  }

  @override
  Future<void> save(TamtamaModel tamtama) async {
    final box = await _openBox();
    await box.put(tamtama.userId, tamtama.toMap());
  }
}

