import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('the grid keeps clear of chrome the shell declares', (
    tester,
  ) async {
    const double chrome = 96;
    final PagingState<int, SubmissionPreview> state =
        PagingState<int, SubmissionPreview>(
          pages: const [<SubmissionPreview>[]],
          keys: const [1],
          hasNextPage: false,
        );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              padding: EdgeInsets.only(bottom: chrome),
            ),
            child: SubmissionPagedGrid(
              state: state,
              fetchNextPage: () {},
              onRefresh: () async {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final Iterable<SliverPadding> pads = tester.widgetList<SliverPadding>(
      find.byType(SliverPadding),
    );
    expect(pads, isNotEmpty);
    expect(
      pads.any((e) => e.padding.resolve(TextDirection.ltr).bottom >= chrome),
      isTrue,
      reason: 'no sliver reserved room for the declared chrome',
    );

    await tester.idle();
    await tester.pump(const Duration(milliseconds: 1));
  });
}
