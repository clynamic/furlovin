import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/parser/parser.dart';

void main() {
  FieldError missing(String path) => FieldError(
    path: path,
    kind: FieldErrorKind.missing,
    error: const NoMatch(),
  );

  test('hiding a page keeps later breakage visible', () {
    final HiddenBoundaries hidden = HiddenBoundaries();
    final DocumentErrors seen = DocumentErrors(type: 'submissionDocument')
      ..add(missing('submission.views'));
    hidden.hideAll(seen, seen.all);

    final DocumentErrors later = DocumentErrors(type: 'submissionDocument')
      ..add(missing('submission.views'))
      ..add(missing('submission.tags'));
    expect(hidden.visible(later), [missing('submission.tags')]);
  });

  test('hiding a page leaves other page types alone', () {
    final HiddenBoundaries hidden = HiddenBoundaries();
    final DocumentErrors submission = DocumentErrors(type: 'submissionDocument')
      ..add(missing('comments'));
    hidden.hideAll(submission, submission.all);

    final DocumentErrors journal = DocumentErrors(type: 'journalDocument')
      ..add(missing('comments'));
    expect(hidden.visible(journal), journal.all);
  });
}
