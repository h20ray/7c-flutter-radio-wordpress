import 'package:hive/hive.dart';
import '../../../../config/news_config.dart';
import '../../../../core/utils/debug_logger.dart';
import '../models/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>?> getCachedCategories();
  Future<void> cacheCategories(List<CategoryModel> categories);
  Future<List<int>?> getCachedHomeTopTabCategories();
  Future<void> cacheHomeTopTabCategories(List<int> categories);
  Future<List<int>?> getCachedBlockedCategories();
  Future<void> cacheBlockedCategories(List<int> categories);
  Future<DateTime?> getCategoriesCacheTimestamp();
  Future<DateTime?> getConfigCacheTimestamp();
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  static const _categoriesBoxName = 'categories_box';
  static const _configBoxName = 'category_config_box';
  static const _categoriesKey = 'categories';
  static const _homeTopTabCategoriesKey = 'homeTopTabCategories';
  static const _blockedCategoriesKey = 'blockedCategories';
  static const _categoriesTimestampKey = 'categories_timestamp';
  static const _configTimestampKey = 'config_timestamp';

  Future<Box> _openCategoriesBox() async {
    if (Hive.isBoxOpen(_categoriesBoxName)) {
      return Hive.box(_categoriesBoxName);
    }
    return Hive.openBox(_categoriesBoxName);
  }

  Future<Box> _openConfigBox() async {
    if (Hive.isBoxOpen(_configBoxName)) {
      return Hive.box(_configBoxName);
    }
    return Hive.openBox(_configBoxName);
  }

  bool _isCacheValid(DateTime? cacheTime) {
    if (cacheTime == null) return false;
    final now = DateTime.now();
    final difference = now.difference(cacheTime);
    return difference <= NewsConfig.categoryCacheTTL;
  }

  @override
  Future<List<CategoryModel>?> getCachedCategories() async {
    try {
      final box = await _openCategoriesBox();
      final timestamp = box.get(_categoriesTimestampKey) as int?;
      
      if (timestamp == null) return null;
      
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (!_isCacheValid(cacheTime)) {
        return null;
      }
      
      final raw = box.get(_categoriesKey);
      if (raw is List) {
        return raw.map((item) {
          if (item is Map) {
            return CategoryModel.fromJson(Map<String, dynamic>.from(item));
          }
          return null;
        }).whereType<CategoryModel>().toList();
      }
      
      return null;
    } catch (e, stackTrace) {
      DebugLogger.logError(
        'Failed to read cached categories',
        error: e,
        stackTrace: stackTrace,
        tag: 'CategoryLocalDataSource',
      );
      return null;
    }
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    try {
      final box = await _openCategoriesBox();
      final categoriesJson = categories.map((category) => category.toJson()).toList();
      await box.put(_categoriesKey, categoriesJson);
      await box.put(_categoriesTimestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e, stackTrace) {
      DebugLogger.logError(
        'Failed to cache categories',
        error: e,
        stackTrace: stackTrace,
        tag: 'CategoryLocalDataSource',
      );
    }
  }

  @override
  Future<List<int>?> getCachedHomeTopTabCategories() async {
    try {
      final box = await _openConfigBox();
      final timestamp = box.get(_configTimestampKey) as int?;
      
      if (timestamp == null) return null;
      
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (!_isCacheValid(cacheTime)) {
        return null;
      }
      
      final raw = box.get(_homeTopTabCategoriesKey);
      if (raw is List) {
        return raw.map((item) => int.tryParse(item.toString()) ?? 0).where((e) => e > 0).toList();
      }
      
      return null;
    } catch (e, stackTrace) {
      DebugLogger.logError(
        'Failed to read cached home top tab categories',
        error: e,
        stackTrace: stackTrace,
        tag: 'CategoryLocalDataSource',
      );
      return null;
    }
  }

  @override
  Future<void> cacheHomeTopTabCategories(List<int> categories) async {
    try {
      final box = await _openConfigBox();
      await box.put(_homeTopTabCategoriesKey, categories);
      await box.put(_configTimestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e, stackTrace) {
      DebugLogger.logError(
        'Failed to cache home top tab categories',
        error: e,
        stackTrace: stackTrace,
        tag: 'CategoryLocalDataSource',
      );
    }
  }

  @override
  Future<List<int>?> getCachedBlockedCategories() async {
    try {
      final box = await _openConfigBox();
      final timestamp = box.get(_configTimestampKey) as int?;
      
      if (timestamp == null) return null;
      
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (!_isCacheValid(cacheTime)) {
        return null;
      }
      
      final raw = box.get(_blockedCategoriesKey);
      if (raw is List) {
        return raw.map((item) => int.tryParse(item.toString()) ?? 0).where((e) => e > 0).toList();
      }
      
      return null;
    } catch (e, stackTrace) {
      DebugLogger.logError(
        'Failed to read cached blocked categories',
        error: e,
        stackTrace: stackTrace,
        tag: 'CategoryLocalDataSource',
      );
      return null;
    }
  }

  @override
  Future<void> cacheBlockedCategories(List<int> categories) async {
    try {
      final box = await _openConfigBox();
      await box.put(_blockedCategoriesKey, categories);
      await box.put(_configTimestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e, stackTrace) {
      DebugLogger.logError(
        'Failed to cache blocked categories',
        error: e,
        stackTrace: stackTrace,
        tag: 'CategoryLocalDataSource',
      );
    }
  }

  @override
  Future<DateTime?> getCategoriesCacheTimestamp() async {
    try {
      final box = await _openCategoriesBox();
      final timestamp = box.get(_categoriesTimestampKey) as int?;
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<DateTime?> getConfigCacheTimestamp() async {
    try {
      final box = await _openConfigBox();
      final timestamp = box.get(_configTimestampKey) as int?;
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

