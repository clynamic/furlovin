import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:material_ui/material_ui.dart';

class FaImage extends ConsumerWidget {
  const FaImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.failure,
  });

  final String url;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? failure;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Session session = ref
        .watch(sessionProvider)
        .maybeWhen(data: (e) => e, orElse: () => const Session());
    final CacheManager cache = ref.watch(thumbnailCacheProvider);
    return CachedNetworkImage(
      imageUrl: url,
      cacheKey: '$url#${session.discriminator}',
      cacheManager: cache,
      httpHeaders: session.headersFor(url),
      fit: fit,
      placeholder: (context, url) => placeholder ?? const SizedBox.shrink(),
      errorWidget: (context, url, error) =>
          failure ?? placeholder ?? const SizedBox.shrink(),
    );
  }
}
