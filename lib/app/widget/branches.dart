import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

class BranchScrolls {
  final Map<int, ScrollController> _byBranch = {};
  final Map<int, RevisitController> _revisits = {};

  ScrollController of(int branch) =>
      _byBranch.putIfAbsent(branch, ScrollController.new);

  RevisitController revisitOf(int branch) =>
      _revisits.putIfAbsent(branch, RevisitController.new);

  void dispose() {
    for (final ScrollController controller in _byBranch.values) {
      controller.dispose();
    }
    _byBranch.clear();
  }
}

final Provider<BranchScrolls> branchScrollsProvider = Provider<BranchScrolls>((
  ref,
) {
  final BranchScrolls scrolls = BranchScrolls();
  ref.onDispose(scrolls.dispose);
  return scrolls;
});

class BranchScroll extends ConsumerWidget {
  const BranchScroll({super.key, required this.branch, required this.child});

  final int branch;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BranchScrolls scrolls = ref.watch(branchScrollsProvider);
    return Revisit(
      controller: scrolls.revisitOf(branch),
      child: PrimaryScrollController(
        controller: scrolls.of(branch),
        automaticallyInheritForPlatforms: TargetPlatform.values.toSet(),
        child: child,
      ),
    );
  }
}
