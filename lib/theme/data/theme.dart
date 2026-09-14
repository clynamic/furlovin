import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

const Color faHighlight = Color(0xFFADD8F5);
const Color faSlate = Color(0xFF20242A);

const Color seedColor = Color(0xFF3F8FC4);

class Ratings extends ThemeExtension<Ratings> {
  const Ratings({
    required this.general,
    required this.mature,
    required this.adult,
    required this.missing,
  });

  static const Ratings light = Ratings(
    general: Color(0xFF5A6069),
    mature: Color(0xFF8A5200),
    adult: Color(0xFFB3261E),
    missing: Color(0xFF8A8079),
  );

  static const Ratings dark = Ratings(
    general: Color(0xFFA8AEB8),
    mature: Color(0xFFF0B357),
    adult: Color(0xFFF2867F),
    missing: Color(0xFF8A8079),
  );

  final Color general;
  final Color mature;
  final Color adult;
  final Color missing;

  @override
  Ratings copyWith({
    Color? general,
    Color? mature,
    Color? adult,
    Color? missing,
  }) => Ratings(
    general: general ?? this.general,
    mature: mature ?? this.mature,
    adult: adult ?? this.adult,
    missing: missing ?? this.missing,
  );

  @override
  Ratings lerp(Ratings? other, double t) {
    if (other == null) return this;
    return Ratings(
      general: Color.lerp(general, other.general, t)!,
      mature: Color.lerp(mature, other.mature, t)!,
      adult: Color.lerp(adult, other.adult, t)!,
      missing: Color.lerp(missing, other.missing, t)!,
    );
  }
}

extension RatingsTheme on ThemeData {
  Ratings get ratings => extension<Ratings>() ?? Ratings.light;
}

const ButtonStyle buttonStyle = ButtonStyle(
  shape: WidgetStatePropertyAll<OutlinedBorder>(
    RoundedRectangleBorder(borderRadius: Corner.panels),
  ),
);

final Map<(Brightness, Color?, bool), ThemeData> _themes = {};

ThemeData buildTheme(
  Brightness brightness, {
  Color? accent,
  bool black = false,
}) => _themes.putIfAbsent((
  brightness,
  accent,
  brightness == Brightness.dark && black,
), () => _buildTheme(brightness, accent: accent, black: black));

ThemeData _buildTheme(
  Brightness brightness, {
  Color? accent,
  bool black = false,
}) {
  final bool isDark = brightness == Brightness.dark;
  final bool isBlack = isDark && black;
  final ColorScheme scheme = ColorScheme.fromSeed(
    seedColor: accent ?? seedColor,
    brightness: brightness,
    surface: switch ((isDark, isBlack)) {
      (_, true) => const Color(0xFF000000),
      (true, _) => const Color(0xFF1A1D22),
      _ => const Color(0xFFFAF9F7),
    },
    surfaceContainerLowest: switch ((isDark, isBlack)) {
      (_, true) => const Color(0xFF0F0F10),
      (true, _) => const Color(0xFF141619),
      _ => const Color(0xFFFFFFFF),
    },
    surfaceContainer: switch ((isDark, isBlack)) {
      (_, true) => const Color(0xFF18191B),
      (true, _) => const Color(0xFF22262D),
      _ => const Color(0xFFF1EFEC),
    },
    surfaceContainerHighest: switch ((isDark, isBlack)) {
      (_, true) => const Color(0xFF232427),
      (true, _) => const Color(0xFF2C313A),
      _ => const Color(0xFFE7E4E0),
    },
  );

  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    extensions: <ThemeExtension<Object?>>[
      if (isDark) Ratings.dark else Ratings.light,
    ],
    textButtonTheme: const TextButtonThemeData(style: buttonStyle),
    iconButtonTheme: const IconButtonThemeData(style: buttonStyle),
    outlinedButtonTheme: const OutlinedButtonThemeData(style: buttonStyle),
    filledButtonTheme: FilledButtonThemeData(
      style: buttonStyle.copyWith(
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: Space.page, vertical: Space.snug),
        ),
      ),
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(style: buttonStyle),
    segmentedButtonTheme: const SegmentedButtonThemeData(style: buttonStyle),
    dialogTheme: const DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: Corner.toolbar),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surfaceContainerLowest,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: Corner.cards),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: scheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant,
      thickness: 1,
      space: 1,
    ),
    chipTheme: ChipThemeData(
      side: BorderSide.none,
      backgroundColor: scheme.surfaceContainer,
      shape: const RoundedRectangleBorder(borderRadius: Corner.cards),
    ),
  );
}
