import 'dart:async';
import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:furlovin/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

class _Silent implements FileService {
  @override
  int concurrentFetches = 1;

  @override
  Future<FileServiceResponse> get(String url, {Map<String, String>? headers}) =>
      Completer<FileServiceResponse>().future;
}

class _Client extends SubmissionClient {
  _Client({required super.rules}) : super(client: FaClient());

  @override
  Future<List<Favorite>> favorites(String user, {int after = 0}) async =>
      after == 0
      ? [
          for (int id = 1; id <= 300; id++)
            Favorite(id: 1000 - id, submission: _preview(id)),
        ]
      : const [];

  @override
  Future<SubmissionDocument> submission(int id) =>
      Completer<SubmissionDocument>().future;
}

SubmissionPreview _preview(int id) => SubmissionPreview(
  id: id,
  link: 'https://www.furaffinity.net/view/$id/',
  rating: SubmissionRating.general,
  thumbnail: 'https://t.furaffinity.net/$id@600-0.jpg',
  uploader: 'someone',
  title: id.isEven ? 'a title long enough to wrap onto a second line' : 'short',
  thumbnailWidth: 100 + (id * 37 % 200),
  thumbnailHeight: 200,
);

void main() {
  late RuleSet rules;
  late ProviderContainer container;

  setUpAll(() {
    rules = RuleSet.fromJson(
      decodeRules(File('assets/rules/v1.yaml').readAsStringSync()),
    );
  });

  final SubmissionListingKey listing = (favoritesListing, 'someone');

  Future<void> settle(WidgetTester tester) async {
    for (int frame = 0; frame < 60; frame++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
  }

  Future<NavigatorState> pump(WidgetTester tester) async {
    final CacheManager cache = CacheManager(
      Config(
        'test',
        fileSystem: MemoryCacheSystem(),
        repo: NonStoringObjectProvider(),
        fileService: _Silent(),
      ),
    );
    container = ProviderContainer.test(
      overrides: [
        sessionKeyProvider.overrideWithValue('anonymous'),
        submissionClientProvider.overrideWith(
          (ref) async => _Client(rules: rules),
        ),
        thumbnailCacheProvider.overrideWithValue(cache),
        artworkCacheProvider.overrideWithValue(cache),
      ],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: buildTheme(Brightness.light),
          onGenerateRoute: (settings) => DismissRoute<void>(
            settings: settings,
            builder: (context) => const UserFavoritesPage(name: 'someone'),
          ),
        ),
      ),
    );
    await settle(tester);
    return tester.state(find.byType(Navigator));
  }

  void follow(int id) => container
      .read(submissionListingFollowProvider(listing).notifier)
      .follow(_preview(id));

  Finder tile(int id) => find.byWidgetPredicate(
    (widget) => widget is SubmissionTile && widget.submission.id == id,
  );

  void expectOnScreen(WidgetTester tester, int id) {
    expect(tile(id), findsOneWidget);
    final Rect shown = tester.getRect(tile(id));
    const Rect screen = Rect.fromLTWH(0, 0, 800, 600);
    expect(screen.overlaps(shown), isTrue, reason: '$shown is off screen');
  }

  Future<void> close(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(minutes: 1));
  }

  testWidgets('a far submission scrolls into view', (tester) async {
    await pump(tester);
    expect(tile(250), findsNothing);

    follow(250);
    await settle(tester);

    expectOnScreen(tester, 250);

    await close(tester);
  });

  testWidgets('a far submission chosen while covered is there as it uncovers', (
    tester,
  ) async {
    final NavigatorState navigator = await pump(tester);
    unawaited(
      navigator.push(
        DismissRoute<void>(builder: (context) => const Scaffold()),
      ),
    );
    await settle(tester);

    follow(180);
    await settle(tester);
    navigator.pop();
    await tester.pump();

    expect(tile(180), findsOneWidget);

    await settle(tester);

    expectOnScreen(tester, 180);

    await close(tester);
  });

  testWidgets('a pager swiped onward leaves the grid on its submission', (
    tester,
  ) async {
    final NavigatorState navigator = await pump(tester);
    unawaited(
      navigator.push(
        DismissRoute<void>(
          builder: (context) => SubmissionPager(
            origin: SubmissionOrigin(listing: listing, preview: _preview(1)),
          ),
        ),
      ),
    );
    await settle(tester);

    for (int swipe = 0; swipe < 12; swipe++) {
      await tester.fling(find.byType(PageView), const Offset(-600, 0), 1000);
      await settle(tester);
    }
    navigator.pop();
    await settle(tester);

    expectOnScreen(tester, 13);

    await close(tester);
  });

  testWidgets('an earlier submission scrolls back into view', (tester) async {
    await pump(tester);
    follow(250);
    await settle(tester);

    follow(40);
    await settle(tester);

    expectOnScreen(tester, 40);

    await close(tester);
  });
}
