import 'package:furlovin/parser/parser.dart';

class FieldRule {
  const FieldRule(
    this.alternatives, {
    this.required = false,
    this.repeated = false,
    this.type = FieldType.string,
  });

  factory FieldRule.fromJson(
    Object? json,
    Map<String, List<Step>> refs,
    Map<String, Set<String>> enums,
  ) {
    if (json is! Map) {
      throw const StepException('field', 'expected an object');
    }
    final Object? steps = json['steps'];
    if (steps is! List) {
      throw const StepException('field', 'expected a list of pipelines');
    }
    return FieldRule(
      [for (final Object? alternative in steps) _pipeline(alternative, refs)],
      required: json['required'] as bool? ?? false,
      repeated: json['repeated'] as bool? ?? false,
      type: _typeOf(json['type'] as String? ?? 'string', enums),
    );
  }

  static FieldType _typeOf(String name, Map<String, Set<String>> enums) =>
      FieldType(name, values: enums[name]);

  static List<Step> _pipeline(Object? json, Map<String, List<Step>> refs) {
    if (json is! List) {
      throw const StepException('field', 'expected a list of steps');
    }
    return [
      for (final Object? step in json)
        ...expandStep((step! as Map).cast<String, Object?>(), refs),
    ];
  }

  static List<Step> expandStep(
    Map<String, Object?> json,
    Map<String, List<Step>> refs,
  ) {
    final Object? reference = json[r'$ref'];
    if (reference == null) return [Step.fromJson(json)];
    final List<Step>? resolved = refs[reference];
    if (resolved == null) {
      throw StepException(r'$ref', 'unknown ref "$reference"');
    }
    return resolved;
  }

  final List<List<Step>> alternatives;
  final bool required;
  final bool repeated;
  final FieldType type;
}

class EntityRule {
  const EntityRule({required this.feature, required this.fields});

  factory EntityRule.fromJson(
    Map<String, Object?> json,
    Map<String, List<Step>> refs,
    Map<String, Set<String>> enums,
  ) => EntityRule(
    feature: json['feature'] as String? ?? '',
    fields: (json['fields']! as Map).map(
      (k, v) => MapEntry(k.toString(), FieldRule.fromJson(v, refs, enums)),
    ),
  );

  final String feature;
  final Map<String, FieldRule> fields;
}

class SlotRule {
  const SlotRule({
    required this.entity,
    required this.selector,
    this.list = false,
  });

  factory SlotRule.fromJson(Map<String, Object?> json) => SlotRule(
    entity: json['entity']! as String,
    selector: json['selector']! as String,
    list: json['list'] as bool? ?? false,
  );

  final String entity;
  final String selector;
  final bool list;
}

class PageRule {
  const PageRule({this.feature = '', this.slots = const {}});

  factory PageRule.fromJson(Map<String, Object?> json) => PageRule(
    feature: json['feature'] as String? ?? '',
    slots: ((json['slots'] as Map?) ?? const {}).map(
      (k, v) => MapEntry(
        k.toString(),
        SlotRule.fromJson((v! as Map).cast<String, Object?>()),
      ),
    ),
  );

  final String feature;
  final Map<String, SlotRule> slots;

  SlotRule? operator [](String slot) => slots[slot];
}

class RuleSet {
  const RuleSet({
    required this.schema,
    required this.revision,
    required this.entities,
    required this.pages,
    required this.json,
  });

  factory RuleSet.fromJson(Map<String, Object?> json) {
    final Map<String, List<Step>> refs = {};
    final Map<String, Object?> declared = ((json['refs'] as Map?) ?? const {})
        .cast<String, Object?>();
    for (final MapEntry<String, Object?> entry in declared.entries) {
      refs[entry.key] = [
        for (final Object? step in entry.value! as List)
          ...FieldRule.expandStep((step! as Map).cast<String, Object?>(), refs),
      ];
    }
    final Map<String, Set<String>> enums = {
      for (final MapEntry<String, Object?> entry
          in ((json['enums'] as Map?) ?? const {})
              .cast<String, Object?>()
              .entries)
        entry.key: {
          for (final Object? value
              in (entry.value! as Map).cast<String, Object?>()['values']!
                  as List)
            '$value',
        },
    };
    return RuleSet(
      json: json,
      schema: (json['schema'] as num?)?.toInt() ?? 0,
      revision: (json['revision'] as num?)?.toInt() ?? 0,
      entities: (json['entities']! as Map).map(
        (k, v) => MapEntry(
          k.toString(),
          EntityRule.fromJson((v! as Map).cast<String, Object?>(), refs, enums),
        ),
      ),
      pages: ((json['pages'] as Map?) ?? const {}).map(
        (k, v) => MapEntry(
          k.toString(),
          PageRule.fromJson((v! as Map).cast<String, Object?>()),
        ),
      ),
    );
  }

  static int get currentSchema => generatedSchema;

  final int schema;
  final int revision;
  final Map<String, EntityRule> entities;
  final Map<String, PageRule> pages;

  final Map<String, Object?> json;

  bool get isSupported => schema == currentSchema;

  EntityRule? operator [](String name) => entities[name];

  List<String> validateAgainst(Map<String, List<String>> manifest) {
    final List<String> problems = [];
    for (final MapEntry<String, List<String>> entry in manifest.entries) {
      final EntityRule? entity = entities[entry.key];
      if (entity == null) {
        problems.add('missing entity "${entry.key}"');
        continue;
      }
      for (final String field in entry.value) {
        if (!entity.fields.containsKey(field)) {
          problems.add('${entry.key} is missing field "$field"');
        }
      }
    }
    return problems;
  }
}
