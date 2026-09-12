import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
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
}
