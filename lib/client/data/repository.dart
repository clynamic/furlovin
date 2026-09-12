import 'package:drift/drift.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:furlovin/database/database.dart';

class DriftCacheRepository implements CacheInfoRepository {
  const DriftCacheRepository({
    required this.database,
    required this.store,
    required this.maxBytes,
  });

  final AppDatabase database;
  final String store;
  final int maxBytes;

  $CacheEntriesTable get _table => database.cacheEntries;

  SimpleSelectStatement<$CacheEntriesTable, CacheEntry> get _mine =>
      database.select(_table)..where((row) => row.store.equals(store));

  CacheObject _object(CacheEntry row) => CacheObject(
    row.url,
    key: row.cacheKey,
    relativePath: row.path,
    validTill: row.validTill,
    eTag: row.eTag,
    id: row.id,
    length: row.size,
    touched: row.touched,
  );

  CacheEntriesCompanion _companion(CacheObject object, DateTime touched) =>
      CacheEntriesCompanion.insert(
        store: store,
        cacheKey: object.key,
        url: object.url,
        path: object.relativePath,
        validTill: object.validTill,
        eTag: Value(object.eTag),
        size: Value(object.length),
        touched: touched,
      );

  DateTime _touch(CacheObject object, bool now) =>
      now ? DateTime.now() : object.touched ?? DateTime.now();

  @override
  Future<bool> exists() async => true;

  @override
  Future<bool> open() async => true;

  @override
  Future<bool> close() async => true;

  @override
  Future<CacheObject?> get(String key) async {
    final CacheEntry? row =
        await (_mine..where((row) => row.cacheKey.equals(key)))
            .getSingleOrNull();
    return row == null ? null : _object(row);
  }

  @override
  Future<CacheObject> insert(
    CacheObject cacheObject, {
    bool setTouchedToNow = true,
  }) async {
    final int id = await database
        .into(_table)
        .insert(_companion(cacheObject, _touch(cacheObject, setTouchedToNow)));
    return cacheObject.copyWith(id: id);
  }

  @override
  Future<int> update(
    CacheObject cacheObject, {
    bool setTouchedToNow = true,
  }) async {
    final int? id = cacheObject.id;
    if (id == null) return 0;
    return (database.update(_table)..where((row) => row.id.equals(id))).write(
      _companion(cacheObject, _touch(cacheObject, setTouchedToNow)),
    );
  }

  @override
  Future<dynamic> updateOrInsert(CacheObject cacheObject) async {
    if (cacheObject.id == null) return insert(cacheObject);
    return update(cacheObject);
  }

  @override
  Future<int> delete(int id) =>
      (database.delete(_table)..where((row) => row.id.equals(id))).go();

  @override
  Future<int> deleteAll(Iterable<int> ids) async {
    if (ids.isEmpty) return 0;
    return (database.delete(
      _table,
    )..where((row) => row.id.isIn(ids.toList()))).go();
  }

  @override
  Future<List<CacheObject>> getAllObjects() async =>
      (await _mine.get()).map(_object).toList();

  @override
  Future<List<CacheObject>> getOldObjects(Duration maxAge) async {
    final DateTime cutoff = DateTime.now().subtract(maxAge);
    final List<CacheEntry> rows =
        await (_mine..where((row) => row.touched.isSmallerThanValue(cutoff)))
            .get();
    return rows.map(_object).toList();
  }

  @override
  Future<List<CacheObject>> getObjectsOverCapacity(int capacity) async {
    final List<CacheEntry> rows =
        await (_mine..orderBy([(row) => OrderingTerm.desc(row.touched)])).get();
    final List<CacheObject> excess = [];
    int used = 0;
    for (int index = 0; index < rows.length; index++) {
      used += rows[index].size ?? 0;
      if (index >= capacity || used > maxBytes) {
        excess.add(_object(rows[index]));
      }
    }
    return excess;
  }

  @override
  Future<void> deleteDataFile() async {
    await (database.delete(
      _table,
    )..where((row) => row.store.equals(store))).go();
  }
}
