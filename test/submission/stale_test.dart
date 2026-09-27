import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:furlovin/user/user.dart';

import '../_support/documents.dart';

class _Pages implements HttpClientAdapter {
  _Pages(this.pages);

  final Map<String, String> pages;
  final Set<String> failing = {};
  final List<String> requested = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final String path = options.uri.path;
    requested.add(path);
    return ResponseBody.fromString(
      failing.contains(path) ? '' : pages[path] ?? '',
      failing.contains(path) ? 503 : 200,
      headers: {
        Headers.contentTypeHeader: ['text/html; charset=utf-8'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late DateTime now;

  setUp(() => now = DateTime(2026, 9, 27, 12));

  ProviderContainer host(_Pages adapter) {
    final FaClient client = FaClient()..dio.httpClientAdapter = adapter;
    return ProviderContainer.test(
      retry: retryFailure,
      overrides: [
        clockProvider.overrideWithValue(() => now),
        sessionKeyProvider.overrideWithValue('anonymous'),
        submissionClientProvider.overrideWith(
          (ref) => SubmissionClient(client: client, rules: loadRules()),
        ),
        userClientProvider.overrideWith(
          (ref) => UserClient(client: client, rules: loadRules()),
        ),
      ],
    );
  }

  Future<void> revisit(
    ProviderContainer container,
    ProviderListenable<Object?> provider,
  ) async {
    container.listen(provider, (previous, next) {}).close();
    await Future<void>.delayed(Duration.zero);
  }

  test('a revisited submission refreshes once it is stale', () async {
    final _Pages adapter = _Pages({'/view/1/': fixture('view')});
    final ProviderContainer container = host(adapter);
    final ProviderSubscription<AsyncValue<SubmissionDocument>> first = container
        .listen(submissionProvider(1), (previous, next) {});
    final int id = (await container.read(submissionProvider(1).future))
        .submission
        .id;
    first.close();

    now = now.add(const Duration(minutes: 4));
    await revisit(container, submissionProvider(1));
    expect(adapter.requested, ['/view/1/']);

    now = now.add(const Duration(minutes: 2));
    container.listen(submissionProvider(1), (previous, next) {});
    await Future<void>.delayed(Duration.zero);
    final AsyncValue<SubmissionDocument> refreshing = container.read(
      submissionProvider(1),
    );
    expect(refreshing.isLoading, isTrue);
    expect(refreshing.value?.submission.id, id);

    await container.read(submissionProvider(1).future);
    expect(adapter.requested, ['/view/1/', '/view/1/']);
  });

  test('a stale submission waits for a favourite to finish sending', () async {
    final _Pages adapter = _Pages({
      '/view/1/': fixture('view').replaceFirst(
        '<div id="submission-options">',
        '<div id="submission-options"><a href="/fav/1/?key=x">Fav</a>',
      ),
      '/fav/1/': fixture('view_folders').replaceFirst(
        '<div id="submission-options">',
        '<div id="submission-options"><a href="/unfav/1/?key=y">Fav</a>',
      ),
    });
    final ProviderContainer container = host(adapter);
    final ProviderSubscription<AsyncValue<SubmissionDocument>> first = container
        .listen(submissionProvider(1), (previous, next) {});
    await container.read(submissionProvider(1).future);
    final Future<void> favouriting = container
        .read(submissionProvider(1).notifier)
        .setFavourited(true);
    first.close();

    now = now.add(const Duration(minutes: 6));
    await revisit(container, submissionProvider(1));
    expect(adapter.requested, ['/view/1/']);

    await favouriting;
    expect(adapter.requested, ['/view/1/', '/fav/1/']);
  });

  test('a failed refresh keeps the loaded submission', () async {
    final _Pages adapter = _Pages({'/view/1/': fixture('view')});
    final ProviderContainer container = host(adapter);
    final ProviderSubscription<AsyncValue<SubmissionDocument>> first = container
        .listen(submissionProvider(1), (previous, next) {});
    final int id = (await container.read(submissionProvider(1).future))
        .submission
        .id;
    first.close();

    adapter.failing.add('/view/1/');
    now = now.add(const Duration(minutes: 6));
    container.listen(submissionProvider(1), (previous, next) {});
    await Future<void>.delayed(Duration.zero);
    for (
      int turn = 0;
      turn < 100 && container.read(submissionProvider(1)).isLoading;
      turn++
    ) {
      await Future<void>.delayed(Duration.zero);
    }

    final AsyncValue<SubmissionDocument> failed = container.read(
      submissionProvider(1),
    );
    expect(adapter.requested, ['/view/1/', '/view/1/']);
    expect(failed.hasError, isTrue);
    expect(failed.value?.submission.id, id);
  });

  test('a revisited profile refreshes once it is stale', () async {
    final _Pages adapter = _Pages({'/user/someone/': fixture('user')});
    final ProviderContainer container = host(adapter);
    final ProviderSubscription<AsyncValue<UserDocument>> first = container
        .listen(userProvider('someone'), (previous, next) {});
    await container.read(userProvider('someone').future);
    first.close();

    now = now.add(const Duration(minutes: 4));
    await revisit(container, userProvider('someone'));
    expect(adapter.requested, ['/user/someone/']);

    now = now.add(const Duration(minutes: 2));
    container.listen(userProvider('someone'), (previous, next) {});
    await Future<void>.delayed(Duration.zero);
    await container.read(userProvider('someone').future);
    expect(adapter.requested, ['/user/someone/', '/user/someone/']);
  });
}
