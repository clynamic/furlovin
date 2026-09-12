import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:html/parser.dart' as html;

void main() {
  final StepContext context = StepContext(
    base: Uri.parse('https://furaffinity.net/'),
  );
  final List<Object?> items = html
      .parse('<ul><li>a</li><li>b</li><li>c</li></ul>')
      .querySelectorAll('li');

  test('picks by match position', () {
    expect(const IndexStep(0).apply(items, context), items.first);
    expect(const IndexStep(2).apply(items, context), items.last);
  });

  test('counts back from the end', () {
    expect(const IndexStep(-1).apply(items, context), items.last);
    expect(const IndexStep(-3).apply(items, context), items.first);
  });

  test('answers nothing when out of range', () {
    expect(const IndexStep(3).apply(items, context), isNull);
    expect(const IndexStep(-4).apply(items, context), isNull);
    expect(const IndexStep(0).apply(null, context), isNull);
  });

  test('refuses a value that is not a list', () {
    expect(
      () => const IndexStep(0).apply('text', context),
      throwsA(isA<StepException>()),
    );
  });
}
