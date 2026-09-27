import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/parser/parser.dart';

void main() {
  FieldError missing(String path) => FieldError(
    path: path,
    kind: FieldErrorKind.missing,
    error: const NoMatch(),
  );

  test('hiding a page keeps later breakage visible', () {
    final DocumentErrors seen = DocumentErrors(type: 'submissionDocument')
      ..add(missing('submission.views'));
    final HiddenBoundaries hidden = const HiddenBoundaries().hideAll(
      seen,
      seen.all,
    );

    final DocumentErrors later = DocumentErrors(type: 'submissionDocument')
      ..add(missing('submission.views'))
      ..add(missing('submission.tags'));
    expect(hidden.visible(later), [missing('submission.tags')]);
  });

  test('hiding a page leaves other page types alone', () {
    final DocumentErrors submission = DocumentErrors(type: 'submissionDocument')
      ..add(missing('comments'));
    final HiddenBoundaries hidden = const HiddenBoundaries().hideAll(
      submission,
      submission.all,
    );

    final DocumentErrors journal = DocumentErrors(type: 'journalDocument')
      ..add(missing('comments'));
    expect(hidden.visible(journal), journal.all);
  });

  test('hiding a boundary notifies once', () {
    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);
    final List<HiddenBoundaries> seen = [];
    container.listen(
      hiddenBoundariesProvider,
      (previous, next) => seen.add(next),
    );

    container.read(hiddenBoundariesProvider.notifier)
      ..hide('comments')
      ..hide('comments');

    expect(seen, hasLength(1));
    expect(container.read(hiddenBoundariesProvider).hides('comments'), isTrue);
  });
}
