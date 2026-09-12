import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/database/database.dart';
import 'package:furlovin/identity/identity.dart';

void main() {
  late AppDatabase database;
  late IdentityStore store;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    store = IdentityStore(database);
  });

  tearDown(() => database.close());

  test('reads nothing when empty', () async {
    expect(await store.read(), isNull);
  });

  test('round trips a session', () async {
    const Session session = Session(
      cookies: {'a': 'one', 'b': 'two'},
      userAgent: 'Mozilla/5.0 (X11; Linux x86_64)',
    );
    await store.write(session);
    final Session? read = await store.read();
    expect(read, isNotNull);
    expect(read!.cookies, session.cookies);
    expect(read.userAgent, session.userAgent);
    expect(read.isAuthenticated, isTrue);
  });

  test('replaces rather than accumulating', () async {
    await store.write(const Session(cookies: {'a': '1', 'b': '2'}));
    await store.write(const Session(cookies: {'a': '3', 'b': '4'}));
    expect(await database.select(database.identities).get(), hasLength(1));
    expect((await store.read())!.cookies['a'], '3');
  });

  test('clears', () async {
    await store.write(const Session(cookies: {'a': '1', 'b': '2'}));
    await store.clear();
    expect(await store.read(), isNull);
  });
}
