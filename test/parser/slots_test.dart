import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:html/parser.dart' as html;

RuleSet _rules(String brokenSelector) => RuleSet.fromJson({
  'schema': generatedSchema,
  'types': {
    'thing': {
      'feature': 'test',
      'fields': {
        'value': {
          'read': [
            [
              {'op': 'text'},
            ],
          ],
        },
      },
    },
    'page': {
      'feature': 'test',
      'page': true,
      'fields': {
        'broken': {
          'type': 'thing',
          'at': [brokenSelector],
        },
        'good': {
          'type': 'thing',
          'at': ['span.good'],
        },
      },
    },
  },
});

void main() {
  ParseOutcome parse(String selector) => _rules(selector).parsePage(
    'page',
    html.parse('<span class="good">kept</span>'),
    base: Uri.parse('https://www.furaffinity.net'),
  );

  test('a field with an unparseable selector does not take the page down', () {
    final ParseOutcome outcome = parse('div[');
    expect(outcome.failed['broken'], isA<UnexpectedParseError>());
    expect((outcome['good']! as ParseOutcome)['value'], 'kept');
  });

  test('an optional field that matches nothing stays quiet', () {
    final ParseOutcome outcome = parse('span.absent');
    expect(outcome.failed, isEmpty);
    expect(outcome['broken'], isNull);
    expect((outcome['good']! as ParseOutcome)['value'], 'kept');
  });

  test('a gap in the middle of a list does not shift the ones after it', () {
    final Object? third =
        ParseEngine(base: Uri.parse('https://www.furaffinity.net')).evaluate(
          const FieldRule([
            [SelectAllStep('span'), AttrStep('v'), IndexStep(2)],
          ]),
          html
              .parse(
                '<div><span v="a">1</span><span>2</span><span v="c">3</span></div>',
              )
              .querySelector('div'),
        );
    expect(third, 'c');
  });
}
