import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

const String _elapsed = 'furlovin';
const Duration _moment = Duration(seconds: 45);

final DateFormat _absolute = DateFormat('d MMMM y');

bool _installed = false;

class _TerseMessages extends timeago.EnShortMessages {
  @override
  String suffixAgo() => 'ago';

  @override
  String aboutAnHour(int minutes) => '1h';

  @override
  String aDay(int hours) => '1d';

  @override
  String aboutAMonth(int days) => '1mo';

  @override
  String aboutAYear(int year) => '1y';
}

String describeWhen(DateTime when, {DateTime? now}) {
  final DateTime moment = now ?? DateTime.now();
  if (when.isAfter(moment)) return _absolute.format(when);
  if (moment.difference(when) < _moment) return 'just now';
  if (!_installed) {
    timeago.setLocaleMessages(_elapsed, _TerseMessages());
    _installed = true;
  }
  return timeago.format(when, clock: moment, locale: _elapsed);
}

final NumberFormat _count = NumberFormat.decimalPattern();

String countOf(int value) => _count.format(value);

String titleOf(String value) =>
    value.isEmpty ? value : value[0].toUpperCase() + value.substring(1);
