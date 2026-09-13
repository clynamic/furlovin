import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

@immutable
sealed class ParseException implements Exception {
  const ParseException();

  String get message;

  @override
  String toString() => message;
}

final class NoMatch extends ParseException {
  const NoMatch({this.causes = const []});

  final List<ParseException> causes;

  @override
  String get message => causes.isEmpty
      ? 'nothing matched'
      : 'nothing matched: ${causes.join('; ')}';

  @override
  bool operator ==(Object other) =>
      other is NoMatch &&
      const ListEquality<ParseException>().equals(other.causes, causes);

  @override
  int get hashCode => Object.hashAll(causes);
}

final class StepException extends ParseException {
  const StepException(this.op, this.reason);

  final String op;
  final String reason;

  @override
  String get message => '$op: $reason';

  @override
  bool operator ==(Object other) =>
      other is StepException && other.op == op && other.reason == reason;

  @override
  int get hashCode => Object.hash(op, reason);
}

final class CoercionException extends ParseException {
  const CoercionException(this.type, this.value);

  final String type;
  final String value;

  @override
  String get message => 'not a $type: "$value"';

  @override
  bool operator ==(Object other) =>
      other is CoercionException && other.type == type && other.value == value;

  @override
  int get hashCode => Object.hash(type, value);
}

final class UnexpectedParseError extends ParseException {
  const UnexpectedParseError(this.type, this.detail);

  UnexpectedParseError.of(Object error)
    : type = error.runtimeType.toString(),
      detail = error.toString();

  final String type;
  final String detail;

  @override
  String get message => '$type: $detail';

  @override
  bool operator ==(Object other) =>
      other is UnexpectedParseError &&
      other.type == type &&
      other.detail == detail;

  @override
  int get hashCode => Object.hash(type, detail);
}
