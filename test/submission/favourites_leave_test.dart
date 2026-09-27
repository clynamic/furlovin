import 'dart:async';
import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/parser/parser.dart';
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

class _FavouritesClient extends SubmissionClient {
  _FavouritesClient(this.answer, {required super.rules})
    : super(client: FaClient());

  final Future<List<Favorite>> Function(int after) answer;
  final List<int> asked = [];

  @override
  Future<List<Favorite>> favorites(String user, {int after = 0}) {
    asked.add(after);
    return answer(after);
  }
}

SubmissionPreview _preview(int id) => SubmissionPreview(
  id: id,
  link: 'https://www.furaffinity.net/view/$id/',
  rating: SubmissionRating.general,
  thumbnail: 'https://t.furaffinity.net/$id@600-0.jpg',
  uploader: 'someone',
);

void main() {
  testWidgets('leaving favourites while a page loads keeps that page', (
    tester,
  ) async {
    final RuleSet rules = RuleSet.fromJson(
      decodeRules(File('assets/rules/v1.yaml').readAsStringSync()),
    );
    final Completer<List<Favorite>> second = Completer();
    final _FavouritesClient client = _FavouritesClient(
      (after) async => switch (after) {
        0 => [
          Favorite(id: 900, submission: _preview(1)),
          Favorite(id: 800, submission: _preview(2)),
        ],
        800 => second.future,
        _ => const [],
      },
      rules: rules,
    );
    final ProviderContainer container = ProviderContainer.test(
      overrides: [
        sessionKeyProvider.overrideWithValue('anonymous'),
        submissionClientProvider.overrideWith((ref) async => client),
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
    );
    final ValueNotifier<bool> shown = ValueNotifier(true);
    addTearDown(shown.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: buildTheme(Brightness.light),
          home: ValueListenableBuilder<bool>(
            valueListenable: shown,
            builder: (context, open, child) => open
                ? const UserFavoritesPage(name: 'someone')
                : const SizedBox(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(client.asked, [0, 800], reason: 'the second page should be loading');

    shown.value = false;
    await tester.pump();
    second.complete([Favorite(id: 700, submission: _preview(3))]);
    await tester.pump();

    shown.value = true;
    await tester.pump();
    await tester.pump();

    final PagingState<int, SubmissionPreview> state = container.read(
      submissionListingProvider((favoritesListing, 'someone')),
    );
    expect(state.items?.map((e) => e.id), [1, 2, 3]);
    expect(find.byType(SubmissionTile), findsNWidgets(3));
    expect(client.asked.where((after) => after != 700), [0, 800]);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(minutes: 1));
  });
}
