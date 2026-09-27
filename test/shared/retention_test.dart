import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/shared/shared.dart';

void main() {
  test('drops the oldest once over capacity', () async {
    final ProviderContainer container = ProviderContainer.test();

    final Retention retention = Retention(2);
    final List<int> disposed = [];

    final counted = FutureProvider.autoDispose.family<int, int>((
      ref,
      id,
    ) async {
      ref.onDispose(() {
        disposed.add(id);
        retention.release(id);
      });
      retention.hold(id, ref.keepAlive());
      return id;
    });

    for (final int id in [1, 2, 3]) {
      await container.read(counted(id).future);
    }

    await Future<void>.delayed(Duration.zero);

    expect(retention.length, 2);
    expect(disposed, [1]);
  });

  test('re-holding the same key keeps one link', () {
    final Retention retention = Retention(4);
    expect(retention.length, 0);
    retention.release(99);
    expect(retention.length, 0);
  });
}
