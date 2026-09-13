import 'package:html/dom.dart';

class StepException implements Exception {
  const StepException(this.op, this.reason);

  final String op;
  final String reason;

  @override
  String toString() => 'StepException($op): $reason';
}

sealed class Step {
  const Step();

  factory Step.fromJson(Map<String, Object?> json) {
    final String op = json['op'] as String? ?? '';
    return switch (op) {
      'select' => SelectStep(json['css']! as String),
      'selectAll' => SelectAllStep(json['css']! as String),
      'closest' => ClosestStep(json['css']! as String),
      'previous' => PreviousStep(json['css']! as String),
      'attr' => AttrStep(json['name']! as String),
      'text' => TextStep(own: json['own'] as bool? ?? false),
      'html' => const HtmlStep(),
      'class' => ClassStep(json['prefix']! as String),
      'regex' => RegexStep(
        json['pattern']! as String,
        (json['group'] as num?)?.toInt() ?? 1,
      ),
      'replace' => ReplaceStep(
        json['pattern']! as String,
        json['with'] as String? ?? '',
      ),
      'index' => IndexStep((json['at']! as num).toInt()),
      'trim' => const TrimStep(),
      'url' => UrlStep(json['base'] as String?),
      'literal' => LiteralStep(json['value']),
      _ => throw StepException(op, 'unknown op'),
    };
  }

  String get op;

  bool get takesList => false;

  Object? apply(Object? input, StepContext context);

  Map<String, Object?> toJson();
}

class StepContext {
  const StepContext({required this.base});

  final Uri base;
}

bool _matches(Element element, String css) {
  final Node? parent = element.parent ?? element.parentNode;
  return switch (parent) {
    Element() => parent.querySelectorAll(css).contains(element),
    Document() => parent.querySelectorAll(css).contains(element),
    _ => false,
  };
}

Element? _element(Object? input, String op) {
  if (input is Element) return input;
  if (input is Document) return input.documentElement;
  if (input == null) return null;
  throw StepException(op, 'expected an element, got ${input.runtimeType}');
}

class SelectStep extends Step {
  const SelectStep(this.css);

  final String css;

  @override
  String get op => 'select';

  @override
  Object? apply(Object? input, StepContext context) {
    if (input is Document) return input.querySelector(css);
    return _element(input, op)?.querySelector(css);
  }

  @override
  Map<String, Object?> toJson() => {'op': op, 'css': css};
}

class SelectAllStep extends Step {
  const SelectAllStep(this.css);

  final String css;

  @override
  String get op => 'selectAll';

  @override
  Object? apply(Object? input, StepContext context) {
    if (input is Document) return input.querySelectorAll(css);
    return _element(input, op)?.querySelectorAll(css);
  }

  @override
  Map<String, Object?> toJson() => {'op': op, 'css': css};
}

class ClosestStep extends Step {
  const ClosestStep(this.css);

  final String css;

  @override
  String get op => 'closest';

  @override
  Object? apply(Object? input, StepContext context) {
    Element? at = _element(input, op)?.parent;
    while (at != null) {
      if (_matches(at, css)) return at;
      at = at.parent;
    }
    return null;
  }

  @override
  Map<String, Object?> toJson() => {'op': op, 'css': css};
}

class PreviousStep extends Step {
  const PreviousStep(this.css);

  final String css;

  @override
  String get op => 'previous';

  @override
  Object? apply(Object? input, StepContext context) {
    final Element? before = _element(input, op)?.previousElementSibling;
    return before != null && _matches(before, css) ? before : null;
  }

  @override
  Map<String, Object?> toJson() => {'op': op, 'css': css};
}

class AttrStep extends Step {
  const AttrStep(this.name);

  final String name;

  @override
  String get op => 'attr';

  @override
  Object? apply(Object? input, StepContext context) =>
      _element(input, op)?.attributes[name];

  @override
  Map<String, Object?> toJson() => {'op': op, 'name': name};
}

class TextStep extends Step {
  const TextStep({this.own = false});

  final bool own;

  @override
  String get op => 'text';

  @override
  Object? apply(Object? input, StepContext context) {
    if (input is String) return input;
    final Element? element = _element(input, op);
    if (element == null) return null;
    if (!own) return element.text;
    return element.nodes.whereType<Text>().map((e) => e.text).join();
  }

  @override
  Map<String, Object?> toJson() => {'op': op, if (own) 'own': true};
}

class HtmlStep extends Step {
  const HtmlStep();

  @override
  String get op => 'html';

  @override
  Object? apply(Object? input, StepContext context) {
    final Element? element = _element(input, op);
    if (element == null) return null;
    final String value = element.innerHtml.trim();
    return value.isEmpty ? null : value;
  }

  @override
  Map<String, Object?> toJson() => {'op': op};
}

class ClassStep extends Step {
  const ClassStep(this.prefix);

  final String prefix;

  @override
  String get op => 'class';

  @override
  Object? apply(Object? input, StepContext context) {
    final Element? element = _element(input, op);
    if (element == null) return null;
    for (final String value in element.classes) {
      if (value.startsWith(prefix) && value.length > prefix.length) {
        return value.substring(prefix.length);
      }
    }
    return null;
  }

  @override
  Map<String, Object?> toJson() => {'op': op, 'prefix': prefix};
}

class RegexStep extends Step {
  RegexStep(this.pattern, this.group) : _expression = RegExp(pattern);

  final String pattern;
  final int group;
  final RegExp _expression;

  @override
  String get op => 'regex';

  @override
  Object? apply(Object? input, StepContext context) {
    if (input == null) return null;
    final String value = input is String ? input : input.toString();
    final RegExpMatch? match = _expression.firstMatch(value);
    if (match == null) return null;
    if (group > match.groupCount) {
      throw StepException(op, 'group $group beyond ${match.groupCount}');
    }
    return match.group(group);
  }

  @override
  Map<String, Object?> toJson() => {
    'op': op,
    'pattern': pattern,
    if (group != 1) 'group': group,
  };
}

class ReplaceStep extends Step {
  ReplaceStep(this.pattern, this.replacement) : _expression = RegExp(pattern);

  final String pattern;
  final String replacement;
  final RegExp _expression;

  @override
  String get op => 'replace';

  @override
  Object? apply(Object? input, StepContext context) {
    if (input == null) return null;
    final String value = input is String ? input : input.toString();
    return value.replaceAll(_expression, replacement);
  }

  @override
  Map<String, Object?> toJson() => {
    'op': op,
    'pattern': pattern,
    'with': replacement,
  };
}

class IndexStep extends Step {
  const IndexStep(this.at);

  final int at;

  @override
  String get op => 'index';

  @override
  bool get takesList => true;

  @override
  Object? apply(Object? input, StepContext context) {
    if (input == null) return null;
    if (input is! List) {
      throw StepException(op, 'expected a list, got ${input.runtimeType}');
    }
    final int position = at.isNegative ? input.length + at : at;
    if (position < 0 || position >= input.length) return null;
    return input[position];
  }

  @override
  Map<String, Object?> toJson() => {'op': op, 'at': at};
}

class TrimStep extends Step {
  const TrimStep();

  @override
  String get op => 'trim';

  @override
  Object? apply(Object? input, StepContext context) {
    if (input == null) return null;
    final String value = (input is String ? input : input.toString()).trim();
    return value.isEmpty ? null : value;
  }

  @override
  Map<String, Object?> toJson() => {'op': op};
}

class UrlStep extends Step {
  const UrlStep(this.base);

  final String? base;

  @override
  String get op => 'url';

  @override
  Object? apply(Object? input, StepContext context) {
    if (input == null) return null;
    final String value = input.toString().trim();
    if (value.isEmpty) return null;
    final Uri against = base == null ? context.base : Uri.parse(base!);
    return against.resolve(value).toString();
  }

  @override
  Map<String, Object?> toJson() => {'op': op, if (base != null) 'base': base};
}

class LiteralStep extends Step {
  const LiteralStep(this.value);

  final Object? value;

  @override
  String get op => 'literal';

  @override
  Object? apply(Object? input, StepContext context) => value;

  @override
  Map<String, Object?> toJson() => {'op': op, 'value': value};
}
