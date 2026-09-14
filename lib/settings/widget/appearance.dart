import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

class AppearanceSettings extends ConsumerWidget {
  const AppearanceSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final Appearance appearance = ref.watch(appearanceProvider);
    final PreferenceStore store = ref.read(preferenceStoreProvider);
    return DynamicColorBuilder(
      builder: (light, dark) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Space.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Space.medium),
                child: Text('Theme', style: theme.textTheme.labelLarge),
              ),
              const SizedBox(height: Space.small),
              ChoiceStrip(
                children: [
                  for (final ThemeChoice choice in ThemeChoice.values)
                    ThemeChoiceTile(
                      choice: choice,
                      selected: appearance.theme == choice,
                      light: appearance.dynamicAccent ? light?.primary : null,
                      dark: appearance.dynamicAccent ? dark?.primary : null,
                      onTap: () => store.put(themeChoiceKey, choice.name),
                    ),
                ],
              ),
              const SizedBox(height: Space.medium),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Space.medium,
                ),
                value: appearance.dynamicAccent && light != null,
                onChanged: light == null
                    ? null
                    : (value) => store.put(dynamicAccentKey, '$value'),
                title: const Text('Accent from your system'),
                subtitle: Text(
                  light == null
                      ? 'This device does not offer an accent colour.'
                      : 'Tints buttons and highlights with your system colour.',
                ),
                secondary: AccentSwatch(
                  color: theme.brightness == Brightness.dark
                      ? dark?.primary
                      : light?.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccentSwatch extends StatelessWidget {
  const AccentSwatch({super.key, required this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color ?? theme.colorScheme.surfaceContainerHighest,
        borderRadius: Corner.cards,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
    );
  }
}

class ThemeChoiceTile extends StatelessWidget {
  const ThemeChoiceTile({
    super.key,
    required this.choice,
    required this.selected,
    required this.onTap,
    this.light,
    this.dark,
  });

  final ThemeChoice choice;
  final bool selected;
  final VoidCallback onTap;
  final Color? light;
  final Color? dark;

  String get label => switch (choice) {
    ThemeChoice.system => 'System',
    ThemeChoice.light => 'Light',
    ThemeChoice.dark => 'Dark',
    ThemeChoice.black => 'Black',
  };

  Widget _screen(Brightness brightness, {bool black = false}) => Theme(
    data: buildTheme(
      brightness,
      accent: brightness == Brightness.dark ? dark : light,
      black: black,
    ),
    child: const ThemePreview(),
  );

  @override
  Widget build(BuildContext context) => ChoiceTile(
    label: label,
    selected: selected,
    onTap: onTap,
    preview: switch (choice) {
      ThemeChoice.system => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _screen(Brightness.light)),
          Expanded(child: _screen(Brightness.dark)),
        ],
      ),
      ThemeChoice.light => _screen(Brightness.light),
      ThemeChoice.dark => _screen(Brightness.dark),
      ThemeChoice.black => _screen(Brightness.dark, black: true),
    },
  );
}

class ThemePreview extends StatelessWidget {
  const ThemePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    Widget bar(double width, Color color) => FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: width,
      child: Container(
        height: 5,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
    return ColoredBox(
      color: colors.surface,
      child: Padding(
        padding: const EdgeInsets.all(Space.small),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.tight,
          children: [
            bar(0.6, colors.onSurface),
            Expanded(
              child: Row(
                spacing: Space.tight,
                children: [
                  for (int tile = 0; tile < 2; tile++)
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Space.tight),
                child: SizedBox(
                  height: 12,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: bar(0.5, colors.onSurfaceVariant),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
