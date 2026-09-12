import 'package:material_ui/material_ui.dart';

const double zoomMin = 1;
const double zoomMax = 6;
const double zoomStep = 2.5;
const double zoomSnap = 0.08;
const double edgeSlack = 0.5;

class ZoomController extends ChangeNotifier {
  final TransformationController transformation = TransformationController();

  double _scale = zoomMin;

  double get scale => _scale;

  bool get isZoomed => _scale > zoomMin + zoomSnap;

  void _read() {
    final double next = transformation.value.getMaxScaleOnAxis();
    if ((next - _scale).abs() < 0.001) return;
    _scale = next;
    notifyListeners();
  }

  @override
  void dispose() {
    transformation.dispose();
    super.dispose();
  }
}

class Zoomable extends StatefulWidget {
  const Zoomable({
    super.key,
    required this.child,
    required this.controller,
    this.onTap,
    this.onSpare,
    this.onSpareEnd,
    this.aspectRatio,
  });

  final Widget child;
  final ZoomController controller;
  final VoidCallback? onTap;
  final double? aspectRatio;
  final void Function(Offset spare)? onSpare;
  final void Function(Velocity velocity)? onSpareEnd;

  @override
  State<Zoomable> createState() => _ZoomableState();
}

class _ZoomableState extends State<Zoomable>
    with SingleTickerProviderStateMixin {
  late final AnimationController animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  Animation<Matrix4>? _flight;
  TapDownDetails? _lastTap;

  TransformationController get transformation =>
      widget.controller.transformation;

  @override
  void initState() {
    super.initState();
    transformation.addListener(widget.controller._read);
    animation.addListener(_onFlight);
  }

  @override
  void dispose() {
    transformation.removeListener(widget.controller._read);
    animation
      ..removeListener(_onFlight)
      ..dispose();
    super.dispose();
  }

  void _onFlight() {
    if (_flight case final Animation<Matrix4> value) {
      transformation.value = value.value;
    }
  }

  void _settle() {
    if (widget.controller.isZoomed) return;
    if (transformation.value == Matrix4.identity()) return;
    _fly(Matrix4.identity());
  }

  void _fly(Matrix4 target) {
    _flight = Matrix4Tween(
      begin: transformation.value,
      end: target,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
    animation.forward(from: 0);
  }

  Rect? get _content {
    final double? ratio = widget.aspectRatio;
    final RenderObject? box = context.findRenderObject();
    if (ratio == null || ratio <= 0 || box is! RenderBox || !box.hasSize) {
      return null;
    }
    final Rect viewport = Offset.zero & box.size;
    final FittedSizes fitted = applyBoxFit(
      BoxFit.contain,
      Size(ratio, 1),
      box.size,
    );
    return Alignment.center.inscribe(fitted.destination, viewport);
  }

  void _cycle() {
    final Matrix4 target;
    if (widget.controller.isZoomed) {
      target = Matrix4.identity();
    } else {
      final Rect? content = _content;
      final Offset? tapped = _lastTap?.localPosition;
      final Offset focus = switch ((content, tapped)) {
        (final Rect box, final Offset at) when !box.contains(at) => box.center,
        (_, final Offset at) => at,
        (final Rect box, null) => box.center,
        (null, null) => Offset.zero,
      };
      target = Matrix4.identity()
        ..translateByDouble(
          -focus.dx * (zoomStep - 1),
          -focus.dy * (zoomStep - 1),
          0,
          1,
        )
        ..scaleByDouble(zoomStep, zoomStep, 1, 1);
    }
    _fly(target);
  }

  Offset get _shift =>
      MatrixUtils.transformPoint(transformation.value, Offset.zero);

  Offset? _panned;
  bool _fromTop = false;
  bool _fromBottom = false;

  double get _viewport {
    final RenderObject? box = context.findRenderObject();
    return box is RenderBox && box.hasSize ? box.size.height : 0;
  }

  void _onStart(ScaleStartDetails details) {
    _panned = _shift;
    final double scale = widget.controller.scale;
    final double room = (scale - zoomMin) * _viewport;
    _fromTop = _shift.dy >= -edgeSlack;
    _fromBottom = _shift.dy <= -room + edgeSlack;
  }

  void _onUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount != 1 || details.scale != 1) {
      _panned = null;
      return;
    }
    final Offset moved = _shift;
    if (_panned case final Offset last) {
      final Offset spare = details.focalPointDelta - (moved - last);
      final bool allowed = spare.dy > 0
          ? _fromTop
          : spare.dy < 0 && _fromBottom;
      if (allowed) widget.onSpare?.call(spare);
    }
    _panned = moved;
  }

  void _onEnd(ScaleEndDetails details) {
    _panned = null;
    _settle();
    widget.onSpareEnd?.call(details.velocity);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: widget.onTap,
    onDoubleTapDown: (details) => _lastTap = details,
    onDoubleTap: _cycle,
    child: InteractiveViewer(
      transformationController: transformation,
      onInteractionStart: _onStart,
      onInteractionUpdate: _onUpdate,
      onInteractionEnd: _onEnd,
      minScale: zoomMin,
      maxScale: zoomMax,
      clipBehavior: Clip.none,
      child: widget.child,
    ),
  );
}
