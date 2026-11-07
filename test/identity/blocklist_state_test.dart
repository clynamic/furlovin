import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';

import '../_support/documents.dart';

class _Account extends ViewerClient {
  _Account(this.tags) : super(client: FaClient(), rules: loadRules());

  final Set<String> tags;

  @override
  Future<Viewer?> viewer() async => Viewer(
    name: 'mossbadger',
    tagBlocklist: tags.join(' '),
    blocklistKey: 'ab12',
  );

  @override
  Future<List<String>> setTagBlocked(
    String tag, {
    required bool blocked,
    required String key,
  }) async {
    final String stored = tag.trim().replaceAll(' ', '_');
    if (blocked && !tags.add(stored)) {
      throw const ActionRejected('Keyword already exists');
    }
    if (!blocked) tags.remove(stored);
    return [stored];
  }
}

void main() {
  Future<ProviderContainer> host(_Account account) async {
    final ProviderContainer container = ProviderContainer.test(
      overrides: [
        authenticatedProvider.overrideWithValue(true),
        viewerClientProvider.overrideWith((ref) async => account),
      ],
    );
    container.listen(blocklistProvider, (previous, next) {});
    await container.read(viewerProvider.future);
    return container;
  }

  test('keeps the tag name the site stored', () async {
    final ProviderContainer container = await host(_Account({'feet'}));
    await container
        .read(blocklistProvider.notifier)
        .setTag('big fish', blocked: true);
    expect(container.read(blocklistProvider).tags, {'feet', 'big_fish'});
  });

  test('a refused change still reloads the list from the account', () async {
    final _Account account = _Account({'feet'});
    final ProviderContainer container = await host(account);
    account.tags.add('toes');
    await expectLater(
      container.read(blocklistProvider.notifier).setTag('feet', blocked: true),
      throwsA(isA<ActionRejected>()),
    );
    await container.read(viewerProvider.future);
    expect(container.read(blocklistProvider).tags, {'feet', 'toes'});
  });
}
