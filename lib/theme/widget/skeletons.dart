import 'package:material_ui/material_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ThemedSkeletons extends StatelessWidget {
  const ThemedSkeletons({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return SkeletonizerConfig(
      data: SkeletonizerConfigData(
        effectResolver: (brightness) => ShimmerEffect(
          baseColor: colors.surfaceContainerHighest,
          highlightColor: colors.surfaceContainer,
        ),
      ),
      child: child,
    );
  }
}
