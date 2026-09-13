import 'package:furlovin/parser/data/failure.dart';
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
  });

  final String slot;
  final String? field;
  final IssueKind kind;
  final ParseException error;
  final int count;

  @override
  bool operator ==(Object other) =>
      other is ReadIssue &&
      other.slot == slot &&
      other.field == field &&
      other.kind == kind &&
      other.error == error &&
      other.count == count;

  @override
  int get hashCode => Object.hash(slot, field, kind, error, count);

  @override
  String toString() => [
    kind.name,
    slot,
    ?field,
    if (count > 1) '×$count',
    error.message,
  ].join(' ');
}

class ReadReport {
  final List<ReadIssue> _issues = [];

  List<ReadIssue> get issues => List.unmodifiable(_issues);

  bool get isEmpty => _issues.isEmpty;

  void add(ReadIssue issue) => _issues.add(issue);

  Iterable<ReadIssue> of(String slot) => _issues.where((e) => e.slot == slot);

  bool unreadable(String slot) =>
      of(slot).any((e) => e.kind == IssueKind.unreadable);
}
