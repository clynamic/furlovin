import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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

  test('favouriting keeps the page the favourite answered with', () async {
    final (ProviderContainer container, _Pages adapter) = await host({
      '/view/1/': fixture('view'),
      '/fav/1/': fixture('view_folders'),
    });

    await container
        .read(submissionProvider(1).notifier)
        .favourite('https://www.furaffinity.net/fav/1/?key=x');

    expect(adapter.requested, ['/fav/1/']);
    expect(
      container.read(submissionProvider(1)).value?.submission.id,
      63882441,
    );
  });

  test('an unreadable answer falls back to reading the page again', () async {
    final (ProviderContainer container, _Pages adapter) = await host({
      '/view/1/': fixture('view'),
      '/fav/1/': '<html><body></body></html>',
    });

    await container
        .read(submissionProvider(1).notifier)
        .favourite('https://www.furaffinity.net/fav/1/?key=x');

    expect(adapter.requested, ['/fav/1/', '/view/1/']);
    expect(container.read(submissionProvider(1)).hasValue, isTrue);
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

    container.read(_key.notifier).state = 'member';
    await container.pump();
    await container.read(submissionProvider(1).future);

    expect(adapter.requested, ['/view/1/', '/view/1/']);
  });

  test('a notice page is read once, not retried', () async {
    final _Pages adapter = _Pages({'/view/1/': fixture('alder71_mature')});
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
}

final StateProvider<String?> _key = StateProvider<String?>((ref) => 'guest');
