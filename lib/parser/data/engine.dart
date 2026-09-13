import 'package:furlovin/parser/parser.dart';
import 'package:html/dom.dart';

class ParseEngine {
  const ParseEngine({required this.base});

  final Uri base;

  StepContext get _context => StepContext(base: base);

  Object? evaluate(FieldRule rule, Object? root) {
    final List<ParseException> causes = [];
    for (final List<Step> alternative in rule.alternatives) {
      try {
        final Object? value = _run(alternative, root);
        if (value == null) continue;
        if (rule.repeated) {
          final List<Object>? items = rule.type.coerceList(value);
          if (items != null && items.isNotEmpty) return items;
          continue;
        }
        return rule.type.coerce(value);
      } on ParseException catch (e) {
        causes.add(e);
      } on Object catch (e) {
        causes.add(UnexpectedParseError.of(e));
      }
    }
    if (causes case [final ParseException only]) throw only;
    if (causes.isNotEmpty) throw NoMatch(causes: causes);
    return null;
  }

  Object? _apply(Step step, Object? value) {
    if (step.takesList || value is! List) return step.apply(value, _context);
    return [
      for (final Object? item in value)
        if (item == null) null else step.apply(item, _context),
    ];
  }

  Object? _run(List<Step> steps, Object? root) {
    Object? value = root;
    for (final Step step in steps) {
      value = _apply(step, value);
      if (value == null) return null;
      if (value is List && value.isEmpty) return null;
    }
    return value;
  }

  ParseOutcome parseOne(EntityRule rule, Object? root) {
    final Map<String, Object?> values = {};
    final Map<String, ParseException> failed = {};
    for (final MapEntry<String, FieldRule> field in rule.fields.entries) {
      try {
        final Object? value = evaluate(field.value, root);
        if (value == null && field.value.required) {
          failed[field.key] = const NoMatch();
          continue;
        }
        values[field.key] = value;
      } on ParseException catch (e) {
        failed[field.key] = e;
      }
    }
    return ParseOutcome(values: values, failed: failed);
  }

  List<ParseOutcome> parseAll(
    EntityRule rule,
    Document document, {
    required String selector,
  }) => [
    for (final Element element in document.querySelectorAll(selector))
      parseOne(rule, element),
  ];
}

extension RuleSetParsing on RuleSet {
  PageOutcome parseDocument(
    String page,
    Document document, {
    required Uri base,
  }) {
    final PageRule? rule = pages[page];
    if (rule == null) throw StepException('page', 'unknown page "$page"');
    hydrate(document);
    final Map<String, ParseOutcome> single = {};
    final Map<String, List<ParseOutcome>> lists = {};
    final Map<String, ParseException> missing = {};
    for (final MapEntry<String, SlotRule> entry in rule.slots.entries) {
      try {
        if (entry.value.list) {
          lists[entry.key] = parseSlotAll(entry.value, document, base: base);
        } else {
          single[entry.key] = parseSlot(entry.value, document, base: base);
        }
      } on ParseException catch (e) {
        missing[entry.key] = e;
      } on Object catch (e) {
        missing[entry.key] = UnexpectedParseError.of(e);
      }
    }
    return PageOutcome(single: single, items: lists, missing: missing);
  }

  ParseOutcome parseSlot(
    SlotRule slot,
    Document document, {
    required Uri base,
  }) {
    final EntityRule shape = _shapeOf(slot);
    final Element? element = document.querySelector(slot.selector);
    if (element == null) {
      throw StepException('slot', 'nothing at "${slot.selector}"');
    }
    return ParseEngine(base: base).parseOne(shape, element);
  }

  List<ParseOutcome> parseSlotAll(
    SlotRule slot,
    Document document, {
    required Uri base,
  }) =>
      ParseEngine(base: base)
          .parseAll(_shapeOf(slot), document, selector: slot.selector);

  EntityRule _shapeOf(SlotRule slot) {
    final EntityRule? shape = this[slot.entity];
    if (shape == null) {
      throw StepException('entity', 'unknown entity "${slot.entity}"');
    }
    return shape;
  }
}
