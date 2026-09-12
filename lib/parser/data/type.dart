import 'package:meta/meta.dart';

class CoercionException implements Exception {
  const CoercionException(this.type, this.value);

  final String type;
  final Object value;

  @override
  String toString() => 'not a $type: "$value"';
}

@immutable
class FieldType {
  const FieldType(this.name, {this.values});

  static const FieldType string = FieldType('string');
  static const FieldType integer = FieldType('int');
  static const FieldType float = FieldType('float');
  static const FieldType timestamp = FieldType('timestamp');
  static const FieldType boolean = FieldType('bool');

  static const Set<String> builtIn = {
    'string',
    'int',
    'float',
    'timestamp',
    'bool',
  };

  final String name;
  final Set<String>? values;

  bool get isBuiltIn => builtIn.contains(name);

  List<Object>? coerceList(Object? value) {
    if (value == null) return null;
    final Iterable<Object?> items = value is Iterable ? value : [value];
    final List<Object> coerced = [
      for (final Object? item in items)
        if (coerce(item) case final Object result) result,
    ];
    return switch (name) {
      'int' => coerced.cast<int>().toList(),
      'float' => coerced.cast<double>().toList(),
      'timestamp' => coerced.cast<DateTime>().toList(),
      'bool' => coerced.cast<bool>().toList(),
      _ => coerced.cast<String>().toList(),
    };
  }

  Object? coerce(Object? value) {
    if (value == null) return null;
    return switch (name) {
      'string' => _text(value),
      'int' => _integer(value) ?? _fail(value),
      'float' => _float(value) ?? _fail(value),
      'timestamp' => _timestamp(value) ?? _fail(value),
      'bool' => _boolean(value) ?? _fail(value),
      _ => _member(value),
    };
  }

  Never _fail(Object value) => throw CoercionException(name, value);

  String _text(Object value) => value is String ? value : value.toString();

  Object _member(Object value) {
    final String text = _text(value);
    final Set<String>? allowed = values;
    if (allowed == null || allowed.contains(text)) return text;
    _fail(value);
  }

  static bool? _boolean(Object value) {
    if (value is bool) return value;
    return switch (value.toString().trim().toLowerCase()) {
      'true' || 'yes' || '1' => true,
      'false' || 'no' || '0' => false,
      _ => null,
    };
  }

  static int? _integer(Object value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    final String text = value.toString().replaceAll(RegExp(r'[,\s]'), '');
    return int.tryParse(text) ?? double.tryParse(text)?.toInt();
  }

  static double? _float(Object value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().replaceAll(RegExp(r'[,\s]'), ''));
  }

  static DateTime? _timestamp(Object value) {
    final int? seconds = value is num
        ? value.toInt()
        : int.tryParse(value.toString().trim());
    if (seconds == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
  }

  @override
  bool operator ==(Object other) => other is FieldType && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => name;
}
