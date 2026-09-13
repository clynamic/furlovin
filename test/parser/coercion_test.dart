import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:html/parser.dart' as html;

EntityRule _entity(
  String type,
  String attribute, {
  bool required = false,
  bool expected = false,
}) => RuleSet.fromJson({
  'schema': generatedSchema,
  'revision': 1,
  'enums': {
    'Rating': {
      'feature': 'test',
      'values': ['general', 'adult'],
    },
  },
  'entities': {
    'thing': {
      'feature': 'test',
      'fields': {
        'value': {
          'type': type,
          'required': required,
          'expected': expected,
          'steps': [
            [
              {'op': 'attr', 'name': attribute},
            ],
          ],
        },
      },
    },
  },
})['thing']!;

EntityRule _fallback() => RuleSet.fromJson({
  'schema': generatedSchema,
  'revision': 1,
  'entities': {
    'thing': {
      'feature': 'test',
      'fields': {
        'value': {
          'type': 'int',
          'steps': [
            [
              {'op': 'index', 'at': 0},
            ],
            [
              {'op': 'attr', 'name': 'v'},
            ],
          ],
        },
      },
    },
  },
})['thing']!;

ParseOutcome _parse(EntityRule rule, String markup) =>
    ParseEngine(base: Uri.parse('https://www.furaffinity.net'))
        .parseOne(rule, html.parse(markup).querySelector('span'));

void main() {
  group('coercion', () {
    test('converts what it can', () {
      expect(_parse(_entity('int', 'v'), '<span v="42"></span>')['value'], 42);
      expect(
        _parse(_entity('float', 'v'), '<span v="141.393"></span>')['value'],
        141.393,
      );
      expect(
        _parse(
          _entity('timestamp', 'v'),
          '<span v="1789194688"></span>',
        ).get<DateTime>('value')?.toUtc().year,
        2026,
      );
    });

    test('records a coercion failure rather than a missing value', () {
      final ParseOutcome outcome = _parse(
        _entity('int', 'v'),
        '<span v="abc"></span>',
      );
      expect(outcome.values.containsKey('value'), isFalse);
      expect(outcome.failed['value'], const CoercionException('int', 'abc'));
    });

    test('records failures on optional fields too', () {
      final ParseOutcome outcome = _parse(
        _entity('float', 'v'),
        '<span v="wide"></span>',
      );
      expect(outcome.failed, contains('value'));
    });

    test('distinguishes nothing matched from a bad value', () {
      final ParseOutcome missing = _parse(
        _entity('int', 'v', required: true),
        '<span></span>',
      );
      expect(missing.failed['value'], const NoMatch());

      final ParseOutcome bad = _parse(
        _entity('int', 'v', required: true),
        '<span v="abc"></span>',
      );
      expect(bad.failed['value'], isA<CoercionException>());
    });

    test('a failing alternative falls through to the next one', () {
      final ParseOutcome outcome = _parse(_fallback(), '<span v="7"></span>');
      expect(outcome['value'], 7);
      expect(outcome.failed, isEmpty);
    });

    test('keeps every cause when no alternative works', () {
      final ParseOutcome outcome = _parse(_fallback(), '<span v="x"></span>');
      expect(
        outcome.failed['value'],
        const NoMatch(
          causes: [
            StepException('index', 'expected a list, got Element'),
            CoercionException('int', 'x'),
          ],
        ),
      );
    });

    test('an expected field is recorded missing yet keeps the entity', () {
      final ParseOutcome outcome = _parse(
        _entity('int', 'v', expected: true),
        '<span></span>',
      );
      expect(outcome.failed['value'], const NoMatch());
      expect(outcome.values.containsKey('value'), isTrue);
      expect(outcome['value'], isNull);
    });

    test('an optional field is silent when absent', () {
      expect(_parse(_entity('int', 'v'), '<span></span>').failed, isEmpty);
    });

    test('rejects a value outside a declared enum', () {
      expect(
        _parse(_entity('Rating', 'v'), '<span v="general"></span>')['value'],
        'general',
      );
      final ParseOutcome outcome = _parse(
        _entity('Rating', 'v'),
        '<span v="spicy"></span>',
      );
      expect(
        outcome.failed['value'],
        const CoercionException('Rating', 'spicy'),
      );
    });
  });
}
