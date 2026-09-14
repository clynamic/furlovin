import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/markup/markup.dart';
import 'package:material_ui/material_ui.dart';

class Emote extends ConsumerWidget {
  const Emote({super.key, required this.name, this.scale = 1});

  final String name;
  final double scale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Smilie? smilie = smilies[name];
    if (smilie == null) return const SizedBox.shrink();
    final CacheManager cache = ref.watch(thumbnailCacheProvider);
    return SizedBox(
      width: smilie.width * scale,
      height: smilie.height * scale,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.topLeft,
          maxWidth: smilieSheetWidth * scale,
          maxHeight: smilieSheetHeight * scale,
          child: Transform.translate(
            offset: Offset(-smilie.x * scale, -smilie.y * scale),
            child: Image(
              image: CachedNetworkImageProvider(
                Uri.parse(faOrigin).resolve(smilieSheet).toString(),
                cacheManager: cache,
              ),
              width: smilieSheetWidth * scale,
              height: smilieSheetHeight * scale,
              errorBuilder: (context, error, stack) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
