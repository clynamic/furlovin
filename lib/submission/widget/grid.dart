import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

const double tileExtent = 220;
const int stripLimit = 10;

class BrowsePage extends ConsumerWidget {
  const BrowsePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SubmissionPagedGrid(
      controller: ref.watch(browseProvider),
      header: const SliverAppBar(
        title: Text('Browse'),
        floating: true,
        snap: true,
      ),
    );
  }
}

class UserGalleryPage extends ConsumerWidget {
  const UserGalleryPage({super.key, required this.source});

  final GallerySource source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GalleryListing listing = ref.watch(galleryProvider(source));
    return SubmissionPagedGrid(
      key: ValueKey(source),
      controller: listing.paging,
      header: SliverAppBar(
        title: ValueListenableBuilder<List<Folder>?>(
          valueListenable: listing.folders,
          builder: (context, folders, child) => Text(switch (source.shelf) {
            GalleryShelf.main => source.user,
            GalleryShelf.scraps => "${source.user}'s scraps",
            GalleryShelf.folder =>
              folders?.where(source.holds).firstOrNull?.name ??
                  source.slug!.replaceAll('-', ' '),
          }),
        ),
        floating: true,
        snap: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: GalleryShelves(source: source, folders: listing.folders),
          ),
        ),
      ),
    );
  }
}

class UserFavoritesPage extends ConsumerWidget {
  const UserFavoritesPage({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) => SubmissionPagedGrid(
    controller: ref.watch(favoritesProvider(name)),
    header: SliverAppBar(
      title: Text("$name's favourites"),
      floating: true,
      snap: true,
    ),
  );
}

class SubmissionPagedGrid extends ConsumerWidget {
  const SubmissionPagedGrid({super.key, required this.controller, this.header});

  final SubmissionPaging controller;
  final Widget? header;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Session session = ref
        .watch(sessionProvider)
        .maybeWhen(data: (e) => e, orElse: () => const Session());
    final CacheManager? cache = ref
        .watch(thumbnailCacheProvider)
        .maybeWhen(data: (e) => e, orElse: () => null);

    return RefreshIndicator(
      onRefresh: controller.restart,
      child: PagingListener<int, SubmissionPreview>(
        controller: controller,
        builder: (context, state, fetchNextPage) {
          if (state.status == PagingStatus.loadingFirstPage) {
            return SubmissionGrid.ghost(
              ghost: const SubmissionPreviewGhost(),
              session: session,
              header: header,
            );
          }
          return CustomScrollView(
            slivers: [
              if (header case final Widget value) value,
              if (state.status == PagingStatus.firstPageError)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: failureFor(state.error!, onRetry: controller.restart),
                )
              else
                SliverPadding(
                  padding:
                      const EdgeInsets.all(Space.small) +
                      EdgeInsets.only(
                        bottom: MediaQuery.paddingOf(context).bottom,
                      ),
                  sliver: PagedSliverMasonryGrid<int, SubmissionPreview>.extent(
                    state: state,
                    fetchNextPage: fetchNextPage,
                    maxCrossAxisExtent: tileExtent,
                    mainAxisSpacing: Space.small,
                    crossAxisSpacing: Space.small,
                    showNewPageProgressIndicatorAsGridChild: false,
                    showNewPageErrorIndicatorAsGridChild: false,
                    showNoMoreItemsIndicatorAsGridChild: false,
                    builderDelegate:
                        PagedChildBuilderDelegate<SubmissionPreview>(
                          itemBuilder: (context, submission, index) =>
                              SubmissionTile(
                                submission: submission,
                                session: session,
                                cache: cache,
                              ),
                          noItemsFoundIndicatorBuilder: (context) =>
                              const FailureView(
                                icon: Icons.inbox_outlined,
                                title: 'Nothing here',
                                detail: 'The page held no submissions.',
                              ),
                          newPageErrorIndicatorBuilder: (context) =>
                              NewPageError(
                                error: state.error,
                                onRetry: fetchNextPage,
                              ),
                        ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class NewPageError extends StatelessWidget {
  const NewPageError({super.key, this.error, required this.onRetry});

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: onRetry,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.refresh, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 8),
            Text(
              'Could not load more. Tap to try again.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubmissionGrid extends StatelessWidget {
  const SubmissionGrid({
    super.key,
    required this.submissions,
    required this.session,
    this.header,
  }) : loading = false;

  SubmissionGrid.ghost({
    super.key,
    required Ghost<SubmissionPreview> ghost,
    required this.session,
    this.header,
    int count = 12,
  }) : submissions = ghost.list(count),
       loading = true;

  final List<SubmissionPreview> submissions;
  final Session session;
  final Widget? header;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: loading ? const NeverScrollableScrollPhysics() : null,
      slivers: [
        if (header case final Widget value) value,
        Skeletonizer.sliver(
          enabled: loading,
          child: SliverPadding(
            padding:
                const EdgeInsets.all(Space.small) +
                EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
            sliver: SliverMasonryGrid.extent(
              maxCrossAxisExtent: tileExtent,
              mainAxisSpacing: Space.small,
              crossAxisSpacing: Space.small,
              childCount: submissions.length,
              itemBuilder: (context, index) => SubmissionTile(
                submission: submissions[index],
                session: session,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SubmissionStrip extends ConsumerWidget {
  const SubmissionStrip({
    super.key,
    required this.submissions,
    this.height = 150,
    this.limit = stripLimit,
  });

  final List<SubmissionPreview> submissions;
  final double height;
  final int limit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Session session = ref
        .watch(sessionProvider)
        .maybeWhen(data: (e) => e, orElse: () => const Session());
    final CacheManager? cache = ref
        .watch(thumbnailCacheProvider)
        .maybeWhen(data: (e) => e, orElse: () => null);
    final List<SubmissionPreview> shown = submissions.take(limit).toList();
    return SizedBox(
      height: height,
      child: ScrollEdgeFade(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(right: Space.medium),
          itemCount: shown.length,
          separatorBuilder: (context, index) =>
              const SizedBox(width: Space.small),
          itemBuilder: (context, index) {
            final SubmissionPreview submission = shown[index];
            final double ratio =
                (submission.thumbnailWidth ?? 1) /
                (submission.thumbnailHeight ?? 1);
            return AspectRatio(
              aspectRatio: ratio.clamp(0.5, 2),
              child: ClipRRect(
                borderRadius: Corner.cards,
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => context.openSubmission(
                      submission.id,
                      preview: submission,
                    ),
                    child: SubmissionThumbnail(
                      submission: submission,
                      session: session,
                      cache: cache,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
