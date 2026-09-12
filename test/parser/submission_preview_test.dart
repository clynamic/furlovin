import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:html/parser.dart' as html;

void main() {
  late RuleSet rules;
  late List<ParseOutcome> items;

  setUpAll(() {
    rules = RuleSet.fromJson(
      decodeRules(File('assets/rules/v1.yaml').readAsStringSync()),
    );
    items = rules.parseSlotAll(
      rules.pages['browse']!.slots['submissions']!,
      html.parse(File('test/_fixtures/browse.html').readAsStringSync()),
      base: Uri.parse(faOrigin),
    );
  });

  test('rule set is supported', () {
    expect(rules.isSupported, isTrue);
    expect(rules[SubmissionPreview.entity], isNotNull);
  });

  test('finds every figure on the page', () {
    expect(items, hasLength(48));
  });

  test('every item parses completely', () {
    final Map<String, int> failures = {};
    for (final ParseOutcome item in items) {
      for (final MapEntry<String, String> failure in item.failed.entries) {
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
