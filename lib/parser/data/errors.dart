import 'package:furlovin/parser/data/failure.dart';
import 'package:furlovin/parser/data/outcome.dart';
import 'package:furlovin/parser/data/schema.dart';
import 'package:meta/meta.dart';

enum FieldErrorKind { unreadable, dropped, missing }

@immutable
class FieldError {
  const FieldError({
    required this.slot,
    required this.kind,
    required this.error,
    this.field,
    this.count = 1,
    this.of,
  });

  final String slot;
  final String? field;
  final FieldErrorKind kind;
  final ParseException error;
  final int count;
  final int? of;

  @override
  bool operator ==(Object other) =>
      other is FieldError &&
      other.slot == slot &&
      other.field == field &&
      other.kind == kind &&
      other.error == error &&
      other.count == count &&
      other.of == of;

  @override
  int get hashCode => Object.hash(slot, field, kind, error, count, of);

  @override
  String toString() {
    final String subject = switch (kind) {
      FieldErrorKind.missing =>
        '$slot.$field missing${count > 1 ? ' ×$count' : ''}',
      FieldErrorKind.dropped || FieldErrorKind.unreadable when of != null =>
        '${kind.name} $slot: dropped $count of $of'
            '${field == null ? '' : ' over $field'}',
      _ => '${kind.name} $slot${field == null ? '' : ' over $field'}',
    };
    final ParseException cause = error;
    final List<ParseException> causes =
        cause is NoMatch && cause.causes.isNotEmpty ? cause.causes : [cause];
    return [
      subject,
      for (final ParseException e in causes) '  ${e.message}',
    ].join('\n');
  }
}

final RegExp _theme = RegExp('/themes/([a-z]+)/');

class DocumentErrors {
  DocumentErrors({this.page, this.rules, this.theme});

  DocumentErrors.forPage({
    required String url,
    required String body,
    required RuleSet ruleSet,
  }) : page = url,
       rules = '${ruleSet.schema}/${ruleSet.revision}',
       theme = _theme.firstMatch(body)?[1];

  final String? page;
  final String? rules;
  final String? theme;

  final List<FieldError> _errors = [];

  List<FieldError> get all => List.unmodifiable(_errors);

  bool get isEmpty => _errors.isEmpty;

  void add(FieldError issue) => _errors.add(issue);

  void collect(ParseOutcome root, String type, RuleSet ruleSet) {
    final Map<String, FieldError> merged = {};
    void walk(ParseOutcome outcome, TypeRule rule, List<String> path) {
      for (final TypeField field in rule.fields.values) {
        final List<String> at = [...path, field.name];
        if (outcome.failed[field.name] case final ParseException error) {
          final FieldError issue = _issue(at, error);
          final String key = '${issue.slot}|${issue.field}|${issue.kind.name}';
          final FieldError? known = merged[key];
          merged[key] = known == null
              ? issue
              : FieldError(
                  slot: known.slot,
                  field: known.field,
                  kind: known.kind,
                  error: known.error,
                  count: known.count + issue.count,
                  of: known.of == null ? null : known.of! + (issue.of ?? 0),
                );
        }
        final TypeRule? nested = ruleSet[field.type];
        if (nested == null) continue;
        switch (outcome[field.name]) {
          case final ParseOutcome child:
            walk(child, nested, at);
          case final List<Object?> children:
            for (final ParseOutcome child in children.whereType()) {
              walk(child, nested, at);
            }
        }
      }
    }

    walk(root, ruleSet[type]!, const []);
    _errors.addAll(merged.values);
  }

  static FieldError _issue(List<String> path, ParseException error) {
    final String slot = path.first;
    final List<String> rest = path.skip(1).toList();
    return switch (error) {
      DroppedItems(:final count, :final of, :final field, :final cause) =>
        FieldError(
          slot: slot,
          field: [...rest, ?field].join('.').emptyAsNull,
          kind: count == of
              ? FieldErrorKind.unreadable
              : FieldErrorKind.dropped,
          error: cause,
          count: count,
          of: of,
        ),
      StepException(op: 'in' || 'at') => FieldError(
        slot: slot,
        field: rest.join('.').emptyAsNull,
        kind: FieldErrorKind.unreadable,
        error: error,
      ),
      _ => FieldError(
        slot: slot,
        field: rest.isEmpty ? path.last : rest.join('.'),
        kind: FieldErrorKind.missing,
        error: error,
      ),
    };
  }

  Iterable<FieldError> of(String slot) => _errors.where((e) => e.slot == slot);

  bool unreadable(String slot) =>
      of(slot).any((e) => e.kind == FieldErrorKind.unreadable);
}

extension on String {
  String? get emptyAsNull => isEmpty ? null : this;
}
