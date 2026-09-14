import 'package:material_ui/material_ui.dart';

class RevisitController {
  Future<void> Function()? handler;

  Future<void> revisit() => handler?.call() ?? Future<void>.value();
}

class Revisit extends InheritedWidget {
  const Revisit({super.key, required this.controller, required super.child});

  final RevisitController controller;

  static RevisitController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Revisit>()?.controller;

  @override
  bool updateShouldNotify(Revisit oldWidget) =>
      oldWidget.controller != controller;
}

class RevisitRefresh extends StatefulWidget {
  const RevisitRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
    this.edgeOffset = 0,
  });

  final Future<void> Function() onRefresh;
  final double edgeOffset;
  final Widget child;

  @override
  State<RevisitRefresh> createState() => _RevisitRefreshState();
}

class _RevisitRefreshState extends State<RevisitRefresh> {
  final GlobalKey<RefreshIndicatorState> _indicator =
      GlobalKey<RefreshIndicatorState>();
  RevisitController? _revisit;

  Future<void> _show() async => _indicator.currentState?.show();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final RevisitController? next = Revisit.maybeOf(context);
    if (next == _revisit) return;
    _release();
    _revisit = next?..handler = _show;
  }

  void _release() {
    if (_revisit?.handler == _show) _revisit?.handler = null;
  }

  @override
  void dispose() {
    _release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    key: _indicator,
    edgeOffset: widget.edgeOffset,
    onRefresh: widget.onRefresh,
    child: widget.child,
  );
}
