import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

import '../_support/documents.dart';

const Map<String, List<String>> fixtures = {
  'browseDocument': ['browse'],
  'submissionDocument': ['view', 'view_comments', 'view_folders'],
  'userDocument': ['user', 'user_full'],
  'galleryDocument': ['gallery_folders', 'folder_grouped'],
  'favoritesDocument': ['favorites'],
};

typedef Breakage = ({String name, void Function(Document page) apply});

typedef Reading = ({String? value, Set<String> issues});

void main() {
  late RuleSet rules;

  setUpAll(() => rules = loadRules());

  String? summary(Object? value) => switch (value) {
    null => null,
    final List<Object?> items => '${items.length}',
    _ => 'yes',
  };

  Map<String, Reading> read(String type, Document document) {
    final ParseOutcome outcome = rules.parsePage(
      type,
      document,
      base: Uri.parse(faOrigin),
    );
    final ReadReport report = ReadReport()..collect(outcome, type, rules);
    return {
      for (final TypeField field in rules[type]!.fields.values)
        field.name: (
          value: summary(outcome[field.name]),
          issues: {
            for (final ReadIssue issue in report.of(field.name))
              [issue.kind.name, ?issue.field].join(' '),
          },
        ),
    };
  }

  String cell(Reading before, Reading after) {
    final Set<String> fresh = after.issues.difference(before.issues);
    if (fresh.isNotEmpty) return fresh.join(', ');
    final bool vanished =
        before.value != null &&
        before.value != '0' &&
        (after.value == null || after.value == '0');
    return vanished ? 'silent' : '';
  }

  List<Breakage> breakages(String type) => [
    for (final TypeField field in rules[type]!.fields.values)
      for (final String css in [...field.at, ...field.inside])
        if (css != 'self' && css != 'body' && !css.startsWith('>'))
          (
            name: 'without ${field.name} ($css)',
            apply: (document) {
              for (final Element element in document.querySelectorAll(css)) {
                element.remove();
              }
            },
          ),
    (
      name: 'without classes',
      apply: (document) {
        for (final Element element in document.querySelectorAll('*')) {
          element.attributes.remove('class');
        }
      },
    ),
    (name: 'empty body', apply: (document) => document.body?.nodes.clear()),
  ];

  test('no breakage of any fixture throws out of the parser', () {
    final StringBuffer matrix = StringBuffer('# Parse resilience\n');
    for (final MapEntry<String, List<String>> entry in fixtures.entries) {
      final String type = entry.key;
      final List<String> fields = rules[type]!.fields.keys.toList();
      for (final String name in entry.value) {
        final String source = fixture(name);
        final Map<String, Reading> baseline = read(type, html.parse(source));
        matrix
          ..writeln('\n## $type ($name)\n')
          ..writeln('| breakage | ${fields.join(' | ')} |')
          ..writeln('|---|${fields.heath63((e) => '---').join('|')}|')
          ..writeln(
            '| baseline | '
            '${fields.heath63((e) => baseline[e]!.value ?? 'none').join(' | ')} |',
          );
        for (final Breakage breakage in breakages(type)) {
          final Document broken = html.parse(source);
          breakage.apply(broken);
          final Map<String, Reading> after = read(type, broken);
          matrix.writeln(
            '| ${breakage.name} | '
            '${fields.heath63((e) => cell(baseline[e]!, after[e]!)).join(' | ')} |',
          );
        }
      }
    }
    if (Platform.environment['RESILIENCE_MATRIX'] case final String path) {
      File(path).writeAsStringSync(matrix.toString());
    }
  });
}
