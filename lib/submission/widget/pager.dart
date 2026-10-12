import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_ui/material_ui.dart';

class SubmissionPager extends ConsumerStatefulWidget {
  const SubmissionPager({super.key, required this.origin});

  final SubmissionOrigin origin;

  @override
  ConsumerState<SubmissionPager> createState() => _SubmissionPagerState();
}

class _SubmissionPagerState extends ConsumerState<SubmissionPager> {
  late SubmissionPreview current = widget.origin.preview;
  late int settled = current.id;
  bool trailing = false;
  PageController? pages;

  @override
  void dispose() {
    pages?.dispose();
    super.dispose();
  }

  void _drop() {
    final PageController? stale = pages;
    if (stale == null) return;
    pages = null;
    WidgetsBinding.instance.addPostFrameCallback((_) => stale.dispose());
  }

  void _follow(PageController pages, int index) {
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
        setState(() => settled = items[index].id);
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
        settled = current.id;
        trailing = false;
      }
    }
    final int index = items.indexWhere((e) => e.id == current.id);

    if (index < 0) {
      _drop();
      return SubmissionPage(id: current.id, preview: current);
    }

    final PageController pages = this.pages ??= PageController(
      initialPage: index,
    );
    if (!trailing) _follow(pages, index);

    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) => _onScrollEnd(notification, items),
      child: PagedPageView<int, SubmissionPreview>(
        state: state,
        fetchNextPage: ref
            .read(
              submissionListingPaginationProvider(widget.origin.listing)
                  .notifier,
            )
            .fetchNextPage,
        pageController: pages,
        onPageChanged: (index) {
          trailing = index >= items.length;
          if (!trailing) current = items[index];
        },
        builderDelegate: PagedChildBuilderDelegate<SubmissionPreview>(
          itemBuilder: (context, item, index) => _PagerPage(
            key: ValueKey(item.id),
            child: SubmissionPage(
              id: item.id,
              preview: item,
              settled: item.id == settled,
            ),
          ),
          newPageProgressIndicatorBuilder: (context) => const _PagerEnd(
            child: Center(child: CircularProgressIndicator()),
          ),
          newPageErrorIndicatorBuilder: (context) => _PagerEnd(
            child: Center(
              child: NewPageError(
                error: state.error,
                onRetry: ref
                    .read(
                      submissionListingPaginationProvider(widget.origin.listing)
                          .notifier,
                    )
                    .fetchNextPage,
              ),
            ),
          ),
        ),
      ),
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
  const _PagerEnd({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DismissFade(
    child: ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: child,
    ),
  );
}
