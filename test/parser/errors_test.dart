import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/submission/submission.dart';

import '../_support/documents.dart';

void main() {
  late RuleSet rules;

  setUpAll(() => rules = loadRules());

  DocumentErrors collect(ParseOutcome root) =>
      DocumentErrors()..collect(root, SubmissionDocument.ruleType, rules);

  test('an unreachable nested type is unreadable', () {
    final DocumentErrors errors = collect(
      const ParseOutcome(
        failed: {'miniGallery': StepException('at', 'gorse71 at "x"')},
      ),
    );
    expect(errors.all, const [
      FieldError(
        slot: 'miniGallery',
        kind: FieldErrorKind.unreadable,
        error: StepException('at', 'gorse71 at "x"'),
      ),
    ]);
    expect(errors.unreadable('miniGallery'), isTrue);
  });

  test('a list that loses some items reports how many and why', () {
    final DocumentErrors errors = collect(
      const ParseOutcome(
        failed: {'folders': DroppedItems(2, 3, field: 'id', cause: NoMatch())},
      ),
    );
    expect(errors.all, const [
      FieldError(
        slot: 'folders',
        field: 'id',
        kind: FieldErrorKind.dropped,
        error: NoMatch(),
        count: 2,
        of: 3,
      ),
    ]);
  });

  test('a list that loses every item is unreadable', () {
    final DocumentErrors errors = collect(
      const ParseOutcome(
        failed: {'comments': DroppedItems(4, 4, field: 'id', cause: NoMatch())},
      ),
    );
    expect(errors.unreadable('comments'), isTrue);
  });

  test('missing fields inside list items are merged per field', () {
    final DocumentErrors errors = collect(
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
    expect(errors.all, const [
      FieldError(
        slot: 'comments',
        field: 'posted',
        kind: FieldErrorKind.missing,
        error: NoMatch(),
        count: 2,
      ),
    ]);
  });

  test('a field missing inside a nested type names both', () {
    final DocumentErrors errors = collect(
      const ParseOutcome(
        values: {
          'submission': ParseOutcome(failed: {'views': NoMatch()}),
        },
      ),
    );
    expect(errors.all.single.slot, 'submission');
    expect(errors.all.single.field, 'views');
    expect(errors.all.single.kind, FieldErrorKind.missing);
  });

  test('a real page with nothing broken reports nothing', () {
    final DocumentErrors errors = collect(
      parseFixture(rules, SubmissionDocument.ruleType, 'view_folders'),
    );
    expect(errors.isEmpty, isTrue, reason: '${errors.all}');
  });
}
