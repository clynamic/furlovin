import 'package:furlovin/parser/data/failure.dart';
import 'package:furlovin/parser/data/outcome.dart';
import 'package:furlovin/parser/data/schema.dart';
import 'package:meta/meta.dart';

enum IssueKind { unreadable, dropped, missing }

@immutable
class ReadIssue {
  const ReadIssue({
    required this.slot,
    required this.kind,
    required this.error,
    this.field,
    this.count = 1,
    this.of,
  });

  final String slot;
  final String? field;
  final IssueKind kind;
  final ParseException error;
  final int count;
  final int? of;

  @override
  bool operator ==(Object other) =>
      other is ReadIssue &&
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
      IssueKind.missing => '$slot.$field missing${count > 1 ? ' ×$count' : ''}',
      IssueKind.dropped || IssueKind.unreadable when of != null =>
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

class ReadReport {
  ReadReport({this.page, this.rules, this.theme});

  ReadReport.forPage({
    required String url,
    required String body,
    required RuleSet ruleSet,
  }) : page = url,
       rules = '${ruleSet.schema}/${ruleSet.revision}',
       theme = _theme.firstMatch(body)?[1];

  final String? page;
  final String? rules;
  final String? theme;

  final List<ReadIssue> _issues = [];

  List<ReadIssue> get issues => List.unmodifiable(_issues);

  bool get isEmpty => _issues.isEmpty;

  void add(ReadIssue issue) => _issues.add(issue);

  void collect(ParseOutcome root, String type, RuleSet ruleSet) {
    final Map<String, ReadIssue> merged = {};
    void walk(ParseOutcome outcome, TypeRule rule, List<String> path) {
      for (final TypeField field in rule.fields.values) {
        final List<String> at = [...path, field.name];
        if (outcome.failed[field.name] case final ParseException error) {
          final ReadIssue issue = _issue(at, error);
          final String key = '${issue.slot}|${issue.field}|${issue.kind.name}';
          final ReadIssue? known = merged[key];
          merged[key] = known == null
              ? issue
              : ReadIssue(
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
    _issues.addAll(merged.values);
  }

  static ReadIssue _issue(List<String> path, ParseException error) {
    final String slot = path.first;
    final List<String> rest = path.skip(1).toList();
    return switch (error) {
      DroppedItems(:final count, :final of, :final field, :final cause) =>
        ReadIssue(
          slot: slot,
          field: [...rest, ?field].join('.').emptyAsNull,
          kind: count == of ? IssueKind.unreadable : IssueKind.dropped,
          error: cause,
          count: count,
          of: of,
        ),
      StepException(op: 'in' || 'at') => ReadIssue(
        slot: slot,
        field: rest.join('.').emptyAsNull,
        kind: IssueKind.unreadable,
        error: error,
      ),
      _ => ReadIssue(
        slot: slot,
        field: rest.isEmpty ? path.last : rest.join('.'),
        kind: IssueKind.missing,
        error: error,
      ),
    };
  }

  Iterable<ReadIssue> of(String slot) => _issues.where((e) => e.slot == slot);

  bool unreadable(String slot) =>
      of(slot).any((e) => e.kind == IssueKind.unreadable);
}

extension on String {
  String? get emptyAsNull => isEmpty ? null : this;
}
