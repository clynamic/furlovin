import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:html/parser.dart' as html;

RuleSet _rules(String brokenSelector) => RuleSet.fromJson({
  'schema': generatedSchema,
  'revision': 1,
  'enums': <String, Object?>{},
  'entities': {
    'thing': {
      'feature': 'test',
      'fields': {
        'value': {
          'type': 'string',
          'required': false,
          'steps': [
            [
              {'op': 'text'},
            ],
          ],
        },
      },
    },
  },
  'pages': {
    'page': {
      'feature': 'test',
      'slots': {
        'broken': {
          'entity': 'thing',
          'selector': brokenSelector,
          'list': false,
        },
        'good': {'entity': 'thing', 'selector': 'span.good', 'list': false},
      },
    },
  },
});

void main() {
  test('a slot with an unparseable selector does not take the page down', () {
    final PageOutcome outcome = _rules('div[').parseDocument(
      'page',
      html.parse('<span class="good">kept</span>'),
      base: Uri.parse('https://www.furaffinity.net'),
    );

    expect(outcome.missing, contains('broken'));
    expect(outcome.single['good']?['value'], 'kept');
  });

  test('a slot that matches nothing is reported, not thrown', () {
    final PageOutcome outcome = _rules('span.absent').parseDocument(
      'page',
      html.parse('<span class="good">kept</span>'),
      base: Uri.parse('https://www.furaffinity.net'),
    );

    expect(outcome.missing, contains('broken'));
    expect(outcome.single['good']?['value'], 'kept');
  });

  test('a gap in the middle of a list does not shift the ones after it', () {
    final RuleSet rules = RuleSet.fromJson({
      'schema': generatedSchema,
      'revision': 1,
      'enums': <String, Object?>{},
      'entities': {
        'thing': {
          'feature': 'test',
          'fields': {
            'third': {
              'type': 'string',
              'required': false,
              'steps': [
                [
                  {'op': 'selectAll', 'css': 'span'},
                  {'op': 'attr', 'name': 'v'},
                  {'op': 'index', 'at': 2},
                ],
              ],
            },
          },
        },
      },
    });

    final ParseOutcome outcome =
        ParseEngine(base: Uri.parse('https://www.furaffinity.net')).parseOne(
          rules['thing']!,
          html
              .parse(
                '<div><span v="a">1</span><span>2</span><span v="c">3</span></div>',
              )
              .querySelector('div'),
        );

    expect(outcome['third'], 'c');
  });
}
