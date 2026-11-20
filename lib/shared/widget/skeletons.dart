import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skeletonizer/skeletonizer.dart';

export 'package:skeletonizer/skeletonizer.dart'
    show Bone, Skeleton, Skeletonizer, SkeletonizerConfig;

class SliverSkeletonPaging<T extends Object> extends StatelessWidget {
  const SliverSkeletonPaging({
    super.key,
    required this.state,
    required this.fetchNextPage,
    required this.ghost,
    required this.builder,
  });

  final PagingState<int, T> state;
  final VoidCallback fetchNextPage;
  final T Function(int index) ghost;
  final Widget Function(
    BuildContext context,
    PagingState<int, T> state,
    VoidCallback fetchNextPage,
  )
  builder;

  @override
  Widget build(BuildContext context) {
    final bool loading = state.status == PagingStatus.loadingFirstPage;
    return Skeletonizer.sliver(
      enabled: loading,
      child: builder(
        context,
        loading
            ? PagingState<int, T>(
                pages: [
                  [for (int index = 0; index < 12; index++) ghost(index)],
                ],
                keys: const [1],
              )
            : state,
        loading ? () {} : fetchNextPage,
      ),
    );
  }
}
