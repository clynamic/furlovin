import 'package:furlovin/logs/logs.dart';
import 'package:furlovin/parser/parser.dart';

extension PageOutcomeHarvest on PageOutcome {
  T? read<T>(SingleSlot<T> slot, {required Logger logger, ReadReport? report}) {
    if (missing[slot.name] case final ParseException reason) {
      logger.error('Could not reach {slot}', {
        'slot': slot.name,
        'entity': slot.entity,
        'reason': reason,
      });
      report?.add(
        ReadIssue(slot: slot.name, kind: IssueKind.unreadable, error: reason),
      );
      return null;
    }
    final ParseOutcome? outcome = single[slot.name];
    if (outcome == null) return null;
    final T? value = slot.build(outcome);
    if (value == null) {
      logger.error('Could not build {slot}', {
        'slot': slot.name,
        'entity': slot.entity,
        'failed': outcome.failed,
      });
      final MapEntry<String, ParseException>? cause =
          outcome.failed.entries.firstOrNull;
      report?.add(
        ReadIssue(
          slot: slot.name,
          field: cause?.key,
          kind: IssueKind.unreadable,
          error: cause?.value ?? const NoMatch(),
        ),
      );
      return null;
    }
    if (outcome.failed.isNotEmpty) {
      logger.warn('Read {slot} with {count} gaps', {
        'slot': slot.name,
        'count': outcome.failed.length,
        'failed': outcome.failed,
      });
      for (final MapEntry<String, ParseException> gap
          in outcome.failed.entries) {
        report?.add(
          ReadIssue(
            slot: slot.name,
            field: gap.key,
            kind: IssueKind.missing,
            error: gap.value,
          ),
        );
      }
    }
    return value;
  }

  List<T> readAll<T>(
    ListSlot<T> slot, {
    required Logger logger,
    ReadReport? report,
  }) {
    if (missing[slot.name] case final ParseException reason) {
      logger.warn('Could not reach {slot}', {
        'slot': slot.name,
        'entity': slot.entity,
        'reason': reason,
      });
      report?.add(
        ReadIssue(slot: slot.name, kind: IssueKind.unreadable, error: reason),
      );
      return <T>[];
    }
    final List<ParseOutcome> outcomes = items[slot.name] ?? const [];
    final List<T> built = <T>[];
    final Map<String, int> gaps = {};
    final Map<String, ParseException> first = {};
    MapEntry<String, ParseException>? droppedBy;
    for (final ParseOutcome outcome in outcomes) {
      if (slot.build(outcome) case final T value) {
        built.add(value);
      } else {
        droppedBy ??=
            outcome.failed.entries.firstOrNull ?? const MapEntry('', NoMatch());
        continue;
      }
      for (final MapEntry<String, ParseException> failure
          in outcome.failed.entries) {
        gaps[failure.key] = (gaps[failure.key] ?? 0) + 1;
        first[failure.key] ??= failure.value;
      }
    }
    final int dropped = outcomes.length - built.length;
    if (dropped == 0 && gaps.isEmpty) {
      logger.debug('Read {count} {slot}', {
        'count': built.length,
        'slot': slot.name,
      });
      return built;
    }
    logger.warn('Read {count} {slot}, dropped {dropped}', {
      'count': built.length,
      'slot': slot.name,
      'dropped': dropped,
      'gaps': gaps,
    });
    if (report != null) {
      if (droppedBy != null) {
        report.add(
          ReadIssue(
            slot: slot.name,
            field: droppedBy.key.isEmpty ? null : droppedBy.key,
            kind: dropped == outcomes.length
                ? IssueKind.unreadable
                : IssueKind.dropped,
            error: droppedBy.value,
            count: dropped,
            of: outcomes.length,
          ),
        );
      }
      for (final MapEntry<String, int> gap in gaps.entries) {
        report.add(
          ReadIssue(
            slot: slot.name,
            field: gap.key,
            kind: IssueKind.missing,
            error: first[gap.key]!,
            count: gap.value,
          ),
        );
      }
    }
    return built;
  }
}
