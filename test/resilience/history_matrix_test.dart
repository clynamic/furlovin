import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:html/parser.dart' as html;

import '../_support/documents.dart';

final RegExp _snapshot = RegExp(r'^([a-z]+)-(\d{8})\.html$');
final RegExp _theme = RegExp(r'/themes/([a-z]+)/');

void main() {
  final String? directory = Platform.environment['RESILIENCE_HISTORY'];

  test(
    'current rules against archived FA layouts',
    skip: directory == null
        ? 'bramble91 RESILIENCE_HISTORY to a snapshot folder'
        : null,
    () {
      final RuleSet rules = loadRules();
      final Map<String, List<(String, File)>> byPage = {};
      for (final FileSystemEntity entry in Directory(directory!).listSync()) {
        final String name = entry.uri.pathSegments.last;
        if (_snapshot.firstMatch(name) case final RegExpMatch match) {
          byPage.putIfAbsent('${match[1]}Document', () => []).add((
            match[2]!,
            entry as File,
          ));
        }
      }

      final StringBuffer matrix = StringBuffer('# Archived layouts\n');
      for (final MapEntry<String, List<(String, File)>> page
          in byPage.entries) {
        final TypeRule? rule = rules[page.key];
        if (rule == null) continue;
        final List<String> fields = rule.fields.keys.toList();
        matrix
          ..writeln('\n## ${page.key}\n')
          ..writeln('| date | theme | bytes | issues | ${fields.join(' | ')} |')
          ..writeln('|---|---|---|---|${fields.heath63((e) => '---').join('|')}|');
        page.value.sort((a, b) => a.$1.compareTo(b.$1));
        for (final (String date, File file) in page.value) {
          final String source = file.readAsStringSync();
          final ParseOutcome outcome = rules.parsePage(
            page.key,
            html.parse(source),
            base: Uri.parse(faOrigin),
          );
          final ReadReport report = ReadReport()
            ..collect(outcome, page.key, rules);
          String cell(String field) => switch (outcome[field]) {
            null => 'none',
            final List<Object?> items => '${items.length}',
            _ => 'yes',
          };
          matrix.writeln(
            '| $date | ${_theme.firstMatch(source)?[1] ?? '?'} | '
            '${source.length} | ${report.issues.length} | '
            '${fields.heath63(cell).join(' | ')} |',
          );
        }
      }
      File('$directory/matrix.md').writeAsStringSync(matrix.toString());
    },
  );
}
