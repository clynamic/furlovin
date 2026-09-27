import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/settings/settings.dart';

void main() {
  Future<Hand> read(Map<String, String> preferences) async {
    final ProviderContainer container = ProviderContainer.test(
      overrides: [
        preferencesProvider.overrideWith((ref) => Stream.value(preferences)),
      ],
    );
    container.listen(preferencesProvider, (previous, next) {});
    await container.read(preferencesProvider.future);
    return container.read(handProvider);
  }

  test('keeps the toolbar on the right by default', () async {
    expect(await read(const {}), Hand.right);
  });

  test('reads the stored hand, and ignores ones it does not know', () async {
    expect(await read({handKey: 'left'}), Hand.left);
    expect(await read({handKey: 'centre'}), Hand.right);
  });

  test('a left hand mirrors the order of the toolbar', () {
    expect(['more', 'share', 'favourite'].forHand(Hand.right), [
      'more',
      'share',
      'favourite',
    ]);
    expect(['more', 'share', 'favourite'].forHand(Hand.left), [
      'favourite',
      'share',
      'more',
    ]);
  });
}
