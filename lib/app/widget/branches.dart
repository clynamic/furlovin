import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

class BranchScrolls {
  final Map<int, ScrollController> _byBranch = {};

  ScrollController of(int branch) =>
      _byBranch.putIfAbsent(branch, ScrollController.new);

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
  Widget build(BuildContext context, WidgetRef ref) => PrimaryScrollController(
    controller: ref.watch(branchScrollsProvider).of(branch),
    automaticallyInheritForPlatforms: TargetPlatform.values.toSet(),
    child: child,
  );
}
