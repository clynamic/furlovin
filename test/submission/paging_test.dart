import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  Future<GalleryPage> gallery(GallerySource source, {int page = 1}) async {
    asked.add(source.path(page));
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
  _FavouritesClient(this.pages, {required super.rules})
    : super(client: FaClient());

  final Map<int, List<Favorite>> pages;
  final List<int> asked = [];

  @override
  Future<List<Favorite>> favorites(String user, {int after = 0}) async {
    asked.add(after);
    return pages[after] ?? const [];
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
    final ProviderContainer container = ProviderContainer(
      overrides: [
        sessionKeyProvider.overrideWithValue('anonymous'),
        submissionClientProvider.overrideWith(
          (ref) async => SubmissionClient(client: FaClient(), rules: rules),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Provider<SubmissionPaging> build() {
    requested = [];
    return Provider<SubmissionPaging>(
      (ref) => submissionPaging(ref, (client, page) async {
        requested.add(page);
        return pages.length >= page ? pages[page - 1] : const [];
      }),
    );
  }

  Future<void> settle(SubmissionPaging controller) async {
    for (int turn = 0; turn < 100 && controller.value.isLoading; turn++) {
      await Future<void>.delayed(Duration.zero);
    }
    expect(controller.value.isLoading, isFalse, reason: 'fetch never settled');
  }

  test('restart refetches after the list has run out', () async {
    pages = [
      [_preview(1), _preview(2)],
      const [],
    ];
    final Provider<SubmissionPaging> paging = build();
    final SubmissionPaging controller = host().read(paging);

    await settle(controller);
    controller.fetchNextPage();
    await settle(controller);
    controller.fetchNextPage();
    await settle(controller);
    expect(requested, [1, 2]);
    expect(controller.value.hasNextPage, isFalse);

    await controller.restart();
    expect(requested, [1, 2, 1]);
    expect(controller.value.items, hasLength(2));
    expect(controller.value.hasNextPage, isTrue);
  });

  test(
    'restart keeps the listing on screen until the new page arrives',
    () async {
      final Completer<List<SubmissionPreview>> fresh = Completer();
      int loads = 0;
      final SubmissionPaging controller = SubmissionPaging(
        (key) async => loads++ == 0 ? [_preview(1), _preview(2)] : fresh.future,
      );
      addTearDown(controller.dispose);
      controller.fetchNextPage();
      await settle(controller);

      final Future<void> restarting = controller.restart();
      await Future<void>.delayed(Duration.zero);
      expect(controller.value.items?.map((e) => e.id), [1, 2]);
      expect(controller.value.status, isNot(PagingStatus.loadingFirstPage));

      controller.fetchNextPage();
      expect(loads, 2);

      fresh.complete([_preview(3), _preview(1)]);
      await restarting;
      expect(controller.value.items?.map((e) => e.id), [3, 1]);
      expect(controller.value.keys, [1]);
    },
  );

  test('restart refetches after an empty first page', () async {
    pages = [];
    final Provider<SubmissionPaging> paging = build();
    final SubmissionPaging controller = host().read(paging);

    await settle(controller);
    expect(requested, [1]);

    pages = [
      [_preview(1)],
    ];
    await controller.restart();
    expect(requested, [1, 1]);
    expect(controller.value.items, hasLength(1));
  });

  test('favourites continue after the last favourite id', () async {
    final _FavouritesClient client = _FavouritesClient({
      0: [
        Favorite(id: 900, submission: _preview(1)),
        Favorite(id: 800, submission: _preview(2)),
      ],
      800: [Favorite(id: 700, submission: _preview(3))],
    }, rules: rules);
    final ProviderContainer container = ProviderContainer(
      overrides: [
        sessionKeyProvider.overrideWithValue('anonymous'),
        submissionClientProvider.overrideWith((ref) async => client),
      ],
    );
    addTearDown(container.dispose);
    final SubmissionPaging controller = container.read(
      favoritesProvider('someone'),
    );

    await settle(controller);
    controller.fetchNextPage();
    await settle(controller);
    controller.fetchNextPage();
    await settle(controller);
    controller.fetchNextPage();
    await settle(controller);

    expect(client.asked, [0, 800, 700]);
    expect(controller.value.items?.map((e) => e.id), [1, 2, 3]);
    expect(controller.value.hasNextPage, isFalse);
  });

  test('a gallery shares its sidebar folders from the first page', () async {
    final _GalleryClient client = _GalleryClient(rules: rules);
    final ProviderContainer container = ProviderContainer(
      overrides: [
        sessionKeyProvider.overrideWithValue('anonymous'),
        submissionClientProvider.overrideWith((ref) async => client),
      ],
    );
    addTearDown(container.dispose);
    final GalleryListing listing = container.read(
      galleryProvider(const GallerySource.folder('someone', 7, 'sketches')),
    );
    expect(listing.folders.value, isNull);

    await settle(listing.paging);
    expect(client.asked, ['/gallery/someone/folder/7/sketches/1/']);
    expect(listing.folders.value?.single.name, 'sketches');

    listing.paging.fetchNextPage();
    await settle(listing.paging);
    expect(listing.folders.value, hasLength(1));
  });
}
