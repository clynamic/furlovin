import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/app/app.dart';
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
  const HomeShell({super.key, required this.shell, this.onRevisit});

  final StatefulNavigationShell shell;
  final ValueChanged<int>? onRevisit;

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

  bool _deep(int index) =>
      widget.shell.route.branches[index].navigatorKey.currentState?.canPop() ??
      false;

  void _go(int index) {
    retreat.show();
    if (index != widget.shell.currentIndex) {
      widget.shell.goBranch(index);
      return;
    }
    if (_deep(index)) {
      widget.shell.goBranch(index, initialLocation: true);
      return;
    }
    final ScrollController scroll = ref.read(branchScrollsProvider).of(index);
    if (scroll.positions.length != 1) return;
    final ScrollPosition listing = scroll.positions.first;
    if (listing.pixels <= listing.minScrollExtent) {
      widget.onRevisit?.call(index);
      return;
    }
    listing.animateTo(
      listing.minScrollExtent,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final BottomClaim claim = ref.watch(bottomClaimProvider);
    final MediaQueryData media = MediaQuery.of(context);
    final bool wide = media.size.width >= Layout.compact;
    return Stack(
      children: [
        Positioned.fill(
          child: MediaQuery(
            data: media.copyWith(
              padding: media.padding.copyWith(
                bottom: media.padding.bottom + barSpace,
              ),
            ),
            child: BottomReserve(
              space: barSpace,
              child: ScrollRetreat(
                controller: retreat,
                claim: claim,
                child: widget.shell,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ListenableBuilder(
            listenable: claim,
            builder: (context, child) {
              final double coverage = claim.coverage;
              if (coverage >= 1) return const SizedBox.shrink();
              return FractionalTranslation(
                translation: Offset(
                  0,
                  1.4 * Curves.easeInOut.transform(coverage),
                ),
                child: IgnorePointer(ignoring: coverage > 0, child: child),
              );
            },
            child: RetreatSlide(
              controller: retreat,
              child: SafeArea(
                top: false,
                child: Align(
                  alignment: wide ? Alignment.centerRight : Alignment.center,
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
        ),
      ],
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
