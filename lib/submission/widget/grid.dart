import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/routing/routing.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

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

  double _headerExtent(BuildContext context) =>
      MediaQuery.paddingOf(context).top +
      switch (header) {
        SliverAppBar(
          :final double? toolbarHeight,
          :final PreferredSizeWidget? bottom,
        ) =>
          (toolbarHeight ?? kToolbarHeight) +
              (bottom?.preferredSize.height ?? 0),
        _ => 0,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Session session = ref
        .watch(sessionProvider)
        .maybeWhen(data: (e) => e, orElse: () => const Session());
    final CacheManager cache = ref.watch(thumbnailCacheProvider);
    final Tiles tiles = ref.watch(tilesProvider);

    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: RevisitRefresh(
        onRefresh: controller.restart,
        edgeOffset: _headerExtent(context),
        child: PagingListener<int, SubmissionPreview>(
          controller: controller,
          builder: (context, state, fetchNextPage) {
            if (state.status == PagingStatus.loadingFirstPage) {
              return SubmissionGrid.ghost(
                ghost: const SubmissionPreviewGhost(),
                session: session,
                tiles: tiles,
                header: header,
              );
            }
            return CustomScrollView(
              slivers: [
                if (header case final Widget value) value,
                if (state.status == PagingStatus.firstPageError)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: failureFor(
                      state.error!,
                      onRetry: controller.restart,
                      onLogin: ref.watch(authenticatedProvider)
                          ? null
                          : context.openLogin,
                    ),
                  )
                else
                  SliverPadding(
                    padding:
                        const EdgeInsets.all(Space.small) +
                        EdgeInsets.only(
                          bottom: MediaQuery.paddingOf(context).bottom,
                        ),
                    sliver:
                        PagedSliverMasonryGrid<int, SubmissionPreview>.extent(
                          state: state,
                          fetchNextPage: fetchNextPage,
                          maxCrossAxisExtent: tiles.extent,
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
                                      tiles: tiles,
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
    required this.tiles,
    this.header,
  }) : loading = false;

  SubmissionGrid.ghost({
    super.key,
    required Ghost<SubmissionPreview> ghost,
    required this.session,
    required this.tiles,
    this.header,
    int count = 12,
  }) : submissions = ghost.list(count),
       loading = true;

  final List<SubmissionPreview> submissions;
  final Session session;
  final Tiles tiles;
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
              maxCrossAxisExtent: tiles.extent,
              mainAxisSpacing: Space.small,
              crossAxisSpacing: Space.small,
              childCount: submissions.length,
              itemBuilder: (context, index) => SubmissionTile(
                submission: submissions[index],
                session: session,
                tiles: tiles,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SubmissionStrip extends ConsumerStatefulWidget {
  const SubmissionStrip({
    super.key,
    required this.submissions,
    this.height = 150,
    this.limit = stripLimit,
    this.current,
  });

  final List<SubmissionPreview> submissions;
  final double height;
  final int limit;
  final int? current;

  @override
  ConsumerState<SubmissionStrip> createState() => _SubmissionStripState();
}

class _SubmissionStripState extends ConsumerState<SubmissionStrip> {
  final ScrollController _scroll = ScrollController();
  final GlobalKey _current = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.current != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _center());
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _center() {
    final RenderBox? tile =
        _current.currentContext?.findRenderObject() as RenderBox?;
    final RenderObject? viewport = context.findRenderObject();
    if (!mounted || tile == null || viewport is! RenderBox) return;
    if (!_scroll.hasClients) return;
    final double left = tile.localToGlobal(Offset.zero, ancestor: viewport).dx;
    final double target =
        _scroll.offset + left - (viewport.size.width - tile.size.width) / 2;
    _scroll.jumpTo(
      target.clamp(
        _scroll.position.minScrollExtent,
        _scroll.position.maxScrollExtent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Session session = ref
        .watch(sessionProvider)
        .maybeWhen(data: (e) => e, orElse: () => const Session());
    final CacheManager cache = ref.watch(thumbnailCacheProvider);
    final double extent = ref.watch(tilesProvider).extent;
    final List<SubmissionPreview> shown = widget.submissions
        .take(widget.limit)
        .toList();
    return SizedBox(
      height: widget.height,
      child: ScrollEdgeFade(
        child: ListView.separated(
          controller: _scroll,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(right: Space.medium),
          itemCount: shown.length,
          separatorBuilder: (context, index) =>
              const SizedBox(width: Space.small),
          itemBuilder: (context, index) {
            final SubmissionPreview submission = shown[index];
            final bool here = submission.id == widget.current;
            final double ratio =
                (submission.thumbnailWidth ?? 1) /
                (submission.thumbnailHeight ?? 1);
            return AspectRatio(
              key: here ? _current : null,
              aspectRatio: ratio.clamp(0.5, 2),
              child: Container(
                foregroundDecoration: here
                    ? BoxDecoration(
                        borderRadius: Corner.cards,
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 3,
                        ),
                      )
                    : null,
                child: ClipRRect(
                  borderRadius: Corner.cards,
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: here
                          ? null
                          : () => context.openSubmission(
                              submission.id,
                              preview: submission,
                            ),
                      child: SubmissionThumbnail(
                        submission: submission,
                        session: session,
                        extent: extent,
                        cache: cache,
                      ),
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
