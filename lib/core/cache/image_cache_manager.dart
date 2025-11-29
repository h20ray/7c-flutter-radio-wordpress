import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageCacheManager extends CacheManager {
  static const String _cacheKey = 'imageCache';
  static const int _maxCacheObjects = 200;
  static const Duration _stalePeriod = Duration(days: 30);

  static final ImageCacheManager _instance = ImageCacheManager._internal();

  factory ImageCacheManager() => _instance;

  ImageCacheManager._internal()
      : super(
          Config(
            _cacheKey,
            stalePeriod: _stalePeriod,
            maxNrOfCacheObjects: _maxCacheObjects,
            repo: JsonCacheInfoRepository(databaseName: _cacheKey),
            fileSystem: IOFileSystem(_cacheKey),
            fileService: HttpFileService(),
          ),
        );

  Future<File> getCachedFile(String url) async {
    return await getSingleFile(url);
  }

  Future<void> clearCache() async {
    await emptyCache();
  }
}

