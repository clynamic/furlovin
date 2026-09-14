import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/shared/shared.dart';

void main() {
  test('shows the intent at once and settles on the answer', () async {
    final List<bool> seen = [];
    late final Optimistic<bool> watch;
    watch = Optimistic<bool>(confirmed: false, send: (wanted) async => wanted);

    final Future<void> done = watch.want(true, () => seen.add(watch.shown));
    expect(watch.shown, isTrue);
    expect(watch.pending, isTrue);

    await done;
    expect(watch.confirmed, isTrue);
    expect(watch.pending, isFalse);
    expect(seen.first, isTrue);
  });

  test('taps during a request send only the latest intent', () async {
    final List<bool> sent = [];
    final Completer<bool> first = Completer();
    final Optimistic<bool> watch = Optimistic<bool>(
      confirmed: false,
      send: (wanted) {
        sent.add(wanted);
        return sent.length == 1 ? first.future : Future.value(wanted);
      },
    );

    final Future<void> done = watch.want(true, () {});
    unawaited(watch.want(false, () {}));
    unawaited(watch.want(true, () {}));
    expect(watch.shown, isTrue);

    first.complete(true);
    await done;

    expect(sent, [true]);
    expect(watch.confirmed, isTrue);
  });

  test('a change of mind during a request is sent afterwards', () async {
    final List<bool> sent = [];
    final Completer<bool> first = Completer();
    final Optimistic<bool> watch = Optimistic<bool>(
      confirmed: false,
      send: (wanted) {
        sent.add(wanted);
        return sent.length == 1 ? first.future : Future.value(wanted);
      },
    );

    final Future<void> done = watch.want(true, () {});
    unawaited(watch.want(false, () {}));

    first.complete(true);
    await done;

    expect(sent, [true, false]);
    expect(watch.confirmed, isFalse);
  });

  test('a failure rolls back to what was confirmed', () async {
    final Optimistic<bool> watch = Optimistic<bool>(
      confirmed: false,
      send: (wanted) async => throw StateError('offline'),
    );

    await expectLater(watch.want(true, () {}), throwsStateError);

    expect(watch.shown, isFalse);
    expect(watch.pending, isFalse);
  });

  test('gives up after a bounded number of disagreeing answers', () async {
    int sent = 0;
    final Optimistic<bool> watch = Optimistic<bool>(
      confirmed: false,
      send: (wanted) async {
        sent++;
        return false;
      },
    );

    await watch.want(true, () {});

    expect(sent, optimisticAttempts);
    expect(watch.shown, isFalse);
  });

  group('pacing', () {
    late DateTime clock;
    late List<Duration> sentAt;
    final DateTime start = DateTime(2026);

    setUp(() {
      clock = start;
      sentAt = [];
    });

    Optimistic<bool> paced(
      Future<bool> Function(bool wanted) answer, {
      OptimisticPause? pause,
    }) => Optimistic<bool>(
      confirmed: false,
      settle: actionSettle,
      spacing: actionSpacing,
      pause: pause,
      now: () => clock,
      wait: (duration) async => clock = clock.add(duration),
      send: (wanted) {
        sentAt.add(clock.difference(start));
        return answer(wanted);
      },
    );

    test('changing your mind within the settle window sends nothing', () async {
      final Optimistic<bool> watch = paced((wanted) async => wanted);

      final Future<void> done = watch.want(true, () {});
      unawaited(watch.want(false, () {}));
      await done;

      expect(sentAt, isEmpty);
      expect(watch.confirmed, isFalse);
    });

    test('rapid toggles send the final intent once', () async {
      final Optimistic<bool> watch = paced((wanted) async => wanted);

      final Future<void> done = watch.want(true, () {});
      unawaited(watch.want(false, () {}));
      unawaited(watch.want(true, () {}));
      await done;

      expect(sentAt, hasLength(1));
      expect(watch.confirmed, isTrue);
    });

    test('requests are kept apart by the spacing', () async {
      final Optimistic<bool> watch = paced((wanted) async => wanted);

      await watch.want(true, () {});
      await watch.want(false, () {});

      expect(sentAt, hasLength(2));
      expect(sentAt[1] - sentAt[0], greaterThanOrEqualTo(actionSpacing));
      expect(watch.confirmed, isFalse);
    });

    test(
      'a rate limit pauses and tries again instead of rolling back',
      () async {
        int answers = 0;
        final Optimistic<bool> watch = paced(
          (wanted) async {
            if (answers++ == 0) throw const FormatException('Rate limited');
            return wanted;
          },
          pause: (error, attempt) =>
              error is FormatException ? const Duration(seconds: 3) : null,
        );

        await watch.want(true, () {});

        expect(sentAt, hasLength(2));
        expect(watch.confirmed, isTrue);
      },
    );
  });
}
