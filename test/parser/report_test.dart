import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/logs/logs.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:furlovin/submission/submission.dart';

ParseOutcome _folder(int id, {Map<String, ParseException> failed = const {}}) =>
    ParseOutcome(
      values: {
        'user': 'someone',
        'id': id,
        'slug': 'f$id',
        'name': 'folder $id',
      },
      failed: failed,
    );

void main() {
  final Logger logger = Logger('test');

  test('an unreachable slot is unreadable', () {
    final ReadReport report = ReadReport();
    const PageOutcome(
      missing: {'miniGallery': StepException('slot', 'nothing at "x"')},
    ).read(SubmissionSlots.miniGallery, logger: logger, report: report);
    expect(report.issues, const [
      ReadIssue(
        slot: 'miniGallery',
        kind: IssueKind.unreadable,
        error: StepException('slot', 'nothing at "x"'),
      ),
    ]);
    expect(report.unreadable('miniGallery'), isTrue);
  });

  test('a list that loses some items reports how many', () {
    final ReadReport report = ReadReport();
    final List<Folder> folders = PageOutcome(
      items: {
        'folders': [
          _folder(1),
          const ParseOutcome(failed: {'id': NoMatch()}),
          const ParseOutcome(failed: {'id': NoMatch()}),
        ],
      },
    ).readAll(SubmissionSlots.folders, logger: logger, report: report);
    expect(folders, hasLength(1));
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
    final ReadReport report = ReadReport();
    const PageOutcome(
      items: {
        'folders': [
          ParseOutcome(failed: {'id': NoMatch()}),
        ],
      },
    ).readAll(SubmissionSlots.folders, logger: logger, report: report);
    expect(report.unreadable('folders'), isTrue);
  });

  test('a kept item missing an expected field is reported per field', () {
    final ReadReport report = ReadReport();
    PageOutcome(
      items: {
        'folders': [
          _folder(1, failed: const {'count': NoMatch()}),
          _folder(2, failed: const {'count': NoMatch()}),
        ],
      },
    ).readAll(SubmissionSlots.folders, logger: logger, report: report);
    expect(report.issues, const [
      ReadIssue(
        slot: 'folders',
        field: 'count',
        kind: IssueKind.missing,
        error: NoMatch(),
        count: 2,
      ),
    ]);
  });

  test('a clean read reports nothing', () {
    final ReadReport report = ReadReport();
    PageOutcome(
      items: {
        'folders': [_folder(1)],
      },
    ).readAll(SubmissionSlots.folders, logger: logger, report: report);
    expect(report.isEmpty, isTrue);
  });
}
