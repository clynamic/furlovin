import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/database/database.dart';

const String thumbnailCacheKey = 'furlovin_thumbnails';
const String artworkCacheKey = 'furlovin_artwork';

const int thumbnailCacheBytes = 128 * 1024 * 1024;
const int artworkCacheBytes = 256 * 1024 * 1024;

const int thumbnailCacheObjects = 3000;
const int artworkCacheObjects = 400;

CacheManager createThumbnailCache(Dio dio, AppDatabase database) =>
    CacheManager(
      Config(
        thumbnailCacheKey,
        maxNrOfCacheObjects: thumbnailCacheObjects,
        fileService: DioFileService(dio),
        repo: DriftCacheRepository(
          database: database,
          store: thumbnailCacheKey,
          maxBytes: thumbnailCacheBytes,
        ),
      ),
    );

CacheManager createArtworkCache(Dio dio, AppDatabase database) => CacheManager(
  Config(
    artworkCacheKey,
    maxNrOfCacheObjects: artworkCacheObjects,
    stalePeriod: const Duration(days: 7),
    fileService: DioFileService(dio),
    repo: DriftCacheRepository(
      database: database,
      store: artworkCacheKey,
      maxBytes: artworkCacheBytes,
    ),
  ),
);
