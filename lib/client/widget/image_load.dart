import 'dart:async';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:material_ui/material_ui.dart';

const Duration imageLoadPatience = Duration(milliseconds: 250);
const double imageLoadBar = 3;

Rect? containedRect(double? aspectRatio, Size size) {
  if (aspectRatio == null || aspectRatio <= 0 || size.isEmpty) return null;
  final FittedSizes fitted = applyBoxFit(
    BoxFit.contain,
    Size(aspectRatio, 1),
    size,
  );
  return Alignment.center.inscribe(fitted.destination, Offset.zero & size);
}

Duration? cooldownOf(Object error) => switch (error) {
  DioException(error: RateLimited(:final Duration? retryAfter)) =>
    retryAfter ?? rateLimitPause,
  RateLimited(:final Duration? retryAfter) => retryAfter ?? rateLimitPause,
  _ => null,
};

class ImageLoadOverlay extends StatefulWidget {
  const ImageLoadOverlay({
    super.key,
    required this.load,
    required this.locate,
    this.moves,
  });

  final ImageLoadController load;
  final Rect? Function(Size size) locate;
  final Listenable? moves;

  @override
  State<ImageLoadOverlay> createState() => _ImageLoadOverlayState();
}

class _ImageLoadOverlayState extends State<ImageLoadOverlay> {
  Timer? _patience;
  Timer? _countdown;
  bool _patient = false;
  DateTime? _waitUntil;

  @override
  void initState() {
    super.initState();
    widget.load.addListener(_onLoad);
    _onLoad();
  }

  @override
  void didUpdateWidget(ImageLoadOverlay old) {
    super.didUpdateWidget(old);
    if (old.load == widget.load) return;
    old.load.removeListener(_onLoad);
    widget.load.addListener(_onLoad);
    _onLoad();
  }

  @override
  void dispose() {
    widget.load.removeListener(_onLoad);
    _patience?.cancel();
    _countdown?.cancel();
    super.dispose();
  }

  void _onLoad() {
    switch (widget.load.value) {
      case ImageLoading():
        _waitUntil = null;
        _countdown?.cancel();
        if (_patient || (_patience?.isActive ?? false)) return;
        _patience = Timer(imageLoadPatience, () {
          if (mounted) setState(() => _patient = true);
        });
      case ImageLoaded():
        _settle();
      case ImageFailed(:final Object error):
        _settle();
        if (cooldownOf(error) case final Duration wait) {
          _waitUntil = DateTime.now().add(wait);
          _countdown = Timer.periodic(const Duration(seconds: 1), (_) {
            if (!mounted) return;
            if (_left == Duration.zero) _countdown?.cancel();
            setState(() {});
          });
        }
    }
  }

  void _settle() {
    _patience?.cancel();
    _patient = false;
  }

  Duration get _left {
    final DateTime? until = _waitUntil;
    if (until == null) return Duration.zero;
    final Duration left = until.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) => ListenableBuilder(
      listenable: Listenable.merge([widget.load, ?widget.moves]),
      builder: (context, _) {
        final Size size = box.biggest;
        final Rect? image = widget.locate(size);
        if (image == null) return const SizedBox.shrink();
        final Rect visible = image.intersect(Offset.zero & size);
        if (visible.width <= 0 || visible.height <= 0) {
          return const SizedBox.shrink();
        }
        final double bottom = math.min(image.bottom, size.height);
        return Stack(
          children: [
            switch (widget.load.value) {
              ImageLoading(:final double? fraction) when _patient => Positioned(
                left: visible.left,
                width: visible.width,
                top: bottom - imageLoadBar,
                height: imageLoadBar,
                child: IgnorePointer(
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: imageLoadBar,
                    backgroundColor: Colors.white24,
                  ),
                ),
              ),
              ImageFailed() => Positioned(
                left: visible.left,
                width: visible.width,
                top: bottom - 52,
                height: 48,
                child: Center(child: _retry(context)),
              ),
              _ => const SizedBox.shrink(),
            },
          ],
        );
      },
    ),
  );

  Widget _retry(BuildContext context) {
    final Duration left = _left;
    final bool waiting = left > Duration.zero;
    const List<Shadow> shade = [Shadow(color: scrimShadow, blurRadius: 10)];
    return TextButton.icon(
      onPressed: waiting ? null : widget.load.retry,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.white70,
      ),
      icon: Icon(
        waiting ? Icons.hourglass_empty : Icons.refresh,
        shadows: shade,
      ),
      label: Text(
        waiting
            ? 'Waiting for Fur Affinity (${left.inSeconds + 1} s)'
            : 'Retry full image',
        style: const TextStyle(shadows: shade),
      ),
    );
  }
}
