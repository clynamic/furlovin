import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:material_ui/material_ui.dart';

typedef ImageRung = ({String url, CacheManager? cache, int? decodeWidth});

@immutable
sealed class ImageLoad {
  const ImageLoad();
}

class ImageLoading extends ImageLoad {
  const ImageLoading([this.fraction]);

  final double? fraction;

  @override
  bool operator ==(Object other) =>
      other is ImageLoading && other.fraction == fraction;

  @override
  int get hashCode => fraction.hashCode;
}

class ImageLoaded extends ImageLoad {
  const ImageLoaded();

  @override
  bool operator ==(Object other) => other is ImageLoaded;

  @override
  int get hashCode => 0;
}

class ImageFailed extends ImageLoad {
  const ImageFailed(this.error);

  final Object error;

  @override
  bool operator ==(Object other) =>
      other is ImageFailed && other.error == error;

  @override
  int get hashCode => error.hashCode;
}

class ImageLoadController extends ValueNotifier<ImageLoad> {
  ImageLoadController() : super(const ImageLoading());

  final Set<String> _settled = {};
  int _attempt = 0;
  bool _disposed = false;

  int get attempt => _attempt;

  void retry() {
    _attempt++;
    _settled.clear();
    value = const ImageLoading();
  }

  void report(String url, ImageLoad next) {
    if (next is ImageLoading && _settled.contains(url)) return;
    if (next is! ImageLoading) _settled.add(url);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_disposed || next == value) return;
      if (next is ImageLoading && _settled.contains(url)) return;
      value = next;
    });
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class ProgressiveImage extends StatefulWidget {
  const ProgressiveImage({
    super.key,
    required this.rungs,
    required this.headers,
    required this.discriminator,
    this.fit = BoxFit.contain,
    this.background,
    this.fade = const Duration(milliseconds: 180),
    this.onRatio,
    this.load,
  });

  final List<ImageRung> rungs;
  final Map<String, String> Function(String url) headers;
  final String discriminator;
  final BoxFit fit;
  final Color? background;
  final Duration fade;
  final ValueChanged<double>? onRatio;
  final ImageLoadController? load;

  @override
  State<ProgressiveImage> createState() => _ProgressiveImageState();
}

class _ProgressiveImageState extends State<ProgressiveImage> {
  int _attempt = 0;

  @override
  void initState() {
    super.initState();
    widget.load?.addListener(_onLoad);
  }

  @override
  void didUpdateWidget(ProgressiveImage old) {
    super.didUpdateWidget(old);
    if (old.load == widget.load) return;
    old.load?.removeListener(_onLoad);
    widget.load?.addListener(_onLoad);
  }

  @override
  void dispose() {
    widget.load?.removeListener(_onLoad);
    super.dispose();
  }

  void _onLoad() {
    final ImageLoadController? load = widget.load;
    if (load == null || load.attempt == _attempt) return;
    _attempt = load.attempt;
    if (widget.rungs.lastOrNull case final ImageRung best) {
      final String key = '${best.url}#${widget.discriminator}';
      unawaited(best.cache?.removeFile(key));
      unawaited(CachedNetworkImageProvider(best.url, cacheKey: key).evict());
    }
    setState(() {});
  }

  Widget _image(ImageProvider<Object> provider, {required bool best}) {
    final Widget image = Image(image: provider, fit: widget.fit);
    final ValueChanged<double>? onRatio = widget.onRatio;
    if (!best || onRatio == null) return image;
    return MeasuredImage(provider: provider, onRatio: onRatio, child: image);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ImageLoadController? load = widget.load;
    Widget below = ColoredBox(
      color: widget.background ?? theme.colorScheme.surfaceContainer,
    );
    for (final ImageRung rung in widget.rungs) {
      final Widget under = below;
      final bool best = rung == widget.rungs.last;
      final bool first = rung == widget.rungs.first;
      final bool reporting = best && load != null;
      below = CachedNetworkImage(
        key: best ? ValueKey(_attempt) : null,
        imageUrl: rung.url,
        cacheKey: '${rung.url}#${widget.discriminator}',
        cacheManager: rung.cache,
        httpHeaders: widget.headers(rung.url),
        memCacheWidth: rung.decodeWidth,
        fit: widget.fit,
        fadeInDuration: first ? widget.fade : Duration.zero,
        fadeOutDuration: first ? widget.fade : Duration.zero,
        placeholderFadeInDuration: Duration.zero,
        placeholder: reporting ? null : (context, url) => under,
        progressIndicatorBuilder: reporting
            ? (context, url, progress) {
                load.report(url, ImageLoading(progress.progress));
                return under;
              }
            : null,
        errorWidget: (context, url, error) {
          if (reporting) load.report(url, ImageFailed(error));
          return under;
        },
        imageBuilder: reporting || (best && widget.onRatio != null)
            ? (context, provider) {
                if (reporting) load.report(rung.url, const ImageLoaded());
                return _image(provider, best: best);
              }
            : null,
      );
    }
    return below;
  }
}

class MeasuredImage extends StatefulWidget {
  const MeasuredImage({
    super.key,
    required this.provider,
    required this.onRatio,
    required this.child,
  });

  final ImageProvider<Object> provider;
  final ValueChanged<double> onRatio;
  final Widget child;

  @override
  State<MeasuredImage> createState() => _MeasuredImageState();
}

class _MeasuredImageState extends State<MeasuredImage> {
  ImageStream? _stream;
  late final ImageStreamListener _listener = ImageStreamListener(_onFrame);

  void _onFrame(ImageInfo info, bool synchronous) {
    final int height = info.image.height;
    if (height != 0) widget.onRatio(info.image.width / height);
  }

  void _listen() {
    final ImageStream next = widget.provider.resolve(
      createLocalImageConfiguration(context),
    );
    if (next.key == _stream?.key) return;
    _stream?.removeListener(_listener);
    _stream = next..addListener(_listener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _listen();
  }

  @override
  void didUpdateWidget(MeasuredImage old) {
    super.didUpdateWidget(old);
    if (old.provider != widget.provider) _listen();
  }

  @override
  void dispose() {
    _stream?.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
