import 'package:yaml/yaml.dart';

Map<String, Object?> decodeRules(String source) {
  final Object? document = plainYaml(loadYaml(source));
  if (document is! Map<String, Object?>) {
    throw const FormatException('rules must be a mapping');
  }
  return document;
}

Object? plainYaml(Object? node) => switch (node) {
  YamlMap() => <String, Object?>{
    for (final MapEntry<Object?, Object?> entry in node.entries)
      '${entry.key}': plainYaml(entry.value),
  },
  YamlList() => <Object?>[for (final Object? item in node) plainYaml(item)],
  YamlScalar() => node.value,
  Map<Object?, Object?>() => <String, Object?>{
    for (final MapEntry<Object?, Object?> entry in node.entries)
      '${entry.key}': plainYaml(entry.value),
  },
  List<Object?>() => <Object?>[
    for (final Object? item in node) plainYaml(item),
  ],
  _ => node,
};
