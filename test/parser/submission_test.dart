import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/submission/submission.dart';
import 'package:html/parser.dart' as html;

import '../_support/documents.dart';

void main() {
  late ParseOutcome outcome;
  late Submission submission;
  late RuleSet rules;

  setUpAll(() {
    rules = loadRules();
    outcome = child(
      parseFixture(rules, SubmissionDocument.ruleType, 'view'),
      'submission',
    );
    submission = Submission.fromOutcome(outcome)!;
  });

  test('parses without failures', () {
    expect(outcome.failed, isEmpty);
  });

  test('reads identity from the page', () {
    expect(submission.id, 66339591);
    expect(submission.title, 'New sorrel74!');
    expect(submission.uploader, 'olive33');
    expect(submission.rating, SubmissionRating.general);
    expect(submission.type, SubmissionType.image);
    expect(submission.extension, 'png');
  });

  test('resolves the full file and its preview', () {
    expect(submission.file, startsWith('https://d.furaffinity.net/art/'));
    expect(submission.file, endsWith('.png'));
    expect(submission.preview, startsWith('https://t.furaffinity.net/'));
    expect(submission.preview, contains('@600-'));
  });

  test('reads the posted time as an instant', () {
    expect(submission.posted, isNotNull);
    expect(submission.posted!.isUtc, isTrue);
    expect(submission.posted!.year, 2026);
  });

  test('reads the stats as numbers', () {
    expect(submission.views, greaterThan(0));
    expect(submission.comments, isNotNull);
    expect(submission.favorites, isNotNull);
  });

  test('keeps the description as markup', () {
    expect(submission.description, isNotNull);
    expect(submission.description, isNotEmpty);
  });

  test('reads tags as a list', () {
    expect(submission.tags.length, greaterThan(3));
    expect(submission.tags, contains('cedar35'));
    expect(submission.tags, everyElement(isNot(contains(' '))));
  });

  test('reads the uploader display name and avatar', () {
    expect(submission.uploaderName, isNotNull);
    expect(submission.uploaderAvatar, startsWith('https://a.furaffinity.net/'));
  });

  test('reads the positional stats block', () {
    expect(submission.category, 'Artwork (Tansy27)');
    expect(submission.theme, 'General Sorrel39 Art');
    expect(submission.species, 'Bramble28 (Mallow73)');
    expect(submission.resolution, '1614 x 2283');
    expect(submission.fileSize, '1.71 MB');
  });

  group('favourited', () {
    bool? read(String options) {
      final String markup =
          '<html><body><div id="submission-options">$options</div></body></html>';
      return TreeEngine(types: rules, base: Uri.parse(faOrigin))
          .parseType(rules['submission']!, html.parse(markup))
          .get<bool>('favourited');
    }

    test('an unfavourite link means it is already favourited', () {
      expect(read('<a href="/unfav/123/?key=abc">Remove</a>'), isTrue);
    });

    test('a favourite link means it is not', () {
      expect(read('<a href="/fav/123/?key=abc">Add</a>'), isFalse);
    });

    test('neither link leaves it unknown rather than false', () {
      expect(read('<span>gorse71</span>'), isNull);
    });
  });
}
