import 'package:drift/drift.dart';

class CacheEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get store => text()();

  TextColumn get cacheKey => text()();

  TextColumn get url => text()();

  TextColumn get path => text()();

  DateTimeColumn get validTill => dateTime()();

  TextColumn get eTag => text().nullable()();

  IntColumn get size => integer().nullable()();

  DateTimeColumn get touched => dateTime()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {store, cacheKey},
  ];
}
