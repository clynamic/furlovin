import 'package:drift/native.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/database/database.dart';

void main() {
  late AppDatabase database;
  late DriftCacheRepository thumbnails;
  late DriftCacheRepository artwork;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    thumbnails = DriftCacheRepository(
      database: database,
      store: 'thumbnails',
      maxBytes: 1000,
    );
    artwork = DriftCacheRepository(
      database: database,
      store: 'artwork',
      maxBytes: 1000,
    );
  });

  tearDown(() => database.close());

  Future<CacheObject> put(
    DriftCacheRepository repository,
    String key, {
    int size = 100,
    DateTime? touched,
  }) => repository.insert(
    CacheObject(
      'https://t.furaffinity.net/$key.jpg',
      key: key,
      relativePath: '$key.jpg',
      validTill: DateTime(2030),
      length: size,
      touched: touched,
    ),
    setTouchedToNow: touched == null,
  );

  test('round trips an object', () async {
    final CacheObject stored = await put(thumbnails, 'a', size: 42);
    expect(stored.id, isNotNull);

    final CacheObject? read = await thumbnails.get('a');
    expect(read!.url, 'https://t.furaffinity.net/a.jpg');
    expect(read.relativePath, 'a.jpg');
    expect(read.length, 42);
    expect(read.id, stored.id);
  });

  test('keeps stores apart', () async {
    await put(thumbnails, 'shared');
    await put(artwork, 'shared');

    expect(await thumbnails.getAllObjects(), hasLength(1));
    expect(await artwork.getAllObjects(), hasLength(1));
    expect(await thumbnails.get('shared'), isNotNull);
  });

  test('evicts by bytes, oldest first', () async {
    for (int index = 0; index < 12; index++) {
      await put(
        thumbnails,
        'k$index',
        touched: DateTime(2026).add(Duration(minutes: index)),
      );
    }

    final List<CacheObject> excess = await thumbnails.getObjectsOverCapacity(
      1000,
    );

    expect(excess.map((e) => e.key), ['k1', 'k0']);
  });

  test('still honours the object count', () async {
    for (int index = 0; index < 5; index++) {
      await put(
        thumbnails,
        'k$index',
        size: 1,
        touched: DateTime(2026).add(Duration(minutes: index)),
      );
    }

    final List<CacheObject> excess = await thumbnails.getObjectsOverCapacity(3);
    expect(excess.map((e) => e.key), ['k1', 'k0']);
  });

  test('reports objects past their age', () async {
    await put(thumbnails, 'fresh', touched: DateTime.now());
    await put(
      thumbnails,
      'stale',
      touched: DateTime.now().subtract(const Duration(days: 30)),
    );

    final List<CacheObject> old = await thumbnails.getOldObjects(
      const Duration(days: 7),
    );
    expect(old.map((e) => e.key), ['stale']);
  });

  test('deletes by id and in bulk', () async {
    final CacheObject one = await put(thumbnails, 'one');
    final CacheObject two = await put(thumbnails, 'two');
    final CacheObject three = await put(thumbnails, 'three');

    expect(await thumbnails.delete(one.id!), 1);
    expect(await thumbnails.deleteAll([two.id!, three.id!]), 2);
    expect(await thumbnails.getAllObjects(), isEmpty);
    expect(await thumbnails.deleteAll(const []), 0);
  });

  test('updates in place without duplicating', () async {
    final CacheObject stored = await put(thumbnails, 'a', size: 10);
    await thumbnails.updateOrInsert(stored.copyWith(length: 999));

    final List<CacheObject> all = await thumbnails.getAllObjects();
    expect(all, hasLength(1));
    expect(all.single.length, 999);
  });

  test('clears only its own store', () async {
    await put(thumbnails, 'a');
    await put(artwork, 'b');

    await thumbnails.deleteDataFile();

    expect(await thumbnails.getAllObjects(), isEmpty);
    expect(await artwork.getAllObjects(), hasLength(1));
  });
}
