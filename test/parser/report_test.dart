import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/submission/submission.dart';

import '../_support/documents.dart';

void main() {
  late RuleSet rules;

  setUpAll(() => rules = loadRules());

  ReadReport collect(ParseOutcome root) =>
      ReadReport()..collect(root, SubmissionDocument.ruleType, rules);

  test('an unreachable nested type is unreadable', () {
    final ReadReport report = collect(
      const ParseOutcome(
        failed: {'miniGallery': StepException('at', 'gorse71 at "x"')},
      ),
    );
    expect(report.issues, const [
      ReadIssue(
        slot: 'miniGallery',
        kind: IssueKind.unreadable,
        error: StepException('at', 'gorse71 at "x"'),
      ),
    ]);
    expect(report.unreadable('miniGallery'), isTrue);
  });

  test('a list that loses some items reports how many and why', () {
    final ReadReport report = collect(
      const ParseOutcome(
        failed: {'folders': DroppedItems(2, 3, field: 'id', cause: NoMatch())},
      ),
    );
    expect(report.issues, const [
      ReadIssue(
        slot: 'folders',
        field: 'id',
        kind: IssueKind.dropped,
        error: NoMatch(),
        count: 2,
        of: 3,
      ),
    ]);
  });

  test('a list that loses every item is unreadable', () {
    final ReadReport report = collect(
      const ParseOutcome(
        failed: {'comments': DroppedItems(4, 4, field: 'id', cause: NoMatch())},
      ),
    );
    expect(report.unreadable('comments'), isTrue);
  });

  test('missing fields inside list items are merged per field', () {
    final ReadReport report = collect(
      const ParseOutcome(
        values: {
          'comments': [
            ParseOutcome(failed: {'posted': NoMatch()}),
            ParseOutcome(failed: {'posted': NoMatch()}),
            ParseOutcome(),
          ],
        },
      ),
    );
    expect(report.issues, const [
      ReadIssue(
        slot: 'comments',
        field: 'posted',
        kind: IssueKind.missing,
        error: NoMatch(),
        count: 2,
      ),
    ]);
  });

  test('a field missing inside a nested type names both', () {
    final ReadReport report = collect(
      const ParseOutcome(
        values: {
          'submission': ParseOutcome(failed: {'views': NoMatch()}),
        },
      ),
    );
    expect(report.issues.single.slot, 'submission');
    expect(report.issues.single.field, 'views');
    expect(report.issues.single.kind, IssueKind.missing);
  });

  test('a real page with nothing broken reports nothing', () {
    final ReadReport report = collect(
      parseFixture(rules, SubmissionDocument.ruleType, 'view_folders'),
    );
    expect(report.isEmpty, isTrue, reason: '${report.issues}');
  });
}
