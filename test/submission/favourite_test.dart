import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/submission/submission.dart';

import '../_support/documents.dart';

class _Pages implements HttpClientAdapter {
  _Pages(this.pages);

  final Map<String, String> pages;
  final List<String> requested = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requested.add(options.uri.path);
    return ResponseBody.fromString(
      pages[options.uri.path] ?? '',
      200,
      headers: {
        Headers.contentTypeHeader: ['text/html; charset=utf-8'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  Future<(ProviderContainer, _Pages)> host(Map<String, String> pages) async {
    final _Pages adapter = _Pages(pages);
    final FaClient client = FaClient()..dio.httpClientAdapter = adapter;
    final ProviderContainer container = ProviderContainer(
      overrides: [
        sessionKeyProvider.overrideWithValue('anonymous'),
        submissionClientProvider.overrideWith(
          (ref) => SubmissionClient(client: client, rules: loadRules()),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.listen(submissionProvider(1), (previous, next) {});
    await container.read(submissionProvider(1).future);
    adapter.requested.clear();
    return (container, adapter);
  }

  String withLink(String page, String href) => page.replaceFirst(
    '<div id="submission-options">',
    '<div id="submission-options"><a href="$href">Fav</a>',
  );

  test(
    'favouriting shows at once and keeps the page it answered with',
    () async {
      final (ProviderContainer container, _Pages adapter) = await host({
        '/view/1/': withLink(fixture('view'), '/fav/1/?key=x'),
        '/fav/1/': withLink(fixture('view_folders'), '/unfav/1/?key=y'),
      });
      final Submission before = container
          .read(submissionProvider(1))
          .value!
          .submission;

      final Future<void> favouriting = container
          .read(submissionProvider(1).notifier)
          .setFavourited(true);
      final Submission shown = container
          .read(submissionProvider(1))
          .value!
          .submission;
      expect(shown.favourited, isTrue);
      expect(shown.favorites, before.favorites! + 1);

      await favouriting;
      expect(adapter.requested, ['/fav/1/']);
      final Submission settled = container
          .read(submissionProvider(1))
          .value!
          .submission;
      expect(settled.id, 65815591);
      expect(settled.favourited, isTrue);
    },
  );

  test('an unreadable answer falls back to reading the page again', () async {
    final (ProviderContainer container, _Pages adapter) = await host({
      '/view/1/': withLink(fixture('view'), '/fav/1/?key=x'),
      '/fav/1/': '<html><body></body></html>',
    });
    adapter.pages['/view/1/'] = withLink(fixture('view'), '/unfav/1/?key=y');

    await container.read(submissionProvider(1).notifier).setFavourited(true);

    expect(adapter.requested, ['/fav/1/', '/view/1/']);
    expect(
      container.read(submissionProvider(1)).value?.submission.favourited,
      isTrue,
    );
  });

  test('a new session discards a loaded submission', () async {
    final _Pages adapter = _Pages({'/view/1/': fixture('view')});
    final FaClient client = FaClient()..dio.httpClientAdapter = adapter;
    final ProviderContainer container = ProviderContainer(
      overrides: [
        sessionKeyProvider.overrideWith((ref) => ref.watch(_key)),
        submissionClientProvider.overrideWith(
          (ref) => SubmissionClient(client: client, rules: loadRules()),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.listen(submissionProvider(1), (previous, next) {});
    await container.read(submissionProvider(1).future);

    container.read(_key.notifier).signIn();
    await container.pump();
    await container.read(submissionProvider(1).future);

    expect(adapter.requested, ['/view/1/', '/view/1/']);
  });

  test('a notice page is read once, not retried', () async {
    final _Pages adapter = _Pages({'/view/1/': fixture('notice_mature')});
    final FaClient client = FaClient()..dio.httpClientAdapter = adapter;
    final ProviderContainer container = ProviderContainer(
      retry: retryFailure,
      overrides: [
        sessionKeyProvider.overrideWithValue('anonymous'),
        submissionClientProvider.overrideWith(
          (ref) => SubmissionClient(client: client, rules: loadRules()),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.listen(submissionProvider(1), (previous, next) {});

    await expectLater(
      container.read(submissionProvider(1).future),
      throwsA(isA<ContentFiltered>()),
    );
    await Future<void>.delayed(const Duration(seconds: 1));

    expect(adapter.requested, ['/view/1/']);
  });

  test('a logged out inbox asks nothing of the site', () async {
    final _Pages adapter = _Pages({});
    final FaClient client = FaClient()..dio.httpClientAdapter = adapter;
    final ProviderContainer container = ProviderContainer(
      retry: retryFailure,
      overrides: [
        sessionProvider.overrideWith((ref) => Stream.value(const Session())),
        submissionClientProvider.overrideWith(
          (ref) => SubmissionClient(client: client, rules: loadRules()),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.listen(sessionProvider, (previous, next) {});
    await container.read(sessionProvider.future);

    final SubmissionListingKey inbox = (inboxListing, null);
    container.listen(submissionListingProvider(inbox), (previous, next) {});
    for (
      int turn = 0;
      turn < 100 &&
          container.read(submissionListingProvider(inbox)).error == null;
      turn++
    ) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }

    expect(
      container.read(submissionListingProvider(inbox)).error,
      isA<AuthenticationRequired>(),
    );
    expect(adapter.requested, isEmpty);
  });
}

final NotifierProvider<_Key, String?> _key = NotifierProvider<_Key, String?>(
  _Key.new,
);

class _Key extends Notifier<String?> {
  @override
  String? build() => 'guest';

  void signIn() => state = 'member';
}
