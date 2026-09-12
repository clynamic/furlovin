import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:furlovin/logs/logs.dart';
import 'package:logging/logging.dart' as logging;

abstract class LogPrinter {
  const LogPrinter();

  void onLog(LogEntry entry);

  FutureOr<void> close() {}
}

class Logs {
  Logs({
    this.printers = const [],
    this.redactor = const LogRedactor(),
    this.compactor = const LogStackCompactor(),
    LogDeduplicator? deduplicator,
  }) : deduplicator = deduplicator ?? LogDeduplicator() {
    this.deduplicator.attach(_publish);
  }

  static const int maxEntries = 500;

  final List<LogPrinter> printers;
  final LogRedactor redactor;
  final LogStackCompactor compactor;
  final LogDeduplicator deduplicator;

  final List<LogEntry> _entries = [];
  final StreamController<LogEntry> _added = StreamController.broadcast();
  StreamSubscription<logging.LogRecord>? _subscription;
  int _sequence = 0;

  List<LogEntry> get entries => UnmodifiableListView(_entries);

  Stream<LogEntry> get added => _added.stream;

  void connect() {
    _subscription = logging.Logger.root.onRecord.listen(
      (record) => deduplicator.add(
        compactor.apply(redactor.apply(LogEntry.fromRecord(record))),
      ),
    );
  }

  void _publish(LogEntry entry) {
    final LogEntry stored = entry.copyWith(id: _sequence++);
    _entries.add(stored);
    if (_entries.length > maxEntries) {
      _entries.removeRange(0, _entries.length - maxEntries);
    }
    _added.add(stored);
    for (final LogPrinter printer in printers) {
      printer.onLog(stored);
    }
  }

  Future<void> close() async {
    await _subscription?.cancel();
    deduplicator.close();
    await _added.close();
    for (final LogPrinter printer in printers) {
      await printer.close();
    }
  }
}

class ConsoleLogPrinter extends LogPrinter {
  const ConsoleLogPrinter();

  static String color(LogLevel level) => switch (level) {
    LogLevel.error => '\x1B[31m',
    LogLevel.warn => '\x1B[33m',
    LogLevel.info => '\x1B[34m',
    LogLevel.debug || LogLevel.trace => '\x1B[90m',
  };

  @override
  void onLog(LogEntry entry) =>
      debugPrint('${color(entry.level)}${formatLogEntry(entry)}\x1B[0m');
}
