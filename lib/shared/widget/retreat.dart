import 'package:furlovin/shared/widget/claim.dart';
import 'package:material_ui/material_ui.dart';

const double retreatThreshold = 56;

class RetreatController extends ChangeNotifier {
  bool _shown = true;
  double _travel = 0;

  bool get shown => _shown;

  void show() => _settle(true);

  void _settle(bool value) {
    _travel = 0;
    if (_shown == value) return;
    _shown = value;
    notifyListeners();
  }

  bool absorb(ScrollNotification notification) {
    if (notification.depth != 0) return false;
    final ScrollMetrics metrics = notification.metrics;
    if (metrics.axis != Axis.vertical) return false;
    if (!metrics.hasContentDimensions) return false;
    if (metrics.maxScrollExtent <= metrics.minScrollExtent) {
      _settle(true);
      return false;
    }
    if (metrics.pixels <= metrics.minScrollExtent) {
      _settle(true);
      return false;
    }
    if (notification is! ScrollUpdateNotification) return false;
    final double delta = notification.scrollDelta ?? 0;
    if (delta == 0) return false;
    if (!delta.isNegative != !_travel.isNegative) _travel = 0;
    _travel += delta;
    if (_travel > retreatThreshold) _settle(false);
    if (_travel < -retreatThreshold) _settle(true);
    return false;
  }
}

class ScrollRetreat extends StatelessWidget {
  const ScrollRetreat({
    super.key,
    required this.controller,
    required this.child,
    this.claim,
  });

  final RetreatController controller;
  final BottomClaim? claim;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollNotification>(
        onNotification: (notification) =>
            !(claim?.claimed ?? false) && controller.absorb(notification),
        child: child,
      );
}

class RetreatSlide extends StatelessWidget {
  const RetreatSlide({
    super.key,
    required this.controller,
    required this.child,
  });

  final RetreatController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, child) => AnimatedSlide(
      offset: controller.shown ? Offset.zero : const Offset(0, 1.4),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      child: IgnorePointer(ignoring: !controller.shown, child: child),
    ),
    child: child,
  );
}
