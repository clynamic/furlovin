import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:html/parser.dart' as html;

void main() {
  late RuleSet rules;
  late List<ParseOutcome> outcomes;

  setUpAll(() {
    rules = RuleSet.fromJson(
      decodeRules(File('assets/rules/v1.yaml').readAsStringSync()),
    );
    outcomes = rules.parseSlotAll(
      rules.pages['browse']!.slots['submissions']!,
      html.parse(File('test/_fixtures/browse.html').readAsStringSync()),
      base: Uri.parse(faOrigin),
    );
  });

  test('generated schema matches the rule file', () {
    expect(generatedSchema, rules.schema);
    expect(generatedSchema, RuleSet.currentSchema);
  });

  test('manifest covers every entity the rules declare', () {
    expect(ruleManifest.keys, containsAll(rules.entities.keys));
    for (final MapEntry<String, List<String>> entry in ruleManifest.entries) {
      expect(rules[entry.key]!.fields.keys, containsAll(entry.value));
    }
  });

  test('every outcome becomes a typed model', () {
    final List<SubmissionPreview> listings = outcomes
        .map(SubmissionPreview.fromOutcome)
        .nonNulls
        .toList();
    expect(listings, hasLength(outcomes.length));
    for (final SubmissionPreview listing in listings) {
      expect(listing.id, greaterThan(0));
      expect(listing.failed, isEmpty);
      expect(listing.link, contains('/view/${listing.id}/'));
    }
  });

  test('models compare by value', () {
    final SubmissionPreview first = SubmissionPreview.fromOutcome(
      outcomes.first,
    )!;
    final SubmissionPreview same = SubmissionPreview.fromOutcome(
      outcomes.first,
    )!;
    expect(first, same);
    expect(first.copyWith(title: 'larch17'), isNot(same));
  });

  test('a missing required field yields no model', () {
    expect(SubmissionPreview.fromOutcome(const ParseOutcome()), isNull);
  });

  test('optional failures survive into the model', () {
    const ParseOutcome outcome = ParseOutcome(
      values: {
        'id': 1,
        'uploader': 'olive96',
        'link': 'https://www.furaffinity.net/view/1/',
        'rating': 'general',
        'thumbnail': 'https://t.furaffinity.net/1@200-1.jpg',
        'title': 'a title',
      },
      failed: {'thumbnailWidth': NoMatch()},
    );
    final SubmissionPreview? listing = SubmissionPreview.fromOutcome(outcome);
    expect(listing, isNotNull);
    expect(listing!.thumbnailWidth, isNull);
    expect(listing.failed, containsPair('thumbnailWidth', const NoMatch()));
  });
}
