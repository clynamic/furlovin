import 'package:furlovin/shared/data/data.dart';
import 'package:material_ui/material_ui.dart';

const double spreadBreakpoint = 560;

class SpreadRow extends StatelessWidget {
  const SpreadRow({
    super.key,
    required this.leading,
    required this.trailing,
    this.breakpoint = spreadBreakpoint,
  });

  final Widget leading;
  final Widget Function(bool wide) trailing;
  final double breakpoint;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < breakpoint) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Space.medium,
          children: [leading, trailing(false)],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Space.large,
        children: [
          Expanded(child: leading),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth / 2),
            child: trailing(true),
          ),
        ],
      );
    },
  );
}
