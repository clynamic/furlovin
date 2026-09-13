import 'package:furlovin/parser/parser.dart';

enum Presence { required, expected, optional }

class TypeField {
  const TypeField({
    required this.name,
    required this.type,
    this.presence = Presence.optional,
    this.list = false,
    this.at = const [],
    this.inside = const [],
    this.read = const [],
  });

  final String name;
  final String type;
  final Presence presence;
  final bool list;
  final List<String> at;
  final List<String> inside;
  final List<List<Step>> read;
}

class TypeRule {
  const TypeRule({
    required this.name,
    required this.feature,
    required this.fields,
    this.page = false,
  });

  final String name;
  final String feature;
  final bool page;
  final Map<String, TypeField> fields;
}

class TypeSet {
  const TypeSet({
    required this.schema,
    required this.revision,
    required this.types,
    required this.enums,
    required this.json,
  });

  factory TypeSet.fromJson(Map<String, Object?> json) {
    final Map<String, List<Step>> refs = {
      for (final MapEntry<Object?, Object?> entry
          in ((json['refs'] as Map?) ?? const {}).entries)
        entry.key! as String: [
          for (final Object? step in entry.value! as List)
            ...FieldRule.expandStep(
              (step! as Map).cast<String, Object?>(),
              const {},
            ),
        ],
    };
    final Map<String, Set<String>> enums = {
      for (final MapEntry<Object?, Object?> entry
          in ((json['enums'] as Map?) ?? const {}).entries)
        entry.key! as String: {
          for (final Object? value
              in ((entry.value! as Map)['values']! as List))
            value! as String,
        },
    };
    final Map<String, TypeRule> types = {
      for (final MapEntry<Object?, Object?> entry
          in ((json['types']! as Map)).entries)
        entry.key! as String: _type(
          entry.key! as String,
          (entry.value! as Map).cast<String, Object?>(),
          refs,
        ),
    };
    final TypeSet set = TypeSet(
      schema: (json['schema']! as num).toInt(),
      revision: (json['revision'] as num?)?.toInt() ?? 0,
      types: types,
      enums: enums,
      json: json,
    );
    set._validate();
    return set;
  }

  final int schema;
  final int revision;
  final Map<String, TypeRule> types;
  final Map<String, Set<String>> enums;
  final Map<String, Object?> json;

  static const Set<String> scalars = {
    'string',
    'int',
    'float',
    'timestamp',
    'bool',
  };

  TypeRule? operator [](String name) => types[name];

  bool isType(String name) => types.containsKey(name);

  FieldType scalar(String name) => FieldType(name, values: enums[name]);

  static TypeRule _type(
    String name,
    Map<String, Object?> json,
    Map<String, List<Step>> refs,
  ) => TypeRule(
    name: name,
    feature: json['feature']! as String,
    page: json['page'] as bool? ?? false,
    fields: {
      for (final MapEntry<Object?, Object?> entry
          in ((json['fields']! as Map)).entries)
        entry.key! as String: _field(
          entry.key! as String,
          (entry.value! as Map).cast<String, Object?>(),
          refs,
        ),
    },
  );

  static TypeField _field(
    String name,
    Map<String, Object?> json,
    Map<String, List<Step>> refs,
  ) => TypeField(
    name: name,
    type: json['type'] as String? ?? 'string',
    presence: Presence.values.byName(json['presence'] as String? ?? 'optional'),
    list: json['list'] as bool? ?? false,
    at: _strings(json['at']),
    inside: _strings(json['in']),
    read: [
      for (final Object? alternative in (json['read'] as List?) ?? const [])
        [
          for (final Object? step in alternative! as List)
            ...FieldRule.expandStep(
              (step! as Map).cast<String, Object?>(),
              refs,
            ),
        ],
    ],
  );

  static List<String> _strings(Object? json) => [
    for (final Object? value in (json as List?) ?? const []) value! as String,
  ];

  void _validate() {
    for (final TypeRule type in types.values) {
      for (final TypeField field in type.fields.values) {
        final String where = '${type.name}.${field.name}';
        final bool nested = isType(field.type);
        if (!nested &&
            !scalars.contains(field.type) &&
            !enums.containsKey(field.type)) {
          throw StepException(
            'schema',
            '$where has unknown type ${field.type}',
          );
        }
        if (nested && field.read.isNotEmpty) {
          throw StepException('schema', '$where reads a type with steps');
        }
        if ((nested || field.list) && field.at.isEmpty) {
          throw StepException('schema', '$where needs at');
        }
        if (!nested && field.read.isEmpty) {
          throw StepException('schema', '$where needs read');
        }
      }
    }
  }
}
