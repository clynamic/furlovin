import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

const double fallbackAspectRatio = 1;
const double minAspectRatio = 0.5;
const double maxAspectRatio = 2;

class SubmissionTile extends StatelessWidget {
  const SubmissionTile({
    super.key,
    required this.submission,
    required this.session,
    required this.tiles,
    this.cache,
    this.onTap,
  });

  final SubmissionPreview submission;
  final Session session;
  final Tiles tiles;
  final CacheManager? cache;
  final VoidCallback? onTap;

  double? get naturalAspectRatio {
    final double? width = submission.thumbnailWidth;
    final double? height = submission.thumbnailHeight;
    if (width == null || height == null || height == 0) return null;
    return width / height;
  }

  double get aspectRatio => switch (tiles.shape) {
    TileShape.natural => (naturalAspectRatio ?? fallbackAspectRatio).clamp(
      minAspectRatio,
      maxAspectRatio,
    ),
    TileShape.even => evenTileAspectRatio,
  };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap:
            onTap ??
            () => context.openSubmission(submission.id, preview: submission),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: aspectRatio,
              child: Skeleton.replace(
                width: double.infinity,
                height: double.infinity,
                child: ContentHero(
                  tag: submissionHeroTag(submission.id),
                  content: FittedContent(
                    fit: BoxFit.cover,
                    aspectRatio: naturalAspectRatio,
                  ),
                  child: SubmissionThumbnail(
                    submission: submission,
                    session: session,
                    extent: tiles.extent,
                    cache: cache,
                  ),
                ),
              ),
            ),
            if (tiles.captions)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      submission.title ?? 'Untitled',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      submission.uploaderName ?? submission.uploader,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SubmissionThumbnail extends StatelessWidget {
  const SubmissionThumbnail({
    super.key,
    required this.submission,
    required this.session,
    required this.extent,
    this.cache,
  });

  final SubmissionPreview submission;
  final Session session;
  final CacheManager? cache;
  final double extent;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double ratio = MediaQuery.devicePixelRatioOf(context);
    final String url = thumbnailFor(submission.thumbnail, extent, ratio);
    return CachedNetworkImage(
      imageUrl: url,
      cacheKey: '$url#${session.discriminator}',
      cacheManager: cache,
      memCacheWidth: (extent * ratio).round(),
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 120),
      placeholder: (context, url) => const Skeletonizer(
        child: Bone(width: double.infinity, height: double.infinity),
      ),
      errorWidget: (context, url, error) => ColoredBox(
        color: theme.colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.broken_image_outlined,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
