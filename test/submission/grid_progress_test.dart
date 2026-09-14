import 'dart:async';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:furlovin/theme/theme.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_ui/material_ui.dart';

class _Silent implements FileService {
  @override
  int concurrentFetches = 1;

  @override
  Future<FileServiceResponse> get(String url, {Map<String, String>? headers}) =>
      Completer<FileServiceResponse>().future;
}

void main() {
  testWidgets('loading another page shows a spinner in the app theme', (
    tester,
  ) async {
    final SubmissionPaging controller = SubmissionPaging(
      (key) async => const <SubmissionPreview>[],
    );
    addTearDown(controller.dispose);
    controller.value = PagingState<int, SubmissionPreview>(
      pages: [const SubmissionPreviewGhost().list(2)],
      keys: const [1],
      isLoading: true,
    );

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
          home: SubmissionPagedGrid(controller: controller),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(minutes: 1));
  });
}
