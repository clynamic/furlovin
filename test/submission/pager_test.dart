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

import '../_support/gestures.dart';

class _Silent implements FileService {
  @override
  int concurrentFetches = 1;

  @override
  Future<FileServiceResponse> get(String url, {Map<String, String>? headers}) =>
      Completer<FileServiceResponse>().future;
}

class _Client extends SubmissionClient {
  _Client(this.answer, {required super.rules}) : super(client: FaClient());

  final Future<List<Favorite>> Function(int after) answer;
  final List<int> listed = [];
  final List<int> viewed = [];

  @override
  Future<List<Favorite>> favorites(String user, {int after = 0}) {
    listed.add(after);
    return answer(after);
  }

  @override
  Future<SubmissionDocument> submission(int id) {
    viewed.add(id);
    return Completer<SubmissionDocument>().future;
  }
}

SubmissionPreview _preview(int id) => SubmissionPreview(
  id: id,
  link: 'https://www.furaffinity.net/view/$id/',
  rating: SubmissionRating.general,
  thumbnail: 'https://t.furaffinity.net/$id@600-0.jpg',
  uploader: 'someone',
);

Favorite _favorite(int id) => Favorite(id: 1000 - id, submission: _preview(id));

void main() {
  late RuleSet rules;

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

  Future<_Client> pump(
    WidgetTester tester,
    Future<List<Favorite>> Function(int after) answer, {
    int open = 1,
  }) async {
    final _Client client = _Client(answer, rules: rules);
    final CacheManager cache = CacheManager(
      Config(
        'test',
        fileSystem: MemoryCacheSystem(),
        repo: NonStoringObjectProvider(),
        fileService: _Silent(),
      ),
    );
    final ProviderContainer container = ProviderContainer.test(
      overrides: [
        sessionKeyProvider.overrideWithValue('anonymous'),
        submissionClientProvider.overrideWith((ref) async => client),
        thumbnailCacheProvider.overrideWithValue(cache),
        artworkCacheProvider.overrideWithValue(cache),
      ],
    );
    final ProviderSubscription<Object?> held = container.listen(
      submissionListingProvider(listing),
      (previous, next) {},
    );
    addTearDown(held.close);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: buildTheme(Brightness.light),
          home: const SizedBox(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    final NavigatorState navigator = tester.state(find.byType(Navigator));
    unawaited(
      navigator.push(
        DismissRoute<void>(
          builder: (context) => SubmissionPager(
            origin: SubmissionOrigin(listing: listing, preview: _preview(open)),
          ),
        ),
      ),
    );
    await settle(tester);
    return client;
  }

  Future<void> swipe(WidgetTester tester, double dx) async {
    await tester.fling(find.byType(PageView), Offset(dx, 0), 1000);
    await settle(tester);
  }

  Future<void> close(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(minutes: 1));
  }

  int shown(WidgetTester tester) =>
      tester.widgetList<SubmissionPage>(find.byType(SubmissionPage)).single.id;

  testWidgets('opens on the submission it was opened from', (tester) async {
    final _Client client = await pump(
      tester,
      (after) async =>
          after == 0 ? [_favorite(1), _favorite(2), _favorite(3)] : const [],
      open: 2,
    );

    expect(shown(tester), 2);
    expect(client.viewed, [2]);

    await close(tester);
  });

  testWidgets('a swipe fetches only the submission it settles on', (
    tester,
  ) async {
    final _Client client = await pump(
      tester,
      (after) async =>
          after == 0 ? [_favorite(1), _favorite(2), _favorite(3)] : const [],
    );

    await swipe(tester, -600);

    expect(shown(tester), 2);
    expect(client.viewed, [1, 2]);

    await close(tester);
  });

  testWidgets('a peek at the next submission fetches nothing', (tester) async {
    final _Client client = await pump(
      tester,
      (after) async =>
          after == 0 ? [_favorite(1), _favorite(2), _favorite(3)] : const [],
    );

    final TestGesture finger = await tester.startGesture(
      const Offset(600, 300),
    );
    await finger.moveBy(const Offset(-100, 0));
    await tester.pump();
    await finger.moveBy(const Offset(-100, 0));
    await tester.pump();
    expect(find.byType(SubmissionPage), findsNWidgets(2));
    await finger.up();
    await settle(tester);

    expect(shown(tester), 1);
    expect(client.viewed, [1]);

    await close(tester);
  });

  testWidgets('swiping past the loaded submissions loads the next page', (
    tester,
  ) async {
    final _Client client = await pump(
      tester,
      (after) async => switch (after) {
        0 => [_favorite(1), _favorite(2)],
        998 => [_favorite(3)],
        _ => const [],
      },
    );

    await swipe(tester, -600);
    await swipe(tester, -600);

    expect(client.listed, containsAllInOrder([0, 998]));
    expect(shown(tester), 3);
    expect(client.viewed, [1, 2, 3]);

    await close(tester);
  });

  testWidgets('a page that loads while waiting at the end opens in place', (
    tester,
  ) async {
    final Completer<List<Favorite>> more = Completer();
    final _Client client = await pump(
      tester,
      (after) => switch (after) {
        0 => Future.value([_favorite(1), _favorite(2)]),
        998 => more.future,
        _ => Future.value(const <Favorite>[]),
      },
    );

    await swipe(tester, -600);
    await swipe(tester, -600);
    expect(find.byType(SubmissionPage), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    more.complete([_favorite(3)]);
    await settle(tester);

    expect(shown(tester), 3);
    expect(client.viewed, [1, 2, 3]);

    await close(tester);
  });

  int behind(WidgetTester tester) => tester
      .widgetList<SubmissionPage>(
        find.byType(SubmissionPage, skipOffstage: false),
      )
      .single
      .id;

  int viewing(WidgetTester tester) => tester
      .widgetList<SubmissionViewer>(find.byType(SubmissionViewer))
      .single
      .id;

  Future<void> openFullscreen(WidgetTester tester) async {
    await tester.tapAt(const Offset(400, 150));
    await settle(tester);
  }

  testWidgets('tapping the image opens fullscreen on that submission', (
    tester,
  ) async {
    await pump(
      tester,
      (after) async =>
          after == 0 ? [_favorite(1), _favorite(2), _favorite(3)] : const [],
      open: 2,
    );

    await openFullscreen(tester);

    expect(viewing(tester), 2);

    await close(tester);
  });

  testWidgets('a swipe in fullscreen moves the details beneath along', (
    tester,
  ) async {
    final _Client client = await pump(
      tester,
      (after) async =>
          after == 0 ? [_favorite(1), _favorite(2), _favorite(3)] : const [],
    );
    await openFullscreen(tester);

    await swipe(tester, -600);

    expect(viewing(tester), 2);
    expect(behind(tester), 2);
    expect(client.viewed, [1, 2]);

    await close(tester);
  });

  testWidgets('a peek in fullscreen leaves the details beneath alone', (
    tester,
  ) async {
    await pump(
      tester,
      (after) async =>
          after == 0 ? [_favorite(1), _favorite(2), _favorite(3)] : const [],
    );
    await openFullscreen(tester);

    final TestGesture finger = await tester.startGesture(
      const Offset(600, 300),
    );
    await finger.moveBy(const Offset(-100, 0));
    await tester.pump();
    await finger.moveBy(const Offset(-100, 0));
    await tester.pump();
    await finger.up();
    await settle(tester);

    expect(viewing(tester), 1);
    expect(behind(tester), 1);

    await close(tester);
  });

  testWidgets('a zoomed image in fullscreen keeps a swipe to itself', (
    tester,
  ) async {
    await pump(
      tester,
      (after) async =>
          after == 0 ? [_favorite(1), _favorite(2), _favorite(3)] : const [],
    );
    await openFullscreen(tester);

    await doubleTap(tester, const Offset(400, 300));
    await swipe(tester, -300);

    expect(viewing(tester), 1);

    await close(tester);
  });
}
