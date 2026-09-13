import 'package:furlovin/parser/parser.dart';
import 'package:html/dom.dart';

class ParseEngine {
  const ParseEngine({required this.base});

  final Uri base;

  StepContext get _context => StepContext(base: base);

  Object? evaluate(
    FieldRule rule,
    Object? root, [
    List<ParseException>? causes,
  ]) {
    for (final (int at, List<Step> alternative) in rule.alternatives.indexed) {
      try {
        (Step, Object?)? stopped;
        final Object? value = _run(
          alternative,
          root,
          (step, input) => stopped = (step, input),
        );
        if (value == null) {
          if (stopped case (final Step step, final Object? input)) {
            causes?.add(
              EmptyStep(at + 1, describeStep(step), input: excerpt(input)),
            );
          }
          continue;
        }
        if (rule.repeated) {
          final List<Object>? items = rule.type.coerceList(value);
          if (items != null && items.isNotEmpty) return items;
          causes?.add(EmptyStep(at + 1, 'list of ${rule.type.name}'));
          continue;
        }
        return rule.type.coerce(value);
      } on ParseException catch (e) {
        causes?.add(e);
      } on Object catch (e) {
        causes?.add(UnexpectedParseError.of(e));
      }
    }
    return null;
  }

  Object? _apply(Step step, Object? value) {
    if (step.takesList || value is! List) return step.apply(value, _context);
    return [
      for (final Object? item in value)
        if (item == null) null else step.apply(item, _context),
    ];
  }

  Object? _run(
    List<Step> steps,
    Object? root,
    void Function(Step step, Object? input) stopped,
  ) {
    Object? value = root;
    for (final Step step in steps) {
      final Object? input = value;
      value = _apply(step, value);
      if (value == null || (value is List && value.isEmpty)) {
        stopped(step, input);
        return null;
      }
    }
    return value;
  }
}

const int excerptLength = 60;

String? excerpt(Object? input) {
  switch (input) {
    case final String text:
      final String flat = text.replaceAll(RegExp(r'\s+'), ' ').trim();
      final String cut = flat.length > excerptLength
          ? '${flat.substring(0, excerptLength)}…'
          : flat;
      return '"$cut"';
    case final Element element:
      return [
        '<${element.localName}',
        if (element.id.isNotEmpty) ' id="${element.id}"',
        if (element.classes.isNotEmpty) ' class="${element.classes.join(' ')}"',
        '>',
      ].join();
    default:
      return null;
  }
}
