//캐시 관리

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class CustomCacheManager extends BaseCacheManager {
  factory CustomCacheManager() {
    _instance ??= CustomCacheManager._();

    return _instance;
  }

  CustomCacheManager._()
      : super(key,
            maxAgeCacheObject: const Duration(days: 7),
            maxNrOfCacheObjects: 30);

  static const String key = 'customCache';

  static CustomCacheManager _instance;

  @override
  Future<String> getFilePath() async {
    final directory = await getTemporaryDirectory();
    print('directory.path ${directory.path}');
    return p.join(directory.path, key);
  }
}

class CustomImageCache extends WidgetsFlutterBinding {
  @override
  ImageCache createImageCache() {
    final imageCache = super.createImageCache();

    imageCache.maximumSizeBytes = 20 * 1024 * 1024; //20mb 이상->캐시클리어

    return imageCache;
  }
}
