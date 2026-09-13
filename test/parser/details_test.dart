import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/parser/parser.dart';

void main() {
  test('copied details say where and why a list broke', () {
    final DocumentErrors errors =
        DocumentErrors(
            page: 'https://www.furaffinity.net/view/28151717/',
            rules: '1/10',
            theme: 'beta',
          )
          ..add(
            const FieldError(
              slot: 'comments',
              field: 'id',
              kind: FieldErrorKind.unreadable,
              count: 141,
              of: 141,
              error: NoMatch(
                causes: [EmptyStep(1, 'select "a.comment_anchor[id^="cid:"]"')],
              ),
            ),
          )
          ..add(
            const FieldError(
              slot: 'submission',
              field: 'views',
              kind: FieldErrorKind.missing,
              error: NoMatch(
                causes: [EmptyStep(1, 'select "div[title="Views"] > div"')],
              ),
            ),
          );
    final List<String> lines = errorDetails(
      errors,
      errors.all,
      null,
    ).split('\n');
    expect(lines[0], contains('rules 1/10'));
    expect(lines[0], contains('theme beta'));
    expect(lines[1], 'https://www.furaffinity.net/view/28151717/');
    expect(lines[2], 'unreadable comments: dropped 141 of 141 over id');
    expect(
      lines[3],
      '  alternative 1: select "a.comment_anchor[id^="cid:"]" matched nothing',
    );
    expect(lines[4], 'submission.views missing');
  });
}
