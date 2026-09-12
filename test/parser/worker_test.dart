import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/submission/submission.dart';

void main() {
  late Map<String, Object?> rules;
  late String document;

  setUpAll(() {
    rules = decodeRules(File('assets/rules/v1.yaml').readAsStringSync());
    document = File('test/_fixtures/browse.html').readAsStringSync();
  });

  test('parses off the main isolate and returns sendable results', () async {
    final PageOutcome page = await parseAway(
      ParseRequest(
        document: document,
        rules: rules,
        page: 'browse',
        base: faOrigin,
      ),
    );
    final List<ParseOutcome> outcomes = page.items['submissions']!;
    expect(outcomes, hasLength(48));
    expect(outcomes.every((e) => e.failed.isEmpty), isTrue);
    expect(page.missing, isEmpty);
  });

  test('outcomes survive the isolate boundary intact', () async {
    final PageOutcome page = await parseAway(
      ParseRequest(
        document: document,
        rules: rules,
        page: 'browse',
        base: faOrigin,
      ),
    );
    final List<SubmissionPreview> items = page.items['submissions']!
        .map(SubmissionPreview.fromOutcome)
        .nonNulls
        .toList();
    expect(items, hasLength(48));
    for (final SubmissionPreview item in items) {
      expect(item.id, greaterThan(0));
      expect(item.rating, isA<SubmissionRating>());
      expect(item.thumbnailWidth, isNotNull);
    }
  });

  test('matches what the main isolate produces', () async {
    final PageOutcome off = await parseAway(
      ParseRequest(
        document: document,
        rules: rules,
        page: 'browse',
        base: faOrigin,
      ),
    );
    final PageOutcome on = ParseRequest(
      document: document,
      rules: rules,
      page: 'browse',
      base: faOrigin,
    ).run();
    expect(off.items['submissions'], on.items['submissions']);
  });
}
