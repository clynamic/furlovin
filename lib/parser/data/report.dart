import 'package:furlovin/parser/data/failure.dart';
import 'package:furlovin/parser/data/rule.dart';
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

  Iterable<ReadIssue> of(String slot) => _issues.where((e) => e.slot == slot);

  bool unreadable(String slot) =>
      of(slot).any((e) => e.kind == IssueKind.unreadable);
}
