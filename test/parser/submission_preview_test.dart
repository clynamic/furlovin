import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/submission/submission.dart';

import '../_support/documents.dart';

void main() {
  late RuleSet rules;
  late List<ParseOutcome> items;

  setUpAll(() {
    rules = loadRules();
    items = children(
      parseFixture(rules, BrowseDocument.ruleType, 'browse'),
      'submissions',
    );
  });

  test('rule set is supported', () {
    expect(rules.isSupported, isTrue);
    expect(rules[SubmissionPreview.ruleType], isNotNull);
  });

  test('finds every figure on the page', () {
    expect(items, hasLength(48));
  });

  test('every item parses completely', () {
    final Map<String, int> failures = {};
    for (final ParseOutcome item in items) {
      for (final MapEntry<String, ParseException> failure
          in item.failed.entries) {
        failures.update(
          '${failure.key}: ${failure.value}',
          (e) => e + 1,
          ifAbsent: () => 1,
        );
      }
    }
    expect(failures, isEmpty, reason: 'parse failures: $failures');
  });

  test('extracts the expected shapes', () {
    for (final ParseOutcome item in items) {
      expect(item.get<int>('id'), isA<int>());
      expect(item.get<String>('rating'), isIn(['general', 'mature', 'adult']));
      expect(item.get<String>('title'), isNotEmpty);
      expect(item.get<String>('uploader'), isNotEmpty);
      expect(
        item.get<String>('link'),
        startsWith('https://www.furaffinity.net/view/'),
      );
      expect(
        item.get<String>('thumbnail'),
        startsWith('https://t.furaffinity.net/'),
      );
      expect(item.get<double>('thumbnailWidth'), greaterThan(0));
      expect(item.get<double>('thumbnailHeight'), greaterThan(0));
    }
  });

  test('uploader is the url name, not the display name', () {
    for (final ParseOutcome item in items) {
      final String uploader = item.get<String>('uploader')!;
      expect(uploader, uploader.toLowerCase());
      expect(uploader, isNot(contains(' ')));
    }
  });

  test('favourites carry the id their next page continues after', () {
    final List<Favorite> favourites = FavoritesDocument.fromOutcome(
      parseFixture(rules, FavoritesDocument.ruleType, 'favorites'),
    )!.favorites;
    expect(favourites, hasLength(48));
    for (final Favorite favourite in favourites) {
      expect(favourite.id, greaterThan(0));
      expect(favourite.failed, isEmpty);
      expect(favourite.submission.id, greaterThan(0));
    }
    expect(favourites.last.id, 1732255726);
  });

  test('aspect ratio is usable before the image loads', () {
    for (final ParseOutcome item in items) {
      final double ratio =
          item.get<double>('thumbnailWidth')! /
          item.get<double>('thumbnailHeight')!;
      expect(ratio, greaterThan(0));
      expect(ratio, lessThan(20));
    }
  });
}
