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

class BranchScrollScope extends InheritedWidget {
  const BranchScrollScope({
    super.key,
    required this.scrolls,
    required super.child,
  });

  final BranchScrolls scrolls;

  static BranchScrolls of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<BranchScrollScope>()!.scrolls;

  @override
  bool updateShouldNotify(BranchScrollScope oldWidget) =>
      oldWidget.scrolls != scrolls;
}

class BranchScroll extends StatelessWidget {
  const BranchScroll({super.key, required this.branch, required this.child});

  final int branch;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final BranchScrolls scrolls = BranchScrollScope.of(context);
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
