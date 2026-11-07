import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/comment/comment.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/submission/submission.dart';

import '../_support/documents.dart';

void main() {
  late ParseOutcome page;

  setUpAll(() {
    page = parseFixture(
      loadRules(),
      SubmissionDocument.ruleType,
      'view_comments',
    );
  });

  test('the submission parses on a page full of comments', () {
    final ParseOutcome outcome = child(page, 'submission');
    final Submission submission = Submission.fromOutcome(outcome)!;
    expect(outcome.failed, isEmpty);
    expect(submission.id, 20602645);
    expect(submission.uploader, 'fennel');
    expect(submission.title, 'Fennel1 Heath2');
  });

  test('the posted date is the submission, not a comment', () {
    final Submission submission = Submission.fromOutcome(
      child(page, 'submission'),
    )!;
    expect(
      submission.posted,
      DateTime.fromMillisecondsSinceEpoch(1528214019 * 1000, isUtc: true),
    );
  });

  test('reads every comment on the page', () {
    final List<Comment> comments = SubmissionDocument.fromOutcome(page)!
        .comments;
    expect(comments.length, greaterThan(100));
    for (final Comment comment in comments) {
      expect(comment.id, greaterThan(0));
      expect(comment.posted, isNotNull);
      expect(comment.depth, isNotNull);
    }
  });

  test('reads each width step down to 85 percent as one reply level', () {
    final List<Comment> comments = SubmissionDocument.fromOutcome(page)!
        .comments;
    expect(comments.map((e) => e.depth).toSet(), {0, 1, 2, 3, 4, 5});
  });
}
