import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/comment/comment.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:html/parser.dart' as html;

void main() {
  late RuleSet rules;
  late String markup;

  setUpAll(() {
    rules = RuleSet.fromJson(
      decodeRules(File('assets/rules/v1.yaml').readAsStringSync()),
    );
    markup = File('test/_fixtures/view_comments.html').readAsStringSync();
  });

  test('the submission parses on a page full of comments', () {
    final ParseOutcome outcome = rules.parseSlot(
      rules.pages['submission']!.slots['submission']!,
      html.parse(markup),
      base: Uri.parse(faOrigin),
    );
    final Submission submission = Submission.fromOutcome(outcome)!;
    expect(outcome.failed, isEmpty);
    expect(submission.id, 28151717);
    expect(submission.uploader, 'fennel76');
    expect(submission.title, 'Fennel66 Fallow29');
  });

  test('the posted date is the submission, not a comment', () {
    final Submission submission = Submission.fromOutcome(
      rules.parseSlot(
        rules.pages['submission']!.slots['submission']!,
        html.parse(markup),
        base: Uri.parse(faOrigin),
      ),
    )!;
    expect(
      submission.posted,
      DateTime.fromMillisecondsSinceEpoch(1532833035 * 1000, isUtc: true),
    );
  });

  test('reads every comment on the page', () {
    final List<Comment> comments = rules
        .parseSlotAll(
          rules.pages['submission']!.slots['comments']!,
          html.parse(markup),
          base: Uri.parse(faOrigin),
        )
        .map(Comment.fromOutcome)
        .nonNulls
        .toList();
    expect(comments.length, greaterThan(100));
    for (final Comment comment in comments) {
      expect(comment.id, greaterThan(0));
      expect(comment.posted, isNotNull);
      expect(comment.width, isNotNull);
    }
  });

  test('width encodes reply depth in three point steps', () {
    final List<Comment> comments = rules
        .parseSlotAll(
          rules.pages['submission']!.slots['comments']!,
          html.parse(markup),
          base: Uri.parse(faOrigin),
        )
        .map(Comment.fromOutcome)
        .nonNulls
        .toList();
    final Set<int> widths = comments.map((e) => e.width!).toSet();
    expect(widths, contains(100));
    for (final int width in widths) {
      expect((100 - width) % 3, 0, reason: 'width $width is off the ladder');
      expect(width, inInclusiveRange(85, 100));
    }
  });
}
