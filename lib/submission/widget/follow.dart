import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:material_ui/material_ui.dart';

const int followAttempts = 8;

class SubmissionGridFollow extends ConsumerStatefulWidget {
  const SubmissionGridFollow({
    super.key,
    required this.listing,
    required this.items,
    required this.spacing,
    required this.child,
  });

  final SubmissionListingKey listing;
  final List<SubmissionPreview> items;
  final double spacing;
  final Widget child;

  @override
  ConsumerState<SubmissionGridFollow> createState() =>
      _SubmissionGridFollowState();
}

typedef _Placed = ({
  int index,
  double offset,
  double x,
  Size size,
  SubmissionTile tile,
  Element element,
});

class _SubmissionGridFollowState extends ConsumerState<SubmissionGridFollow> {
  int? target;
  int attempts = 0;
  bool scheduled = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual(submissionListingFollowProvider(widget.listing), (
      previous,
      next,
    ) {
      if (next == null) return;
      target = next;
      attempts = 0;
      final SubmissionListingFollow follow = ref.read(
        submissionListingFollowProvider(widget.listing).notifier,
      );
      follow.target = null;
      _follow();
    });
  }

  void _mounted() {
    if (target == null || scheduled) return;
    scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scheduled = false;
      if (mounted) _follow();
    });
  }

  List<_Placed> _placed() {
    final Map<int, int> indices = {
      for (final (int index, SubmissionPreview item) in widget.items.indexed)
        item.id: index,
    };
    final List<_Placed> placed = [];
    void visit(Element element) {
      if (element.widget case final SubmissionTile tile) {
        final RenderObject? box = element.renderObject;
        final int? index = indices[tile.submission.id];
        if (index != null && box is RenderBox && box.hasSize && box.attached) {
          placed.add((
            index: index,
            offset: RenderAbstractViewport.of(box)
                .getOffsetToReveal(box, 0)
                .offset,
            x: box.localToGlobal(Offset.zero).dx,
            size: box.size,
            tile: tile,
            element: element,
          ));
        }
        return;
      }
      element.visitChildren(visit);
    }

    context.visitChildElements(visit);
    return placed..sort((a, b) => a.index.compareTo(b.index));
  }

  void _follow() {
    final int? id = target;
    if (id == null) return;
    final int wanted = widget.items.indexWhere((e) => e.id == id);
    final List<_Placed> placed = _placed();
    if (wanted < 0 || placed.isEmpty) return;

    for (final _Placed tile in placed) {
      if (tile.index != wanted) continue;
      target = null;
      Scrollable.ensureVisible(tile.element, alignment: 0.5);
      return;
    }

    if (attempts++ >= followAttempts) {
      target = null;
      return;
    }
    final _Placed anchor = placed.reduce(
      (a, b) => (wanted - a.index).abs() <= (wanted - b.index).abs() ? a : b,
    );
    final List<double> layout = _replay(placed, math.max(wanted, anchor.index));
    final ScrollPosition position = Scrollable.of(anchor.element).position;
    final double estimate =
        layout[wanted] -
        layout[anchor.index] +
        anchor.offset -
        (position.viewportDimension - anchor.size.height) / 2;
    position.jumpTo(
      estimate.clamp(position.minScrollExtent, position.maxScrollExtent),
    );
  }

  List<double> _replay(List<_Placed> placed, int until) {
    final double width = placed.first.size.width;
    final Tiles tiles = placed.first.tile.tiles;
    final int columns = {for (final _Placed tile in placed) tile.x.round()}
        .length;
    final double caption =
        placed
            .map((e) => e.size.height - width / e.tile.aspectRatio)
            .reduce((a, b) => a + b) /
        placed.length;
    final List<double> bottoms = List.filled(columns, 0);
    final List<double> offsets = [];
    for (final SubmissionPreview item in widget.items.take(until + 1)) {
      int column = 0;
      for (int next = 1; next < columns; next++) {
        if (bottoms[next] < bottoms[column]) column = next;
      }
      offsets.add(bottoms[column]);
      bottoms[column] +=
          width / tileAspectRatio(item, tiles) + caption + widget.spacing;
    }
    return offsets;
  }

  @override
  Widget build(BuildContext context) =>
      _FollowScope(onMounted: _mounted, child: widget.child);
}

class _FollowScope extends InheritedWidget {
  const _FollowScope({required this.onMounted, required super.child});

  final VoidCallback onMounted;

  @override
  bool updateShouldNotify(_FollowScope oldWidget) => false;
}

class SubmissionFollowProbe extends StatefulWidget {
  const SubmissionFollowProbe({super.key, required this.child});

  final Widget child;

  @override
  State<SubmissionFollowProbe> createState() => _SubmissionFollowProbeState();
}

class _SubmissionFollowProbeState extends State<SubmissionFollowProbe> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.getInheritedWidgetOfExactType<_FollowScope>()?.onMounted();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
