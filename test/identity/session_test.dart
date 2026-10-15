import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/database/database.dart';
import 'package:furlovin/identity/identity.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer.test(
      overrides: [databaseProvider.overrideWithValue(database)],
    );
  });

  tearDown(() => database.close());

  test('starts with the stored clearance', () async {
    await IdentityStore(database)
        .write(const Session(cookies: {'a': 'x', 'b': 'y'}));
    await ClearanceStore(database)
        .write(const Clearance(cookies: {'cf_clearance': 'token'}));

    container.listen(sessionProvider, (previous, next) {});
    final Session session = await container.read(sessionProvider.future);
    expect(session.isAuthenticated, isTrue);
    expect(session.clearance.cookies, {'cf_clearance': 'token'});
  });

  test('takes a new clearance without dropping the login', () async {
    await IdentityStore(database)
        .write(const Session(cookies: {'a': 'x', 'b': 'y'}));
    final List<bool> authenticated = [];
    container.listen<bool>(
      authenticatedProvider,
      (previous, next) => authenticated.add(next),
      fireImmediately: true,
    );
    await container.read(sessionProvider.future);

    await ClearanceStore(database)
        .write(const Clearance(cookies: {'cf_clearance': 'token'}));
    await pumpEventQueue();

    expect(container.read(sessionProvider).value?.clearance.cookies, {
      'cf_clearance': 'token',
    });
    expect(authenticated.skipWhile((e) => !e), everyElement(isTrue));
  });
}
