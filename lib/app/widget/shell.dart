import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

const double barHeight = 64;
const double barSpace = barHeight + Space.snug + Space.snug;

class ShellDestination {
  const ShellDestination({
    required this.icon,
    required this.selected,
    required this.label,
    required this.path,
    this.alerts,
  });

  final IconData icon;
  final IconData selected;
  final String label;
  final String path;
  final int? Function(Viewer viewer)? alerts;
}

const List<ShellDestination> shellDestinations = [
  ShellDestination(
    icon: Icons.inbox_outlined,
    selected: Icons.inbox,
    label: 'Inbox',
    path: inboxPath,
    alerts: _submissionAlerts,
  ),
  ShellDestination(
    icon: Icons.explore_outlined,
    selected: Icons.explore,
    label: 'Browse',
    path: browsePath,
  ),
  ShellDestination(
    icon: Icons.person_outline,
    selected: Icons.person,
    label: 'You',
    path: mePath,
  ),
];

int? _submissionAlerts(Viewer viewer) => viewer.submissionAlerts;

class ShellBar extends StatelessWidget {
  const ShellBar({
    super.key,
    required this.index,
    required this.viewer,
    required this.onGo,
    required this.onSearch,
  });

  final int index;
  final Viewer? viewer;
  final ValueChanged<int> onGo;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerLowest,
      elevation: 3,
      shadowColor: Colors.black,
      borderRadius: Corner.toolbar,
      child: SizedBox(
        height: barHeight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (int at, ShellDestination destination)
                in shellDestinations.indexed)
              ShellTab(
                destination: destination,
                chosen: at == index,
                count: viewer == null
                    ? null
                    : destination.alerts?.call(viewer!),
                onTap: () => onGo(at),
              ),
            ShellTab(
              destination: const ShellDestination(
                icon: Icons.search,
                selected: Icons.search,
                label: 'Search',
                path: searchPath,
              ),
              chosen: false,
              count: null,
              onTap: onSearch,
            ),
          ],
        ),
      ),
    );
  }
}

class ShellTab extends StatelessWidget {
  const ShellTab({
    super.key,
    required this.destination,
    required this.chosen,
    required this.count,
    required this.onTap,
  });

  final ShellDestination destination;
  final bool chosen;
  final int? count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color tint = chosen
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      borderRadius: Corner.toolbar,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Space.page,
          vertical: Space.small,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Badge(
              isLabelVisible: count != null && count! > 0,
              label: Text(countOf(count ?? 0)),
              child: Icon(
                chosen ? destination.selected : destination.icon,
                color: tint,
                size: 24,
              ),
            ),
            const SizedBox(height: Space.hair),
            Text(
              destination.label,
              style: theme.textTheme.labelSmall?.copyWith(color: tint),
            ),
          ],
        ),
      ),
    );
  }
}
