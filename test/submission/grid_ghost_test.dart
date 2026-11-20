import 'dart:async';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:furlovin/theme/theme.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_ui/material_ui.dart';

import '../_support/skeletons.dart';

class _Silent implements FileService {
  @override
  int concurrentFetches = 1;

  @override
  Future<FileServiceResponse> get(String url, {Map<String, String>? headers}) =>
      Completer<FileServiceResponse>().future;
}

void main() {
  Future<void> show(
    WidgetTester tester,
    PagingState<int, SubmissionPreview> state,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          thumbnailCacheProvider.overrideWithValue(
            CacheManager(
              Config(
                'test',
                fileSystem: MemoryCacheSystem(),
                repo: NonStoringObjectProvider(),
                fileService: _Silent(),
              ),
            ),
          ),
        ],
        child: MaterialApp(
          theme: buildTheme(Brightness.light),
          home: SubmissionPagedGrid(
            state: state,
            fetchNextPage: () {},
            onRefresh: () async {},
          ),
        ),
      ),
    );
    await tester.pump();
  }

  Future<void> leave(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(minutes: 1));
  }

  testWidgets('a grid loading its first page shows ghost tiles', (
    tester,
  ) async {
    await show(tester, PagingState<int, SubmissionPreview>(isLoading: true));

    expect(skeletons(find.byType(SubmissionTile)), findsWidgets);

    await leave(tester);
  });

  testWidgets('a loaded grid shows its submissions as they are', (
    tester,
  ) async {
    await show(
      tester,
      PagingState<int, SubmissionPreview>(
        pages: const [
          [
            SubmissionPreview(
              id: 7,
              link: 'https://example.com/view/7/',
              rating: SubmissionRating.general,
              thumbnail: 'https://example.com/7.jpg',
              uploader: 'otter',
            ),
          ],
        ],
        keys: const [1],
        hasNextPage: false,
      ),
    );

    expect(find.byType(SubmissionTile), findsOneWidget);
    expect(skeletons(find.byType(SubmissionTile)), findsNothing);

    await leave(tester);
  });
}
