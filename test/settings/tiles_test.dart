import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/settings/settings.dart';

void main() {
  Future<Tiles> read(Map<String, String> preferences) async {
    final ProviderContainer container = ProviderContainer(
      overrides: [
        preferencesProvider.overrideWith((ref) => Stream.value(preferences)),
      ],
    );
    addTearDown(container.dispose);
    container.listen(preferencesProvider, (previous, next) {});
    await container.read(preferencesProvider.future);
    return container.read(tilesProvider);
  }

  test('shows natural tiles with captions by default', () async {
    expect(await read(const {}), const Tiles());
  });

  test('reads the stored shape, size and captions', () async {
    expect(
      await read({
        tileShapeKey: 'even',
        tileExtentKey: '160',
        tileCaptionsKey: 'false',
      }),
      const Tiles(shape: TileShape.even, extent: 160, captions: false),
    );
  });

  test('ignores stored values it does not know', () async {
    expect(
      await read({tileShapeKey: 'hexagon', tileExtentKey: 'big'}),
      const Tiles(),
    );
    expect((await read({tileExtentKey: '9000'})).extent, maxTileExtent);
  });
}
