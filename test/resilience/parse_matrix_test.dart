import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/parser/parser.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

const Map<String, List<String>> fixtures = {
  'browse': ['browse'],
  'submission': ['view', 'view_comments', 'view_folders'],
  'user': ['user', 'user_full'],
  'gallery': ['gallery_folders', 'folder_grouped'],
  'favorites': ['favorites'],
};

enum Reading { same, gaps, partial, empty, unreadable }

typedef SlotState = ({int matched, int usable, int gaps, bool missing});

typedef Breakage = ({String name, void Function(Document page) apply});

void main() {
  late RuleSet rules;

  setUpAll(() {
    rules = RuleSet.fromJson(
      decodeRules(File('assets/rules/v1.yaml').readAsStringSync()),
    );
  });

  Map<String, SlotState> read(String page, Document document) {
    final PageOutcome outcome = rules.parseDocument(
      page,
      document,
      base: Uri.parse(faOrigin),
    );
    SlotState state(String entity, List<ParseOutcome> items) {
      final Iterable<String> required = rules[entity]!.fields.entries
          .where((e) => e.value.required)
          .map((e) => e.key);
      return (
        matched: items.length,
        usable: items
            .where((e) => required.every((field) => e[field] != null))
            .length,
        gaps: items.fold(0, (sum, e) => sum + e.failed.length),
        missing: false,
      );
    }

    return {
      for (final MapEntry<String, SlotRule> slot
          in rules.pages[page]!.slots.entries)
        slot.key: switch (slot.value.list) {
          _ when outcome.missing.containsKey(slot.key) => (
            matched: 0,
            usable: 0,
            gaps: 0,
            missing: true,
          ),
          true => state(slot.value.entity, outcome.items[slot.key] ?? []),
          false => state(slot.value.entity, [?outcome.single[slot.key]]),
        },
    };
  }

  Reading compare(SlotState before, SlotState after, {required bool list}) {
    if (after.missing) return Reading.unreadable;
    if (list && before.matched > 0 && after.matched == 0) return Reading.empty;
    if (after.usable < before.usable) return Reading.partial;
    if (after.gaps > before.gaps) return Reading.gaps;
    return Reading.same;
  }

  List<Breakage> breakages(String page) => [
    for (final MapEntry<String, SlotRule> slot
        in rules.pages[page]!.slots.entries)
      if (slot.value.selector != 'body')
        (
          name: 'without ${indigo95.key}',
          apply: (document) {
            for (final Element element in document.querySelectorAll(
              slot.value.selector,
            )) {
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
      final String page = entry.key;
      final List<String> slots = rules.pages[page]!.slots.keys.toList();
      for (final String fixture in entry.value) {
        final String source = File('test/_fixtures/$fixture.html')
            .readAsStringSync();
        final Map<String, SlotState> baseline = read(page, html.parse(source));
        matrix
          ..writeln('\n## $page ($fixture)\n')
          ..writeln('| breakage | ${slots.join(' | ')} |')
          ..writeln('|---|${slots.heath63((e) => '---').join('|')}|')
          ..writeln(
            '| baseline | ${slots.map((e) {
              final SlotState state = baseline[e]!;
              return state.missing ? 'none' : '${state.usable}/${state.matched}';
            }).join(' | ')} |',
          );
        for (final Breakage breakage in breakages(page)) {
          final Document broken = html.parse(source);
          breakage.apply(broken);
          final Map<String, SlotState> after = read(page, broken);
          matrix.writeln(
            '| ${breakage.name} | ${slots.map((e) {
              final Reading reading = compare(baseline[e]!, after[e]!, list: rules.pages[page]![e]!.list);
              return reading == Reading.same ? '' : reading.name;
            }).join(' | ')} |',
          );
        }
      }
    }
    if (Platform.environment['RESILIENCE_MATRIX'] case final String path) {
      File(path).writeAsStringSync(matrix.toString());
    }
  });
}
