import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

import '../tool/sanitize_page.dart';
import '_support/documents.dart';

final RegExp _pseudonym = RegExp('^(${nameWords.join('|')})[0-9]*\$');

final RegExp _hex = RegExp(r'\b[0-9a-f]{32,}\b');

final RegExp _email = RegExp(
  r'\b[\w.+-]*[A-Za-z][\w.+-]*@[\w-]*[A-Za-z][\w-]*\.[a-z]{2,}\b',
);

Iterable<Node> walk(Node node) sync* {
  for (final Node child in node.nodes) {
    yield child;
    yield* walk(child);
  }
}

Iterable<String> mappableValues(Document document) sync* {
  for (final Node node in walk(document)) {
    if (node is Text) {
      if (node.text.trim().isNotEmpty) yield node.text;
    } else if (node is Element) {
      for (final MapEntry<Object, String> entry in node.attributes.entries) {
        final String key = entry.key.toString();
        if (skipAttributes.contains(key)) continue;
        if (entry.value.isNotEmpty) yield entry.value;
      }
    }
  }
}

void main() {
  final Set<String> vocabulary = {
    ...structuralVocabulary(File('assets/rules/v1.yaml').readAsStringSync()),
    ...literalVocabulary(File(roleSource).readAsStringSync()),
    ...typeVocabulary,
    ...selectorVocabulary,
  };

  for (final String name in fixturePages.keys) {
    group(name, () {
      late String source;
      late Document document;
      late Set<String> allowed;

      setUpAll(() {
        source = fixture(name);
        document = html.parse(source);
        final File list = File('test/_fixtures/$name.allowed.txt');
        allowed = list.existsSync()
            ? list
                  .readAsLinesSync()
                  .where((e) => e.isNotEmpty)
                  .map((e) => e.toLowerCase())
                  .toSet()
            : <String>{};
      });

      test('carries no word outside the vocabulary or the pseudonyms', () {
        final Set<String> strangers = {};
        for (final String value in mappableValues(document)) {
          for (final Segment part in segment(value)) {
            if (!part.token || part.digits) continue;
            final String word = part.text.toLowerCase();
            if (vocabulary.contains(word)) continue;
            if (allowed.contains(word)) continue;
            if (_pseudonym.hasMatch(word)) continue;
            strangers.add(part.text);
          }
        }
        expect(strangers, isEmpty, reason: 'unmapped words survived in $name');
      });

      test('carries no session key', () {
        expect(_hex.allMatches(source).map((e) => e.group(0)), isEmpty);
      });

      test('carries no address outside the pseudonyms', () {
        final Set<String> strangers = {};
        for (final RegExpMatch match in _email.allMatches(source)) {
          for (final Segment part in segment(match.group(0)!)) {
            if (!part.token || part.digits) continue;
            final String word = part.text.toLowerCase();
            if (vocabulary.contains(word)) continue;
            if (_pseudonym.hasMatch(word)) continue;
            strangers.add(match.group(0)!);
          }
        }
        expect(strangers, isEmpty);
      });
    });
  }
}
