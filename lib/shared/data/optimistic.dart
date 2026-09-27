const int optimisticAttempts = 4;

const Duration actionSettle = Duration(seconds: 1);
const Duration actionSpacing = Duration(seconds: 3);

typedef OptimisticPause = Duration? Function(Object error, int attempt);

Future<void> _delay(Duration duration) => Future<void>.delayed(duration);

class Optimistic<T> {
  Optimistic({
    required this.confirmed,
    required this.send,
    this.attempts = optimisticAttempts,
    this.settle = Duration.zero,
    this.spacing = Duration.zero,
    this.pause,
    this._wait = _delay,
    this._now = DateTime.now,
  });

  T confirmed;
  final Future<T> Function(T wanted) send;
  final int attempts;
  final Duration settle;
  final Duration spacing;
  final OptimisticPause? pause;

  final Future<void> Function(Duration duration) _wait;
  final DateTime Function() _now;

  T? _intent;
  bool _busy = false;
  DateTime _touched = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime? _sent;

  T get shown => _intent ?? confirmed;

  bool get pending => _intent != null && _intent != confirmed;

  bool get settled => !_busy;

  Future<void> want(T wanted, void Function() changed) async {
    _intent = wanted;
    _touched = _now();
    changed();
    if (_busy) return;
    _busy = true;
    try {
      int attempt = 0;
      while (attempt < attempts) {
        final Duration quiet = settle - _now().difference(_touched);
        if (quiet > Duration.zero) {
          await _wait(quiet);
          continue;
        }
        final T? goal = _intent;
        if (goal == null || goal == confirmed) break;
        if (_sent case final DateTime last) {
          final Duration gap = spacing - _now().difference(last);
          if (gap > Duration.zero) {
            await _wait(gap);
            continue;
          }
        }
        _sent = _now();
        attempt++;
        try {
          confirmed = await send(goal);
          changed();
        } on Object catch (error) {
          final Duration? delay = pause?.call(error, attempt);
          if (delay == null || attempt >= attempts) rethrow;
          await _wait(delay);
        }
      }
    } finally {
      _busy = false;
      _intent = null;
      changed();
    }
  }
}
