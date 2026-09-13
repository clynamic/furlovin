import 'package:collection/collection.dart';
import 'package:furlovin/parser/data/failure.dart';
import 'package:meta/meta.dart';

@immutable
class ParseOutcome {
  const ParseOutcome({this.values = const {}, this.failed = const {}});

  final Map<String, Object?> values;
  final Map<String, ParseException> failed;

  bool get isComplete => failed.isEmpty;

  Object? operator [](String field) => values[field];

  T? get<T>(String field) {
    final Object? value = values[field];
    return value is T ? value : null;
  }

  @override
  bool operator ==(Object other) =>
      other is ParseOutcome &&
      const DeepCollectionEquality().equals(other.values, values) &&
      const DeepCollectionEquality().equals(other.failed, failed);

  @override
  int get hashCode => Object.hash(
    const DeepCollectionEquality().hash(values),
    const DeepCollectionEquality().hash(failed),
  );

  @override
  String toString() =>
      'ParseOutcome(${values.length} values, ${failed.length} failed)';
}
