import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';

class PriorityRow extends MultiChildRenderObjectWidget {
  PriorityRow({
    super.key,
    required List<Widget> children,
    required Widget overflow,
    this.pinned = const {},
    this.spacing = 0,
  }) : super(children: [...children, overflow]);

  final Set<int> pinned;
  final double spacing;

  @override
  RenderPriorityRow createRenderObject(BuildContext context) =>
      RenderPriorityRow(pinned, spacing);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderPriorityRow renderObject,
  ) {
    renderObject
      ..pinned = pinned
      ..spacing = spacing;
  }
}

class PriorityParentData extends ContainerBoxParentData<RenderBox> {
  bool shown = false;
}

class RenderPriorityRow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, PriorityParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, PriorityParentData> {
  RenderPriorityRow(this._pinned, this._spacing);

  Set<int> _pinned;
  Set<int> get pinned => _pinned;
  set pinned(Set<int> value) {
    if (setEquals(value, _pinned)) return;
    _pinned = value;
    markNeedsLayout();
  }

  double _spacing;
  double get spacing => _spacing;
  set spacing(double value) {
    if (value == _spacing) return;
    _spacing = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! PriorityParentData) {
      child.parentData = PriorityParentData();
    }
  }

  List<RenderBox> get _children {
    final List<RenderBox> all = [];
    RenderBox? child = firstChild;
    while (child != null) {
      all.add(child);
      child = childAfter(child);
    }
    return all;
  }

  List<bool> _choose(List<double> widths, double limit) {
    final int count = widths.length - 1;
    final List<bool> shown = List<bool>.filled(widths.length, false);
    double gaps(int items) => items > 1 ? spacing * (items - 1) : 0;

    double every = 0;
    for (int at = 0; at < count; at++) {
      every += widths[at];
    }
    if (every + gaps(count) <= limit) {
      shown.fillRange(0, count, true);
      return shown;
    }

    int items = 1;
    double used = widths[count];
    for (int at = 0; at < count; at++) {
      if (!pinned.contains(at)) continue;
      shown[at] = true;
      used += widths[at];
      items++;
    }
    for (int at = 0; at < count; at++) {
      if (shown[at]) continue;
      if (used + widths[at] + gaps(items + 1) > limit) continue;
      shown[at] = true;
      used += widths[at];
      items++;
    }
    shown[count] = true;
    return shown;
  }

  @override
  void performLayout() {
    final List<RenderBox> children = _children;
    if (children.isEmpty) {
      size = constraints.smallest;
      return;
    }
    final BoxConstraints loose = constraints.loosen();
    for (final RenderBox child in children) {
      child.layout(loose, parentUsesSize: true);
    }
    final List<bool> shown = _choose([
      for (final RenderBox child in children) child.size.width,
    ], constraints.maxWidth);
    _squeeze(children, shown, constraints.maxWidth);

    double x = 0;
    double height = 0;
    for (final (int at, RenderBox child) in children.indexed) {
      final PriorityParentData data = child.parentData! as PriorityParentData;
      data.shown = shown[at];
      if (!data.shown) continue;
      height = math.max(height, child.size.height);
    }
    for (final RenderBox child in children) {
      final PriorityParentData data = child.parentData! as PriorityParentData;
      if (!data.shown) continue;
      data.offset = Offset(x, (height - child.size.height) / 2);
      x += child.size.width + spacing;
    }
    final double wanted = math.max(0, x - spacing);
    size = constraints.constrain(Size(wanted, height));
    _clipped = wanted > size.width;
  }

  void _squeeze(List<RenderBox> children, List<bool> shown, double limit) {
    final RenderBox overflow = children.last;
    double used = 0;
    int items = 0;
    final List<RenderBox> pinnedShown = [];
    for (final (int at, RenderBox child) in children.indexed) {
      if (!shown[at]) continue;
      used += child.size.width;
      items++;
      if (pinned.contains(at)) pinnedShown.add(child);
    }
    used += items > 1 ? spacing * (items - 1) : 0;
    if (used <= limit || pinnedShown.isEmpty) return;
    final double rest =
        limit -
        (shown.last ? overflow.size.width + spacing : 0) -
        spacing * (pinnedShown.length - 1);
    final double each = math.max(0, rest / pinnedShown.length);
    for (final RenderBox child in pinnedShown) {
      child.layout(
        constraints.loosen().copyWith(maxWidth: each),
        parentUsesSize: true,
      );
    }
  }

  bool _clipped = false;

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    final List<RenderBox> children = _children;
    if (children.isEmpty) return constraints.smallest;
    final BoxConstraints loose = constraints.loosen();
    final List<Size> sizes = [
      for (final RenderBox child in children) child.getDryLayout(loose),
    ];
    final List<bool> shown = _choose([
      for (final Size size in sizes) size.width,
    ], constraints.maxWidth);
    double width = 0;
    double height = 0;
    int items = 0;
    for (final (int at, Size size) in sizes.indexed) {
      if (!shown[at]) continue;
      width += size.width;
      height = math.max(height, size.height);
      items++;
    }
    return constraints.constrain(
      Size(width + (items > 1 ? spacing * (items - 1) : 0), height),
    );
  }

  @override
  double computeMinIntrinsicHeight(double width) => _children.fold(
    0,
    (tallest, child) => math.max(tallest, child.getMinIntrinsicHeight(width)),
  );

  @override
  double computeMaxIntrinsicHeight(double width) => _children.fold(
    0,
    (tallest, child) => math.max(tallest, child.getMaxIntrinsicHeight(width)),
  );

  final LayerHandle<ClipRectLayer> _clip = LayerHandle<ClipRectLayer>();

  void _paintShown(PaintingContext context, Offset offset) {
    for (final RenderBox child in _children) {
      final PriorityParentData data = child.parentData! as PriorityParentData;
      if (data.shown) context.paintChild(child, offset + data.offset);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!_clipped) {
      _clip.layer = null;
      _paintShown(context, offset);
      return;
    }
    _clip.layer = context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      _paintShown,
      oldLayer: _clip.layer,
    );
  }

  @override
  void dispose() {
    _clip.layer = null;
    super.dispose();
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final RenderBox child in _children.reversed) {
      final PriorityParentData data = child.parentData! as PriorityParentData;
      if (!data.shown) continue;
      final bool hit = result.addWithPaintOffset(
        offset: data.offset,
        position: position,
        hitTest: (result, transformed) =>
            child.hitTest(result, position: transformed),
      );
      if (hit) return true;
    }
    return false;
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    for (final RenderBox child in _children) {
      final PriorityParentData data = child.parentData! as PriorityParentData;
      if (data.shown) visitor(child);
    }
  }
}
