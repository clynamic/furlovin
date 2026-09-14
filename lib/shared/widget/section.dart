import 'package:furlovin/shared/data/data.dart';
import 'package:material_ui/material_ui.dart';

class SliverSection extends StatelessWidget {
  const SliverSection({
    super.key,
    required this.title,
    required this.expanded,
    required this.onToggle,
    required this.sliver,
    this.count,
    this.action,
    this.inset = const EdgeInsets.all(Space.medium),
  });

  final String title;
  final int? count;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget sliver;
  final Widget? action;
  final EdgeInsets inset;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double gutter = Layout.gutterOf(context);
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(gutter, Space.snug, gutter, 0),
      sliver: DecoratedSliver(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: Corner.cards,
        ),
        sliver: SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
              child: SectionHeader(
                title: title,
                count: count,
                expanded: expanded,
                onToggle: onToggle,
                padding: EdgeInsets.fromLTRB(
                  inset.left,
                  Space.tight,
                  Space.tight,
                  expanded ? 0 : Space.tight,
                ),
              ),
            ),
            if (expanded)
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  inset.left,
                  Space.small,
                  inset.right,
                  action == null ? inset.bottom : Space.small,
                ),
                sliver: sliver,
              ),
            if (expanded && action != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Space.small,
                    0,
                    Space.small,
                    Space.small,
                  ),
                  child: Align(alignment: Alignment.centerRight, child: action),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.expanded,
    required this.onToggle,
    this.count,
    this.padding = EdgeInsets.zero,
  });

  final String title;
  final int? count;
  final bool expanded;
  final VoidCallback onToggle;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: padding,
      child: Row(
        spacing: Space.small,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (count case final int value)
            Text(
              '$value',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          const Spacer(),
          IconButton(
            onPressed: onToggle,
            visualDensity: VisualDensity.compact,
            tooltip: expanded ? 'Collapse' : 'Expand',
            icon: AnimatedRotation(
              turns: expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 160),
              child: Icon(
                Icons.expand_more,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
