import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:furlovin/client/data/table.dart';
import 'package:furlovin/identity/data/table.dart';
import 'package:furlovin/settings/data/table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Identities, Preferences, CacheEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'furlovin'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(preferences);
      if (from < 3) await m.createTable(cacheEntries);
    },
  );
}
