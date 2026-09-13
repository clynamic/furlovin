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

  ParseRequest request() => ParseRequest(
    document: document,
    rules: rules,
    page: BrowseDocument.ruleType,
    base: faOrigin,
  );

  test('parses off the main isolate and returns sendable results', () async {
    final ParseOutcome page = await parseAway(request());
    final List<Object?> outcomes = page['submissions']! as List<Object?>;
    expect(outcomes, hasLength(48));
    expect(
      outcomes.cast<ParseOutcome>().every((e) => e.failed.isEmpty),
      isTrue,
    );
    expect(page.failed, isEmpty);
  });

  test('outcomes survive the isolate boundary intact', () async {
    final BrowseDocument page = BrowseDocument.fromOutcome(
      await parseAway(request()),
    )!;
    expect(page.submissions, hasLength(48));
    for (final SubmissionPreview item in page.submissions) {
      expect(item.id, greaterThan(0));
      expect(item.rating, isA<SubmissionRating>());
      expect(item.thumbnailWidth, isNotNull);
    }
  });

  test('matches what the main isolate produces', () async {
    expect(await parseAway(request()), request().run());
  });
}
