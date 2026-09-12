import 'package:material_ui/material_ui.dart';

const double readableRatio = 4.5;
const double readableStep = 0.02;

double contrastRatio(Color first, Color second) {
  final double one = first.computeLuminance();
  final double two = second.computeLuminance();
  final double lighter = one > two ? one : two;
  final double darker = one > two ? two : one;
  return (lighter + 0.05) / (darker + 0.05);
}

Color readableOn(Color color, Color ground, {double ratio = readableRatio}) {
  if (contrastRatio(color, ground) >= ratio) return color;
  final bool darken = ground.computeLuminance() > 0.5;
  final HSLColor start = HSLColor.fromColor(color);
  for (double shift = readableStep; shift <= 1; shift += readableStep) {
    final double lightness =
        (darken ? start.lightness - shift : start.lightness + shift).clamp(
          0.0,
          1.0,
        );
    final Color candidate = start.withLightness(lightness).toColor();
    if (contrastRatio(candidate, ground) >= ratio) return candidate;
    if (lightness == 0 || lightness == 1) break;
  }
  return darken ? Colors.black : Colors.white;
}
