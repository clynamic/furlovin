import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('black turns the page black and keeps cards lifted above it', () {
    final ColorScheme black = buildTheme(
      Brightness.dark,
      black: true,
    ).colorScheme;
    expect(black.surface, const Color(0xFF000000));
    expect(
      black.surfaceContainerLowest.computeLuminance(),
      greaterThan(black.surface.computeLuminance()),
    );
  });

  test('black only applies to the dark theme', () {
    expect(
      buildTheme(Brightness.light, black: true).colorScheme.surface,
      buildTheme(Brightness.light).colorScheme.surface,
    );
  });

  test('an accent reseeds the primary colour', () {
    expect(
      buildTheme(
        Brightness.light,
        accent: const Color(0xFFE91E63),
      ).colorScheme.primary,
      isNot(buildTheme(Brightness.light).colorScheme.primary),
    );
  });
}
