import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:material_ui/material_ui.dart';

typedef ImageRung = ({String url, CacheManager? cache, int? decodeWidth});

class ProgressiveImage extends StatelessWidget {
  const ProgressiveImage({
    super.key,
    required this.rungs,
    required this.headers,
    required this.discriminator,
    this.fit = BoxFit.contain,
    this.background,
    this.fade = const Duration(milliseconds: 180),
    this.onRatio,
  });

  final List<ImageRung> rungs;
  final Map<String, String> Function(String url) headers;
  final String discriminator;
  final BoxFit fit;
  final Color? background;
  final Duration fade;
  final ValueChanged<double>? onRatio;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    Widget below = ColoredBox(
      color: background ?? theme.colorScheme.surfaceContainer,
    );
    for (final ImageRung rung in rungs) {
      final Widget under = below;
      final bool best = rung == rungs.last;
      final bool first = rung == rungs.first;
      below = CachedNetworkImage(
        imageUrl: rung.url,
        cacheKey: '${rung.url}#$discriminator',
        cacheManager: rung.cache,
        httpHeaders: headers(rung.url),
        memCacheWidth: rung.decodeWidth,
        fit: fit,
        fadeInDuration: first ? fade : Duration.zero,
        fadeOutDuration: first ? fade : Duration.zero,
        placeholderFadeInDuration: Duration.zero,
        placeholder: (context, url) => under,
        errorWidget: (context, url, error) => under,
        imageBuilder: onRatio == null || !best
            ? null
            : (context, provider) => MeasuredImage(
                provider: provider,
                onRatio: onRatio!,
                child: Image(image: provider, fit: fit),
              ),
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
