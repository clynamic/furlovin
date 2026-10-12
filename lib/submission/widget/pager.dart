import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_ui/material_ui.dart';

class SubmissionPager extends ConsumerStatefulWidget {
  const SubmissionPager({
    super.key,
    required this.origin,
    this.fullscreen = false,
    this.onSettled,
  });

  final SubmissionOrigin origin;
  final bool fullscreen;
  final ValueChanged<SubmissionPreview>? onSettled;

  static Route<void> viewerRoute({
    required SubmissionOrigin origin,
    ValueChanged<SubmissionPreview>? onSettled,
  }) => DismissRoute<void>(
    barrier: Colors.black,
    transition: DismissTransition.fade,
    builder: (context) =>
        SubmissionPager(origin: origin, fullscreen: true, onSettled: onSettled),
  );

  @override
  ConsumerState<SubmissionPager> createState() => _SubmissionPagerState();
}

class _SubmissionPagerState extends ConsumerState<SubmissionPager> {
  late SubmissionPreview current = widget.origin.preview;
  late int settled = current.id;
  bool trailing = false;
  PageController? pages;
  GalleryPanController? pan;

  @override
  void dispose() {
    _drop();
    super.dispose();
  }

  void _drop() {
    final PageController? stale = pages;
    final GalleryPanController? loose = pan;
    pages = null;
    pan = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stale?.dispose();
      loose?.locked.dispose();
    });
  }

  void _settle(SubmissionPreview item) {
    settled = item.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onSettled?.call(item);
      if (!widget.fullscreen) _follow(item);
    });
  }

  void _follow(SubmissionPreview item) {
    final SubmissionListingFollow follow = ref.read(
      submissionListingFollowProvider(widget.origin.listing).notifier,
    );
    follow.target = item.id;
  }

  void _show(SubmissionPreview item) {
    if (!mounted) return;
    final List<SubmissionPreview> items =
        ref.read(submissionListingProvider(widget.origin.listing)).items ??
        const [];
    final int index = items.indexWhere((e) => e.id == item.id);
    setState(() {
      current = item;
      settled = item.id;
      trailing = false;
    });
    _follow(item);
    final PageController? pages = this.pages;
    if (index < 0 || pages == null || !pages.hasClients) return;
    pages.jumpToPage(index);
  }

  void _openViewer(SubmissionPreview item) => Navigator.of(context).push(
    SubmissionPager.viewerRoute(
      origin: SubmissionOrigin(listing: widget.origin.listing, preview: item),
      onSettled: _show,
    ),
  );

  Widget _page(
    SubmissionPreview item, {
    bool settled = true,
    GalleryPanController? pan,
    VoidCallback? onTapImage,
  }) => widget.fullscreen
      ? SubmissionViewer(
          id: item.id,
          preview: item,
          tag: submissionHeroTag(item.id),
          aspectRatio: SubmissionFacade(preview: item).naturalAspectRatio,
          settled: settled,
          pan: pan,
        )
      : SubmissionPage(
          id: item.id,
          preview: item,
          settled: settled,
          onTapImage: onTapImage,
        );

  void _track(PageController pages, int index) {
    if (!pages.hasClients) return;
    final ScrollPosition position = pages.position;
    if (position.isScrollingNotifier.value) return;
    if (pages.page?.round() == index) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && pages.hasClients) pages.jumpToPage(index);
    });
  }

  bool _onScrollEnd(
    ScrollEndNotification notification,
    List<SubmissionPreview> items,
  ) {
    if (notification.depth != 0) return false;
    if (notification.metrics case PageMetrics(:final double page)) {
      final int index = page.round();
      if (index < items.length && items[index].id != settled) {
        setState(() => _settle(items[index]));
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final PagingState<int, SubmissionPreview> state = ref.watch(
      submissionListingProvider(widget.origin.listing),
    );
    final List<SubmissionPreview> items = state.items ?? const [];
    if (this.pages case final PageController resting
        when trailing && resting.hasClients) {
      final int at = resting.page!.round();
      if (at < items.length) {
        current = items[at];
        trailing = false;
        _settle(current);
      }
    }
    final int index = items.indexWhere((e) => e.id == current.id);

    if (index < 0) {
      _drop();
      return _page(current);
    }

    final PageController pages = this.pages ??= PageController(
      initialPage: index,
    );
    final GalleryPanController? pan = widget.fullscreen
        ? this.pan ??= GalleryPanController(pages)
        : null;
    if (!trailing) _track(pages, index);

    final VoidCallback fetchNextPage = ref
        .read(
          submissionListingPaginationProvider(widget.origin.listing).notifier,
        )
        .fetchNextPage;

    Widget view(bool locked) => PagedPageView<int, SubmissionPreview>(
      physics: locked ? const NeverScrollableScrollPhysics() : null,
      state: state,
      fetchNextPage: fetchNextPage,
      pageController: pages,
      onPageChanged: (index) {
        trailing = index >= items.length;
        if (!trailing) current = items[index];
      },
      builderDelegate: PagedChildBuilderDelegate<SubmissionPreview>(
        itemBuilder: (context, item, index) => _PagerPage(
          key: ValueKey(item.id),
          child: _page(
            item,
            settled: item.id == settled,
            pan: pan,
            onTapImage: () => _openViewer(item),
          ),
        ),
        newPageProgressIndicatorBuilder: (context) => _PagerEnd(
          fullscreen: widget.fullscreen,
          child: const Center(child: CircularProgressIndicator()),
        ),
        newPageErrorIndicatorBuilder: (context) => _PagerEnd(
          fullscreen: widget.fullscreen,
          child: Center(
            child: NewPageError(error: state.error, onRetry: fetchNextPage),
          ),
        ),
      ),
    );

    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) => _onScrollEnd(notification, items),
      child: switch (pan) {
        final GalleryPanController pan => ValueListenableBuilder<bool>(
          valueListenable: pan.locked,
          builder: (context, locked, child) => view(locked),
        ),
        null => view(false),
      },
    );
  }
}

class _PagerPage extends StatefulWidget {
  const _PagerPage({super.key, required this.child});

  final Widget child;

  @override
  State<_PagerPage> createState() => _PagerPageState();
}

class _PagerPageState extends State<_PagerPage> {
  final ScrollController scroll = ScrollController();

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      PrimaryScrollController(controller: scroll, child: widget.child);
}

class _PagerEnd extends StatelessWidget {
  const _PagerEnd({required this.fullscreen, required this.child});

  final bool fullscreen;
  final Widget child;

  @override
  Widget build(BuildContext context) => DismissFade(
    child: ColoredBox(
      color: fullscreen
          ? Colors.transparent
          : Theme.of(context).colorScheme.surface,
      child: child,
    ),
  );
}
