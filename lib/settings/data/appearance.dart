import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:material_ui/material_ui.dart';

enum ThemeChoice { system, light, dark, black }

const String themeChoiceKey = 'appearance.theme';
const String dynamicAccentKey = 'appearance.dynamicAccent';

@immutable
class Appearance {
  const Appearance({
    this.theme = ThemeChoice.system,
    this.dynamicAccent = false,
  });

  final ThemeChoice theme;
  final bool dynamicAccent;

  ThemeMode get mode => switch (theme) {
    ThemeChoice.system => ThemeMode.system,
    ThemeChoice.light => ThemeMode.light,
    ThemeChoice.dark || ThemeChoice.black => ThemeMode.dark,
  };

  bool get black => theme == ThemeChoice.black;

  @override
  bool operator ==(Object other) =>
      other is Appearance &&
      other.theme == theme &&
      other.dynamicAccent == dynamicAccent;

  @override
  int get hashCode => Object.hash(theme, dynamicAccent);
}

final Provider<Appearance> appearanceProvider = Provider<Appearance>((ref) {
  final Map<String, String> preferences =
      ref.watch(preferencesProvider).value ?? const {};
  return Appearance(
    theme:
        ThemeChoice.values.asNameMap()[preferences[themeChoiceKey]] ??
        ThemeChoice.system,
    dynamicAccent: preferences[dynamicAccentKey] == 'true',
  );
});
