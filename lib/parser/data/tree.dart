import 'package:furlovin/parser/parser.dart';
import 'package:html/dom.dart';

const String _scope = 'data-furlovin-scope';

List<String> _parts(String css) {
  final List<String> parts = [];
  final StringBuffer current = StringBuffer();
  int depth = 0;
  String? quote;
  for (final String char in css.split('')) {
    if (quote != null) {
      if (char == quote) quote = null;
    } else if (char == '"' || char == "'") {
      quote = char;
    } else if (char == '(' || char == '[') {
      depth++;
    } else if (char == ')' || char == ']') {
      depth--;
    } else if (char == ',' && depth == 0) {
      parts.add(current.toString().trim());
      current.clear();
      continue;
    }
    current.write(char);
  }
  parts.add(current.toString().trim());
  return parts;
}

Node _top(Node node) {
  Node at = node;
  while (at.parentNode != null) {
    at = at.parentNode!;
  }
  return at;
}

List<Element> scopedAll(Node base, String css) {
  if (css.trim() == 'self') {
    return switch (base) {
      Element() => [base],
      Document(:final Element? documentElement) => [?documentElement],
      _ => const [],
    };
  }
  final List<String> parts = _parts(css);
  if (!parts.any((e) => e.startsWith('>'))) {
    return switch (base) {
      Document() => base.querySelectorAll(css),
      Element() => base.querySelectorAll(css),
      _ => const [],
    };
  }
  final Element? element = switch (base) {
    Element() => base,
    Document(:final Element? documentElement) => documentElement,
    _ => null,
  };
  if (element == null) return const [];
  final String scoped = parts
      .map((e) => e.startsWith('>') ? '[$_scope] $e' : e)
      .join(', ');
  element.attributes[_scope] = '';
  try {
    final Node top = _top(element);
    return switch (top) {
      Document() => top.querySelectorAll(scoped),
      Element() => top.querySelectorAll(scoped),
      _ => const [],
    };
  } finally {
    element.attributes.remove(_scope);
  }
}

typedef _Reading = ({
  Object? value,
  ParseException? issue,
  bool absent,
  bool hard,
});

class TreeEngine {
  TreeEngine({required this.types, required this.base})
    : _steps = ParseEngine(base: base);

  final RuleSet types;
  final Uri base;
  final ParseEngine _steps;

  bool usable(TypeRule rule, ParseOutcome outcome) => rule.fields.values
      .where((e) => e.presence == Presence.required)
      .every((e) => !outcome.failed.containsKey(e.name));

  ParseOutcome parseType(TypeRule rule, Node root) {
    final Map<String, Object?> values = {};
    final Map<String, ParseException> failed = {};
    for (final TypeField field in rule.fields.values) {
      final _Reading reading = _guarded(field, root);
      values[field.name] = reading.value;
      final ParseException? issue = reading.issue;
      if (issue == null) continue;
      final bool report =
          !reading.absent ||
          reading.hard ||
          field.presence != Presence.optional;
      if (report) failed[field.name] = issue;
    }
    return ParseOutcome(values: values, failed: failed);
  }

  _Reading _guarded(TypeField field, Node root) {
    try {
      return _read(field, root);
    } on ParseException catch (e) {
      return (
        value: field.list ? const <Object>[] : null,
        issue: e,
        absent: true,
        hard: true,
      );
    } on Object catch (e) {
      return (
        value: field.list ? const <Object>[] : null,
        issue: UnexpectedParseError.of(e),
        absent: true,
        hard: true,
      );
    }
  }

  _Reading _read(TypeField field, Node root) {
    Node scope = root;
    if (field.inside.isNotEmpty) {
      final Element? container = _first(field.inside, root);
      if (container == null) {
        return (
          value: field.list ? const <Object>[] : null,
          issue: StepException(
            'in',
            'nothing at "${field.inside.join(' | ')}"',
          ),
          absent: true,
          hard: false,
        );
      }
      scope = container;
    }
    final bool nested = types.isType(field.type);
    if (!nested && !field.list) return _scalar(field, scope);
    if (!nested) return _scalars(field, scope);
    final TypeRule rule = types[field.type]!;
    if (!field.list) return _single(field, rule, scope);
    return _many(field, rule, scope);
  }

  _Reading _scalar(TypeField field, Node scope) {
    final List<ParseException> causes = [];
    final Object? value = _steps.evaluate(
      FieldRule(field.read, type: types.scalar(field.type)),
      scope,
      causes,
    );
    if (value != null) {
      return (value: value, issue: null, absent: false, hard: false);
    }
    final bool hard = causes.any((e) => e is! EmptyStep);
    return (
      value: null,
      issue: switch (causes) {
        [final ParseException only] when only is! EmptyStep => only,
        _ => NoMatch(causes: causes),
      },
      absent: true,
      hard: hard,
    );
  }

  _Reading _scalars(TypeField field, Node scope) {
    final FieldRule rule = FieldRule(
      field.read,
      type: types.scalar(field.type),
    );
    return (
      value: [
        for (final Element item in _all(field.at, scope))
          ?_steps.evaluate(rule, item),
      ],
      issue: null,
      absent: false,
      hard: false,
    );
  }

  _Reading _single(TypeField field, TypeRule rule, Node scope) {
    final Element? element = _first(field.at, scope);
    if (element == null) {
      return (
        value: null,
        issue: StepException('at', 'nothing at "${field.at.join(' | ')}"'),
        absent: true,
        hard: false,
      );
    }
    final ParseOutcome outcome = parseType(rule, element);
    if (usable(rule, outcome)) {
      return (value: outcome, issue: null, absent: false, hard: false);
    }
    final MapEntry<String, ParseException> cause = outcome.failed.entries
        .firstWhere((e) => rule.fields[e.key]!.presence == Presence.required);
    return (
      value: null,
      issue: DroppedItems(1, 1, field: cause.key, cause: cause.value),
      absent: true,
      hard: true,
    );
  }

  _Reading _many(TypeField field, TypeRule rule, Node scope) {
    final List<Element> elements = _all(field.at, scope);
    final List<ParseOutcome> kept = [];
    MapEntry<String, ParseException>? cause;
    for (final Element element in elements) {
      final ParseOutcome outcome = parseType(rule, element);
      if (usable(rule, outcome)) {
        kept.add(outcome);
        continue;
      }
      cause ??= outcome.failed.entries.firstWhere(
        (e) => rule.fields[e.key]!.presence == Presence.required,
      );
    }
    final int dropped = elements.length - kept.length;
    return (
      value: kept,
      issue: dropped == 0
          ? null
          : DroppedItems(
              dropped,
              elements.length,
              field: cause!.key,
              cause: cause.value,
            ),
      absent: false,
      hard: dropped > 0,
    );
  }

  Element? _first(List<String> alternatives, Node scope) {
    for (final String css in alternatives) {
      final List<Element> found = scopedAll(scope, css);
      if (found.isNotEmpty) return found.first;
    }
    return null;
  }

  List<Element> _all(List<String> alternatives, Node scope) {
    for (final String css in alternatives) {
      final List<Element> found = scopedAll(scope, css);
      if (found.isNotEmpty) return found;
    }
    return const [];
  }
}

extension RuleSetParsing on RuleSet {
  ParseOutcome parsePage(String type, Document document, {required Uri base}) {
    final TypeRule? rule = types[type];
    if (rule == null || !rule.page) {
      throw StepException('page', 'unknown page "$type"');
    }
    hydrate(document);
    return TreeEngine(types: this, base: base).parseType(rule, document);
  }
}
