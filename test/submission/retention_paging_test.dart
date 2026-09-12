import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/search/search.dart';
import 'package:furlovin/submission/submission.dart';

class _Pages implements HttpClientAdapter {
  final List<String> requested = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requested.add(options.uri.path);
    return ResponseBody.fromString(
      '',
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
  late RuleSet rules;

  setUpAll(() {
    rules = RuleSet.fromJson(
      decodeRules(File('assets/rules/v1.yaml').readAsStringSync()),
    );
  });

  ProviderContainer host() {
    final ProviderContainer container = ProviderContainer(
      overrides: [
        submissionClientProvider.overrideWith(
          (ref) async => SubmissionClient(
            client: FaClient()..dio.httpClientAdapter = _Pages(),
            rules: rules,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('a gallery beyond the retention window is let go', () async {
    final ProviderContainer container = host();
    final List<SubmissionPaging> held = [
      for (int i = 0; i <= listingRetention; i++)
        container.read(galleryProvider('user$i')),
    ];

    await Future<void>.delayed(Duration.zero);

    expect(
      identical(container.read(galleryProvider('user0')), held.first),
      isFalse,
      reason: 'the oldest gallery should have been evicted',
    );
    expect(
      identical(
        container.read(galleryProvider('user$listingRetention')),
        held.last,
      ),
      isTrue,
      reason: 'the newest gallery should still be held',
    );
  });

  test('browse is never let go', () async {
    final ProviderContainer container = host();
    final SubmissionPaging first = container.read(browseProvider);
    for (int i = 0; i <= listingRetention * 2; i++) {
      container.read(galleryProvider('other$i'));
    }
    await Future<void>.delayed(Duration.zero);
    expect(identical(container.read(browseProvider), first), isTrue);
  });

  test('galleries and searches do not share retention keys', () async {
    final ProviderContainer container = host();
    final SubmissionPaging gallery = container.read(galleryProvider('fennel114'));
    container.read(searchProvider(const SearchQuery(text: 'fennel114')));
    await Future<void>.delayed(Duration.zero);
    expect(identical(container.read(galleryProvider('fennel114')), gallery), isTrue);
  });
}
