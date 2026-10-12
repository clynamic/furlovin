import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

class GalleryPanController {
  GalleryPanController(this.pages);

  final PageController pages;
  final ValueNotifier<bool> locked = ValueNotifier<bool>(false);
  Drag? _drag;

  void push(double delta) {
    if (!pages.hasClients) return;
    final Drag drag = _drag ??= pages.position.drag(
      DragStartDetails(),
      () => _drag = null,
    );
    drag.update(
      DragUpdateDetails(
        globalPosition: Offset.zero,
        delta: Offset(delta, 0),
        primaryDelta: delta,
      ),
    );
  }

  void release(double velocity) {
    _drag?.end(
      DragEndDetails(
        velocity: Velocity(pixelsPerSecond: Offset(velocity, 0)),
        primaryVelocity: velocity,
      ),
    );
  }
}
