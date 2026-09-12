import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/database/database.dart';

class IdentityStore {
  const IdentityStore(this.database);

  final AppDatabase database;

  Future<Session?> read() async => _sessionOf(await _query().getSingleOrNull());

  Stream<Session?> watch() => _query().watchSingleOrNull().map(_sessionOf);

  SimpleSelectStatement<$IdentitiesTable, Identity> _query() =>
      database.select(database.identities)
        ..orderBy([
          (e) => OrderingTerm.desc(e.updatedAt),
          (e) => OrderingTerm.desc(e.id),
        ])
        ..limit(1);

  Session? _sessionOf(Identity? row) => row == null
      ? null
      : Session(cookies: _decode(row.cookies), userAgent: row.userAgent);

  Future<void> write(Session session, {String? username}) =>
      database.transaction(() async {
        final Identity? row = await _query().getSingleOrNull();
        final IdentitiesCompanion values = IdentitiesCompanion(
          username: username == null ? const Value.absent() : Value(username),
          cookies: Value(jsonEncode(session.cookies)),
          userAgent: Value(session.userAgent),
          updatedAt: Value(DateTime.now()),
        );
        if (row == null) {
          await database.into(database.identities).insert(values);
          return;
        }
        await (database.update(
          database.identities,
        )..where((e) => e.id.equals(row.id))).write(values);
      });

  Future<void> clear() => database.delete(database.identities).go();

  Map<String, String> _decode(String value) {
    final Object? json = jsonDecode(value);
    if (json is! Map) return const {};
    return json.map((k, v) => MapEntry(k.toString(), v.toString()));
  }
}
