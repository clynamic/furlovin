import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
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
        sessionKeyProvider.overrideWithValue('anonymous'),
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
    for (int i = 0; i <= submissionListingRetention; i++) {
      container.read(
        submissionListingProvider((
          galleryListing,
          GallerySource.main('user$i'),
        )),
      );
    }

    await Future<void>.delayed(Duration.zero);

    expect(
      container.exists(
        submissionListingProvider((
          galleryListing,
          const GallerySource.main('user0'),
        )),
      ),
      isFalse,
      reason: 'the oldest gallery should have been evicted',
    );
    expect(
      container.exists(
        submissionListingProvider((
          galleryListing,
          const GallerySource.main('user$submissionListingRetention'),
        )),
      ),
      isTrue,
      reason: 'the newest gallery should still be held',
    );
  });

  test('favourites beyond the retention window are let go', () async {
    final ProviderContainer container = host();
    for (int i = 0; i <= submissionListingRetention; i++) {
      container.read(submissionListingProvider((favoritesListing, 'user$i')));
    }

    await Future<void>.delayed(Duration.zero);

    expect(
      container.exists(submissionListingProvider((favoritesListing, 'user0'))),
      isFalse,
      reason: 'the oldest favourites should have been evicted',
    );
    expect(
      container.exists(
        submissionListingProvider((
          favoritesListing,
          'user$submissionListingRetention',
        )),
      ),
      isTrue,
      reason: 'the newest favourites should still be held',
    );
  });

  test('browse is never let go', () async {
    final ProviderContainer container = host();
    container.read(submissionListingProvider((browseListing, null)));
    for (int i = 0; i <= submissionListingRetention * 2; i++) {
      container.read(
        submissionListingProvider((
          galleryListing,
          GallerySource.main('other$i'),
        )),
      );
    }
    await Future<void>.delayed(Duration.zero);
    expect(
      container.exists(submissionListingProvider((browseListing, null))),
      isTrue,
    );
  });

  test('galleries and searches do not share retention keys', () async {
    final ProviderContainer container = host();
    container.read(
      submissionListingProvider((
        galleryListing,
        const GallerySource.main('fennel114'),
      )),
    );
    container.read(
      submissionListingProvider((
        searchListing,
        SearchQuery.parse('fennel114'),
      )),
    );
    await Future<void>.delayed(Duration.zero);
    expect(
      container.exists(
        submissionListingProvider((
          galleryListing,
          const GallerySource.main('fennel114'),
        )),
      ),
      isTrue,
    );
  });

  test('a gallery, its scraps and its folders are separate listings', () async {
    final ProviderContainer container = host();
    const List<GallerySource> shelves = [
      GallerySource.main('fennel114'),
      GallerySource.scraps('fennel114'),
      GallerySource.folder('fennel114', 7, 'sketches'),
    ];
    for (final GallerySource shelf in shelves) {
      container.read(submissionListingProvider((galleryListing, shelf)));
    }
    await Future<void>.delayed(Duration.zero);
    for (final GallerySource shelf in shelves) {
      expect(
        container.exists(submissionListingProvider((galleryListing, shelf))),
        isTrue,
      );
    }
    expect(
      container.exists(
        submissionListingProvider((
          galleryListing,
          const GallerySource.folder('fennel114', 7, 'renamed'),
        )),
      ),
      isTrue,
      reason: 'FA ignores the slug, so a renamed folder is the same listing',
    );
  });
}
