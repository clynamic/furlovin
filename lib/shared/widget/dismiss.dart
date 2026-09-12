import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

const double dismissThreshold = 120;
const double dismissVelocity = 700;
const double dismissTravel = 1000;
const double dismissReach = 240;
const double dismissMinScale = 0.72;
const double dismissFadeRate = 2;
const Duration dismissDuration = Duration(milliseconds: 300);
const Duration dismissFadeDuration = Duration(milliseconds: 220);

enum DismissTransition { platform, fade }

class DismissRoute<T> extends PageRoute<T> {
  DismissRoute({
    required this.builder,
    this.barrier = const Color(0x8A000000),
    this.transition = DismissTransition.platform,
    super.settings,
  });

  final WidgetBuilder builder;
  final Color barrier;
  final DismissTransition transition;

  final ValueNotifier<bool> dragging = ValueNotifier<bool>(false);
  double direction = 1;

  AnimationController get driver => controller!;

  bool get dismissible => isActive && !isFirst;

  double get dragOffset =>
      dragging.value ? direction * (1 - driver.value) * dismissTravel : 0;

  double get dragProgress => (dragOffset.abs() / dismissReach).clamp(0, 1);

  static DismissRoute<dynamic> of(BuildContext context) {
    final ModalRoute<dynamic>? route = ModalRoute.of(context);
    if (route is! DismissRoute<dynamic>) {
      throw FlutterError(
        'DismissRoute.of() was called with a context that is not inside a '
        'DismissRoute.',
      );
    }
    return route;
  }

  @override
  void install() {
    super.install();
    driver.addStatusListener(_onStatus);
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) dragging.value = false;
  }

  @override
  Color get barrierColor => Colors.transparent;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => switch (transition) {
    DismissTransition.platform => dismissDuration,
    DismissTransition.fade => dismissFadeDuration,
  };

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) => builder(context);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ListenableBuilder(
          listenable: Listenable.merge([animation, dragging]),
          builder: (context, child) => IgnorePointer(
            child: ColoredBox(
              color: barrier.withValues(alpha: barrier.a * _scrim(animation)),
            ),
          ),
        ),
        if (dragging.value)
          child
        else
          switch (transition) {
            DismissTransition.fade => FadeTransition(
              opacity: animation,
              child: child,
            ),
            DismissTransition.platform =>
              Theme.of(context).pageTransitionsTheme.buildTransitions<T>(
                this,
                context,
                animation,
                kAlwaysDismissedAnimation,
                child,
              ),
          },
      ],
    );
  }

  double _scrim(Animation<double> animation) =>
      dragging.value ? 1 - dragProgress : animation.value;

  @override
  void dispose() {
    dragging.dispose();
    super.dispose();
  }
}

class DismissPage<T> extends Page<T> {
  const DismissPage({
    required this.child,
    this.barrier = const Color(0x8A000000),
    this.transition = DismissTransition.platform,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;
  final Color barrier;
  final DismissTransition transition;

  @override
  Route<T> createRoute(BuildContext context) => DismissRoute<T>(
    builder: (context) => child,
    barrier: barrier,
    transition: transition,
    settings: this,
  );
}

class DismissController implements Listenable {
  const DismissController(this.route);

  final DismissRoute<dynamic> route;

  double get offset => route.dragging.value
      ? route.direction * (1 - route.driver.value) * dismissTravel
      : 0;

  double get progress => (offset.abs() / dismissReach).clamp(0, 1);

  double get scale => 1 - (1 - dismissMinScale) * progress;

  bool get isDragging => offset != 0;

  double opacity(double rate) => (1 - progress * rate).clamp(0, 1);

  bool exceeds(double velocity) {
    final double reached = offset;
    if (reached.abs() > dismissThreshold) return true;
    if (reached == 0) return false;
    return velocity.sign == reached.sign && velocity.abs() > dismissVelocity;
  }

  void settle() {
    if (!route.dragging.value) return;
    route.driver.forward();
  }

  void push(double delta) {
    if (!route.dismissible) return;
    if (!route.dragging.value || route.driver.value == 1) {
      route.direction = delta.isNegative ? -1 : 1;
      route.dragging.value = true;
    }
    final double next =
        route.driver.value - delta * route.direction / dismissTravel;
    route.driver.value = next.clamp(0, 1);
    if (route.driver.value == 1) route.dragging.value = false;
  }

  bool release(double velocity) {
    if (!route.dragging.value) return false;
    if (exceeds(velocity)) return true;
    route.driver.forward();
    return false;
  }

  @override
  void addListener(VoidCallback listener) => route.driver.addListener(listener);

  @override
  void removeListener(VoidCallback listener) =>
      route.driver.removeListener(listener);
}

class DismissFade extends StatelessWidget {
  const DismissFade({
    super.key,
    required this.controller,
    required this.child,
    this.rate = dismissFadeRate,
  });

  final DismissController controller;
  final Widget child;
  final double rate;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, child) => IgnorePointer(
      ignoring: controller.isDragging,
      child: Opacity(opacity: controller.opacity(rate), child: child),
    ),
    child: child,
  );
}

class DismissSliverFade extends StatelessWidget {
  const DismissSliverFade({
    super.key,
    required this.controller,
    required this.sliver,
    this.rate = dismissFadeRate,
  });

  final DismissController controller;
  final Widget sliver;
  final double rate;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, child) => SliverIgnorePointer(
      ignoring: controller.isDragging,
      sliver: SliverOpacity(opacity: controller.opacity(rate), sliver: child!),
    ),
    child: sliver,
  );
}

class DismissTransform extends StatelessWidget {
  const DismissTransform({
    super.key,
    required this.controller,
    required this.child,
  });

  final DismissController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, child) => Transform.translate(
      offset: Offset(0, controller.offset),
      child: Transform.scale(scale: controller.scale, child: child),
    ),
    child: child,
  );
}

class DismissScrollPhysics extends ScrollPhysics {
  const DismissScrollPhysics({required this.controller, super.parent});

  final DismissController controller;

  @override
  DismissScrollPhysics applyTo(ScrollPhysics? ancestor) => DismissScrollPhysics(
    controller: controller,
    parent: buildParent(ancestor),
  );

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (position.axis != Axis.vertical) {
      return super.applyPhysicsToUserOffset(position, offset);
    }
    if (offset > 0 && position.pixels <= position.minScrollExtent) {
      controller.push(offset);
      return 0;
    }
    if (offset < 0 && controller.offset > 0) {
      final double taken = math.min(controller.offset, -offset);
      controller.push(-taken);
      return super.applyPhysicsToUserOffset(position, offset + taken);
    }
    return super.applyPhysicsToUserOffset(position, offset);
  }
}

class ScrollToDismiss extends StatefulWidget {
  const ScrollToDismiss({
    super.key,
    required this.controller,
    required this.onDismiss,
    required this.child,
  });

  final DismissController controller;
  final VoidCallback onDismiss;
  final Widget child;

  @override
  State<ScrollToDismiss> createState() => _ScrollToDismissState();
}

class _ScrollToDismissState extends State<ScrollToDismiss> {
  bool _dragging = false;

  void _release(double velocity) {
    _dragging = false;
    if (widget.controller.release(velocity)) widget.onDismiss();
  }

  bool _onNotification(ScrollNotification notification) {
    if (notification.depth != 0) return false;
    if (notification.metrics.axis != Axis.vertical) return false;
    switch (notification) {
      case ScrollUpdateNotification(:final DragUpdateDetails? dragDetails):
        if (dragDetails != null) {
          _dragging = true;
        } else if (_dragging) {
          _release(0);
        }
      case ScrollEndNotification(:final DragEndDetails? dragDetails):
        _release(dragDetails?.velocity.pixelsPerSecond.dy ?? 0);
      case ScrollStartNotification(:final DragStartDetails? dragDetails):
        if (!_dragging) widget.controller.settle();
        _dragging = dragDetails != null;
      default:
        break;
    }
    return false;
  }

  ScrollBehavior? _behavior;

  void _rebuildBehavior() {
    final ScrollBehavior behavior = ScrollConfiguration.of(context);
    _behavior = behavior.copyWith(
      physics: DismissScrollPhysics(controller: widget.controller)
          .applyTo(behavior.getScrollPhysics(context)),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rebuildBehavior();
  }

  @override
  void didUpdateWidget(ScrollToDismiss old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) _rebuildBehavior();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onNotification,
      child: ScrollConfiguration(
        behavior: _behavior!,
        child: DismissTransform(
          controller: widget.controller,
          child: widget.child,
        ),
      ),
    );
  }
}
