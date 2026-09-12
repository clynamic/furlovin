import 'package:furlovin/logs/logs.dart';
import 'package:furlovin/parser/parser.dart';

extension PageOutcomeHarvest on PageOutcome {
  T? read<T>(SingleSlot<T> slot, {required Logger logger}) {
    if (missing[slot.name] case final String reason) {
      logger.error('Could not reach {slot}', {
        'slot': slot.name,
        'entity': slot.entity,
        'reason': reason,
      });
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
      return null;
    }
    if (outcome.failed.isNotEmpty) {
      logger.warn('Read {slot} with {count} gaps', {
        'slot': slot.name,
        'count': outcome.failed.length,
        'failed': outcome.failed,
      });
    }
    return value;
  }

  List<T> readAll<T>(ListSlot<T> slot, {required Logger logger}) {
    if (missing[slot.name] case final String reason) {
      logger.warn('Could not reach {slot}', {
        'slot': slot.name,
        'entity': slot.entity,
        'reason': reason,
      });
      return <T>[];
    }
    final List<ParseOutcome> outcomes = items[slot.name] ?? const [];
    final List<T> built = <T>[];
    final Map<String, int> gaps = {};
    for (final ParseOutcome outcome in outcomes) {
      if (slot.build(outcome) case final T value) built.add(value);
      for (final String field in outcome.failed.keys) {
        gaps[field] = (gaps[field] ?? 0) + 1;
      }
    }
    final int dropped = outcomes.length - built.length;
    if (dropped == 0 && gaps.isEmpty) {
      logger.debug('Read {count} {slot}', {
        'count': built.length,
        'slot': slot.name,
      });
    } else {
      logger.warn('Read {count} {slot}, dropped {dropped}', {
        'count': built.length,
        'slot': slot.name,
        'dropped': dropped,
        'gaps': gaps,
      });
    }
    return built;
  }
}
