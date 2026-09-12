import 'package:flutter_test/flutter_test.dart';
import 'package:furlovin/shared/shared.dart';

void main() {
  final DateTime now = DateTime.utc(2026, 9, 12, 12);

  String ago(Duration since) => describeWhen(now.subtract(since), now: now);

  test('counts up through every unit', () {
    expect(ago(const Duration(minutes: 70)), '1h ago');
    expect(ago(const Duration(seconds: 20)), 'just now');
    expect(ago(const Duration(minutes: 5)), '5m ago');
    expect(ago(const Duration(hours: 3)), '3h ago');
    expect(ago(const Duration(days: 2)), '2d ago');
    expect(ago(const Duration(days: 20)), '20d ago');
    expect(ago(const Duration(days: 90)), '3mo ago');
    expect(ago(const Duration(days: 2900)), '8y ago');
  });

  test('falls back to a date for the future', () {
    expect(
      describeWhen(now.add(const Duration(days: 3)), now: now),
      '15 September 2026',
    );
  });
}
