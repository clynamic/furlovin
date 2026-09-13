import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

final RegExp _snapshot = RegExp(r'^([a-z]+)-(\d{8})\.html$');
final RegExp _theme = RegExp(r'/themes/([a-z]+)/');

void main() {
  final String? directory = Platform.environment['RESILIENCE_HISTORY'];

  test(
    'current rules against archived FA layouts',
    skip: directory == null
        ? 'set RESILIENCE_HISTORY to a snapshot folder'
        : null,
    () {
      final RuleSet rules = RuleSet.fromJson(
        decodeRules(File('assets/rules/v1.yaml').readAsStringSync()),
      );
      final Map<String, List<(String, File)>> byPage = {};
      for (final FileSystemEntity entry in Directory(directory!).listSync()) {
        final String name = entry.uri.pathSegments.last;
        if (_snapshot.firstMatch(name) case final RegExpMatch match) {
          byPage.putIfAbsent(match[1]!, () => []).add((
            match[2]!,
            entry as File,
          ));
        }
      }

      final StringBuffer matrix = StringBuffer('# Archived layouts\n');
      for (final MapEntry<String, List<(String, File)>> page
          in byPage.entries) {
        final PageRule? rule = rules.pages[page.key];
        if (rule == null) continue;
        final List<String> slots = rule.slots.keys.toList();
        matrix
          ..writeln('\n## ${page.key}\n')
          ..writeln('| date | theme | bytes | ${slots.join(' | ')} |')
          ..writeln('|---|---|---|${slots.map((e) => '---').join('|')}|');
        page.value.sort((a, b) => a.$1.compareTo(b.$1));
        for (final (String date, File file) in page.value) {
          final String source = file.readAsStringSync();
          final Document document = html.parse(source);
          final String theme = _theme.firstMatch(source)?[1] ?? '?';
          final PageOutcome outcome = rules.parseDocument(
            page.key,
            document,
            base: Uri.parse(faOrigin),
          );
          String cell(String slot) {
            if (outcome.missing.containsKey(slot)) return 'none';
            final SlotRule slotRule = rule[slot]!;
            final List<ParseOutcome> items = slotRule.list
                ? outcome.items[slot] ?? const []
                : [?outcome.single[slot]];
            final Iterable<String> required = rules[slotRule.entity]!
                .fields
                .entries
                .where((e) => e.value.required)
                .map((e) => e.key);
            final int usable = items
                .where((e) => required.every((field) => e[field] != null))
                .length;
            return '$usable/${items.length}';
          }

          matrix.writeln(
            '| $date | $theme | ${source.length} | '
            '${slots.map(cell).join(' | ')} |',
          );
        }
      }
      File('$directory/matrix.md').writeAsStringSync(matrix.toString());
    },
  );
}
