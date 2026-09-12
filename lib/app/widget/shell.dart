import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:go_router/go_router.dart';
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
    icon: Icons.explore_outlined,
    selected: Icons.explore,
    label: 'Browse',
    path: browsePath,
  ),
  ShellDestination(
    icon: Icons.search_outlined,
    selected: Icons.search,
    label: 'Search',
    path: searchPath,
  ),
  ShellDestination(
    icon: Icons.inbox_outlined,
    selected: Icons.inbox,
    label: 'Inbox',
    path: inboxPath,
    alerts: _submissionAlerts,
  ),
  ShellDestination(
    icon: Icons.person_outline,
    selected: Icons.person,
    label: 'You',
    path: mePath,
  ),
];

int? _submissionAlerts(Viewer viewer) => viewer.submissionAlerts;

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  final RetreatController retreat = RetreatController();

  @override
  void dispose() {
    retreat.dispose();
    super.dispose();
  }

  void _go(int index) {
    retreat.show();
    widget.shell.goBranch(
      index,
      initialLocation: index == widget.shell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final BottomClaim claim = ref.watch(bottomClaimProvider);
    final MediaQueryData media = MediaQuery.of(context);
    final bool wide = media.size.width >= Layout.compact;
    return ListenableBuilder(
      listenable: claim,
      builder: (context, _) {
        final bool claimed = claim.claimed;
        return Stack(
          children: [
            Positioned.fill(
              child: MediaQuery(
                data: media.copyWith(
                  padding: media.padding.copyWith(
                    bottom: media.padding.bottom + (claimed ? 0 : barSpace),
                  ),
                ),
                child: ScrollRetreat(controller: retreat, child: widget.shell),
              ),
            ),
            if (!claimed)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: RetreatSlide(
                  controller: retreat,
                  child: SafeArea(
                    top: false,
                    child: Align(
                      alignment: wide
                          ? Alignment.centerRight
                          : Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          Layout.gutterOf(context),
                          0,
                          Layout.gutterOf(context),
                          Space.snug,
                        ),
                        child: ShellBar(
                          index: widget.shell.currentIndex,
                          viewer: ref.watch(viewerProvider).asData?.value,
                          onGo: _go,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class ShellBar extends StatelessWidget {
  const ShellBar({
    super.key,
    required this.index,
    required this.viewer,
    required this.onGo,
  });

  final int index;
  final Viewer? viewer;
  final ValueChanged<int> onGo;

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
