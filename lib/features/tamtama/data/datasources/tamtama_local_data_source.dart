import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

import '../models/tamtama_model.dart';
import '../models/tamtama_economy_model.dart';

/// Local data source for TamTama pet and economy storage
abstract class TamtamaLocalDataSource {
  /// Fetch pet state for a user (creates initial if not exists)
  Future<TamtamaModel> fetch(String userId);
  
  /// Save pet state
  Future<void> save(TamtamaModel tamtama);
  
  /// Watch pet state changes
  Stream<TamtamaModel> watch(String userId);
  
  /// Fetch economy state for a user (creates initial if not exists)
  Future<TamtamaEconomyModel> fetchEconomy(String userId);
  
  /// Save economy state
  Future<void> saveEconomy(TamtamaEconomyModel economy);
  
  /// Watch economy state changes
  Stream<TamtamaEconomyModel> watchEconomy(String userId);
  
  /// Check if pet exists for user
  Future<bool> exists(String userId);
  
  /// Delete pet data (for reset)
  Future<void> delete(String userId);
}

class TamtamaLocalDataSourceImpl implements TamtamaLocalDataSource {
  static const _petBoxName = 'tamtama_box';
  static const _economyBoxName = 'tamtama_economy_box';

  final BehaviorSubject<TamtamaModel?> _petSubject = BehaviorSubject();
  final BehaviorSubject<TamtamaEconomyModel?> _economySubject = BehaviorSubject();

  Future<Box> _openPetBox() async {
    if (Hive.isBoxOpen(_petBoxName)) {
      return Hive.box(_petBoxName);
    }
    return Hive.openBox(_petBoxName);
  }

  Future<Box> _openEconomyBox() async {
    if (Hive.isBoxOpen(_economyBoxName)) {
      return Hive.box(_economyBoxName);
    }
    return Hive.openBox(_economyBoxName);
  }

  @override
  Future<TamtamaModel> fetch(String userId) async {
    final box = await _openPetBox();
    final raw = box.get(userId);
    if (raw is Map) {
      final model = TamtamaModel.fromMap(
        Map<String, dynamic>.from(raw),
      );
      _petSubject.add(model);
      return model;
    }
    final initial = TamtamaModel.initial(userId);
    await save(initial);
    return initial;
  }

  @override
  Future<void> save(TamtamaModel tamtama) async {
    final box = await _openPetBox();
    await box.put(tamtama.userId, tamtama.toMap());
    _petSubject.add(tamtama);
  }

  @override
  Stream<TamtamaModel> watch(String userId) {
    // Initialize stream with current value if available
    fetch(userId);
    return _petSubject.stream
        .whereNotNull()
        .where((model) => model.userId == userId);
  }

  @override
  Future<TamtamaEconomyModel> fetchEconomy(String userId) async {
    final box = await _openEconomyBox();
    final raw = box.get(userId);
    if (raw is Map) {
      final model = TamtamaEconomyModel.fromMap(
        Map<String, dynamic>.from(raw),
      );
      _economySubject.add(model);
      return model;
    }
    final initial = TamtamaEconomyModel.initial(userId);
    await saveEconomy(initial);
    return initial;
  }

  @override
  Future<void> saveEconomy(TamtamaEconomyModel economy) async {
    final box = await _openEconomyBox();
    await box.put(economy.userId, economy.toMap());
    _economySubject.add(economy);
  }

  @override
  Stream<TamtamaEconomyModel> watchEconomy(String userId) {
    // Initialize stream with current value if available
    fetchEconomy(userId);
    return _economySubject.stream
        .whereNotNull()
        .where((model) => model.userId == userId);
  }

  @override
  Future<bool> exists(String userId) async {
    final box = await _openPetBox();
    return box.containsKey(userId);
  }

  @override
  Future<void> delete(String userId) async {
    final petBox = await _openPetBox();
    final economyBox = await _openEconomyBox();
    await petBox.delete(userId);
    await economyBox.delete(userId);
    _petSubject.add(null);
    _economySubject.add(null);
  }

  void dispose() {
    _petSubject.close();
    _economySubject.close();
  }
}
