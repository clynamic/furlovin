import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/database/database.dart';
import 'package:furlovin/identity/identity.dart';

void main() {
  late AppDatabase database;
  late ClearanceStore store;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    store = ClearanceStore(database);
  });

  tearDown(() => database.close());

  test('round trips a clearance', () async {
    const Clearance clearance = Clearance(
      cookies: {'cf_clearance': 'token'},
      userAgent: 'Mozilla/5.0 (Linux; Android 15)',
    );
    await store.write(clearance);
    final Clearance? read = await store.read();
    expect(read?.cookies, clearance.cookies);
    expect(read?.userAgent, clearance.userAgent);
  });

  test('replaces rather than accumulating', () async {
    await store.write(const Clearance(cookies: {'cf_clearance': 'old'}));
    await store.write(const Clearance(cookies: {'cf_clearance': 'new'}));
    expect(await database.select(database.clearances).get(), hasLength(1));
    expect((await store.read())?.cookies['cf_clearance'], 'new');
  });

  test('survives logging out', () async {
    await store.write(const Clearance(cookies: {'cf_clearance': 'token'}));
    await IdentityStore(database).clear();
    expect((await store.read())?.cookies['cf_clearance'], 'token');
  });
}
