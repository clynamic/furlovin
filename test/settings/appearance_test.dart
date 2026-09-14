import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Appearance read(Map<String, String> preferences) {
    final ProviderContainer container = ProviderContainer(
      overrides: [
        preferencesProvider.overrideWith((ref) => Stream.value(preferences)),
      ],
    );
    addTearDown(container.dispose);
    container.listen(preferencesProvider, (previous, next) {});
    return container.read(appearanceProvider);
  }

  test('follows the system with the fixed accent by default', () {
    const Appearance appearance = Appearance();
    expect(appearance.mode, ThemeMode.system);
    expect(appearance.black, isFalse);
    expect(appearance.dynamicAccent, isFalse);
  });

  test('black is a dark mode with black surfaces', () {
    const Appearance appearance = Appearance(theme: ThemeChoice.black);
    expect(appearance.mode, ThemeMode.dark);
    expect(appearance.black, isTrue);
  });

  test('reads the stored choices, and ignores ones it does not know', () async {
    final ProviderContainer container = ProviderContainer(
      overrides: [
        preferencesProvider.overrideWith(
          (ref) =>
              Stream.value({themeChoiceKey: 'light', dynamicAccentKey: 'true'}),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.listen(preferencesProvider, (previous, next) {});
    await container.read(preferencesProvider.future);

    expect(
      container.read(appearanceProvider),
      const Appearance(theme: ThemeChoice.light, dynamicAccent: true),
    );
    expect(read({themeChoiceKey: 'sepia'}).theme, ThemeChoice.system);
  });
}
