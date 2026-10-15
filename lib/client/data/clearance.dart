import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:furlovin/database/database.dart';
import 'package:meta/meta.dart';

@immutable
class Clearance {
  const Clearance({this.cookies = const {}, this.userAgent});

  static const List<String> names = ['cf_clearance'];

  final Map<String, String> cookies;
  final String? userAgent;
}

class ClearanceStore {
  const ClearanceStore(this.database);

  final AppDatabase database;

  Future<Clearance?> read() async =>
      _clearanceOf(await _query().getSingleOrNull());

  Stream<Clearance?> watch() => _query().watchSingleOrNull().map(_clearanceOf);

  SimpleSelectStatement<$ClearancesTable, ClearanceRow> _query() =>
      database.select(database.clearances)
        ..orderBy([
          (e) => OrderingTerm.desc(e.updatedAt),
          (e) => OrderingTerm.desc(e.id),
        ])
        ..limit(1);

  Clearance? _clearanceOf(ClearanceRow? row) => row == null
      ? null
      : Clearance(cookies: _decode(row.cookies), userAgent: row.userAgent);

  Future<void> write(Clearance clearance) => database.transaction(() async {
    final ClearanceRow? row = await _query().getSingleOrNull();
    final ClearancesCompanion values = ClearancesCompanion(
      cookies: Value(jsonEncode(clearance.cookies)),
      userAgent: Value(clearance.userAgent),
      updatedAt: Value(DateTime.now()),
    );
    if (row == null) {
      await database.into(database.clearances).insert(values);
      return;
    }
    await (database.update(
      database.clearances,
    )..where((e) => e.id.equals(row.id))).write(values);
  });

  Map<String, String> _decode(String value) {
    final Object? json = jsonDecode(value);
    if (json is! Map) return const {};
    return json.map((k, v) => MapEntry(k.toString(), v.toString()));
  }
}
