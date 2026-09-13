import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:html/parser.dart' as html;

Map<String, Object?> _text(String css) => {
  'read': [
    [
      {'op': 'select', 'css': css},
      {'op': 'text'},
      {'op': 'trim'},
    ],
  ],
};

final RuleSet _types = RuleSet.fromJson({
  'schema': 1,
  'types': {
    'item': {
      'feature': 'test',
      'fields': {
        'id': {'presence': 'required', ..._text('b')},
        'note': {'presence': 'expected', ..._text('i')},
        'extra': _text('u'),
      },
    },
    'box': {
      'feature': 'test',
      'fields': {
        'title': {'presence': 'required', ..._text('h1')},
        'items': {
          'presence': 'expected',
          'type': 'item',
          'list': true,
          'in': ['ul.items'],
          'at': ['> li'],
        },
        'first': {
          'type': 'item',
          'at': ['self'],
        },
      },
    },
    'page': {
      'feature': 'test',
      'page': true,
      'fields': {
        'box': {
          'presence': 'required',
          'type': 'box',
          'at': ['section'],
        },
        'strict': {
          'presence': 'required',
          'type': 'item',
          'list': true,
          'in': ['ol.strict'],
          'at': ['li'],
        },
      },
    },
  },
});

ParseOutcome _parse(String body) => _types.parsePage(
  'page',
  html.parse('<html><body>$body</body></html>'),
  base: Uri.parse('https://www.furaffinity.net'),
);

ParseOutcome _box(ParseOutcome page) => page['box']! as ParseOutcome;

List<ParseOutcome> _items(ParseOutcome box) =>
    (box['items']! as List).cast<ParseOutcome>();

void main() {
  const String strict = '<ol class="strict"></ol>';

  test('an empty container is a quiet empty list', () {
    final ParseOutcome page = _parse(
      '<section><h1>t</h1><ul class="items"></ul></section>$strict',
    );
    expect(_items(_box(page)), isEmpty);
    expect(_box(page).failed.containsKey('items'), isFalse);
  });

  test('a missing expected container is recorded, the parent survives', () {
    final ParseOutcome page = _parse('<section><h1>t</h1></section>$strict');
    expect(_box(page)['title'], 't');
    expect(_box(page).failed['items'], isA<StepException>());
  });

  test('a missing required container fails its parent', () {
    final ParseOutcome page = _parse('<section><h1>t</h1></section>');
    expect(page.failed['strict'], isA<StepException>());
  });

  test('a required miss inside a list drops only that item', () {
    final ParseOutcome page = _parse(
      '<section><h1>t</h1><ul class="items"> '
      '<li><b>1</b><i>n</i></li> <li><i>no id</i></li> '
      '</ul></section>$strict',
    );
    expect(_items(_box(page)).map((e) => e['id']), ['1']);
    expect(
      _box(page).failed['items'],
      isA<DroppedItems>()
          .having((e) => e.count, 'count', 1)
          .having((e) => e.of, 'of', 2)
          .having((e) => e.field, 'field', 'id'),
    );
  });

  test('expected absence is recorded, optional absence is not', () {
    final ParseOutcome page = _parse(
      '<section><h1>t</h1><ul class="items"><li><b>1</b></li></ul> '
      '</section>$strict',
    );
    final ParseOutcome item = _items(_box(page)).single;
    expect(item.failed.containsKey('note'), isTrue);
    expect(item.failed.containsKey('extra'), isFalse);
  });

  test('a child selector only reaches direct children', () {
    final ParseOutcome page = _parse(
      '<section><h1>t</h1><ul class="items"> '
      '<li><b>1</b></li> <li><b>2</b><ul><li><b>nested</b></li></ul></li> '
      '</ul></section>$strict',
    );
    expect(_items(_box(page)).map((e) => e['id']), ['1', '2']);
  });

  test('self reads a type from the element it is on', () {
    final ParseOutcome page = _parse(
      '<section><h1>t</h1><b>own</b><ul class="items"></ul></section>$strict',
    );
    expect((_box(page)['first']! as ParseOutcome)['id'], 'own');
  });
}
