import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

SubmissionPreview _preview(int id) => SubmissionPreview(
  id: id,
  link: 'https://www.furaffinity.net/view/$id/',
  rating: SubmissionRating.general,
  thumbnail: 'https://t.furaffinity.net/$id@600-0.jpg',
  uploader: 'someone',
);

class _GalleryClient extends SubmissionClient {
  _GalleryClient({required super.rules}) : super(client: FaClient());

  final List<String> asked = [];

  final Map<String, Completer<GalleryPage>> hold = {};

  @override
  Future<GalleryPage> gallery(GallerySource source, {int page = 1}) async {
    asked.add(source.path(page));
    if (hold[source.path(page)] case final Completer<GalleryPage> waiting) {
      return waiting.future;
    }
    return GalleryPage(
      submissions: page == 1 ? [_preview(1)] : const [],
      folders: page == 1
          ? const [
              Folder(
                user: 'someone',
                id: 7,
                slug: 'sketches',
                name: 'sketches',
              ),
            ]
          : const [],
    );
  }
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

void main() {
  late RuleSet rules;
  late List<int> requested;
  late List<List<SubmissionPreview>> pages;

  setUpAll(() {
    rules = RuleSet.fromJson(
      decodeRules(File('assets/rules/v1.yaml').readAsStringSync()),
    );
  });

  ProviderContainer host() {
    final ProviderContainer container = ProviderContainer.test(
      overrides: [
        sessionKeyProvider.overrideWithValue('anonymous'),
        submissionClientProvider.overrideWith(
          (ref) async => SubmissionClient(client: FaClient(), rules: rules),
        ),
      ],
    );
    return container;
  }

  Future<PagingState<int, SubmissionPreview>> settleListing(
    ProviderContainer container,
    ProviderListenable<PagingState<int, SubmissionPreview>> listing,
  ) async {
    for (
      int turn = 0;
      turn < 100 && container.read(listing).isLoading;
      turn++
    ) {
      await Future<void>.delayed(Duration.zero);
    }
    final PagingState<int, SubmissionPreview> state = container.read(listing);
    expect(state.isLoading, isFalse, reason: 'fetch never settled');
    return state;
  }

  SubmissionListingKey numbered() {
    requested = [];
    return (
      SubmissionListing<void, List<SubmissionPreview>>(
        name: 'numbered',
        fetch: (client, _, page) async {
          requested.add(page);
          return pages.length >= page ? pages[page - 1] : const [];
        },
        items: (page) => page,
        next: (page, key) => page.isEmpty ? null : key + 1,
      ),
      null,
    );
  }

  test('restart refetches after the list has run out', () async {
    pages = [
      [_preview(1), _preview(2)],
      const [],
    ];
    final SubmissionListingKey key = numbered();
    final ProviderContainer container = host();
    container.listen(submissionListingProvider(key), (previous, next) {});
    await settleListing(container, submissionListingProvider(key));
    final SubmissionListingPagination pagination = container.read(
      submissionListingPaginationProvider(key).notifier,
    );
    pagination.fetchNextPage();
    expect(
      (await settleListing(
        container,
        submissionListingProvider(key),
      )).hasNextPage,
      isFalse,
    );
    expect(requested, [1, 2]);

    await pagination.restart();
    final PagingState<int, SubmissionPreview> state = container.read(
      submissionListingProvider(key),
    );
    expect(requested, [1, 2, 1]);
    expect(state.items, hasLength(2));
    expect(state.hasNextPage, isTrue);
  });

  test(
    'restart keeps the listing on screen until the new page arrives',
    () async {
      final Completer<List<SubmissionPreview>> fresh = Completer();
      int loads = 0;
      final SubmissionListingKey key = (
        SubmissionListing<void, List<SubmissionPreview>>(
          name: 'numbered',
          fetch: (client, _, page) async =>
              loads++ == 0 ? [_preview(1), _preview(2)] : fresh.future,
          items: (page) => page,
          next: (page, key) => null,
        ),
        null,
      );
      final ProviderContainer container = host();
      container.listen(submissionListingProvider(key), (previous, next) {});
      await settleListing(container, submissionListingProvider(key));

      final Future<void> restarting = container
          .read(submissionListingPaginationProvider(key).notifier)
          .restart();
      await Future<void>.delayed(Duration.zero);
      final PagingState<int, SubmissionPreview> during = container.read(
        submissionListingProvider(key),
      );
      expect(during.items?.map((e) => e.id), [1, 2]);
      expect(during.status, isNot(PagingStatus.loadingFirstPage));

      fresh.complete([_preview(3), _preview(1)]);
      await restarting;
      final PagingState<int, SubmissionPreview> after = container.read(
        submissionListingProvider(key),
      );
      expect(after.items?.map((e) => e.id), [3, 1]);
      expect(after.keys, [1]);
    },
  );

  test('a listing loads once while the session arrives', () async {
    pages = [
      [_preview(1)],
    ];
    final SubmissionListingKey key = numbered();
    final ProviderContainer container = ProviderContainer.test(
      overrides: [
        sessionKeyProvider.overrideWith((ref) => ref.watch(_arriving)),
        submissionClientProvider.overrideWith(
          (ref) async => SubmissionClient(client: FaClient(), rules: rules),
        ),
      ],
    );
    container.listen(submissionListingProvider(key), (previous, next) {});
    container.read(_arriving.notifier).arrive();
    await settleListing(container, submissionListingProvider(key));

    expect(requested, [1]);
    expect(container.read(submissionListingProvider(key)).items, hasLength(1));
  });

  test('a session blip keeps the listing', () async {
    pages = [
      [_preview(1)],
    ];
    final SubmissionListingKey key = numbered();
    final ProviderContainer container = ProviderContainer.test(
      overrides: [
        sessionKeyProvider.overrideWith((ref) => ref.watch(_arriving)),
        submissionClientProvider.overrideWith(
          (ref) async => SubmissionClient(client: FaClient(), rules: rules),
        ),
      ],
    );
    final _Arriving session = container.read(_arriving.notifier)..arrive();
    container.listen(submissionListingProvider(key), (previous, next) {});
    await settleListing(container, submissionListingProvider(key));

    session.lose();
    await Future<void>.delayed(Duration.zero);
    session.arrive();
    await settleListing(container, submissionListingProvider(key));
    expect(requested, [1]);

    session.lose();
    await Future<void>.delayed(Duration.zero);
    session.signIn();
    await settleListing(container, submissionListingProvider(key));
    expect(requested, [1, 1]);
  });

  test('restart refetches after an empty first page', () async {
    pages = [];
    final SubmissionListingKey key = numbered();
    final ProviderContainer container = host();
    container.listen(submissionListingProvider(key), (previous, next) {});
    await settleListing(container, submissionListingProvider(key));
    expect(requested, [1]);

    pages = [
      [_preview(1)],
    ];
    await container
        .read(submissionListingPaginationProvider(key).notifier)
        .restart();
    expect(requested, [1, 1]);
    expect(container.read(submissionListingProvider(key)).items, hasLength(1));
  });

  ProviderContainer favouritesHost(_FavouritesClient client) {
    final ProviderContainer container = ProviderContainer.test(
      overrides: [
        sessionKeyProvider.overrideWithValue('anonymous'),
        submissionClientProvider.overrideWith((ref) async => client),
      ],
    );
    return container;
  }

  Future<PagingState<int, SubmissionPreview>> settleFavourites(
    ProviderContainer container,
  ) async {
    for (
      int turn = 0;
      turn < 100 &&
          container
              .read(submissionListingProvider((favoritesListing, 'someone')))
              .isLoading;
      turn++
    ) {
      await Future<void>.delayed(Duration.zero);
    }
    final PagingState<int, SubmissionPreview> state = container.read(
      submissionListingProvider((favoritesListing, 'someone')),
    );
    expect(state.isLoading, isFalse, reason: 'fetch never settled');
    return state;
  }

  test('favourites continue after the last favourite id', () async {
    final Map<int, List<Favorite>> pages = {
      0: [
        Favorite(id: 900, submission: _preview(1)),
        Favorite(id: 800, submission: _preview(2)),
      ],
      800: [Favorite(id: 700, submission: _preview(3))],
    };
    final _FavouritesClient client = _FavouritesClient(
      (after) async => pages[after] ?? const [],
      rules: rules,
    );
    final ProviderContainer container = favouritesHost(client);
    await settleFavourites(container);
    final SubmissionListingPagination pagination = container.read(
      submissionListingPaginationProvider((favoritesListing, 'someone'))
          .notifier,
    );
    pagination.fetchNextPage();
    await settleFavourites(container);
    pagination.fetchNextPage();
    final PagingState<int, SubmissionPreview> state = await settleFavourites(
      container,
    );
    pagination.fetchNextPage();

    expect(client.asked, [0, 800, 700]);
    expect(state.items?.map((e) => e.id), [1, 2, 3]);
    expect(state.hasNextPage, isFalse);
  });

  test(
    'favourites keep the listing on screen until the restart arrives',
    () async {
      final Completer<List<Favorite>> fresh = Completer();
      int firsts = 0;
      final _FavouritesClient client = _FavouritesClient(
        (after) async => switch (after) {
          0 when firsts++ > 0 => fresh.future,
          0 => [
            Favorite(id: 900, submission: _preview(1)),
            Favorite(id: 800, submission: _preview(2)),
          ],
          800 => [Favorite(id: 700, submission: _preview(3))],
          _ => const [],
        },
        rules: rules,
      );
      final ProviderContainer container = favouritesHost(client);
      await settleFavourites(container);
      final SubmissionListingPagination pagination = container.read(
        submissionListingPaginationProvider((favoritesListing, 'someone'))
            .notifier,
      );
      pagination.fetchNextPage();
      await settleFavourites(container);

      final Future<void> restarting = pagination.restart();
      await Future<void>.delayed(Duration.zero);
      final PagingState<int, SubmissionPreview> during = container.read(
        submissionListingProvider((favoritesListing, 'someone')),
      );
      expect(during.items?.map((e) => e.id), [1, 2, 3]);
      expect(during.status, isNot(PagingStatus.loadingFirstPage));

      fresh.complete([
        Favorite(id: 950, submission: _preview(4)),
        Favorite(id: 900, submission: _preview(1)),
      ]);
      await restarting;
      final PagingState<int, SubmissionPreview> after = container.read(
        submissionListingProvider((favoritesListing, 'someone')),
      );
      expect(after.items?.map((e) => e.id), [4, 1]);
      expect(after.keys, [0]);
      expect(after.hasNextPage, isTrue);
    },
  );

  test('a favourites page that lands after a restart is dropped', () async {
    final Completer<List<Favorite>> late = Completer();
    final _FavouritesClient client = _FavouritesClient(
      (after) async => switch (after) {
        0 => [
          Favorite(id: 900, submission: _preview(1)),
          Favorite(id: 800, submission: _preview(2)),
        ],
        800 => late.future,
        _ => const [],
      },
      rules: rules,
    );
    final ProviderContainer container = favouritesHost(client);
    await settleFavourites(container);
    final SubmissionListingPagination pagination = container.read(
      submissionListingPaginationProvider((favoritesListing, 'someone'))
          .notifier,
    );
    pagination.fetchNextPage();
    await Future<void>.delayed(Duration.zero);
    expect(client.asked, [0, 800]);

    await pagination.restart();
    late.complete([Favorite(id: 700, submission: _preview(3))]);
    await Future<void>.delayed(Duration.zero);

    final PagingState<int, SubmissionPreview> state = container.read(
      submissionListingProvider((favoritesListing, 'someone')),
    );
    expect(state.items?.map((e) => e.id), [1, 2]);
    expect(state.keys, [0]);
    expect(state.hasNextPage, isTrue);
  });

  test('favourites from another session are wiped', () async {
    final Completer<List<Favorite>> member = Completer();
    int firsts = 0;
    final _FavouritesClient client = _FavouritesClient(
      (after) async => switch (after) {
        0 when firsts++ > 0 => member.future,
        0 => [Favorite(id: 900, submission: _preview(1))],
        _ => const [],
      },
      rules: rules,
    );
    final ProviderContainer container = ProviderContainer.test(
      overrides: [
        sessionKeyProvider.overrideWith((ref) => ref.watch(_session)),
        submissionClientProvider.overrideWith((ref) async => client),
      ],
    );
    expect((await settleFavourites(container)).items?.map((e) => e.id), [1]);

    container.read(_session.notifier).signIn();
    await Future<void>.delayed(Duration.zero);
    final PagingState<int, SubmissionPreview> switching = container.read(
      submissionListingProvider((favoritesListing, 'someone')),
    );
    expect(switching.status, PagingStatus.loadingFirstPage);

    member.complete([Favorite(id: 950, submission: _preview(2))]);
    expect((await settleFavourites(container)).items?.map((e) => e.id), [2]);
  });

  test('favourites left mid-load keep their pages', () async {
    final Completer<List<Favorite>> second = Completer();
    final _FavouritesClient client = _FavouritesClient(
      (after) async => switch (after) {
        0 => [Favorite(id: 900, submission: _preview(1))],
        900 => second.future,
        _ => const [],
      },
      rules: rules,
    );
    final ProviderContainer container = favouritesHost(client);
    final ProviderSubscription<PagingState<int, SubmissionPreview>> screen =
        container.listen(
          submissionListingProvider((favoritesListing, 'someone')),
          (previous, next) {},
        );
    await settleFavourites(container);
    container
        .read(
          submissionListingPaginationProvider((favoritesListing, 'someone'))
              .notifier,
        )
        .fetchNextPage();
    screen.close();

    second.complete([Favorite(id: 800, submission: _preview(2))]);
    final PagingState<int, SubmissionPreview> state = await settleFavourites(
      container,
    );

    expect(state.items?.map((e) => e.id), [1, 2]);
    expect(state.keys, [0, 900]);
    expect(client.asked, [0, 900]);
  });

  test('a gallery shares its sidebar folders from the first page', () async {
    const GallerySource source = GallerySource.folder('someone', 7, 'sketches');
    final _GalleryClient client = _GalleryClient(rules: rules);
    final ProviderContainer container = ProviderContainer.test(
      overrides: [
        sessionKeyProvider.overrideWithValue('anonymous'),
        submissionClientProvider.overrideWith((ref) async => client),
      ],
    );
    container.listen(galleryFoldersProvider(source), (previous, next) {});
    container.listen(
      submissionListingProvider((galleryListing, source)),
      (previous, next) {},
    );
    expect(container.read(galleryFoldersProvider(source)), isNull);

    await settleListing(
      container,
      submissionListingProvider((galleryListing, source)),
    );
    expect(client.asked, ['/gallery/someone/folder/7/sketches/1/']);
    expect(
      container.read(galleryFoldersProvider(source))?.single.name,
      'sketches',
    );

    container
        .read(
          submissionListingPaginationProvider((galleryListing, source))
              .notifier,
        )
        .fetchNextPage();
    await settleListing(
      container,
      submissionListingProvider((galleryListing, source)),
    );
    expect(client.asked, hasLength(2));
    expect(container.read(galleryFoldersProvider(source)), hasLength(1));
  });

  test('gallery folders stay while another shelf loads', () async {
    const GallerySource main = GallerySource.main('someone');
    const GallerySource scraps = GallerySource.scraps('someone');
    final _GalleryClient client = _GalleryClient(rules: rules);
    final Completer<GalleryPage> held = Completer();
    client.hold['/scraps/someone/1/'] = held;
    final ProviderContainer container = ProviderContainer.test(
      overrides: [
        sessionKeyProvider.overrideWithValue('anonymous'),
        submissionClientProvider.overrideWith((ref) async => client),
      ],
    );
    container.listen(galleryFoldersProvider(main), (previous, next) {});
    container.listen(
      submissionListingProvider((galleryListing, main)),
      (previous, next) {},
    );
    await settleListing(
      container,
      submissionListingProvider((galleryListing, main)),
    );

    container.listen(galleryFoldersProvider(scraps), (previous, next) {});
    container.listen(
      submissionListingProvider((galleryListing, scraps)),
      (previous, next) {},
    );
    await Future<void>.delayed(Duration.zero);
    expect(
      container
          .read(submissionListingProvider((galleryListing, scraps)))
          .status,
      PagingStatus.loadingFirstPage,
    );
    expect(
      container.read(galleryFoldersProvider(scraps))?.single.name,
      'sketches',
    );

    held.complete(const GalleryPage());
    await settleListing(
      container,
      submissionListingProvider((galleryListing, scraps)),
    );
    expect(container.read(galleryFoldersProvider(scraps)), isEmpty);
  });
}

final NotifierProvider<_Session, String?> _session =
    NotifierProvider<_Session, String?>(_Session.new);

class _Session extends Notifier<String?> {
  @override
  String? build() => 'guest';

  void signIn() => state = 'member';
}

final NotifierProvider<_Arriving, String?> _arriving =
    NotifierProvider<_Arriving, String?>(_Arriving.new);

class _Arriving extends Notifier<String?> {
  @override
  String? build() => null;

  void arrive() => state = 'guest';

  void lose() => state = null;

  void signIn() => state = 'member';
}
